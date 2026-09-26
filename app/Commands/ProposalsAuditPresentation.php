<?php
declare(strict_types=1);
namespace App\Commands;
use CodeIgniter\CLI\BaseCommand;
use CodeIgniter\CLI\CLI;

/** Safe to run on the affected server; reports tokens, never rewrites templates. */
final class ProposalsAuditPresentation extends BaseCommand
{
    protected $group = 'Proposals';
    protected $name = 'proposals:audit-presentation';
    protected $description = 'Audita contenido persistido, selección de plantilla y totales sin escribir datos.';
    protected $usage = 'proposals:audit-presentation <proposal_id>';

    public function run(array $params)
    {
        $id = (int) ($params[0] ?? 0);
        if ($id <= 0) { CLI::error('Indica el ID de Proposal.'); return; }
        $db = db_connect();
        $proposal = $db->table('proposals')->where(['id' => $id, 'deleted' => 0])->get(1)->getRow();
        if (!$proposal) { CLI::error('Proposal inexistente.'); return; }
        $templates = [];
        foreach ($db->table('proposal_templates')->where('deleted', 0)->get()->getResult() as $template) {
            $templates[] = ['id' => (int) $template->id, 'title' => $template->title,
                'matches_saved_content' => (string) $template->template === (string) $proposal->content,
                'content_audit' => $this->audit((string) $template->template)];
        }
        CLI::write(json_encode([
            'read_only' => true, 'proposal_id' => $id,
            'proposal_template_id' => $proposal->proposal_template_id ?? null,
            'render_source' => 'proposals.content (snapshot, no default fallback)',
            'saved_content' => $this->audit((string) $proposal->content),
            'templates' => $templates,
            'totals' => (new \App\Services\ProposalTotalsService($db))->forProposal($id),
        ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));
    }

    private function audit(string $content): array
    {
        preg_match_all('/\{PROPOSAL_[A-Z_]+\}/', $content, $matches);
        $tokens = array_values(array_unique($matches[0]));
        $required = ['{PROPOSAL_ITEMS_WITH_TAXES}', '{PROPOSAL_SUBTOTAL}', '{PROPOSAL_DISCOUNT_ROW}',
            '{PROPOSAL_TOTAL_AFTER_DISCOUNT_ROW}', '{PROPOSAL_TAXES}', '{PROPOSAL_GRAND_TOTAL}'];
        $forbidden = array_values(array_intersect($tokens, ['{PROPOSAL_ITEMS}', '{PROPOSAL_TOTAL}']));
        $missing = array_values(array_diff($required, $tokens));
        return ['tokens' => $tokens, 'missing_fiscal_tokens' => $missing, 'legacy_tokens' => $forbidden,
            'fiscal_template_valid' => !$missing && !$forbidden, 'sha256' => hash('sha256', $content)];
    }
}
