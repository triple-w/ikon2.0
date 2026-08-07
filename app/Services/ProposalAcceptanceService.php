<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\Users_model;
use CodeIgniter\Database\BaseConnection;
use RuntimeException;

final class ProposalAcceptanceService
{
    public function __construct(
        private ?ProposalToInvoiceService $converter = null,
        private ?BaseConnection $db = null
    ) {
        $this->db ??= db_connect('default');
        $this->converter ??= new ProposalToInvoiceService(null, $this->db);
    }

    public function acceptAndConvert(int $proposalId, int $actorId): array
    {
        $this->db->transBegin();
        try {
            $table = $this->db->prefixTable('proposals');
            $proposal = $this->db->query("SELECT * FROM {$table} WHERE id=? AND deleted=0 FOR UPDATE", [$proposalId])->getRow();
            if (! $proposal) {
                throw new RuntimeException('La propuesta no existe o fue eliminada.');
            }
            $this->assertAuthorized($actorId, $proposal);

            if ($proposal->converted_sale_id) {
                $invoice = $this->db->table('invoices')->where(['id' => $proposal->converted_sale_id, 'proposal_id' => $proposalId, 'deleted' => 0])->get(1)->getRow();
                if (! $invoice) {
                    throw new RuntimeException('El vínculo de conversión de la propuesta es inconsistente.');
                }
                $this->db->transCommit();
                return ['proposal_id' => $proposalId, 'invoice_id' => (int) $invoice->id, 'invoice_action' => 'existing'];
            }

            $linked = $this->db->table('invoices')->where(['proposal_id' => $proposalId, 'deleted' => 0])->get()->getResult();
            if ($linked) {
                throw new RuntimeException('Existe una venta vinculada sin backlink consistente; se requiere revisión manual.');
            }
            if ($proposal->status === 'accepted') {
                throw new RuntimeException('La propuesta fue aceptada antes de este flujo y requiere auditoría legacy.');
            }
            if (! in_array($proposal->status, ['draft', 'sent'], true)) {
                throw new RuntimeException('El estado actual de la propuesta no permite aceptarla.');
            }

            $invoiceId = $this->converter->createFromProposal($proposal, $actorId);
            $now = get_current_utc_time();
            $updated = $this->db->table('proposals')->where(['id' => $proposalId, 'deleted' => 0])->update([
                'status' => 'accepted',
                'accepted_by' => $actorId,
                'accepted_at' => $now,
                'converted_sale_id' => $invoiceId,
                'converted_at' => $now,
                'converted_by' => $actorId,
            ]);
            if (! $updated) {
                throw new RuntimeException('No fue posible cerrar la propuesta.');
            }
            if ($this->db->tableExists('commercial_lifecycle_audit')) {
                $this->db->table('commercial_lifecycle_audit')->insert([
                    'entity_type' => 'proposal', 'entity_id' => $proposalId,
                    'event' => 'proposal_converted', 'old_status' => $proposal->status,
                    'new_status' => 'accepted', 'reason' => null,
                    'user_id' => $actorId, 'created_at' => $now,
                ]);
            }
            if (! $this->db->transStatus()) {
                throw new RuntimeException('La transacción de aceptación no pudo completarse.');
            }
            $this->db->transCommit();
            return ['proposal_id' => $proposalId, 'invoice_id' => $invoiceId, 'invoice_action' => 'created'];
        } catch (\Throwable $e) {
            $this->db->transRollback();
            $this->db->resetTransStatus();
            throw $e;
        }
    }

    private function assertAuthorized(int $actorId, object $proposal): void
    {
        $actor = (new Users_model($this->db))->get_access_info($actorId);
        if (! $actor || ! $actor->id || $actor->user_type !== 'staff') {
            throw new RuntimeException('El actor no puede aceptar propuestas.');
        }
        if ((int) $actor->is_admin === 1) {
            return;
        }
        $permissions = @unserialize((string) $actor->permissions) ?: [];
        $proposalPermission = $permissions['proposal'] ?? '';
        $invoicePermission = $permissions['invoice'] ?? '';
        $canAccessProposal = $proposalPermission === 'all'
            || ($proposalPermission === 'own' && (int) $proposal->created_by === $actorId);
        $canCreateSale = in_array($invoicePermission, [
            'all', 'manage_own_client_invoices', 'manage_own_client_invoices_except_delete',
            'manage_only_own_created_invoices', 'manage_only_own_created_invoices_except_delete',
        ], true);
        if (($permissions['proposal.accept_and_convert'] ?? '') !== '1' || ! $canAccessProposal || ! $canCreateSale) {
            throw new RuntimeException('El actor no tiene permisos para aceptar y convertir esta propuesta.');
        }
    }
}
