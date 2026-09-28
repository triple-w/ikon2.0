<?php
declare(strict_types=1);
namespace App\Services;

use App\Services\Fiscal\FiscalDecimal;

/** Builds Pagos 2.0 from normalized DRs, regardless of their origin. */
final class PaymentComplementPaymentBuilder
{
    public function build(array $payment, array $documents): array
    {
        $payment['DoctoRelacionado']=[];
        $payment['ImpuestosP']=['TrasladosP'=>[],'RetencionesP'=>[]];
        foreach ($documents as $d) {
            $equivalence=$d['currency']===$payment['MonedaP']?'1':(string)$d['equivalence'];
            $dr=['IdDocumento'=>$d['uuid'],'Serie'=>$d['series'],'Folio'=>$d['folio'],'MonedaDR'=>$d['currency'],
                'EquivalenciaDR'=>$equivalence,'NumParcialidad'=>(int)$d['installment'],'ImpSaldoAnt'=>$d['previous_balance'],
                'ImpPagado'=>$d['paid_amount'],'ImpSaldoInsoluto'=>$d['remaining_balance'],'ObjetoImpDR'=>$d['tax_object'],
                'ImpuestosDR'=>['TrasladosDR'=>[],'RetencionesDR'=>[]]];
            foreach ($d['taxes'] as $t) {
                $withheld=$t['tax_type']==='withholding';
                $node=['BaseDR'=>$t['base'],'ImpuestoDR'=>$t['tax_code'],'TipoFactorDR'=>$t['factor_type']];
                if ($t['factor_type']!=='Exento') $node+=['TasaOCuotaDR'=>$t['rate_or_quota'],'ImporteDR'=>$t['amount']];
                $dr['ImpuestosDR'][$withheld?'RetencionesDR':'TrasladosDR'][]=$node;
                $kind=$withheld?'RetencionesP':'TrasladosP';
                $key=$withheld?$t['tax_code']:implode('|',[$t['tax_code'],$t['factor_type'],(string)$t['rate_or_quota']]);
                $bucket=&$payment['ImpuestosP'][$kind][$key];
                $bucket['ImpuestoP']=$t['tax_code'];
                if (!$withheld) {
                    $bucket['BaseP']=FiscalDecimal::add($bucket['BaseP']??'0',PaymentComplementRelatedDocuments::inPaymentCurrency((string)$t['base'],$equivalence));
                    $bucket['TipoFactorP']=$t['factor_type'];
                    if ($t['factor_type']!=='Exento') $bucket['TasaOCuotaP']=$t['rate_or_quota'];
                }
                if ($t['factor_type']!=='Exento') $bucket['ImporteP']=FiscalDecimal::add($bucket['ImporteP']??'0',PaymentComplementRelatedDocuments::inPaymentCurrency((string)$t['amount'],$equivalence));
                unset($bucket);
            }
            $payment['DoctoRelacionado'][]=$dr;
        }
        return $payment;
    }

    /** Totales is in MXN; ImpuestosP stays in each payment's own currency. */
    public function accumulate(array $totals, array $payment): array
    {
        $rate=$payment['MonedaP']==='MXN'?'1':(string)$payment['TipoCambioP'];
        $totals['MontoTotalPagos']=FiscalDecimal::add($totals['MontoTotalPagos'],FiscalDecimal::multiply((string)$payment['Monto'],$rate));
        foreach (['TrasladosP','RetencionesP'] as $kind) foreach ($payment['ImpuestosP'][$kind] as $key=>$tax) {
            $previous=$totals[$kind][$key]??[];
            $totals[$kind][$key]=$tax;
            foreach (['BaseP','ImporteP'] as $field) if (isset($tax[$field])) $totals[$kind][$key][$field]=FiscalDecimal::add($previous[$field]??'0',FiscalDecimal::multiply((string)$tax[$field],$rate));
        }
        return $totals;
    }
}
