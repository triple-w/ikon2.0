<?php
declare(strict_types=1);
namespace App\Services;

use App\Services\Fiscal\CommercialTaxBreakdownService;
use App\Services\Fiscal\FiscalDecimal;
use RuntimeException;

/** Shared document totals; does not calculate tax rates or change line pricing. */
final class ProposalTotalsService
{
    public function __construct(private mixed $db = null) { $this->db ??= db_connect(); }
    public function forProposal(int $id): array
    {
        return $this->present((new CommercialTaxBreakdownService($this->db))->forProposal($id));
    }
    public function forSale(int $id): array
    {
        return $this->present((new CommercialTaxBreakdownService($this->db))->forSale($id));
    }
    private function present(array $totals): array
    {
        return $totals + [
            'tax_total' => FiscalDecimal::subtract($totals['transferred'], $totals['withheld']),
            'grand_total' => $totals['total'],
            'after_discount' => FiscalDecimal::subtract($totals['subtotal'], $totals['discount']),
        ];
    }
    public function assertSaleMatches(array $proposalTotals, int $saleId): void
    {
        // Preserve conversion of legacy proposals without complete fiscal configuration.
        if (!$proposalTotals['ready']) return;
        $sale = $this->forSale($saleId);
        if (!$sale['ready']) throw new RuntimeException('La venta no conserva la configuración fiscal de la propuesta.');
        foreach (['subtotal', 'discount', 'tax_total', 'grand_total'] as $key) {
            if (FiscalDecimal::micros((string) $proposalTotals[$key]) !== FiscalDecimal::micros((string) $sale[$key])) {
                throw new RuntimeException('Los totales fiscales de la propuesta y la venta no coinciden: ' . $key);
            }
        }
    }
}
