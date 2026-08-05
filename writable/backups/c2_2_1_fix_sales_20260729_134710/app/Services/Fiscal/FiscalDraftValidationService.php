<?php
declare(strict_types=1);
namespace App\Services\Fiscal;

use Throwable;

final class FiscalDraftValidationService
{
    public function __construct(private mixed $db = null, private ?FiscalIssueDatePolicy $dates = null)
    {
        $this->db ??= db_connect();
        $this->dates ??= new FiscalIssueDatePolicy();
    }

    public function validate(array $draft, array $allocations, array $concepts): array
    {
        $errors = [];
        $warnings = [];
        $add = static function (array &$target, string $field, string $code, string $message, string $section): void {
            $target[] = compact('field','code','message','section');
        };
        $issuer = $this->db->table('fiscal_profiles')->where([
            'id' => (int) ($draft['issuer_id'] ?? 0), 'profile_type' => 'issuer',
        ])->whereIn('status',['active','ready'])->get(1)->getRow();
        if (!$issuer) $add($errors,'issuer_id','ISSUER_REQUIRED','Selecciona un emisor fiscal activo.','issuer');
        if ($issuer) {
            foreach (['rfc'=>'RFC','legal_name'=>'razón social','tax_regime_id'=>'régimen fiscal','expedition_postal_code'=>'código postal de expedición'] as $field=>$label) {
                if (trim((string) ($issuer->{$field} ?? '')) === '') $add($errors,$field,'ISSUER_FIELD_REQUIRED',"Falta {$label} del emisor.",'issuer');
            }
            $certificate = $this->db->table('fiscal_issuer_certificates')->where([
                'issuer_profile_id' => (int) $issuer->id, 'deleted' => 0,
            ])->whereIn('status',['active','valid'])->where('valid_from <=', date('Y-m-d H:i:s'))->where('valid_to >=', date('Y-m-d H:i:s'))->get(1)->getRow();
            if (!$certificate) $add($errors,'certificate','CSD_NOT_USABLE','El emisor no tiene un CSD vigente y utilizable.','issuer');
        }
        $receiver = $this->db->table('fiscal_profiles')->where([
            'id' => (int) ($draft['receiver_profile_id'] ?? 0), 'profile_type' => 'receiver',
        ])->whereIn('status',['active','ready'])->get(1)->getRow();
        if (!$receiver) {
            $add($errors,'receiver_profile_id','RECEIVER_REQUIRED','Faltan los datos fiscales del receptor.','receiver');
        } else {
            foreach ([
                'rfc'=>'RFC del receptor','legal_name'=>'razón social del receptor',
                'tax_regime_id'=>'régimen fiscal del receptor','fiscal_postal_code'=>'código postal fiscal',
                'default_cfdi_use_id'=>'uso CFDI',
            ] as $field=>$label) {
                if (trim((string) ($receiver->{$field} ?? '')) === '' || (str_ends_with($field, '_id') && (int)$receiver->{$field} <= 0)) {
                    $add($errors,$field,'RECEIVER_FIELD_REQUIRED',"Falta {$label}.",'receiver');
                }
            }
        }
        foreach (['payment_form_code'=>'forma de pago','payment_method_code'=>'método de pago','currency_code'=>'moneda'] as $field=>$label) {
            if (trim((string) ($draft[$field] ?? '')) === '') $add($errors,$field,'COMPROBANTE_FIELD_REQUIRED',"Falta {$label}.",'document');
        }
        if (($draft['currency_code'] ?? 'MXN') !== 'MXN') {
            try {
                if (FiscalDecimal::micros((string) ($draft['exchange_rate'] ?? '0')) <= 0) throw new \RuntimeException();
            } catch (Throwable) {
                $add($errors,'exchange_rate','EXCHANGE_RATE_REQUIRED','Captura un tipo de cambio válido.','document');
            }
        }
        try {
            $this->dates->validate((string) ($draft['issue_date'] ?? ''));
        } catch (Throwable $e) {
            $message = match ($e->getMessage()) {
                'FISCAL_ISSUE_DATE_FUTURE' => 'La fecha de expedición no puede estar en el futuro.',
                'FISCAL_ISSUE_DATE_TOO_OLD' => 'La fecha de expedición excede la antigüedad permitida.',
                default => 'La fecha de expedición no tiene un formato válido.',
            };
            $add($errors,'issue_date',$e->getMessage(),$message,'document');
        }
        if (!$allocations) $add($errors,'sales','SALES_REQUIRED','Selecciona al menos una venta con saldo disponible.','sales');
        if (!$concepts) $add($errors,'concepts','CONCEPTS_REQUIRED','Selecciona al menos un concepto.','concepts');
        foreach ($concepts as $concept) {
            try {
                if (FiscalDecimal::micros((string) ($concept['quantity'] ?? '0')) <= 0) throw new \RuntimeException();
                if (FiscalDecimal::micros((string) ($concept['total'] ?? '0')) <= 0) throw new \RuntimeException();
            } catch (Throwable) {
                $add($errors,'concepts','CONCEPT_INVALID','Las cantidades e importes de los conceptos deben ser mayores que cero.','concepts');
            }
            $snapshot = $concept['snapshot'] ?? [];
            foreach (['product_service_code','unit_code','tax_object_code'] as $field) {
                if (trim((string) ($snapshot[$field] ?? '')) === '') {
                    $add($errors,$field,'CONCEPT_FISCAL_DATA_REQUIRED','Un concepto no tiene configuración fiscal completa.','concepts');
                }
            }
        }
        return ['valid' => !$errors, 'errors' => $errors, 'warnings' => $warnings];
    }
}
