<?php
declare(strict_types=1);
namespace App\Services\Fiscal;

/** Builds a complete fiscal review in memory. It never inserts a fiscal draft. */
final class FiscalReviewPreparation
{
    public function __construct(private mixed$db=null){$this->db??=db_connect();}

    public function prepare(array$data,array$input):array
    {
        $issuer=$data['issuer']??null;$receiver=$data['receiver']??null;$series=null;foreach(($data['series']??[])as$candidate)if((int)$candidate->id===(int)($input['fiscal_series_id']??0)){$series=$candidate;break;}
        try{$issueDate=(new FiscalIssueDateNormalizer())->normalizeTransport($input['issue_date']??null);}catch(\Throwable){$issueDate=trim((string)($input['issue_date']??''));}
        $draft=['id'=>0,'issuer_id'=>(int)($issuer->id??0),'receiver_profile_id'=>(int)($receiver->id??0),'fiscal_series_id'=>(int)($series->id??0),'issue_date'=>$issueDate,'currency_code'=>(string)($input['currency_code']??'MXN'),'exchange_rate'=>(string)($input['exchange_rate']??'1.000000'),'payment_method_code'=>(string)($input['payment_method_code']??''),'payment_form_code'=>(string)($input['payment_form_code']??''),'cfdi_use_code'=>(string)($input['cfdi_use_code']??''),'environment'=>config('Fiscal')->environment,'snapshot_version'=>2,'requires_snapshot_refresh'=>0,'snapshot_completed_at'=>get_current_utc_time()];
        // FiscalResolvedInvoiceLineService delegates to CommercialItemTaxResolver;
        // review and persistence therefore share override -> master -> blocker resolution.
        $items=[];$allocations=[];$subtotal=$discount=$transferred=$withheld=$total='0.000000';$resolver=new FiscalResolvedInvoiceLineService($this->db);
        foreach(($data['sales']??[])as$entry){$saleFull=$this->db->table('invoices')->where('id',(int)$entry['sale']->id)->get(1)->getRow();$saleTotal='0.000000';foreach($entry['items']as$item){$quantity=(string)$item->quantity;$commercialSubtotal=FiscalDecimal::multiply($quantity,(string)$item->rate);$lineDiscount=FiscalDecimal::micros((string)($saleFull->invoice_subtotal??'0'))>0?FiscalDecimal::prorate((string)($saleFull->discount_total??'0'),$commercialSubtotal,(string)$saleFull->invoice_subtotal):'0.000000';$line=$resolver->resolve($item,$quantity,$lineDiscount,(int)($issuer->id??0));$line['sale_id']=(int)$entry['sale']->id;$snapshot=$line['snapshot'];
                if(!$line['ready']){$snapshot['resolution_blockers']=$line['blockers'];$line['snapshot']=$snapshot;$line['subtotal']=$commercialSubtotal;$line['tax']='0.000000';$line['total']=FiscalDecimal::subtract($commercialSubtotal,$lineDiscount);$line['taxes']=[];}
                $items[]=$line;$subtotal=FiscalDecimal::add($subtotal,$line['subtotal']);$discount=FiscalDecimal::add($discount,$lineDiscount);$transferred=FiscalDecimal::add($transferred,(string)($snapshot['transferred_total']??'0.000000'));$withheld=FiscalDecimal::add($withheld,(string)($snapshot['withheld_total']??'0.000000'));$total=FiscalDecimal::add($total,$line['total']);$saleTotal=FiscalDecimal::add($saleTotal,$line['total']);}
            $allocations[]=['sale_id'=>(int)$entry['sale']->id,'allocated_total'=>$saleTotal,'allocation_status'=>'reserved'];}
        $draft+=['subtotal'=>$subtotal,'discount'=>$discount,'tax_total'=>FiscalDecimal::subtract($transferred,$withheld),'total'=>$total];$concepts=array_map(static fn(array$i)=>['quantity'=>$i['quantity'],'total'=>$i['total'],'snapshot'=>$i['snapshot']],$items);$validation=(new FiscalDraftValidationService($this->db))->validate($draft,$allocations,$concepts);
        return['draft'=>$draft,'items'=>$items,'allocations'=>$allocations,'totals'=>['subtotal'=>$subtotal,'discount'=>$discount,'transferred'=>$transferred,'withheld'=>$withheld,'total'=>$total],'validation'=>$validation];
    }
}
