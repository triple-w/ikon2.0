<?php
declare(strict_types=1);

namespace App\Services;

use App\Models\Estimate_items_model;
use App\Models\Invoice_items_model;
use App\Models\Invoices_model;
use RuntimeException;

class EstimateToInvoiceService
{
    public function __construct(private ?InvoiceCreationService $creator = null)
    {
        $this->creator ??= new InvoiceCreationService();
    }

    public function prepareHeader(object $estimate, int $userId, string $status, ?string $billDate = null, ?string $dueDate = null): array
    {
        $billDate ??= get_my_local_time('Y-m-d');
        $dueDate ??= date('Y-m-d', strtotime('+' . (int) get_setting('default_due_date_after_billing_date') . ' days', strtotime($billDate)));
        return [
            'client_id' => $estimate->client_id,
            'project_id' => 0,
            'bill_date' => $billDate,
            'due_date' => $dueDate,
            'status' => $status,
            'tax_id' => $estimate->tax_id,
            'tax_id2' => $estimate->tax_id2,
            'tax_id3' => 0,
            'company_id' => $estimate->company_id,
            'note' => $estimate->note,
            'labels' => '',
            'estimate_id' => $estimate->id,
            'discount_amount' => $estimate->discount_amount,
            'discount_amount_type' => $estimate->discount_amount_type,
            'discount_type' => $estimate->discount_type,
            'created_by' => $userId,
            'files' => serialize([]),
            'recurring' => 0,
            'repeat_every' => 1,
            'repeat_type' => 'months',
            'no_of_cycles' => 0,
        ];
    }

    public function getItems(int $estimateId): array
    {
        $items = (new Estimate_items_model())->get_details(['estimate_id' => $estimateId])->getResult();
        if (! $items) {
            throw new RuntimeException('La cotización no contiene partidas; no se puede crear una venta vacía.');
        }
        return array_map(static fn ($item) => [
            'item_id' => $item->item_id,
            'title' => $item->title,
            'description' => $item->description,
            'quantity' => $item->quantity,
            'unit_type' => $item->unit_type,
            'rate' => $item->rate,
            'total' => $item->total,
            // RISE estimate_items has no taxable column; the original conversion marks copied rows taxable.
            'taxable' => property_exists($item, 'taxable') ? $item->taxable : 1,
            'sort' => $item->sort,
        ], $items);
    }

    public function createFromEstimate(object $estimate, int $userId, string $status, array $overrides = []): int
    {
        $header = array_replace($this->prepareHeader($estimate, $userId, $status), $overrides);
        return $this->creator->create($header, $this->getItems((int) $estimate->id));
    }

    /** Compatibility path for non-atomic legacy callers with an existing header. */
    public function copyItems(int $estimateId, int $invoiceId): int
    {
        $source = $this->getItems($estimateId);
        $items = new Invoice_items_model();
        foreach ($source as $row) {
            $row['invoice_id'] = $invoiceId;
            if (! $items->ci_save($row)) {
                throw new RuntimeException('No fue posible copiar una partida de la cotización.');
            }
        }
        (new Invoices_model())->update_invoice_total_meta($invoiceId);
        return count($source);
    }
}
