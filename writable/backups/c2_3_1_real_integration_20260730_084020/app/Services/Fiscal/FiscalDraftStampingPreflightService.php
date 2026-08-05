<?php
declare(strict_types=1);

namespace App\Services\Fiscal;

use RuntimeException;
use Throwable;

final class FiscalDraftStampingPreflightService
{
    public function __construct(private mixed $db = null, private ?FiscalDraftSnapshotService $snapshots = null)
    {
        $this->db ??= db_connect();
        $this->snapshots ??= new FiscalDraftSnapshotService($this->db);
    }

    public function inspect(int $draftId, bool $allowPreparedDocument = false): array
    {
        $errors = [];
        try {
            $snapshot = $this->snapshots->getCompleteFiscalSnapshot($draftId);
        } catch (Throwable) {
            return $this->result(null, ['El borrador debe editarse y guardarse nuevamente antes de facturarse.']);
        }
        $draft = $snapshot['draft'];
        if (($draft['status'] ?? '') !== 'ready') $errors[] = 'El borrador no está listo para facturarse.';
        if ((int)($draft['snapshot_version'] ?? 0) < 2
            || (int)($draft['requires_snapshot_refresh'] ?? 1) !== 0
            || empty($draft['snapshot_completed_at'])) {
            $errors[] = 'El borrador debe editarse y guardarse nuevamente antes de facturarse.';
        }
        if (empty($snapshot['issuer_snapshot']['tax_regime_code'])
            || empty($snapshot['issuer_snapshot']['rfc'])
            || empty($snapshot['receiver_snapshot']['rfc'])) {
            $errors[] = 'El snapshot fiscal del emisor o receptor está incompleto.';
        }
        if (!$snapshot['items']) $errors[] = 'El borrador no contiene conceptos.';
        foreach ($snapshot['items'] as $item) {
            $object = (string)($item['snapshot']['object_tax'] ?? $item['snapshot']['tax_object_code'] ?? '');
            if ($object !== '01' && !$item['taxes']) {
                $errors[] = 'Un concepto gravable no tiene impuestos persistidos.';
                break;
            }
        }
        $expected = FiscalDecimal::subtract(
            FiscalDecimal::add(
                FiscalDecimal::subtract((string)$snapshot['totals']['subtotal'], (string)$snapshot['totals']['discount']),
                (string)$snapshot['totals']['transferred']
            ),
            (string)$snapshot['totals']['withheld']
        );
        if (FiscalDecimal::micros($expected) !== FiscalDecimal::micros((string)$snapshot['totals']['total'])) {
            $errors[] = 'Los totales del snapshot fiscal no son consistentes.';
        }
        $allocated = 0;
        foreach ($snapshot['allocations'] as $allocation) {
            if (($allocation['allocation_status'] ?? '') !== 'reserved') {
                $errors[] = 'Las asignaciones del borrador no están reservadas.';
                break;
            }
            $allocated += FiscalDecimal::micros((string)$allocation['allocated_total']);
            $sale = $this->db->table('invoices')->select('status,commercial_status,deleted')
                ->where('id', (int)$allocation['sale_id'])->get(1)->getRowArray();
            if (!$sale || (int)$sale['deleted'] === 1 || $sale['status'] === 'cancelled'
                || !in_array((string)($sale['commercial_status'] ?? 'open'), ['open', 'closed'], true)) {
                $errors[] = 'Una venta relacionada no está disponible para facturación.';
            }
        }
        if ($allocated !== FiscalDecimal::micros((string)$snapshot['totals']['total'])) {
            $errors[] = 'Las asignaciones no coinciden con el total del borrador.';
        }
        try {
            (new FiscalIssueDatePolicy())->validate((string)$draft['issue_date']);
        } catch (Throwable) {
            $errors[] = 'La fecha de expedición ya no es válida.';
        }
        $preparedDocumentId = (int)($draft['fiscal_document_id'] ?? 0);
        if (!$preparedDocumentId) {
            $preparedDocumentId = (int)($this->db->table('fiscal_documents')->select('id')
                ->where('source_draft_id', $draftId)->get(1)->getRow()?->id ?? 0);
        }
        if ($preparedDocumentId) {
            if (!$allowPreparedDocument) {
                $errors[] = 'El borrador ya tiene un documento fiscal principal.';
            } else {
                $document = $this->db->table('fiscal_documents')->select('status')
                    ->where(['id'=>$preparedDocumentId,'source_draft_id'=>$draftId,'deleted'=>0])->get(1)->getRow();
                $active = $this->db->table('fiscal_stamp_attempts')->where('fiscal_document_id',$preparedDocumentId)
                    ->whereIn('status',['pending','sending','unknown','timeout_unknown','transport_unknown','reconciliation_required'])
                    ->countAllResults();
                if (!$document || !in_array($document->status,['locked','ready_to_stamp','stamping_error'],true) || $active) {
                    $errors[] = 'El documento fiscal preparado requiere revisión antes de continuar.';
                }
            }
        }
        return $this->result($snapshot, array_values(array_unique($errors)));
    }

    public function requireReady(int $draftId, bool $allowPreparedDocument = false): array
    {
        $result = $this->inspect($draftId, $allowPreparedDocument);
        if (!$result['allowed']) throw new RuntimeException($result['errors'][0]);
        return $result['snapshot'];
    }

    private function result(?array $snapshot, array $errors): array
    {
        return ['allowed' => !$errors, 'errors' => $errors, 'snapshot' => $snapshot];
    }
}
