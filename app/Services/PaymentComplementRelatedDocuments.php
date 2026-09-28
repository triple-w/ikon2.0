<?php
declare(strict_types=1);
namespace App\Services;

use App\Services\Fiscal\FiscalDecimal;
use RuntimeException;

/** Shared fiscal input; external records never enter the administrative ledger. */
final class PaymentComplementRelatedDocuments
{
    public function __construct(private $db) {}

    public function external(int $paymentId): array
    {
        return $this->db->table('payment_complement_external_documents')
            ->where(['payment_complement_payment_id'=>$paymentId, 'deleted'=>0])->orderBy('id')->get()->getResult();
    }

    public function documents(int $paymentId): array
    {
        $result = [];
        $resolver = new FiscalDocumentHistoricalTaxResolver($this->db);
        $internal = $this->db->table('payment_complement_documents d')->select('d.*,f.series,f.folio,f.payment_method_code')
            ->join('fiscal_documents f','f.id=d.fiscal_document_id')->where(['d.payment_complement_payment_id'=>$paymentId,'d.deleted'=>0])->orderBy('d.id')->get()->getResult();
        foreach ($internal as $d) {
            $history = $resolver->resolve((int)$d->fiscal_document_id);
            $result[] = ['source'=>'internal','id'=>(int)$d->id,'uuid'=>$d->document_uuid,'series'=>$d->series,'folio'=>$d->folio,
                'currency'=>$d->currency_dr ?: 'MXN','equivalence'=>$d->equivalence_dr ?: '1','payment_method'=>$d->payment_method_code,
                'tax_object'=>$history['tax_object_code'],'installment'=>$d->installment_number,'previous_balance'=>$d->previous_balance,
                'paid_amount'=>$d->amount_paid,'remaining_balance'=>$d->remaining_balance,
                'taxes'=>$resolver->prorate($history,(string)$d->amount_paid,(string)$d->previous_balance)];
        }
        foreach ($this->external($paymentId) as $d) $result[] = $this->normalizeExternal($d);
        return $result;
    }

    public function normalizeExternal(object $d): array
    {
        $taxes = $this->db->table('payment_complement_external_taxes')->where('external_document_id',$d->id)->orderBy('id')->get()->getResultArray();
        return ['source'=>'external','id'=>(int)$d->id,'uuid'=>$d->uuid,'series'=>$d->series,'folio'=>$d->folio,
            'currency'=>$d->currency_code,'equivalence'=>$d->exchange_rate,'payment_method'=>$d->payment_method_code,
            'tax_object'=>$d->tax_object_code,'installment'=>$d->installment_number,'previous_balance'=>$d->previous_balance,
            'paid_amount'=>$d->paid_amount,'remaining_balance'=>$d->remaining_balance,'taxes'=>$taxes];
    }

    /** EquivalenciaDR: DR currency units per one payment currency unit, up to 10 decimals. */
    public static function inPaymentCurrency(string $amount, string $equivalence): string
    {
        if (!preg_match('/^\d{1,18}(?:\.\d{1,10})?$/',$equivalence) || bccomp($equivalence,'0',10)<=0) {
            throw new RuntimeException('EquivalenciaDR debe ser mayor que cero y tener hasta diez decimales.');
        }
        $converted=bcadd(bcdiv($amount,$equivalence,12),'0.0000005',6);if(bccomp($converted,'999999999999.999999',6)>0)throw new RuntimeException('El importe convertido excede la precisión admitida.');return $converted;
    }

    public function applied(int $paymentId): string
    {
        $total='0.000000';
        foreach ($this->db->table('payment_complement_documents')->where(['payment_complement_payment_id'=>$paymentId,'deleted'=>0])->get()->getResult() as $d) {
            $total=FiscalDecimal::add($total,self::inPaymentCurrency((string)$d->amount_paid,(string)($d->equivalence_dr ?: '1')));
        }
        foreach ($this->external($paymentId) as $d) $total=FiscalDecimal::add($total,self::inPaymentCurrency((string)$d->paid_amount,(string)$d->exchange_rate));
        $payment=$this->db->table('payment_complement_payments')->where('id',$paymentId)->get(1)->getRow();
        return self::paymentAmount($total,(string)$payment->currency_code);
    }

    public static function paymentAmount(string $amount, string $currency): string
    {
        // Currencies currently provided by the application's SAT catalog have two decimals.
        if (in_array($currency,['MXN','USD','EUR'],true)) return bcadd(bcadd($amount,'0.005',2),'0',6);
        return $amount;
    }

    public static function taxAmount(string $amount): string
    {
        $value=FiscalDecimal::format(FiscalDecimal::micros($amount));
        [$whole,$fraction]=explode('.',$value);
        return $whole.'.'.str_pad(rtrim($fraction,'0'),2,'0');
    }
}
