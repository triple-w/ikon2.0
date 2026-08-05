<?php
$labels = [
    'not_invoiced' => 'Sin facturar', 'draft' => 'Con borrador',
    'partially_invoiced' => 'Parcialmente facturada', 'fully_invoiced' => 'Totalmente facturada',
    'cancelled_invoices' => 'Facturas canceladas', 'mixed' => 'Estado mixto',
];
?>
<div class="card mb15">
    <div class="card-header fw-bold">Resumen fiscal de la venta</div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-2"><small>Total venta</small><div><?php echo to_currency($summary['sale_total']); ?></div></div>
            <div class="col-md-2"><small>Facturado vigente</small><div><?php echo to_currency($summary['active_invoiced_total']); ?></div></div>
            <div class="col-md-2"><small>Reservado</small><div><?php echo to_currency($summary['draft_reserved_total']); ?></div></div>
            <div class="col-md-2"><small>Disponible</small><div><?php echo to_currency($summary['available_to_invoice']); ?></div></div>
            <div class="col-md-2"><small>Estado fiscal</small><div><span class="badge bg-info"><?php echo esc($labels[$summary['fiscal_status']] ?? $summary['fiscal_status']); ?></span></div></div>
        </div>
        <div class="mt15">
            <?php if ($permissions['create_draft']) { ?>
                <a class="btn btn-primary btn-sm" href="<?php echo get_uri('fiscal/invoices/review/'.$invoice_id); ?>">Crear borrador</a>
            <?php } ?>
            <?php if ($permissions['view_draft'] && $summary['active_drafts']) { ?>
                <span class="btn btn-default btn-sm disabled">Ver borrador (<?php echo count($summary['active_drafts']); ?>)</span>
            <?php } ?>
            <?php if ($permissions['view_invoice']) {
                foreach ($summary['active_documents'] as $document) { ?>
                    <a class="btn btn-default btn-sm" href="<?php echo get_uri('fiscal/invoices/'.$document['fiscal_document_id']); ?>">Ver factura</a>
                <?php }
                if ($summary['active_documents'] || $summary['cancelled_documents']) { ?>
                    <a class="btn btn-default btn-sm" href="<?php echo get_uri('fiscal/invoices'); ?>">Ver documentos relacionados</a>
                <?php }
            } ?>
        </div>
    </div>
</div>
