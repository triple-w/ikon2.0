<?php
declare(strict_types=1);

namespace App\Services\Fiscal;

use RuntimeException;
use Throwable;

final class FiscalPreparedDocumentLifecycleService
{
    private const UNCERTAIN_ATTEMPTS = ['pending','sending','unknown','timeout_unknown','transport_unknown','reconciliation_required'];
    public const RECONCILIATION_REQUIRED = 'El documento fiscal requiere conciliación antes de volver a facturar.';

    public function __construct(private mixed $db = null, private ?FiscalDraftSnapshotHashService $hasher = null)
    {
        $this->db ??= db_connect();
        $this->hasher ??= new FiscalDraftSnapshotHashService();
    }

    public function assertDraftEditable(int $draftId): void
    {
        $draft = $this->db->table('fiscal_drafts')->where('id',$draftId)->get(1)->getRow();
        $documentId = (int)($draft->fiscal_document_id ?? 0);
        $builder = $this->db->table('fiscal_documents');
        $document = ($documentId ? $builder->where('id',$documentId) : $builder->where('source_draft_id',$draftId))->get(1)->getRow();
        if ($document && $this->isProtected((int)$document->id,(string)$document->status)) {
            throw new RuntimeException(self::RECONCILIATION_REQUIRED);
        }
    }

    public function invalidateIfSnapshotChanged(int $draftId, int $userId): array
    {
        // Materialization locks the draft; PAC preparation locks the document.
        // Hold both until detachment and its audit are durable.
        $this->db->transBegin();
        try {
            $draftTable = $this->db->prefixTable('fiscal_drafts');
            $documentTable = $this->db->prefixTable('fiscal_documents');
            $draft = $this->db->query("SELECT * FROM {$draftTable} WHERE id=? FOR UPDATE",[$draftId])->getRow();
            if (!$draft) throw new RuntimeException('El borrador fiscal no existe.');
            $documentId = (int)($draft->fiscal_document_id ?? 0);
            $document = $documentId
                ? $this->db->query("SELECT * FROM {$documentTable} WHERE id=? FOR UPDATE",[$documentId])->getRow()
                : $this->db->query("SELECT * FROM {$documentTable} WHERE source_draft_id=? FOR UPDATE",[$draftId])->getRow();
            if (!$document) {
                if ($documentId) $this->db->table('fiscal_drafts')->where('id',$draftId)->update([
                    'fiscal_document_id'=>null,'updated_by'=>$userId,'updated_at'=>get_current_utc_time(),
                ]);
                $result = ['prepared'=>false,'action'=>$documentId?'missing_document_detached':'none'];
            } else {
                $documentId = (int)$document->id;
                if ((int)($document->source_draft_id ?? 0) !== $draftId) {
                    throw new RuntimeException('El documento preparado no corresponde al borrador.');
                }
                $snapshot = (new FiscalDraftSnapshotService($this->db))->getCompleteFiscalSnapshot($draftId);
                $currentHash = $this->hasher->hash($snapshot);
                $oldHash = (string)($document->source_snapshot_hash ?? '');
                $hasStamp = (bool)$this->db->table('fiscal_document_stamps')->where('fiscal_document_id',$documentId)->countAllResults()
                    || trim((string)($document->uuid ?? '')) !== '';
                $attempts = $this->attempts($documentId, true);
                $decision = self::decision($oldHash,$currentHash,$hasStamp,$attempts,(string)$document->status);
                if ($decision === 'protected') throw new RuntimeException(self::RECONCILIATION_REQUIRED);
                if ($decision === 'reuse') {
                    $result = ['prepared'=>true,'action'=>'reused','document_id'=>$documentId,'snapshot_hash'=>$currentHash];
                } else {
                    $latest = $attempts[0] ?? [];
                    $reason = ($latest['status'] ?? '') === 'transport_not_sent' ? 'transport_not_sent' : 'snapshot_changed';
                    $now = get_current_utc_time();
                    // Preserve the document, folio, XML, signatures and attempt history.
                    // source_draft_id is unique, so releasing only the reverse link is insufficient.
                    $this->db->table('fiscal_documents')->where('id',$documentId)->update([
                        'source_draft_id'=>null,'status'=>'superseded','updated_at'=>$now,
                    ]);
                    $draftUpdate = ['fiscal_document_id'=>null,'updated_by'=>$userId,'updated_at'=>$now];
                    if ($reason === 'transport_not_sent') $draftUpdate['status'] = 'ready';
                    $this->db->table('fiscal_drafts')->where('id',$draftId)->update($draftUpdate);
                    $this->db->table('fiscal_draft_audit')->insert([
                        'fiscal_draft_id'=>$draftId,'sale_id'=>null,'user_id'=>$userId,
                        'event'=>'draft_prepared_document_invalidated',
                        'summary_json'=>json_encode([
                            'draft_id'=>$draftId,'old_document_id'=>$documentId,'reason'=>$reason,
                            'attempt_id'=>$latest['id']??null,
                            'old_source_snapshot_hash'=>$oldHash?:null,'current_snapshot_hash'=>$currentHash,
                        ],JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES),
                        'created_at'=>$now,
                    ]);
                    $result = ['prepared'=>false,'action'=>'invalidated','document_id'=>$documentId,'snapshot_hash'=>$currentHash];
                }
            }
            if (!$this->db->transStatus()) throw new RuntimeException('No fue posible invalidar la preparación fiscal de forma segura.');
            $this->db->transCommit();
            return $result;
        } catch (Throwable $error) {
            $this->db->transRollback();
            throw $error;
        }
    }

    /** Attempts must be ordered newest first, as returned by attempts(). */
    public static function decision(string $oldHash,string $currentHash,bool $hasStamp,array $attempts,string $documentStatus='locked'): string
    {
        $sameSnapshot = $oldHash !== '' && hash_equals($oldHash,$currentHash);
        if ($hasStamp || str_starts_with($documentStatus,'stamped') || $documentStatus === 'cancelled') {
            return $sameSnapshot ? 'reuse' : 'protected';
        }
        if (in_array($documentStatus,['stamping','stamp_status_unknown'],true)) return 'protected';
        $attempts = array_map(static fn($attempt):array=>(array)$attempt,$attempts);
        foreach ($attempts as $attempt) {
            if (trim((string)($attempt['uuid']??'')) !== ''
                || (int)($attempt['requires_reconciliation']??0) !== 0
                || in_array((string)($attempt['status']??''),self::UNCERTAIN_ATTEMPTS,true)) return 'protected';
            if (($attempt['status']??'') === 'transport_not_sent' && !self::confirmedNotSent($attempt)) return 'protected';
        }
        if (($attempts[0]['status']??'') === 'transport_not_sent') {
            // A newer local failure cannot erase an older possible PAC submission.
            foreach ($attempts as $attempt) if (!self::confirmedNotSent($attempt)) return 'protected';
            return 'invalidate';
        }
        return $sameSnapshot ? 'reuse' : 'invalidate';
    }

    private static function confirmedNotSent(array $attempt): bool
    {
        if (($attempt['status']??'') !== 'transport_not_sent') return false;
        foreach (['sent_at','uuid','pac_reference','provider_code','response_hash','contingency_path','response_body_sha256','response_content_type'] as $field) {
            if (trim((string)($attempt[$field]??'')) !== '') return false;
        }
        if (!in_array((string)($attempt['parsing_phase']??''),['','transport_not_sent','transport_completed'],true)) return false;
        if ((int)($attempt['http_status']??0) !== 0 || (int)($attempt['response_body_length']??0) !== 0
            || (int)($attempt['requires_reconciliation']??0) !== 0) return false;
        $rawStructure = trim((string)($attempt['response_structure']??''));
        $structure = json_decode($rawStructure,true);
        if ($rawStructure !== '' && !is_array($structure)) return false;
        if (is_array($structure) && (!empty($structure['has_data']) || !empty($structure['keys']))) return false;
        if (array_key_exists('request_sent',$attempt)
            && !in_array($attempt['request_sent'],[false,0,'0'],true)) return false;
        if (is_array($structure) && array_key_exists('request_sent',$structure)) {
            return $structure['request_sent'] === false;
        }
        if (array_key_exists('request_sent',$attempt)) return true;
        // Older attempts have no request_sent column. finishNotSent's terminal
        // status + error_category are the existing durable "not sent" evidence,
        // but only in the absence of any contradictory transport evidence above.
        return ($attempt['error_category']??'') === 'transport_not_sent';
    }

    private function attempts(int $documentId, bool $lock = false): array
    {
        if ($lock) {
            $table = $this->db->prefixTable('fiscal_stamp_attempts');
            return $this->db->query("SELECT * FROM {$table} WHERE fiscal_document_id=? ORDER BY id DESC FOR UPDATE",[$documentId])->getResultArray();
        }
        return $this->db->table('fiscal_stamp_attempts')->where('fiscal_document_id',$documentId)
            ->orderBy('id','DESC')->get()->getResultArray();
    }

    private function isProtected(int $documentId,string $status): bool
    {
        $hasStamp = (bool)$this->db->table('fiscal_document_stamps')->where('fiscal_document_id',$documentId)->countAllResults();
        return self::decision('different','current',$hasStamp,$this->attempts($documentId),$status) === 'protected';
    }
}
