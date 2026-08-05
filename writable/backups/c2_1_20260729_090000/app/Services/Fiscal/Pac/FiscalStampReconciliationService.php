<?php
declare(strict_types=1);
namespace App\Services\Fiscal\Pac;
use RuntimeException;

final class FiscalStampReconciliationService
{
    public function __construct(private $db=null,private ?PacSecretVault $vault=null,private ?string $contingencyRoot=null){$this->db=$db?:db_connect();}
    public function recoverFromContingency(int $attemptId,int $userId,bool $authorized):array
    {
        if(!$authorized)throw new RuntimeException('No tiene permiso para conciliar timbrados.');
        $attempt=$this->db->table('fiscal_stamp_attempts')->where('id',$attemptId)->get(1)->getRow();
        if(!$attempt||!in_array($attempt->status,['reconciliation_required','duplicate_reported','timeout_unknown','response_invalid'],true))throw new RuntimeException('El intento no admite conciliación.');
        if(!$attempt->contingency_path)throw new RuntimeException('No existe XML de contingencia; no se reenviará automáticamente.');
        $vault=$this->vault??new PacSecretVault();
        $xml=(new PacContingencyStorageService($vault,$this->contingencyRoot))->read($attempt->contingency_path);
        return ['attempt'=>$attempt,'xml'=>$xml,'sha256'=>hash('sha256',$xml),'requires_validation'=>true,'automatic_resend'=>false];
    }
}
