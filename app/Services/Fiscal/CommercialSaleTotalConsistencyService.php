<?php
declare(strict_types=1);

namespace App\Services\Fiscal;

use RuntimeException;

/** Keeps newly-authored commercial sales aligned with their canonical fiscal lines. */
final class CommercialSaleTotalConsistencyService
{
    public const MISMATCH = 'FISCAL_SALE_TOTAL_MISMATCH';

    public function __construct(private mixed $db = null) { $this->db ??= db_connect(); }

    public function assertConsistent(int $saleId, ?int $issuerId = null): array
    {
        $sale = $this->sale($saleId);
        $breakdown = (new CommercialTaxBreakdownService($this->db))->forSale($saleId, $issuerId);
        if (!$breakdown['ready']) throw new RuntimeException((string) ($breakdown['missing'][0] ?? 'Falta la configuración fiscal de una partida.'));
        if ($this->cents((string) $sale->invoice_total) !== $this->cents((string) $breakdown['total'])) throw new RuntimeException(self::MISMATCH);
        return $breakdown;
    }

    /** Legacy NULL origins and fiscally allocated sales remain untouched. */
    public function synchronizeIfCanonical(int $saleId, ?int $issuerId = null): bool
    {
        $this->sale($saleId);
        $items = $this->db->table('invoice_items')->select('id,price_origin')->where(['invoice_id' => $saleId, 'deleted' => 0])->get()->getResult();
        if (!$items) return false;
        foreach ($items as $item) if (!in_array((string) $item->price_origin, ['manual', 'cost_margin'], true)) return false;
        if ($this->hasFiscalAllocation($saleId)) return false;
        $breakdown = (new CommercialTaxBreakdownService($this->db))->forSale($saleId, $issuerId);
        if (!$breakdown['ready']) return false;
        $updated = $this->db->table('invoices')->where(['id' => $saleId, 'deleted' => 0])->update([
            'invoice_subtotal' => $breakdown['subtotal'], 'discount_total' => $breakdown['discount'],
            'tax' => FiscalDecimal::subtract((string) $breakdown['transferred'], (string) $breakdown['withheld']),
            'tax2' => '0.000000', 'tax3' => '0.000000', 'invoice_total' => $breakdown['total'],
        ]);
        if (!$updated) throw new RuntimeException('No fue posible sincronizar los totales comerciales y fiscales.');
        return true;
    }

    private function hasFiscalAllocation(int $saleId): bool
    {
        if ($this->db->table('fiscal_document_sales')->where('sale_id', $saleId)->where('allocation_status !=', 'cancelled')->countAllResults()) return true;
        return (bool) $this->db->table('fiscal_draft_sales')->where(['sale_id' => $saleId, 'allocation_status' => 'reserved'])->countAllResults();
    }

    private function sale(int $saleId): object
    {
        $sale = $this->db->table('invoices')->where(['id' => $saleId, 'deleted' => 0])->get(1)->getRow();
        if (!$sale) throw new RuntimeException('La venta no existe.');
        return $sale;
    }

    private function cents(string $amount): int
    {
        $micros = FiscalDecimal::micros($amount);
        return $micros >= 0 ? intdiv($micros + 5000, 10000) : -intdiv(abs($micros) + 5000, 10000);
    }
}
