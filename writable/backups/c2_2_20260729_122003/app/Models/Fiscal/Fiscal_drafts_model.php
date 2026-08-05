<?php
declare(strict_types=1);
namespace App\Models\Fiscal;
use CodeIgniter\Model;
final class Fiscal_drafts_model extends Model
{
    protected $table = 'fiscal_drafts';
    protected $returnType = 'object';
    protected $useTimestamps = true;
    protected $allowedFields = [
        'issuer_id','customer_id','document_type','provisional_series','issue_date','currency_code',
        'exchange_rate','payment_form_code','payment_method_code','cfdi_use_code',
        'receiver_tax_regime_code','receiver_postal_code','expedition_postal_code','subtotal',
        'discount','tax_total','total','fiscal_payload','status','created_by','updated_by',
    ];
    protected $validationRules = [
        'document_type' => 'required|in_list[I,E,P,T,N]',
        'status' => 'required|in_list[draft,ready,stamping,stamped,discarded,expired,error]',
    ];
}
