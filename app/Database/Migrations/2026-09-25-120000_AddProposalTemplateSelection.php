<?php
declare(strict_types=1);
namespace App\Database\Migrations;
use CodeIgniter\Database\Migration;

final class AddProposalTemplateSelection extends Migration
{
    public function up()
    {
        if (!$this->db->fieldExists('proposal_template_id', 'proposals')) {
            $this->forge->addColumn('proposals', [
                'proposal_template_id' => ['type' => 'INT', 'null' => true, 'default' => null],
            ]);
            $this->db->resetDataCache();
        }
        // No backfill: historical content may have been edited or copied from deleted templates.
    }
    public function down()
    {
        if ($this->db->fieldExists('proposal_template_id', 'proposals')) {
            $this->forge->dropColumn('proposals', 'proposal_template_id');
            $this->db->resetDataCache();
        }
    }
}
