<?php

declare(strict_types=1);

namespace App\Services;

use CodeIgniter\Database\BaseConnection;

final class ProposalEditabilityPolicy
{
    public function __construct(private ?BaseConnection $db = null)
    {
        $this->db ??= db_connect('default');
    }

    public function isEditable(object|int $proposal): bool
    {
        if (is_int($proposal)) {
            $proposal = $this->db->table('proposals')->where('id', $proposal)->get(1)->getRow();
        }
        if (! $proposal || ! $proposal->id || (int) $proposal->deleted === 1 || $proposal->status === 'accepted' || ! empty($proposal->converted_sale_id)) {
            return false;
        }

        if ($this->db->fieldExists('proposal_id', 'invoices')) {
            return ! $this->db->table('invoices')->where(['proposal_id' => $proposal->id, 'deleted' => 0])->countAllResults();
        }
        return true;
    }
}
