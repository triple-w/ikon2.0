<?php
declare(strict_types=1);

namespace App\Services\Fiscal\Cancellation;

use App\Contracts\Fiscal\Cancellation\FiscalCancellationAdapterInterface;
use RuntimeException;
use Throwable;
use App\Services\Fiscal\FiscalPreviewModeGuard;

final class FiscalCancellationService
{
    private $db;
    public function __construct($db=null, private readonly ?FiscalCancellationAdapterInterface $adapter=null)
    {
        $this->db=$db?:db_connect();
    }

    public function cancel(int $documentId,string $reason,?string $replacementUuid,int $userId,bool $authorized):array
    {
        (new FiscalPreviewModeGuard($this->db))->assertCancellationAllowed();
        if(!$authorized)throw new RuntimeException('No tiene permiso para cancelar facturas.');
        if(!in_array($reason,['01','02','03','04'],true))throw new RuntimeException('El motivo de cancelación no es válido.');
        $replacementUuid=$replacementUuid?strtoupper(trim($replacementUuid)):null;
        if($reason==='01'&&!preg_match('/^[0-9A-F]{8}-[0-9A-F]{4}-[1-5][0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/',$replacementUuid??''))throw new RuntimeException('El motivo 01 requiere UUID sustituto válido.');
        if($reason!=='01')$replacementUuid=null;
        $lock='ikontrol:fiscal:cancel:'.$documentId;
        $row=$this->db->query('SELECT GET_LOCK(?,0) acquired',[$lock])->getRow();
        if((int)($row->acquired??0)!==1)return['success'=>false,'status'=>'processing','message'=>'La cancelación ya está siendo procesada.'];
        try{
            $this->db->transBegin();
            $table=$this->db->prefixTable('fiscal_documents');
            $document=$this->db->query("SELECT * FROM {$table} WHERE id=? AND deleted=0 FOR UPDATE",[$documentId])->getRow();
            $stamp=$this->db->table('fiscal_document_stamps')->where('fiscal_document_id',$documentId)->get(1)->getRow();
            $issuer=$this->db->table('fiscal_document_issuers')->where('fiscal_document_id',$documentId)->get(1)->getRow();
            $receiver=$this->db->table('fiscal_document_receivers')->where('fiscal_document_id',$documentId)->get(1)->getRow();
            $xml=$this->db->table('fiscal_document_artifacts')->where(['fiscal_document_id'=>$documentId,'artifact_type'=>'stamped_xml','superseded_at'=>null])->get(1)->getRow();
            if(!$document||!$stamp||!$xml||!trim((string)$stamp->uuid))throw new RuntimeException('Sólo un CFDI timbrado puede cancelarse fiscalmente.');
            if(in_array($document->status,['stamping','stamp_status_unknown'],true))throw new RuntimeException('No puede cancelarse un documento con estado fiscal desconocido.');
            $existing=$this->db->table('fiscal_cancellation_requests')->where('fiscal_document_id',$documentId)->orderBy('id','DESC')->get(1)->getRow();
            if($existing){
                $this->db->transCommit();return['success'=>$existing->status==='accepted','status'=>$existing->status,'request_id'=>(int)$existing->id,'message'=>'Ya existe una solicitud de cancelación para este CFDI.'];
            }
            if($document->status==='cancelled')throw new RuntimeException('El CFDI ya está cancelado.');
            $key=hash('sha256',implode('|',[$documentId,$stamp->uuid,$reason,$replacementUuid??'','fake','local']));
            $now=get_current_utc_time();
            $data=['fiscal_document_id'=>$documentId,'fiscal_document_stamp_id'=>$stamp->id,'uuid'=>$stamp->uuid,'issuer_rfc'=>$issuer->rfc,'receiver_rfc'=>$receiver->rfc,'total'=>$document->total,'cancellation_reason'=>$reason,'replacement_uuid'=>$replacementUuid,'provider'=>'fake','environment'=>'local','status'=>'sending','requested_at'=>$now,'user_id'=>$userId,'idempotency_key'=>$key,'requires_reconciliation'=>0,'created_at'=>$now,'updated_at'=>$now];
            $this->db->table('fiscal_cancellation_requests')->insert($data);$requestId=(int)$this->db->insertID();
            $this->db->table('fiscal_cancellation_attempts')->insert(['fiscal_cancellation_request_id'=>$requestId,'status'=>'sending','started_at'=>$now,'created_at'=>$now,'updated_at'=>$now]);$attemptId=(int)$this->db->insertID();
            $this->db->table('fiscal_documents')->where('id',$documentId)->update(['status'=>'cancellation_pending','updated_at'=>$now]);
            if(!$this->db->transStatus())throw new RuntimeException('No fue posible preparar la cancelación durable.');
            $this->db->transCommit();

            $result=($this->adapter??new FakeFiscalCancellationAdapter())->cancel(['uuid'=>$stamp->uuid,'reason'=>$reason,'replacement_uuid'=>$replacementUuid]);
            if(!empty($result['force_persistence_error']))throw new RuntimeException('Fallo de persistencia posterior simulado.');
            return $this->persistResult($documentId,$requestId,$attemptId,$result,$userId);
        }catch(Throwable $e){
            $this->db->transRollback();
            if(isset($requestId)){
                $now=get_current_utc_time();
                $this->db->table('fiscal_cancellation_requests')->where('id',$requestId)->update(['status'=>'unknown','requires_reconciliation'=>1,'updated_at'=>$now]);
                $this->db->table('fiscal_cancellation_attempts')->where('id',$attemptId)->update(['status'=>'reconciliation_required','requires_reconciliation'=>1,'updated_at'=>$now]);
                $this->db->table('fiscal_documents')->where('id',$documentId)->update(['status'=>'cancellation_pending','updated_at'=>$now]);
                return['success'=>false,'status'=>'unknown','request_id'=>$requestId,'requires_reconciliation'=>true,'message'=>'La cancelación requiere conciliación.'];
            }
            throw$e;
        }finally{try{$this->db->query('SELECT RELEASE_LOCK(?)',[$lock]);}catch(Throwable){}}
    }

    private function persistResult(int$documentId,int$requestId,int$attemptId,array$result,int$userId):array
    {
        $status=(string)$result['status'];$now=get_current_utc_time();$requestStatus=$status;$documentStatus=match($status){'accepted'=>'cancelled','pending'=>'cancellation_pending','rejected','transport_not_sent'=>'cancellation_rejected','unknown'=>'cancellation_pending',default=>'cancellation_pending'};
        $requires=$status==='unknown'?1:0;$ackId=null;
        $this->db->transBegin();
        try{
            if($status==='accepted'){
                $clean=trim((string)($result['ack_base64']??''));$bytes=base64_decode($clean,true);
                if($bytes===false||!str_starts_with(ltrim($bytes),'<?xml')||strlen($bytes)<40)throw new RuntimeException('El acuse fake no es válido.');
                $this->db->table('fiscal_cancellation_artifacts')->insert(['fiscal_cancellation_request_id'=>$requestId,'fiscal_cancellation_attempt_id'=>$attemptId,'artifact_type'=>'cancellation_ack','content_encoding'=>'base64','content_base64'=>$clean,'decoded_mime_type'=>'application/xml','decoded_size_bytes'=>strlen($bytes),'decoded_sha256'=>hash('sha256',$bytes),'created_by'=>$userId,'created_at'=>$now]);$ackId=(int)$this->db->insertID();
            }
            $this->db->table('fiscal_cancellation_requests')->where('id',$requestId)->update(['status'=>$requestStatus,'provider_code'=>$result['code'],'provider_message'=>$result['message'],'confirmed_at'=>in_array($status,['accepted','rejected'],true)?$now:null,'cancelled_at'=>$status==='accepted'?$now:null,'requires_reconciliation'=>$requires,'updated_at'=>$now]);
            $this->db->table('fiscal_cancellation_attempts')->where('id',$attemptId)->update(['status'=>$requestStatus,'provider_code'=>$result['code'],'provider_message'=>$result['message'],'response_hash'=>hash('sha256',json_encode([$status,$result['code'],$result['message']])), 'requires_reconciliation'=>$requires,'responded_at'=>$now,'updated_at'=>$now]);
            $this->db->table('fiscal_documents')->where('id',$documentId)->update(['status'=>$documentStatus,'updated_at'=>$now]);
            if(!$this->db->transStatus())throw new RuntimeException('No fue posible persistir el resultado de cancelación.');
            $this->db->transCommit();
        }catch(Throwable$e){$this->db->transRollback();throw$e;}
        return['success'=>$status==='accepted','status'=>$status,'request_id'=>$requestId,'attempt_id'=>$attemptId,'ack_artifact_id'=>$ackId,'requires_reconciliation'=>(bool)$requires,'message'=>$result['message']];
    }
}
