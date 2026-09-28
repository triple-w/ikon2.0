<?php
declare(strict_types=1);
namespace App\Services;

use App\Services\Fiscal\FiscalDecimal;
use RuntimeException;
use Throwable;

final class PaymentComplementExternalDocumentService
{
    public function __construct(private $db) {}

    public function validate(array $input, string $paymentCurrency): array
    {
        $uuid=strtoupper(trim((string)($input['uuid']??'')));
        if (!preg_match('/^[0-9A-F]{8}-(?:[0-9A-F]{4}-){3}[0-9A-F]{12}$/D',$uuid)) throw new RuntimeException('UUID inválido.');
        $currency=strtoupper(trim((string)($input['currency_code']??'')));
        if ($currency==='XXX'||!$this->db->table('sat_currencies')->where(['code'=>$currency,'is_active'=>1])->countAllResults()) throw new RuntimeException('Seleccione una moneda SAT activa.');
        $equivalence=trim((string)($input['exchange_rate']??''));
        if ($currency===$paymentCurrency) {
            if ($equivalence!=='' && (!preg_match('/^\d{1,18}(?:\.\d{1,10})?$/D',$equivalence)||bccomp($equivalence,'1',10)!==0)) throw new RuntimeException('EquivalenciaDR debe ser 1 cuando las monedas coinciden.');
            $equivalence='1';
        }
        PaymentComplementRelatedDocuments::inPaymentCurrency('1',$equivalence);
        if (($input['payment_method_code']??'PPD')!=='PPD') throw new RuntimeException('El CFDI relacionado debe tener método de pago PPD.');
        $installment=(string)($input['installment_number']??'');
        if (!preg_match('/^[1-9]\d{0,8}$/D',$installment)) throw new RuntimeException('NumParcialidad debe ser un entero mayor o igual a 1.');
        $previous=$this->decimal($input['previous_balance']??'');
        $paid=$this->decimal($input['paid_amount']??'');
        if (in_array($currency,['MXN','USD','EUR'],true) &&
            (bccomp($previous,bcadd($previous,'0',2),6)!==0 || bccomp($paid,bcadd($paid,'0',2),6)!==0)) {
            throw new RuntimeException('Los saldos e importe pagado en '.$currency.' admiten hasta dos decimales.');
        }
        if (bccomp($previous,'0',6)<=0||bccomp($paid,'0',6)<=0||bccomp($paid,$previous,6)>0) throw new RuntimeException('El importe pagado debe ser mayor que cero y no exceder el saldo anterior.');
        $remaining=FiscalDecimal::subtract($previous,$paid);
        if (isset($input['remaining_balance'])&&trim((string)$input['remaining_balance'])!==''&&$this->decimal($input['remaining_balance'])!==$remaining) throw new RuntimeException('ImpSaldoInsoluto debe ser saldo anterior menos importe pagado.');
        $object=(string)($input['tax_object_code']??'');
        if (!in_array($object,['01','02','03'],true)) throw new RuntimeException('ObjetoImpDR debe ser 01, 02 o 03.');
        if(!is_array($input['taxes']??[]))throw new RuntimeException('El desglose de impuestos debe ser una lista.');$taxes=[];$keys=[];
        foreach (($input['taxes']??[]) as $tax) {
            if (!is_array($tax)) throw new RuntimeException('Impuesto DR inválido.');
            $type=(string)($tax['tax_type']??'');$code=(string)($tax['tax_code']??'');$factor=(string)($tax['factor_type']??'');
            if (!in_array($type,['transfer','withholding'],true)||!in_array($code,['001','002','003'],true)||!in_array($factor,['Tasa','Cuota','Exento'],true)) throw new RuntimeException('Tipo, impuesto o factor DR inválido.');
            if ($type==='withholding'&&$factor==='Exento') throw new RuntimeException('Una retención no puede ser Exento.');
            $base=$this->decimal($tax['base']??'');
            if (bccomp($base,'0',6)<=0) throw new RuntimeException('BaseDR debe ser mayor que cero.');
            $rate=$factor==='Exento'?null:$this->decimal($tax['rate_or_quota']??'');
            $amount=$factor==='Exento'?null:$this->decimal($tax['amount']??'');
            if ($factor!=='Exento') {
                // SAT bounds use the precision actually serialized, not a fixed IVA or float tolerance.
                $baseScale=strlen(explode('.',PaymentComplementRelatedDocuments::taxAmount($base))[1]);
                $amountScale=strlen(explode('.',PaymentComplementRelatedDocuments::taxAmount($amount))[1]);
                $halfUnit=bcdiv('1',bcpow('10',(string)$baseScale,0),12);
                $halfUnit=bcdiv($halfUnit,'2',12);
                $lower=bcmul(bcsub($base,$halfUnit,12),$rate,$amountScale);
                $upper=bcmul(bcsub(bcadd($base,$halfUnit,12),'0.000000000001',12),$rate,12);
                $unit=bcdiv('1',bcpow('10',(string)$amountScale,0),12);
                $upper=bcadd($upper,bcsub($unit,'0.000000000001',12),$amountScale);
                if (bccomp($amount,$lower,6)<0||bccomp($amount,$upper,6)>0) throw new RuntimeException('ImporteDR está fuera de los límites de BaseDR por TasaOCuotaDR.');
            }
            $key=implode('|',[$type,$code,$factor,$rate]);
            if (isset($keys[$key])) throw new RuntimeException('Agrupe las bases del mismo impuesto, factor y tasa en una sola fila.');
            $keys[$key]=true;
            $taxes[]=['tax_type'=>$type,'base'=>$base,'tax_code'=>$code,'factor_type'=>$factor,'rate_or_quota'=>$rate,'amount'=>$amount];
        }
        if (($object==='02'&&!$taxes)||($object!=='02'&&$taxes)) throw new RuntimeException('ObjetoImpDR 02 requiere impuestos DR; 01 y 03 no deben incluir desglose.');
        $series=trim((string)($input['series']??''));$folio=trim((string)($input['folio']??''));
        if (mb_strlen($series)>25||mb_strlen($folio)>40||preg_match('/[|\x00-\x1F]/',$series.$folio)) throw new RuntimeException('Serie o folio inválido.');
        return ['uuid'=>$uuid,'series'=>$series,'folio'=>$folio,'currency_code'=>$currency,'exchange_rate'=>$equivalence,
            'payment_method_code'=>'PPD','tax_object_code'=>$object,'installment_number'=>(int)$installment,
            'previous_balance'=>$previous,'paid_amount'=>$paid,'remaining_balance'=>$remaining,'taxes'=>$taxes];
    }

    public function get(int $complementId, int $id): object
    {
        $row=$this->db->table('payment_complement_external_documents')->where(['id'=>$id,'payment_complement_id'=>$complementId,'deleted'=>0])->get(1)->getRow();
        if (!$row) throw new RuntimeException('El CFDI externo no pertenece a este complemento.');
        $row->taxes=$this->db->table('payment_complement_external_taxes')->where('external_document_id',$id)->orderBy('id')->get()->getResultArray();
        return $row;
    }

    public function save(int $complementId, int $id, array $input, ?int $actor): int
    {
        $this->db->transBegin();
        try {
            $drafts=new PaymentComplementDraftService($this->db);
            $context=$drafts->lockedContext($complementId);
            $source=$this->db->query('SELECT * FROM '.$this->db->prefixTable('invoice_payments').' WHERE id=? FOR UPDATE',[$context->source_invoice_payment_id])->getRow();
            if (!$source||$source->status!=='active'||$source->deleted) throw new RuntimeException('El pago origen ya no está activo.');
            $payment=$this->db->table('payment_complement_payments')->where('id',$context->payment_snapshot_id)->get(1)->getRow();
            if ($id) $this->get($complementId,$id);
            $data=$this->validate($input,(string)$payment->currency_code);
            $duplicate=$this->db->table('payment_complement_external_documents')->where(['payment_complement_id'=>$complementId,'uuid'=>$data['uuid'],'deleted'=>0])->where('id !=',$id)->countAllResults();
            $internal=$this->db->table('payment_complement_documents')->where(['payment_complement_payment_id'=>$payment->id,'document_uuid'=>$data['uuid'],'deleted'=>0])->countAllResults();
            if ($duplicate||$internal) throw new RuntimeException('El UUID ya está relacionado en este complemento.');
            // Internal CFDIs must use the existing balance/reservation machinery.
            if ($this->db->table('fiscal_document_stamps')->where('uuid',$data['uuid'])->countAllResults()) throw new RuntimeException('El UUID existe en iKontrol; agréguelo desde Facturas elegibles.');
            $taxes=$data['taxes'];unset($data['taxes']);$now=get_current_utc_time();$data['updated_at']=$now;
            if ($id) {
                $this->db->table('payment_complement_external_documents')->where('id',$id)->update($data);
                $this->db->table('payment_complement_external_taxes')->where('external_document_id',$id)->delete();
            } else {
                $this->db->table('payment_complement_external_documents')->insert($data+['payment_complement_id'=>$complementId,'payment_complement_payment_id'=>$payment->id,'created_by'=>$actor,'created_at'=>$now,'deleted'=>0]);
                $id=(int)$this->db->insertID();
            }
            foreach ($taxes as $tax) $this->db->table('payment_complement_external_taxes')->insert($tax+['external_document_id'=>$id]);
            $total=(new PaymentComplementRelatedDocuments($this->db))->applied((int)$payment->id);
            if (bccomp($total,(string)$source->amount,6)>0) throw new RuntimeException('El importe aplicado excede el monto fiscal disponible del pago.');
            $drafts->syncTotals($complementId,(int)$payment->id);
            if (!$this->db->transStatus()) throw new RuntimeException('No fue posible guardar el CFDI externo.');
            $this->db->transCommit();return $id;
        } catch (Throwable $e) {$this->db->transRollback();throw $e;}
    }

    public function remove(int $complementId, int $id): void
    {
        $this->db->transBegin();
        try {
            $drafts=new PaymentComplementDraftService($this->db);$context=$drafts->lockedContext($complementId);
            $this->get($complementId,$id);
            $this->db->table('payment_complement_external_documents')->where('id',$id)->update(['deleted'=>1,'updated_at'=>get_current_utc_time()]);
            $drafts->syncTotals($complementId,$context->payment_snapshot_id);
            if (!$this->db->transStatus()) throw new RuntimeException('No fue posible quitar el CFDI externo.');
            $this->db->transCommit();
        } catch (Throwable $e) {$this->db->transRollback();throw $e;}
    }

    private function decimal($value): string
    {
        $value=trim((string)$value);
        if (!preg_match('/^\d{1,12}(?:\.\d{1,6})?$/D',$value)) throw new RuntimeException('Importe inválido: use un número positivo con hasta seis decimales, sin separadores.');
        return FiscalDecimal::format(FiscalDecimal::micros($value));
    }
}
