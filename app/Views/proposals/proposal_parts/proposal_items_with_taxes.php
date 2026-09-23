<?php
// Reuse the existing image/table renderer, explicitly excluding its summary.
echo view('proposals/proposal_parts/proposal_items_table', [
    'proposal_items' => $proposal_items,
    'proposal_total_summary' => $proposal_total_summary,
    'proposal_fiscal_lines' => $proposal_fiscal_lines,
    'proposal_fiscal_output' => true,
    'proposal_show_summary' => false,
    'mode' => $mode ?? null,
], ['saveData' => false]);
