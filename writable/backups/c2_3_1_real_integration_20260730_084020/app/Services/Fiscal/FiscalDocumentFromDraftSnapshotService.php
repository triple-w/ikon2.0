<?php
declare(strict_types=1);

namespace App\Services\Fiscal;

use RuntimeException;
use Throwable;

final class FiscalDocumentFromDraftSnapshotService
{
    public function __construct(private mixed $db = null, private ?FiscalDraftStampingPreflightService $preflight = null)
    {
        $this->db ??= db_connect();
        $this->preflight ??= new FiscalDraftStampingPreflightService($this->db);
    }

    public function materialize(int $draftId, int $userId): int
    {
        $this->db->transBegin();
        try {
            $draftTable = $this->db->prefixTable('fiscal_drafts');
            $this->db->query("SELECT id FROM {$draftTable} WHERE id=? FOR UPDATE", [$draftId]);
            $snapshot = $this->preflight->requireReady($draftId);
            $draft = $snapshot['draft'];
            $seriesTable = $this->db->prefixTable('fiscal_series');
            $series = $this->db->query(
                "SELECT * FROM {$seriesTable} WHERE id=? AND issuer_profile_id=? AND is_active=1 AND deleted=0 FOR UPDATE",
                [(int)$draft['fiscal_series_id'], (int)$draft['issuer_id']]
            )->getRowArray();
            if (!$series) throw new RuntimeException('La serie fiscal del snapshot ya no está disponible.');
            $folio = max((int)$series['initial_folio'], (int)$series['current_folio'] + 1);
            $now = get_current_utc_time();
            $sourceHash = hash('sha256', json_encode($snapshot, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));
            $firstSale = (int)$snapshot['allocations'][0]['sale_id'];
            $document = [
                'invoice_id' => $firstSale, 'source_draft_id' => $draftId,
                'issuer_profile_id' => (int)$draft['issuer_id'],
                'receiver_profile_id' => (int)$draft['receiver_profile_id'],
                'fiscal_series_id' => (int)$draft['fiscal_series_id'],
                'document_type' => 'income', 'status' => 'locked', 'version' => 1,
                'series' => (string)$series['series'], 'folio' => $folio,
                'issue_date' => (string)$draft['issue_date'],
                'expedition_postal_code' => (string)$draft['expedition_postal_code'],
                'currency_code' => (string)$draft['currency_code'],
                'exchange_rate' => (string)$draft['exchange_rate'],
                'payment_form_code' => (string)$draft['payment_form_code'],
                'payment_method_code' => (string)$draft['payment_method_code'],
                'cfdi_use_code' => (string)$draft['cfdi_use_code'], 'export_code' => '01',
                'subtotal' => $snapshot['totals']['subtotal'], 'discount' => $snapshot['totals']['discount'],
                'transferred_tax_total' => $snapshot['totals']['transferred'],
                'withheld_tax_total' => $snapshot['totals']['withheld'], 'total' => $snapshot['totals']['total'],
                'administrative_total_reference' => $snapshot['totals']['total'],
                'pricing_mode' => (string)($snapshot['issuer_snapshot']['tax_pricing_mode'] ?? 'snapshot'),
                'source_snapshot_hash' => $sourceHash, 'created_by' => $userId,
                'created_at' => $now, 'updated_at' => $now, 'locked_at' => $now, 'deleted' => 0,
            ];
            if (!$this->db->table('fiscal_documents')->insert($document)) throw new RuntimeException('No fue posible crear el documento fiscal.');
            $documentId = (int)$this->db->insertID();
            $this->insertParties($documentId, $snapshot, $now);
            $this->insertItems($documentId, $snapshot, $now);
            $this->insertTaxTotals($documentId, $snapshot['item_taxes'], $now);
            $this->db->table('fiscal_document_metadata')->insert([
                'fiscal_document_id' => $documentId,
                'metadata_json' => json_encode([
                    'source' => 'fiscal_draft_snapshot_v2', 'draft_id' => $draftId,
                    'snapshot_hash' => $sourceHash, 'snapshot_version' => 2,
                ], JSON_UNESCAPED_SLASHES),
                'warnings_json' => '[]', 'rules_version' => 'ikontrol-draft-snapshot-v2',
                'payment_total_snapshot' => $snapshot['totals']['total'], 'created_at' => $now,
            ]);
            $this->db->table('fiscal_series')->where('id', $series['id'])->update(['current_folio' => $folio, 'updated_at' => $now]);
            $this->db->table('fiscal_drafts')->where('id', $draftId)->update([
                'fiscal_document_id' => $documentId, 'status' => 'stamping',
                'updated_by' => $userId, 'updated_at' => $now,
            ]);
            $this->audit($draftId, $userId, 'draft_document_created', ['document_id' => $documentId, 'snapshot_hash' => $sourceHash]);
            if (!$this->db->transStatus()) throw new RuntimeException('No fue posible materializar el snapshot fiscal.');
            $this->db->transCommit();
            return $documentId;
        } catch (Throwable $e) {
            $this->db->transRollback();
            throw $e;
        }
    }

    private function insertParties(int $documentId, array $snapshot, string $now): void
    {
        $issuer = $snapshot['issuer_snapshot'];
        $receiver = $snapshot['receiver_snapshot'];
        $this->db->table('fiscal_document_issuers')->insert([
            'fiscal_document_id' => $documentId, 'rfc' => $issuer['rfc'],
            'legal_name' => $issuer['legal_name'], 'tax_regime_code' => $issuer['tax_regime_code'],
            'fiscal_postal_code' => $issuer['fiscal_postal_code'],
            'expedition_postal_code' => $snapshot['draft']['expedition_postal_code'],
            'country_code' => $issuer['fiscal_country_code'] ?? 'MEX',
            'street' => $issuer['fiscal_street'] ?? null, 'external_number' => $issuer['fiscal_external_number'] ?? null,
            'internal_number' => $issuer['fiscal_internal_number'] ?? null, 'neighborhood' => $issuer['fiscal_neighborhood'] ?? null,
            'locality' => $issuer['fiscal_locality'] ?? null, 'municipality' => $issuer['fiscal_municipality'] ?? null,
            'state' => $issuer['fiscal_state'] ?? null, 'created_at' => $now,
        ]);
        $this->db->table('fiscal_document_receivers')->insert([
            'fiscal_document_id' => $documentId, 'rfc' => $receiver['rfc'],
            'legal_name' => $receiver['legal_name'],
            'tax_regime_code' => $snapshot['draft']['receiver_tax_regime_code'],
            'fiscal_postal_code' => $snapshot['draft']['receiver_postal_code'],
            'cfdi_use_code' => $snapshot['draft']['cfdi_use_code'],
            'fiscal_residence_country_code' => $receiver['tax_residency_country'] ?? null,
            'foreign_tax_registration' => $receiver['foreign_tax_registration'] ?? null,
            'street' => $receiver['fiscal_street'] ?? null, 'external_number' => $receiver['fiscal_external_number'] ?? null,
            'internal_number' => $receiver['fiscal_internal_number'] ?? null, 'neighborhood' => $receiver['fiscal_neighborhood'] ?? null,
            'locality' => $receiver['fiscal_locality'] ?? null, 'municipality' => $receiver['fiscal_municipality'] ?? null,
            'state' => $receiver['fiscal_state'] ?? null, 'created_at' => $now,
        ]);
    }

    private function insertItems(int $documentId, array $snapshot, string $now): void
    {
        foreach ($snapshot['items'] as $index => $item) {
            $s = $item['snapshot'];
            $this->db->table('fiscal_document_items')->insert([
                'fiscal_document_id' => $documentId, 'invoice_item_id' => $item['sale_item_id'],
                'item_id' => $item['product_id'], 'line_number' => $index + 1,
                'product_service_code' => $s['product_service_code'],
                'identification_number' => $s['identification_number'] ?? null,
                'quantity' => $item['quantity'], 'unit_code' => $s['unit_code'],
                'unit_name' => $s['commercial_unit'] ?? 'Pieza',
                'description' => $s['fiscal_description'] ?? $s['description'] ?? $s['title'],
                'unit_value' => $item['unit_price'], 'gross_amount' => $item['subtotal'],
                'discount' => $item['discount'], 'tax_object_code' => $s['object_tax'] ?? $s['tax_object_code'],
                'taxable_base' => $s['taxable_base'], 'transferred_tax_total' => $s['transferred_total'],
                'withheld_tax_total' => $s['withheld_total'], 'line_total' => $item['total'], 'created_at' => $now,
            ]);
            $documentItemId = (int)$this->db->insertID();
            foreach ($item['taxes'] as $order => $tax) {
                $documentTaxType = $this->documentTaxType((string)$tax['tax_type']);
                $this->db->table('fiscal_document_item_taxes')->insert([
                    'fiscal_document_item_id' => $documentItemId, 'administrative_tax_id' => null,
                    'tax_code' => $tax['tax_code'], 'tax_type' => $documentTaxType,
                    'factor_type' => $tax['factor_type'], 'rate_or_quota' => $tax['rate_or_quota'],
                    'taxable_base' => $tax['tax_base'], 'amount' => $tax['tax_amount'],
                    'sort_order' => $order, 'created_at' => $now,
                ]);
            }
        }
    }

    private function insertTaxTotals(int $documentId, array $taxes, string $now): void
    {
        $groups = [];
        foreach ($taxes as $tax) {
            $documentTaxType = $this->documentTaxType((string)$tax['tax_type']);
            $key = implode('|', [$tax['tax_code'], $documentTaxType, $tax['factor_type'], $tax['rate_or_quota'] ?? '']);
            if (!isset($groups[$key])) {
                $groups[$key] = $tax;
                $groups[$key]['tax_type'] = $documentTaxType;
                $groups[$key]['tax_base'] = '0.000000';
                $groups[$key]['tax_amount'] = '0.000000';
            }
            $groups[$key]['tax_base'] = FiscalDecimal::add($groups[$key]['tax_base'], $tax['tax_base']);
            $groups[$key]['tax_amount'] = FiscalDecimal::add($groups[$key]['tax_amount'], $tax['tax_amount']);
        }
        foreach ($groups as $tax) {
            $this->db->table('fiscal_document_tax_totals')->insert([
                'fiscal_document_id' => $documentId, 'tax_code' => $tax['tax_code'],
                'tax_type' => $tax['tax_type'], 'factor_type' => $tax['factor_type'],
                'rate_or_quota' => $tax['rate_or_quota'], 'taxable_base' => $tax['tax_base'],
                'amount' => $tax['tax_amount'], 'created_at' => $now,
            ]);
        }
    }

    private function documentTaxType(string $type): string
    {
        return match ($type) {
            'transfer', 'transferred' => 'transferred',
            'withholding', 'withheld' => 'withheld',
            default => throw new RuntimeException('El snapshot contiene un tipo de impuesto no soportado.'),
        };
    }

    private function audit(int $draftId, int $userId, string $event, array $summary): void
    {
        $this->db->table('fiscal_draft_audit')->insert([
            'fiscal_draft_id' => $draftId, 'user_id' => $userId, 'event' => $event,
            'summary_json' => json_encode($summary, JSON_UNESCAPED_SLASHES), 'created_at' => get_current_utc_time(),
        ]);
    }
}
