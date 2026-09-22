<?php
declare(strict_types=1);

namespace App\Services;

use App\Services\Fiscal\CommercialItemTaxDisplayService;
use App\Services\Fiscal\CommercialTaxBreakdownService;
use App\Services\Fiscal\FiscalDecimal;
use RuntimeException;

/** Read-only adapter: templates consume the same resolved amounts as the UI. */
final class ProposalTemplateFiscalService
{
    public function __construct(private mixed $db = null)
    {
        $this->db ??= db_connect();
    }

    public function prepare(int $proposalId, array $items, object $legacySummary): array
    {
        $breakdown = new CommercialTaxBreakdownService($this->db);
        $totals = $breakdown->forProposal($proposalId);
        if (empty($totals['ready'])) {
            throw new RuntimeException('No se puede generar la Proposal con impuestos: ' . implode('; ', $totals['missing'] ?: ['No hay partidas fiscales resueltas.']));
        }
        $display = new CommercialItemTaxDisplayService($this->db);
        $lines = [];
        foreach ($items as $item) {
            $resolved = $breakdown->lineForDocument('proposals', 'proposal_items', 'proposal_id', (int) $item->id);
            if (empty($resolved['ready'])) {
                throw new RuntimeException('Configuración fiscal pendiente en la partida ' . (int) $item->id);
            }
            $lines[$item->id] = $display->present($resolved, (string) $item->quantity, (string) $item->rate, (string) $legacySummary->currency_symbol);
        }
        // Keep the legacy summary intact: PROPOSAL_TOTAL remains contractual.
        $summary = clone $legacySummary;
        $summary->proposal_subtotal = $totals['subtotal'];
        $summary->discount_total = $totals['discount'];
        $summary->discount_type = 'before_tax';
        $summary->proposal_total = $totals['total'];
        $summary->tax = $summary->tax2 = 0;
        $summary->tax_total = FiscalDecimal::subtract($totals['transferred'], $totals['withheld']);

        return ['proposal_total_summary' => $summary, 'proposal_fiscal_lines' => $lines, 'proposal_fiscal_output' => true];
    }
}
