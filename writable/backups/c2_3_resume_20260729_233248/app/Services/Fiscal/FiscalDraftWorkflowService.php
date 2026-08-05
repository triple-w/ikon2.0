<?php
declare(strict_types=1);
namespace App\Services\Fiscal;

use RuntimeException;
use Throwable;

final class FiscalDraftWorkflowService
{
    private FiscalSaleAllocationService $allocations;
    private FiscalDraftValidationService $validation;

    public function __construct(private mixed $db = null)
    {
        $this->db ??= db_connect();
        $this->allocations = new FiscalSaleAllocationService($this->db);
        $this->validation = new FiscalDraftValidationService($this->db);
    }

    public function compatibleSales(int $saleId, ?int $draftId = null): array
    {
        $base = $this->sale($saleId);
        $currency = $this->currencyForSale($base);
        $rows = $this->db->table('invoices i')
            ->select('i.id,i.display_id,i.bill_date,i.invoice_total,i.invoice_subtotal,i.status,i.client_id,i.company_id,c.company_name,c.currency')
            ->join('clients c', 'c.id=i.client_id', 'left')
            ->where(['i.client_id' => $base->client_id, 'i.company_id' => $base->company_id, 'i.deleted' => 0])
            ->where('i.status !=', 'cancelled')->orderBy('i.id', 'DESC')->get()->getResult();
        $result = [];
        foreach ($rows as $sale) {
            if ($this->currencyForSale($sale) !== $currency) continue;
            $summary = $this->allocations->getSaleFiscalSummary((int) $sale->id);
            $available = $this->allocations->getAvailableAmount((int) $sale->id, $draftId);
            if (FiscalDecimal::micros($available) <= 0 && (int)$sale->id !== $saleId) continue;
            $result[] = ['sale' => $sale, 'summary' => $summary, 'available' => $available];
        }
        return $result;
    }

    public function formData(?int $draftId, array $saleIds): array
    {
        $draft = $draftId ? $this->draft($draftId) : null;
        if ($draft) {
            $saleIds = array_map('intval', array_column(
                $this->db->table('fiscal_draft_sales')->where('fiscal_draft_id', $draftId)
                    ->whereIn('allocation_status', ['reserved','converted'])->get()->getResultArray(),
                'sale_id'
            ));
        }
        $saleIds = array_values(array_unique(array_filter(array_map('intval', $saleIds))));
        if (!$saleIds) throw new RuntimeException('Selecciona al menos una venta.');
        $anchor = $this->sale($saleIds[0]);
        $compatible = $this->compatibleSales((int) $anchor->id, $draftId);
        $allowed = array_column(array_map(static fn(array $row): array => ['id'=>(int)$row['sale']->id], $compatible), 'id');
        foreach ($saleIds as $id) if (!in_array($id, $allowed, true)) throw new RuntimeException('Una venta seleccionada no es fiscalmente compatible.');
        $sales = [];
        foreach ($compatible as &$compatibleEntry) {
            $compatibleEntry['items'] = $this->saleItems((int)$compatibleEntry['sale']->id, $draftId);
        }
        unset($compatibleEntry);
        foreach ($compatible as $entry) {
            if (!in_array((int)$entry['sale']->id, $saleIds, true)) continue;
            $sales[] = $entry;
        }
        $receiver = $this->db->table('fiscal_profiles')->where([
            'client_id' => $anchor->client_id, 'profile_type' => 'receiver',
        ])->whereIn('status',['active','ready'])->orderBy('is_default', 'DESC')->get(1)->getRow();
        $issuer = $this->db->table('fiscal_profiles')->where('profile_type','issuer')
            ->whereIn('status',['active','ready'])->orderBy('is_default', 'DESC')->get(1)->getRow();
        $series = $issuer ? $this->db->table('fiscal_series')->where([
            'issuer_profile_id' => $issuer->id, 'is_active' => 1, 'deleted' => 0,
        ])->groupStart()->where('document_type', 'income')->orWhere('document_type', 'ingreso')->orWhere('document_type', 'I')->groupEnd()
            ->orderBy('is_default','DESC')->get()->getResult() : [];
        $catalog = static fn($db, string $table): array => $db->table($table)->where('is_active',1)->orderBy('code')->get()->getResult();
        return [
            'draft'=>$draft,'sales'=>$sales,'compatible_sales'=>$compatible,'receiver'=>$receiver,'issuer'=>$issuer,'series'=>$series,
            'payment_forms'=>$catalog($this->db,'sat_payment_forms'),
            'payment_methods'=>$catalog($this->db,'sat_payment_methods'),
            'cfdi_uses'=>$catalog($this->db,'sat_cfdi_uses'),
            'tax_regimes'=>$catalog($this->db,'sat_tax_regimes'),
            'max_issue_age_hours'=>(int)config('Fiscal')->maxIssueAgeHours,
            'saved_items'=>$draftId?$this->db->table('fiscal_draft_items')->where('fiscal_draft_id',$draftId)->get()->getResult():[],
        ];
    }

    public function save(array $input, int $userId, ?int $draftId = null): array
    {
        $saleIds = array_values(array_unique(array_filter(array_map('intval', (array)($input['sale_ids'] ?? [])))));
        if (!$saleIds) throw new RuntimeException('Selecciona al menos una venta.');
        $existing = $draftId ? $this->draft($draftId) : null;
        if ($existing && !in_array($existing->status, ['draft','ready','error'], true)) {
            throw new RuntimeException('El estado del borrador no permite edición.');
        }
        $anchor = $this->sale($saleIds[0]);
        $issuerId = (int)($input['issuer_id'] ?? 0);
        $receiverId = (int)($input['receiver_profile_id'] ?? 0);
        $currency = strtoupper(trim((string)($input['currency_code'] ?? 'MXN')));
        $quantities = (array)($input['quantities'] ?? []);
        $concepts = [];
        $bySale = [];
        foreach ($saleIds as $saleId) {
            $sale = $this->sale($saleId);
            if ((int)$sale->client_id !== (int)$anchor->client_id || (int)$sale->company_id !== (int)$anchor->company_id
                || $this->currencyForSale($sale) !== $this->currencyForSale($anchor)) {
                throw new RuntimeException('Las ventas seleccionadas no son compatibles.');
            }
            if ($sale->status === 'cancelled') throw new RuntimeException('Una venta cancelada no puede facturarse.');
            foreach ($this->saleItems($saleId, $draftId) as $item) {
                $quantity = trim((string)($quantities[$item->id] ?? '0'));
                if ($quantity === '' || FiscalDecimal::micros($quantity) === 0) continue;
                if (FiscalDecimal::micros($quantity) < 0 || FiscalDecimal::micros($quantity) > FiscalDecimal::micros((string)$item->quantity)) {
                    throw new RuntimeException('La cantidad seleccionada no es válida.');
                }
                $subtotal = FiscalDecimal::multiply($quantity, (string)$item->rate);
                $discount = FiscalDecimal::prorate((string)$sale->discount_total, $subtotal, (string)$sale->invoice_subtotal);
                $taxHeader = FiscalDecimal::add((string)$sale->tax,(string)$sale->tax2,(string)$sale->tax3);
                $tax = FiscalDecimal::prorate($taxHeader, $subtotal, (string)$sale->invoice_subtotal);
                $total = FiscalDecimal::add(FiscalDecimal::subtract($subtotal,$discount),$tax);
                $snapshot = $this->itemSnapshot($item);
                $concepts[] = [
                    'sale_id'=>$saleId,'sale_item_id'=>(int)$item->id,'product_id'=>(int)$item->item_id,
                    'quantity'=>$quantity,'unit_price'=>FiscalDecimal::format(FiscalDecimal::micros((string)$item->rate)),
                    'discount'=>$discount,'subtotal'=>$subtotal,'tax'=>$tax,'total'=>$total,'snapshot'=>$snapshot,
                ];
                $bySale[$saleId] ??= ['subtotal'=>'0','tax'=>'0','total'=>'0'];
                $bySale[$saleId]['subtotal'] = FiscalDecimal::add($bySale[$saleId]['subtotal'], FiscalDecimal::subtract($subtotal,$discount));
                $bySale[$saleId]['tax'] = FiscalDecimal::add($bySale[$saleId]['tax'],$tax);
                $bySale[$saleId]['total'] = FiscalDecimal::add($bySale[$saleId]['total'],$total);
            }
        }
        if (!$concepts) throw new RuntimeException('Selecciona al menos un concepto con cantidad mayor que cero.');
        $issuerPricing=$this->db->table('fiscal_profiles')->select('tax_pricing_mode')->where('id',$issuerId)->get(1)->getRow();
        $pricingMode=(string)($issuerPricing->tax_pricing_mode??'tax_inclusive');$taxSnapshots=new FiscalDraftTaxSnapshotService($this->db);$bySale=[];
        foreach($concepts as&$concept){
            $calculated=$taxSnapshots->calculate($concept,$pricingMode);
            $concept['subtotal']=FiscalDecimal::add($calculated['base'],$concept['discount']);
            $concept['tax']=FiscalDecimal::subtract($calculated['transferred'],$calculated['withheld']);
            $concept['total']=$calculated['total'];
            $concept['snapshot']+=['object_tax'=>$concept['snapshot']['tax_object_code']??'','snapshot_version'=>2];
            $concept['snapshot']['subtotal_before_tax']=$concept['subtotal'];$concept['snapshot']['discount']=$concept['discount'];
            $concept['snapshot']['taxable_base']=$calculated['base'];$concept['snapshot']['transferred_total']=$calculated['transferred'];
            $concept['snapshot']['withheld_total']=$calculated['withheld'];$concept['snapshot']['concept_total']=$calculated['total'];
            $concept['snapshot']['taxes']=$calculated['taxes'];$concept['_taxes']=$calculated['taxes'];
            $sid=(int)$concept['sale_id'];$bySale[$sid]??=['subtotal'=>'0.000000','tax'=>'0.000000','total'=>'0.000000'];
            $bySale[$sid]['subtotal']=FiscalDecimal::add($bySale[$sid]['subtotal'],$calculated['base']);
            $bySale[$sid]['tax']=FiscalDecimal::add($bySale[$sid]['tax'],$concept['tax']);
            $bySale[$sid]['total']=FiscalDecimal::add($bySale[$sid]['total'],$calculated['total']);
        }unset($concept);
        $allocations = [];
        foreach ($bySale as $saleId=>$amounts) {
            $this->allocations->validateAllocation((int)$saleId,$amounts['total'],$draftId);
            $allocations[] = ['sale_id'=>(int)$saleId,'allocated_subtotal'=>$amounts['subtotal'],'allocated_tax'=>$amounts['tax'],'allocated_total'=>$amounts['total']];
        }
        $subtotal=$discount=$tax=$total='0';
        foreach ($concepts as $concept) {
            $subtotal=FiscalDecimal::add($subtotal,$concept['subtotal']);
            $discount=FiscalDecimal::add($discount,$concept['discount']);
            $tax=FiscalDecimal::add($tax,$concept['tax']);
            $total=FiscalDecimal::add($total,$concept['total']);
        }
        $issueDate = str_replace('T',' ',trim((string)($input['issue_date']??'')));
        if (strlen($issueDate) === 16) $issueDate .= ':00';
        $issuer=$this->db->table('fiscal_profiles')->where(['id'=>$issuerId,'profile_type'=>'issuer'])->whereIn('status',['active','ready'])->get(1)->getRow();
        $receiver=$this->db->table('fiscal_profiles')->where(['id'=>$receiverId,'client_id'=>$anchor->client_id,'profile_type'=>'receiver'])->whereIn('status',['active','ready'])->get(1)->getRow();
        $regime=$receiver?$this->db->table('sat_tax_regimes')->where('id',$receiver->tax_regime_id)->get(1)->getRow():null;
        $cfdiUse=$receiver?$this->db->table('sat_cfdi_uses')->where('id',$receiver->default_cfdi_use_id)->get(1)->getRow():null;
        $seriesId=(int)($input['fiscal_series_id']??0);
        $series=$this->db->table('fiscal_series')->where(['id'=>$seriesId,'issuer_profile_id'=>$issuerId,'is_active'=>1,'deleted'=>0])->get(1)->getRow();
        $draftData = [
            'issuer_id'=>$issuerId,'receiver_profile_id'=>$receiverId,
            'fiscal_series_id'=>$seriesId?:null,
            'customer_id'=>(int)$anchor->client_id,'document_type'=>'I',
            'provisional_series'=>(string)($series->series??''),
            'issue_date'=>$issueDate,'currency_code'=>$currency,
            'exchange_rate'=>trim((string)($input['exchange_rate']??'1'))?:'1',
            'payment_form_code'=>trim((string)($input['payment_form_code']??'')),
            'payment_method_code'=>trim((string)($input['payment_method_code']??'')),
            'cfdi_use_code'=>(string)($cfdiUse->code??''),
            'receiver_tax_regime_code'=>(string)($regime->code??''),
            'receiver_postal_code'=>(string)($receiver->fiscal_postal_code??''),
            'expedition_postal_code'=>(string)($issuer->expedition_postal_code??''),
            'subtotal'=>$subtotal,'discount'=>$discount,'tax_total'=>$tax,'total'=>$total,
            'conditions'=>trim((string)($input['conditions']??'')),
            'observations'=>trim((string)($input['observations']??'')),
            'snapshot_version'=>2,'requires_snapshot_refresh'=>0,'snapshot_completed_at'=>get_current_utc_time(),
        ];
        $validation = $this->validation->validate($draftData,$allocations,$concepts);
        $fatal = array_filter($validation['errors'], static fn(array $error): bool => in_array($error['section'], ['sales','concepts','document'],true));
        if ($fatal) throw new RuntimeException($fatal[0]['message']);
        $draftData['status']=$validation['valid']?'ready':'draft';
        $draftData['ready_at']=$validation['valid']?get_current_utc_time():null;
        $draftData['fiscal_payload']=json_encode([
            'issuer_profile_id'=>$issuerId,'receiver_profile_id'=>$receiverId,
            'issuer_snapshot'=>$issuer?(array)$issuer:[],'receiver_snapshot'=>$receiver?(array)$receiver:[],
            'series_snapshot'=>$series?(array)$series:[],
            'concepts'=>$concepts,'taxes'=>array_map(static fn(array$c):array=>['sale_item_id'=>$c['sale_item_id'],'tax'=>$c['tax']],$concepts),
            'observations'=>$draftData['observations'],'validation'=>$validation,
        ],JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);
        $now=get_current_utc_time();
        $this->db->transBegin();
        try {
            foreach ($saleIds as $saleId) $this->db->query('SELECT id FROM '.$this->db->prefixTable('invoices').' WHERE id=? AND deleted=0 FOR UPDATE',[$saleId]);
            foreach ($allocations as $allocation) $this->allocations->validateAllocation($allocation['sale_id'],$allocation['allocated_total'],$draftId);
            if ($draftId) {
                $this->db->table('fiscal_drafts')->where('id',$draftId)->update($draftData+['updated_by'=>$userId,'updated_at'=>$now]);
                $id=$draftId;$event='draft_updated';
            } else {
                $this->db->table('fiscal_drafts')->insert($draftData+['created_by'=>$userId,'updated_by'=>$userId,'created_at'=>$now,'updated_at'=>$now]);
                $id=(int)$this->db->insertID();$event='draft_created';
            }
            $this->allocations->reserveDraftAllocations($id,$allocations,$userId);
            $oldItemIds=array_column($this->db->table('fiscal_draft_items')->select('id')->where('fiscal_draft_id',$id)->get()->getResultArray(),'id');
            if($oldItemIds)$this->db->table('fiscal_draft_item_taxes')->whereIn('fiscal_draft_item_id',$oldItemIds)->delete();
            $this->db->table('fiscal_draft_items')->where('fiscal_draft_id',$id)->delete();
            foreach ($concepts as $concept) {
                $snapshot=$concept['snapshot'];$itemTaxes=$concept['_taxes'];unset($concept['snapshot'],$concept['_taxes']);
                $this->db->table('fiscal_draft_items')->insert($concept+[
                    'fiscal_draft_id'=>$id,'fiscal_snapshot'=>json_encode($snapshot,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES),
                    'created_at'=>$now,'updated_at'=>$now,
                ]);
                $draftItemId=(int)$this->db->insertID();foreach($itemTaxes as$tax)$this->db->table('fiscal_draft_item_taxes')->insert($tax+[
                    'fiscal_draft_id'=>$id,'fiscal_draft_item_id'=>$draftItemId,'sale_id'=>$concept['sale_id'],
                    'sale_item_id'=>$concept['sale_item_id'],'source'=>'snapshot','created_at'=>$now,'updated_at'=>$now,
                ]);
                $this->audit($id,(int)$concept['sale_id'],$userId,$draftId?'draft_tax_snapshot_updated':'draft_tax_snapshot_created',['item_id'=>$draftItemId,'tax_count'=>count($itemTaxes),'snapshot_version'=>2]);
            }
            $this->audit($id,null,$userId,$event,['sales'=>$saleIds,'total'=>$total,'status'=>$draftData['status']]);
            foreach ($allocations as $allocation) $this->audit($id,$allocation['sale_id'],$userId,$draftId?'allocation_changed':'allocation_reserved',['total'=>$allocation['allocated_total']]);
            if ($draftData['status']==='ready') $this->audit($id,null,$userId,'draft_marked_ready',['validation'=>'complete']);
            if (!$this->db->transStatus()) throw new RuntimeException('No fue posible guardar el borrador.');
            $this->db->transCommit();
            return ['id'=>$id,'status'=>$draftData['status'],'validation'=>$validation];
        } catch (Throwable $e) {
            $this->db->transRollback();
            if (str_contains($e->getMessage(),'EXCEEDS_AVAILABLE')) throw new RuntimeException('El saldo disponible de una o más ventas cambió. Revisa las asignaciones antes de guardar nuevamente.');
            throw $e;
        }
    }

    public function discard(int $draftId, int $userId, string $reason = ''): void
    {
        $draft=$this->draft($draftId);
        if (!in_array($draft->status,['draft','ready','error'],true)) throw new RuntimeException('El borrador no puede descartarse en su estado actual.');
        $sales=array_map('intval',array_column($this->db->table('fiscal_draft_sales')->select('sale_id')->where(['fiscal_draft_id'=>$draftId,'allocation_status'=>'reserved'])->get()->getResultArray(),'sale_id'));
        $this->db->transBegin();
        try {
            $this->allocations->releaseDraftAllocations($draftId,$userId);
            $this->db->table('fiscal_drafts')->where('id',$draftId)->update(['discarded_reason'=>mb_substr(trim($reason),0,500),'discarded_at'=>get_current_utc_time()]);
            $this->audit($draftId,null,$userId,'draft_discarded',['reason_present'=>trim($reason)!=='']);
            foreach($sales as$saleId)$this->audit($draftId,$saleId,$userId,'allocation_released',[]);
            if(!$this->db->transStatus())throw new RuntimeException('No fue posible descartar el borrador.');
            $this->db->transCommit();
        }catch(Throwable$e){$this->db->transRollback();throw$e;}
    }

    public function markReady(int $draftId, int $userId): void
    {
        $draft=$this->draft($draftId);
        if(!in_array($draft->status,['draft','ready','error'],true))throw new RuntimeException('El estado del borrador no permite marcarlo como listo.');
        $allocations=$this->db->table('fiscal_draft_sales')->where(['fiscal_draft_id'=>$draftId,'allocation_status'=>'reserved'])->get()->getResultArray();
        $rows=$this->db->table('fiscal_draft_items')->where('fiscal_draft_id',$draftId)->get()->getResultArray();$concepts=[];
        foreach($rows as$row){$concepts[]=['quantity'=>$row['quantity'],'total'=>$row['total'],'snapshot'=>json_decode((string)$row['fiscal_snapshot'],true)?:[]];}
        $validation=$this->validation->validate((array)$draft+['receiver_profile_id'=>$draft->receiver_profile_id],$allocations,$concepts);
        if(!$validation['valid'])throw new RuntimeException($validation['errors'][0]['message']??'El borrador todavía tiene datos pendientes.');
        $now=get_current_utc_time();$this->db->table('fiscal_drafts')->where('id',$draftId)->update(['status'=>'ready','ready_at'=>$now,'updated_by'=>$userId,'updated_at'=>$now]);
        $this->audit($draftId,null,$userId,'draft_marked_ready',['validation'=>'complete']);
    }

    public function updateReceiver(int $profileId, int $clientId, array $input, int $userId): void
    {
        $profile=$this->db->table('fiscal_profiles')->where(['id'=>$profileId,'client_id'=>$clientId,'profile_type'=>'receiver'])->whereIn('status',['active','ready'])->get(1)->getRowArray();
        if(!$profile)throw new RuntimeException('El perfil fiscal del receptor no existe.');
        $allowed=['legal_name','rfc','fiscal_postal_code','tax_regime_id','default_cfdi_use_id','email'];
        $changes=[];$data=[];
        foreach($allowed as$field){$value=trim((string)($input[$field]??''));if((string)($profile[$field]??'')!==$value){$data[$field]=$value;$changes[]=$field;}}
        if(!$changes)return;
        $data['updated_at']=get_current_utc_time();$this->db->table('fiscal_profiles')->where('id',$profileId)->update($data);
        $this->audit(null,null,$userId,'receiver_updated',['profile_id'=>$profileId,'fields'=>$changes]);
    }

    public function auditPreinvoice(int $draftId,int$userId):void{$this->audit($draftId,null,$userId,'preinvoice_viewed',[]);}

    private function sale(int $id): object
    {
        $sale=$this->db->table('invoices')->where(['id'=>$id,'deleted'=>0])->get(1)->getRow();
        if(!$sale)throw new RuntimeException('La venta no existe.');
        return$sale;
    }
    private function draft(int$id):object{$row=$this->db->table('fiscal_drafts')->where('id',$id)->get(1)->getRow();if(!$row)throw new RuntimeException('El borrador no existe.');return$row;}
    private function currencyForSale(object$sale):string{$client=$this->db->table('clients')->select('currency')->where('id',$sale->client_id)->get(1)->getRow();return strtoupper(trim((string)($client->currency??''))?:get_setting('default_currency')?:'MXN');}
    private function saleItems(int$saleId,?int$draftId):array{return$this->db->table('invoice_items')->where(['invoice_id'=>$saleId,'deleted'=>0])->orderBy('sort')->get()->getResult();}
    private function itemSnapshot(object$item):array
    {
        $settings=$this->db->table('item_fiscal_settings s')->select('s.*,p.code product_service_code,u.code unit_code,o.code tax_object_code')
            ->join('sat_product_service_keys p','p.id=s.sat_product_service_key_id','left')
            ->join('sat_unit_keys u','u.id=s.sat_unit_key_id','left')
            ->join('sat_tax_object_codes o','o.id=s.tax_object_code_id','left')
            ->where(['s.item_id'=>$item->item_id,'s.deleted'=>0])->whereIn('s.status',['active','ready'])
            ->orderBy('s.is_default','DESC')->get(1)->getRowArray();
        return [
            'title'=>(string)$item->title,'description'=>(string)$item->description,'commercial_unit'=>(string)$item->unit_type,
            'product_service_code'=>(string)($settings['product_service_code']??''),
            'unit_code'=>(string)($settings['unit_code']??''),'tax_object_code'=>(string)($settings['tax_object_code']??''),
            'fiscal_description'=>(string)($settings['fiscal_description']??$item->description??$item->title),
        ];
    }
    private function audit(?int$draftId,?int$saleId,int$userId,string$event,array$summary):void{$this->db->table('fiscal_draft_audit')->insert(['fiscal_draft_id'=>$draftId,'sale_id'=>$saleId,'user_id'=>$userId,'event'=>$event,'summary_json'=>json_encode($summary,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES),'created_at'=>get_current_utc_time()]);}
}
