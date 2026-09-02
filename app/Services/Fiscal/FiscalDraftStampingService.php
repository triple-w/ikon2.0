<?php
declare(strict_types=1);

namespace App\Services\Fiscal;

use App\Services\Fiscal\Cfdi40\CfdiPreXmlArtifactService;
use App\Services\Fiscal\Cfdi40\CfdiSigningService;
use App\Services\Fiscal\Pac\FiscalStampingService as PacStampingService;
use App\Services\Fiscal\Pdf\FiscalPacPdfGenerationService;
use RuntimeException;
use Throwable;

final class FiscalDraftStampingService
{
    public function __construct(
        private mixed $db = null,
        private ?FiscalDraftStampingPreflightService $preflight = null,
        private ?FiscalDocumentFromDraftSnapshotService $materializer = null,
        private ?CfdiPreXmlArtifactService $preXml = null,
        private ?CfdiSigningService $signer = null,
        private ?PacStampingService $stamping = null,
        private ?FiscalSaleAllocationService $allocations = null,
        private ?FiscalPacPdfGenerationService $pdfGeneration = null
    ) {
        $this->db ??= db_connect();
        $this->preflight ??= new FiscalDraftStampingPreflightService($this->db);
        $this->materializer ??= new FiscalDocumentFromDraftSnapshotService($this->db, $this->preflight);
        $this->preXml ??= new CfdiPreXmlArtifactService($this->db);
        $this->signer ??= new CfdiSigningService($this->db);
        $this->stamping ??= new PacStampingService($this->db);
        $this->allocations ??= new FiscalSaleAllocationService($this->db);
    }

    public function preflight(int $draftId): array
    {
        $draft=$this->db->table('fiscal_drafts')->select('fiscal_document_id')->where('id',$draftId)->get(1)->getRow();
        return $this->preflight->inspect($draftId, !empty($draft->fiscal_document_id));
    }

    public function stamp(int $draftId, int $userId, bool $authorized): array
    {
        return $this->stampInternal($draftId, $userId, $authorized, false);
    }

    public function stampSaleFlow(int $draftId, int $userId, bool $authorized): array
    {
        return $this->stampInternal($draftId, $userId, $authorized, true);
    }

    private function stampInternal(int $draftId, int $userId, bool $authorized, bool $saleFlow): array
    {
        if (!$authorized) throw new RuntimeException('No tiene permiso para facturar el borrador.');
        $lockName = 'fiscal_draft_stamp_' . $draftId;
        $acquired = (int)($this->db->query('SELECT GET_LOCK(?, 0) acquired', [$lockName])->getRow()->acquired ?? 0);
        if ($acquired !== 1) throw new RuntimeException('El borrador ya está siendo procesado.');
        $documentId = null;
        try {
            $prepared=$this->db->table('fiscal_drafts')->select('fiscal_document_id')->where('id',$draftId)->get(1)->getRow();
            $documentId=(int)($prepared->fiscal_document_id??0);
            $saleFlow ? $this->preflight->requireReadyForSaleFlow($draftId, $documentId>0) : $this->preflight->requireReady($draftId, $documentId>0);
            if($documentId===0)$documentId = $this->materializer->materialize($draftId, $userId, $saleFlow);
            else if(!$this->db->table('fiscal_stamp_attempts')->where('fiscal_document_id',$documentId)->countAllResults())$this->materializer->reconcileLocalDocumentCurrencyTotals($documentId);
            $signature=$this->db->table('fiscal_document_signatures')->where([
                'fiscal_document_id'=>$documentId,'signature_verified'=>1,'xsd_status'=>'valid',
            ])->orderBy('id','DESC')->get(1)->getRow();
            if(!$signature){
                $preXmlArtifact=$this->db->table('fiscal_document_artifacts')->where([
                    'fiscal_document_id'=>$documentId,'artifact_type'=>'pre_xml',
                    'validation_status'=>'valid','superseded_at'=>null,
                ])->orderBy('id','DESC')->get(1)->getRow();
                if(!$preXmlArtifact){
                    $preXml=$this->preXml->generate($documentId,$userId,true);
                    $preXmlArtifact=$preXml['artifact'];
                }
                $certificate=$this->activeCertificate($documentId);
                $this->signer->sign($documentId,(int)$preXmlArtifact->id,(int)$certificate->id,$userId,true);
            }
            $result = $this->stamping->stamp($documentId, $userId, true);
            if ($result->xmlAvailable && $result->uuid) {
                $this->allocations->convertDraftAllocationsToDocument($draftId, $documentId, $userId);
                $this->db->table('fiscal_drafts')->where('id', $draftId)->update([
                    'fiscal_document_id' => $documentId, 'status' => 'stamped',
                    'updated_by' => $userId, 'updated_at' => get_current_utc_time(),
                ]);
                $this->audit($draftId, $userId, 'draft_stamped', [
                    'document_id' => $documentId, 'attempt_id' => $result->attemptId,
                    'pdf_available' => $result->pdfAvailable,
                ]);
                if (!$result->pdfAvailable && config('FiscalPdfProvider')->enabled) {
                    try {
                        $pdf = ($this->pdfGeneration ?? new FiscalPacPdfGenerationService($this->db))
                            ->generate($documentId, $userId);
                        $this->audit($draftId, $userId, 'pac_pdf_requested', [
                            'document_id' => $documentId,
                            'success' => $pdf->success,
                            'pdf_available' => $pdf->pdfAvailable,
                        ]);
                    } catch (Throwable $pdfError) {
                        log_message('warning', 'PAC PDF generation failed after draft stamping document {document}: {type}', [
                            'document' => $documentId,
                            'type' => get_class($pdfError),
                        ]);
                    }
                }
            } elseif ($result->requiresReconciliation) {
                $this->setDraftState($draftId, 'blocked', $userId);
            } else {
                $this->setDraftState($draftId, 'ready', $userId);
            }
            $resultArray = $result->toArray();
            if ($result->xmlAvailable && $result->uuid) {
                $persistedStamp = $this->db->table('fiscal_document_stamps')->where('fiscal_document_id', $documentId)->get(1)->getRow();
                $resultArray['success'] = true;
                $resultArray['status'] = ($persistedStamp->pdf_status ?? '') === 'valid' ? 'stamped' : 'stamped_pdf_pending';
                $resultArray['pdfAvailable'] = ($persistedStamp->pdf_status ?? '') === 'valid' && (int)($persistedStamp->pac_pdf_artifact_id ?? 0) > 0;
            }
            return ['document_id' => $documentId, 'result' => $resultArray];
        } catch (Throwable $e) {
            $this->audit($draftId,$userId,'draft_stamp_failed',[
                'document_id'=>$documentId,'error_class'=>get_class($e),
                'message'=>mb_substr(preg_replace('/[\r\n\t]+/',' ',(string)$e->getMessage()),0,300),
                'pac_attempt_exists'=>$documentId!==null&&(bool)$this->db->table('fiscal_stamp_attempts')->where('fiscal_document_id',$documentId)->countAllResults(),
            ]);
            if ($documentId !== null) {
                $attempt = $this->db->table('fiscal_stamp_attempts')->where('fiscal_document_id', $documentId)
                    ->orderBy('id', 'DESC')->get(1)->getRow();
                if (!$attempt || !in_array((string)$attempt->status, ['sending', 'unknown', 'timeout_unknown', 'transport_unknown', 'reconciliation_required'], true)) {
                    $this->setDraftState($draftId, 'ready', $userId);
                } else {
                    $this->setDraftState($draftId, 'blocked', $userId);
                }
            }
            throw $e;
        } finally {
            $this->db->query('SELECT RELEASE_LOCK(?)', [$lockName]);
        }
    }

    private function activeCertificate(int $documentId): object
    {
        $document = $this->db->table('fiscal_documents')->select('issuer_profile_id')
            ->where('id', $documentId)->get(1)->getRow();
        $now = get_current_utc_time();
        $certificate = $this->db->table('fiscal_issuer_certificates')
            ->where(['issuer_profile_id' => $document->issuer_profile_id, 'status' => 'valid', 'deleted' => 0])
            ->where('valid_from <=', $now)->where('valid_to >=', $now)
            ->orderBy('valid_to', 'DESC')->get(1)->getRow();
        if (!$certificate) throw new RuntimeException('El emisor no tiene un CSD utilizable.');
        return $certificate;
    }

    private function setDraftState(int $draftId, string $status, int $userId): void
    {
        $this->db->table('fiscal_drafts')->where('id', $draftId)->update([
            'status' => $status, 'updated_by' => $userId, 'updated_at' => get_current_utc_time(),
        ]);
    }

    private function audit(int $draftId, int $userId, string $event, array $summary): void
    {
        $this->db->table('fiscal_draft_audit')->insert([
            'fiscal_draft_id' => $draftId, 'user_id' => $userId, 'event' => $event,
            'summary_json' => json_encode($summary, JSON_UNESCAPED_SLASHES), 'created_at' => get_current_utc_time(),
        ]);
    }
}
