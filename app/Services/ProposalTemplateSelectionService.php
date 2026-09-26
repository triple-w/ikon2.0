<?php
declare(strict_types=1);
namespace App\Services;

use RuntimeException;

/** Stores template identity and the editable document snapshot in one update. */
final class ProposalTemplateSelectionService
{
    public function __construct(private mixed $db = null) { $this->db ??= db_connect(); }

    public function template(int $id): object
    {
        $template = $this->db->table('proposal_templates')->where(['id' => $id, 'deleted' => 0])->get(1)->getRow();
        if (!$template) throw new RuntimeException('La plantilla seleccionada no existe o fue eliminada.');
        return $template;
    }

    public function save(int $proposalId, string $content, ?int $templateId): array
    {
        if (!$this->db->fieldExists('proposal_template_id', 'proposals')) {
            throw new RuntimeException('Falta aplicar la migración AddProposalTemplateSelection.');
        }
        $proposal = $this->db->table('proposals')->where(['id' => $proposalId, 'deleted' => 0])->get(1)->getRow();
        if (!$proposal) throw new RuntimeException('La propuesta no existe.');
        // Older clients may omit the ID; editing content must not reset the selection.
        $selected = $templateId ?? ($proposal->proposal_template_id ?? null);
        if ($templateId !== null && $templateId > 0) $this->template($templateId);
        $selected = $selected ? (int) $selected : null;
        $data = ['content' => normalize_proposal_items_template_layout($content), 'proposal_template_id' => $selected];
        if (!$this->db->table('proposals')->where(['id' => $proposalId, 'deleted' => 0])->update($data)) {
            throw new RuntimeException('No fue posible guardar la plantilla de la propuesta.');
        }
        $saved = $this->db->table('proposals')->where(['id' => $proposalId, 'deleted' => 0])->get(1)->getRow();
        if (!$saved || (string) $saved->content !== $data['content'] || (int) $saved->proposal_template_id !== (int) $selected) {
            throw new RuntimeException('No se pudo confirmar el contenido guardado. Recarga antes de continuar.');
        }
        return ['proposal_template_id' => $selected];
    }
}
