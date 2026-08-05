<div class="card">
    <div class="card-header text-center">
        <h3>PREFACTURA</h3>
        <strong class="text-danger">DOCUMENTO SIN VALIDEZ FISCAL</strong>
    </div>
    <div class="card-body">
        <p><strong>Fecha de expedición:</strong> <?php echo esc($preinvoice['issue_date']); ?></p>
        <p><strong>Subtotal:</strong> <?php echo esc($preinvoice['subtotal']); ?></p>
        <p><strong>Descuento:</strong> <?php echo esc($preinvoice['discount']); ?></p>
        <p><strong>Total:</strong> <?php echo esc($preinvoice['total']); ?></p>
        <p><strong>Ventas relacionadas:</strong> <?php echo count($preinvoice['sales']); ?></p>
    </div>
</div>
