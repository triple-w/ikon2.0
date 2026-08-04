<?php
declare(strict_types=1);

namespace App\Services\Fiscal;

use RuntimeException;
use Throwable;

final class FiscalSaleAllocationService
{
    private const ACTIVE_DRAFT_STATUSES = ['draft', 'ready', 'stamping', 'error'];
    private const CANCELLED_DOCUMENT_STATUSES = ['cancelled', 'cancelled_internal', 'cancelled_confirmed'];

    public function __construct(private mixed $db = null)
    {
        $this->db ??= db_connect();
    }

    public function getSaleFiscalSummary(int $saleId): array
    {
        $sale = $this->sale($saleId);
        $documentRows = $this->db->table('fiscal_document_sales a')
            ->select('a.*,d.status document_status,d.series,d.folio,d.total document_total')
            ->join('fiscal_documents d', 'd.id=a.fiscal_document_id')
            ->where('a.sale_id', $saleId)->orderBy('a.id')->get()->getResultArray();
        $draftRows = $this->db->table('fiscal_draft_sales a')
            ->select('a.*,d.status draft_status,d.provisional_series,d.total draft_total')
            ->join('fiscal_drafts d', 'd.id=a.fiscal_draft_id')
            ->where('a.sale_id', $saleId)->orderBy('a.id')->get()->getResultArray();

        $activeMicros = $cancelledMicros = $reservedMicros = 0;
        $activeDocuments = $cancelledDocuments = $activeDrafts = [];
        foreach ($documentRows as $row) {
            $cancelled = $row['allocation_status'] === 'cancelled'
                || in_array($row['document_status'], self::CANCELLED_DOCUMENT_STATUSES, true);
            if ($cancelled) {
                $cancelledMicros += FiscalDecimal::micros((string) $row['allocated_total']);
                $cancelledDocuments[] = $row;
            } elseif ($row['allocation_status'] === 'active') {
                $activeMicros += FiscalDecimal::micros((string) $row['allocated_total']);
                $activeDocuments[] = $row;
            }
        }
        foreach ($draftRows as $row) {
            if ($row['allocation_status'] === 'reserved'
                && in_array($row['draft_status'], self::ACTIVE_DRAFT_STATUSES, true)) {
                $reservedMicros += FiscalDecimal::micros((string) $row['allocated_total']);
                $activeDrafts[] = $row;
            }
        }
        $saleMicros = $sale->invoice_total === null || $sale->invoice_total === ''
            ? 0
            : FiscalDecimal::micros((string) $sale->invoice_total);
        $availableMicros = max(0, $saleMicros - $activeMicros - $reservedMicros);
        $state = $this->fiscalStatus(
            $activeMicros, $cancelledMicros, $reservedMicros, $availableMicros,
            count($activeDocuments), count($cancelledDocuments), count($activeDrafts)
        );
        return [
            'sale_total' => FiscalDecimal::format($saleMicros),
            'active_invoiced_total' => FiscalDecimal::format($activeMicros),
            'draft_reserved_total' => FiscalDecimal::format($reservedMicros),
            'cancelled_invoiced_total' => FiscalDecimal::format($cancelledMicros),
            'available_to_invoice' => FiscalDecimal::format($availableMicros),
            'fiscal_status' => $state,
            'active_documents' => $activeDocuments,
            'cancelled_documents' => $cancelledDocuments,
            'active_drafts' => $activeDrafts,
        ];
    }

    public function getAvailableAmount(int $saleId, ?int $excludeDraftId = null): string
    {
        $summary = $this->getSaleFiscalSummary($saleId);
        $available = FiscalDecimal::micros($summary['available_to_invoice']);
        if ($excludeDraftId) {
            $reserved = $this->db->table('fiscal_draft_sales')
                ->select('allocated_total')->where([
                    'fiscal_draft_id' => $excludeDraftId,
                    'sale_id' => $saleId,
                    'allocation_status' => 'reserved',
                ])->get(1)->getRow();
            if ($reserved) $available += FiscalDecimal::micros((string) $reserved->allocated_total);
        }
        return FiscalDecimal::format($available);
    }

    public function validateAllocation(int $saleId, string $allocatedTotal, ?int $excludeDraftId = null): void
    {
        $micros = FiscalDecimal::micros($allocatedTotal);
        if ($micros <= 0) throw new RuntimeException('FISCAL_ALLOCATION_MUST_BE_POSITIVE');
        if ($micros > FiscalDecimal::micros($this->getAvailableAmount($saleId, $excludeDraftId))) {
            throw new RuntimeException('FISCAL_ALLOCATION_EXCEEDS_AVAILABLE');
        }
    }

    public function reserveDraftAllocations(int $draftId, array $allocations, int $userId): void
    {
        if (!$allocations) throw new RuntimeException('FISCAL_DRAFT_ALLOCATIONS_REQUIRED');
        $this->db->transBegin();
        try {
            $draft = $this->db->query(
                'SELECT * FROM ' . $this->db->prefixTable('fiscal_drafts') . ' WHERE id=? FOR UPDATE',
                [$draftId]
            )->getRow();
            if (!$draft || !in_array($draft->status, self::ACTIVE_DRAFT_STATUSES, true)) {
                throw new RuntimeException('FISCAL_DRAFT_NOT_RESERVABLE');
            }
            $seen = [];
            $allocatedMicros = 0;
            foreach ($allocations as $allocation) {
                $saleId = (int) ($allocation['sale_id'] ?? 0);
                if (!$saleId || isset($seen[$saleId])) throw new RuntimeException('FISCAL_DRAFT_SALE_DUPLICATE');
                $seen[$saleId] = true;
                $this->lockSale($saleId);
                $this->validateParts($allocation);
                $this->validateAllocation($saleId, (string) $allocation['allocated_total'], $draftId);
                $allocatedMicros += FiscalDecimal::micros((string) $allocation['allocated_total']);
                $data = [
                    'allocated_subtotal' => FiscalDecimal::format(FiscalDecimal::micros((string) $allocation['allocated_subtotal'])),
                    'allocated_tax' => FiscalDecimal::format(FiscalDecimal::micros((string) $allocation['allocated_tax'])),
                    'allocated_total' => FiscalDecimal::format(FiscalDecimal::micros((string) $allocation['allocated_total'])),
                    'allocation_status' => 'reserved', 'created_by' => $userId, 'updated_at' => get_current_utc_time(),
                ];
                $existing = $this->db->table('fiscal_draft_sales')
                    ->where(['fiscal_draft_id' => $draftId, 'sale_id' => $saleId])->get(1)->getRow();
                if ($existing) {
                    $this->db->table('fiscal_draft_sales')->where('id', $existing->id)->update($data);
                } else {
                    $this->db->table('fiscal_draft_sales')->insert($data + [
                        'fiscal_draft_id' => $draftId, 'sale_id' => $saleId, 'created_at' => get_current_utc_time(),
                    ]);
                }
            }
            $obsolete = $this->db->table('fiscal_draft_sales')
                ->where('fiscal_draft_id', $draftId)
                ->where('allocation_status', 'reserved');
            if ($seen) $obsolete->whereNotIn('sale_id', array_keys($seen));
            $obsolete->update([
                'allocation_status' => 'released', 'updated_at' => get_current_utc_time(),
            ]);
            if ($allocatedMicros !== FiscalDecimal::micros((string) $draft->total)) {
                throw new RuntimeException('FISCAL_DRAFT_ALLOCATION_TOTAL_MISMATCH');
            }
            $this->db->transCommit();
        } catch (Throwable $exception) {
            $this->db->transRollback();
            throw $exception;
        }
    }

    public function convertDraftAllocationsToDocument(int $draftId, int $documentId, int $userId): void
    {
        $this->db->transBegin();
        try {
            $draft = $this->db->query(
                'SELECT * FROM ' . $this->db->prefixTable('fiscal_drafts') . ' WHERE id=? FOR UPDATE', [$draftId]
            )->getRow();
            $document = $this->db->query(
                'SELECT * FROM ' . $this->db->prefixTable('fiscal_documents') . ' WHERE id=? FOR UPDATE', [$documentId]
            )->getRow();
            $rows = $this->db->table('fiscal_draft_sales')->where([
                'fiscal_draft_id' => $draftId, 'allocation_status' => 'reserved',
            ])->get()->getResultArray();
            if (!$draft || !$document || !$rows) throw new RuntimeException('FISCAL_DRAFT_CONVERSION_INVALID');
            $sum = array_sum(array_map(
                static fn(array $row): int => FiscalDecimal::micros((string) $row['allocated_total']), $rows
            ));
            if ($sum !== FiscalDecimal::micros((string) $draft->total)
                || $sum !== FiscalDecimal::micros((string) $document->total)) {
                throw new RuntimeException('FISCAL_DOCUMENT_ALLOCATION_TOTAL_MISMATCH');
            }
            foreach ($rows as $row) {
                $this->lockSale((int) $row['sale_id']);
                if ($this->db->table('fiscal_document_sales')->where([
                    'fiscal_document_id' => $documentId, 'sale_id' => $row['sale_id'],
                ])->countAllResults()) throw new RuntimeException('FISCAL_DOCUMENT_SALE_DUPLICATE');
                $this->db->table('fiscal_document_sales')->insert([
                    'fiscal_document_id' => $documentId, 'sale_id' => $row['sale_id'],
                    'allocated_subtotal' => $row['allocated_subtotal'], 'allocated_tax' => $row['allocated_tax'],
                    'allocated_total' => $row['allocated_total'], 'allocation_status' => 'active',
                    'created_by' => $userId, 'created_at' => get_current_utc_time(), 'updated_at' => get_current_utc_time(),
                ]);
            }
            $this->db->table('fiscal_draft_sales')->where('fiscal_draft_id', $draftId)
                ->where('allocation_status', 'reserved')->update([
                    'allocation_status' => 'converted', 'updated_at' => get_current_utc_time(),
                ]);
            $this->db->table('fiscal_drafts')->where('id', $draftId)->update([
                'status' => 'stamped', 'updated_by' => $userId, 'updated_at' => get_current_utc_time(),
            ]);
            $this->db->transCommit();
        } catch (Throwable $exception) {
            $this->db->transRollback();
            throw $exception;
        }
    }

    public function releaseDraftAllocations(int $draftId, int $userId): void
    {
        $this->db->transBegin();
        try {
            $draft = $this->db->query(
                'SELECT * FROM ' . $this->db->prefixTable('fiscal_drafts') . ' WHERE id=? FOR UPDATE', [$draftId]
            )->getRow();
            if (!$draft) throw new RuntimeException('FISCAL_DRAFT_NOT_FOUND');
            $this->db->table('fiscal_draft_sales')->where('fiscal_draft_id', $draftId)
                ->where('allocation_status', 'reserved')->update([
                    'allocation_status' => 'released', 'updated_at' => get_current_utc_time(),
                ]);
            $this->db->table('fiscal_drafts')->where('id', $draftId)->update([
                'status' => 'discarded', 'updated_by' => $userId, 'updated_at' => get_current_utc_time(),
            ]);
            $this->db->transCommit();
        } catch (Throwable $exception) {
            $this->db->transRollback();
            throw $exception;
        }
    }

    public function getDocumentSales(int $documentId): array
    {
        return $this->db->table('fiscal_document_sales a')
            ->select('a.*,i.display_id,i.invoice_total,i.status sale_status')
            ->join('invoices i', 'i.id=a.sale_id', 'left')
            ->where('a.fiscal_document_id', $documentId)->orderBy('a.id')->get()->getResultArray();
    }

    public function hasBlockingOperation(int $saleId): bool
    {
        return $this->db->table('fiscal_document_sales a')
            ->join('fiscal_stamp_attempts s','s.fiscal_document_id=a.fiscal_document_id')
            ->where('a.sale_id',$saleId)
            ->whereIn('s.status',['sending','unknown','pending'])
            ->groupStart()->where('s.responded_at',null)->orWhere('s.requires_reconciliation',1)->groupEnd()
            ->countAllResults() > 0;
    }

    private function validateParts(array $allocation): void
    {
        $subtotal = FiscalDecimal::micros((string) ($allocation['allocated_subtotal'] ?? ''));
        $tax = FiscalDecimal::micros((string) ($allocation['allocated_tax'] ?? ''));
        $total = FiscalDecimal::micros((string) ($allocation['allocated_total'] ?? ''));
        if ($subtotal < 0 || $total <= 0 || $subtotal + $tax !== $total) {
            throw new RuntimeException('FISCAL_ALLOCATION_COMPONENTS_INVALID');
        }
    }

    private function lockSale(int $saleId): object
    {
        $sale = $this->db->query(
            'SELECT id,invoice_total,status,deleted FROM ' . $this->db->prefixTable('invoices')
            . ' WHERE id=? FOR UPDATE', [$saleId]
        )->getRow();
        if (!$sale || (int) $sale->deleted === 1) throw new RuntimeException('FISCAL_SALE_NOT_FOUND');
        return $sale;
    }

    private function sale(int $saleId): object
    {
        $sale = $this->db->table('invoices')->select('id,invoice_total,status,deleted')
            ->where(['id' => $saleId, 'deleted' => 0])->get(1)->getRow();
        if (!$sale) throw new RuntimeException('FISCAL_SALE_NOT_FOUND');
        return $sale;
    }

    private function fiscalStatus(
        int $active, int $cancelled, int $reserved, int $available,
        int $activeCount, int $cancelledCount, int $draftCount
    ): string {
        if ($activeCount && ($cancelledCount || $draftCount)) return 'mixed';
        if (!$activeCount && $draftCount && !$cancelledCount) return 'draft';
        if (!$activeCount && $cancelledCount && !$draftCount) return 'cancelled_invoices';
        if ($active > 0 && $available > 0) return 'partially_invoiced';
        if ($activeCount && $available === 0) return 'fully_invoiced';
        if (!$activeCount && !$draftCount && !$cancelledCount) return 'not_invoiced';
        return 'mixed';
    }
}
