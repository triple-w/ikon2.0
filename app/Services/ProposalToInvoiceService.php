<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\Proposal_items_model;
use CodeIgniter\Database\BaseConnection;
use RuntimeException;

final class ProposalToInvoiceService
{
    public function __construct(
        private ?InvoiceCreationService $creator = null,
        private ?BaseConnection $db = null
    ) {
        $this->db ??= db_connect('default');
        $this->creator ??= new InvoiceCreationService($this->db);
    }

    public function createFromProposal(object $proposal, int $actorId): int
    {
        $this->validateRelations($proposal);
        $items = (new Proposal_items_model($this->db))->get_details(['proposal_id' => $proposal->id])->getResult();
        if (! $items) {
            throw new RuntimeException('La propuesta requiere al menos una partida activa.');
        }

        $rows = [];
        foreach ($items as $position => $item) {
            $quantityText = trim((string) $item->quantity);
            $rateText = trim((string) $item->rate);
            if (! preg_match('/^(?:0|[1-9]\d*)(?:\.\d+)?$/', $quantityText)
                || ! preg_match('/^(?:0|[1-9]\d*)(?:\.\d+)?$/', $rateText)) {
                throw new RuntimeException('Las cantidades y precios deben ser decimales finitos no negativos.');
            }
            $quantity = (float) $item->quantity;
            $rate = (float) $item->rate;
            if (! is_finite($quantity) || $quantity <= 0) {
                throw new RuntimeException('Todas las cantidades de la propuesta deben ser mayores que cero.');
            }
            if (! is_finite($rate) || $rate < 0) {
                throw new RuntimeException('Todos los precios de la propuesta deben ser valores no negativos válidos.');
            }
            $rows[] = [
                'item_id' => (int) $item->item_id,
                'title' => (string) $item->title,
                'description' => (string) ($item->description ?? ''),
                'quantity' => $item->quantity,
                'unit_type' => (string) $item->unit_type,
                'rate' => $item->rate,
                'total' => $quantity * $rate,
                'taxable' => 1,
                'sort' => (int) ($item->sort ?? $position),
            ];
        }

        $billDate = get_my_local_time('Y-m-d');
        $dueDate = date('Y-m-d', strtotime('+' . (int) get_setting('default_due_date_after_billing_date') . ' days', strtotime($billDate)));
        $header = [
            'type' => 'invoice',
            'client_id' => (int) $proposal->client_id,
            'project_id' => (int) ($proposal->project_id ?: 0),
            'bill_date' => $billDate,
            'due_date' => $dueDate,
            'status' => 'not_paid',
            'commercial_status' => 'open',
            'tax_id' => (int) $proposal->tax_id,
            'tax_id2' => (int) $proposal->tax_id2,
            'tax_id3' => 0,
            'company_id' => (int) $proposal->company_id,
            'note' => $proposal->note,
            'labels' => '',
            'estimate_id' => 0,
            'proposal_id' => (int) $proposal->id,
            'discount_amount' => $proposal->discount_amount,
            'discount_amount_type' => $proposal->discount_amount_type,
            'discount_type' => $proposal->discount_type,
            'created_by' => $actorId,
            'files' => serialize([]),
            'recurring' => 0,
            'repeat_every' => 1,
            'repeat_type' => 'months',
            'no_of_cycles' => 0,
        ];

        return $this->creator->create($header, $rows, false);
    }

    private function validateRelations(object $proposal): void
    {
        $client = $this->db->table('clients')->where(['id' => $proposal->client_id, 'deleted' => 0])->get(1)->getRow();
        if (! $client || (int) $client->is_lead === 1) {
            throw new RuntimeException('El cliente de la propuesta no es válido para crear una venta.');
        }
        if (! $this->db->table('company')->where(['id' => $proposal->company_id, 'deleted' => 0])->countAllResults()) {
            throw new RuntimeException('La empresa de la propuesta no es válida.');
        }
        if ($proposal->project_id) {
            $project = $this->db->table('projects')->where(['id' => $proposal->project_id, 'deleted' => 0])->get(1)->getRow();
            if (! $project || (int) $project->client_id !== (int) $proposal->client_id) {
                throw new RuntimeException('El proyecto de la propuesta no corresponde al cliente.');
            }
        }
        foreach ([(int) $proposal->tax_id, (int) $proposal->tax_id2] as $taxId) {
            if ($taxId && ! $this->db->table('taxes')->where(['id' => $taxId, 'deleted' => 0])->countAllResults()) {
                throw new RuntimeException('La propuesta contiene un impuesto inexistente o eliminado.');
            }
        }
    }
}
