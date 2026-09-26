<?php
$totals = $proposal_commercial_totals;
$currency = $proposal_total_summary->currency_symbol;
$hasDiscount = \App\Services\Fiscal\FiscalDecimal::micros((string) $totals['discount']) > 0;
$discountLink = $is_proposal_editable ? modal_anchor(get_uri('proposals/discount_modal_form'), '<i data-feather="edit" class="icon-16"></i>', [
    'class' => 'edit', 'data-post-proposal_id' => $proposal_id, 'title' => app_lang('edit_discount')
]) : '';
// Empty proposals show zero; incomplete fiscal configurations must not look tax-free.
$pending = !$totals['ready'] && !empty($totals['missing']);
$rows = [[app_lang('sub_total'), $totals['subtotal']]];
if ($hasDiscount) {
    $rows[] = [app_lang('discount'), $totals['discount']];
    $rows[] = [app_lang('total_after_discount'), $totals['after_discount']];
}
$rows[] = ['Impuestos', $totals['tax_total']];
$rows[] = [app_lang('total'), $totals['grand_total']];
?>
<table class="table text-right strong table-responsive no-body-top-bottom-border mb0">
    <?php foreach ($rows as $index => [$label, $amount]) { ?>
        <tr>
            <td><?php echo esc($label); ?></td>
            <td style="width: 120px;"><?php echo $pending ? '—' : to_currency($amount, $currency); ?></td>
            <?php if ($is_proposal_editable) { ?>
                <td style="width: 100px;" class="text-center"><?php echo $index === ($hasDiscount ? 1 : 0) ? $discountLink : ''; ?></td>
            <?php } ?>
        </tr>
    <?php } ?>
</table>
<?php if ($pending) { ?>
    <div class="text-warning">Configuración fiscal pendiente: <?php echo esc(implode('; ', $totals['missing'])); ?></div>
<?php } ?>
