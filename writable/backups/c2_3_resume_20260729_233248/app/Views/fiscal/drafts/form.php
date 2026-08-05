<?php
$editing = !empty($draft);
$selected = array_map(static fn($row)=>(int)$row['sale']->id,$sales);
$saved = []; foreach($saved_items as$item)$saved[(int)$item->sale_item_id]=(string)$item->quantity;
$issue = $editing ? date('Y-m-d\TH:i',strtotime($draft->issue_date)) : date('Y-m-d\TH:i');
$receiverProfile = $receiver;
$action = $editing ? get_uri('fiscal/drafts/'.$draft->id) : get_uri('fiscal/drafts');
?>
<div class="page-title clearfix"><h1><?php echo $editing?'Editar borrador #'.$draft->id:'Revisión fiscal'; ?></h1></div>
<div class="card"><div class="card-body">
<div class="alert alert-info">Revisa los datos comerciales y fiscales. Guardar no timbra, no genera XML y no llama al PAC.</div>
<?php echo form_open($action,['id'=>'fiscal-draft-form','class'=>'general-form']); echo csrf_field(); ?>
<h4>Ventas y asignaciones</h4>
<?php foreach($compatible_sales as$entry){$sale=$entry['sale'];$checked=in_array((int)$sale->id,$selected,true); ?>
<div class="border rounded p-3 mb10 sale-block" data-sale="<?php echo(int)$sale->id; ?>">
    <label class="fw-bold"><input type="checkbox" name="sale_ids[]" value="<?php echo(int)$sale->id; ?>" <?php echo$checked?'checked':''; ?>> Venta <?php echo esc($sale->display_id?:'#'.$sale->id); ?></label>
    <span class="ms-3">Total: <?php echo to_currency($sale->invoice_total); ?></span>
    <span class="ms-3">Disponible: <?php echo to_currency($entry['available']); ?></span>
    <table class="table table-sm mt10"><thead><tr><th>Concepto</th><th>Disponible</th><th>Precio</th><th>Cantidad a facturar</th></tr></thead><tbody>
    <?php foreach($entry['items']as$item){ ?><tr><td><?php echo esc($item->title); ?></td><td><?php echo esc($item->quantity); ?></td><td><?php echo to_currency($item->rate); ?></td><td><input class="form-control concept-qty" name="quantities[<?php echo$item->id; ?>]" value="<?php echo esc($saved[$item->id]??($checked?$item->quantity:'0')); ?>" inputmode="decimal"></td></tr><?php } ?>
    </tbody></table>
</div><?php } ?>
<h4 class="mt20">Emisor y comprobante</h4>
<div class="row g-2">
 <div class="col-md-4"><label>Emisor</label><select name="issuer_id" class="form-control"><option value="<?php echo(int)($issuer->id??0); ?>"><?php echo esc($issuer->legal_name??'Emisor no configurado'); ?></option></select></div>
 <div class="col-md-2"><label>Serie</label><select name="fiscal_series_id" class="form-control"><?php foreach($series as$s){ ?><option value="<?php echo$s->id; ?>" <?php echo($editing&&(int)$draft->fiscal_series_id===(int)$s->id)?'selected':''; ?>><?php echo esc($s->series); ?></option><?php } ?></select><input type="hidden" name="provisional_series" value="<?php echo esc($editing?$draft->provisional_series:($series[0]->series??'')); ?>"></div>
 <div class="col-md-3"><label>Fecha y hora de expedición</label><input type="datetime-local" name="issue_date" class="form-control" value="<?php echo$issue; ?>" required><small>Puedes seleccionar una fecha dentro de las últimas <?php echo(int)$max_issue_age_hours; ?> horas.</small></div>
 <div class="col-md-1"><label>Moneda</label><input name="currency_code" class="form-control" value="<?php echo esc($editing?$draft->currency_code:'MXN'); ?>"></div>
 <div class="col-md-2"><label>Tipo de cambio</label><input name="exchange_rate" class="form-control" value="<?php echo esc($editing?$draft->exchange_rate:'1.000000'); ?>" inputmode="decimal"></div>
</div>
<div class="row g-2 mt10">
 <div class="col-md-3"><label>Forma de pago</label><select name="payment_form_code" class="form-control"><option value="">Seleccionar</option><?php foreach($payment_forms as$row){ ?><option value="<?php echo$row->code; ?>" <?php echo($editing&&$draft->payment_form_code===$row->code)?'selected':''; ?>><?php echo esc($row->code.' · '.$row->name); ?></option><?php } ?></select></div>
 <div class="col-md-3"><label>Método de pago</label><select name="payment_method_code" class="form-control"><option value="">Seleccionar</option><?php foreach($payment_methods as$row){ ?><option value="<?php echo$row->code; ?>" <?php echo($editing&&$draft->payment_method_code===$row->code)?'selected':''; ?>><?php echo esc($row->code.' · '.$row->name); ?></option><?php } ?></select></div>
 <div class="col-md-3"><label>Condiciones</label><input name="conditions" class="form-control" value="<?php echo esc($editing?$draft->conditions:''); ?>"></div>
 <div class="col-md-3"><label>Observaciones</label><input name="observations" class="form-control" value="<?php echo esc($editing?$draft->observations:''); ?>"></div>
</div>
<h4 class="mt20">Receptor</h4>
<input type="hidden" name="receiver_profile_id" value="<?php echo(int)($receiverProfile->id??0); ?>">
<div class="row g-2">
 <div class="col-md-3"><label>Razón social fiscal</label><input name="legal_name" class="form-control" value="<?php echo esc($receiverProfile->legal_name??''); ?>"></div>
 <div class="col-md-2"><label>RFC</label><input name="rfc" class="form-control" value="<?php echo esc($receiverProfile->rfc??''); ?>"></div>
 <div class="col-md-2"><label>Código postal fiscal</label><input name="fiscal_postal_code" class="form-control" value="<?php echo esc($receiverProfile->fiscal_postal_code??''); ?>"><input type="hidden" name="receiver_postal_code" value="<?php echo esc($receiverProfile->fiscal_postal_code??''); ?>"></div>
 <div class="col-md-2"><label>Régimen fiscal</label><select name="tax_regime_id" class="form-control"><?php foreach($tax_regimes as$row){ ?><option value="<?php echo$row->id; ?>" <?php echo((int)($receiverProfile->tax_regime_id??0)===(int)$row->id)?'selected':''; ?>><?php echo esc($row->code.' · '.$row->description); ?></option><?php } ?></select><input type="hidden" name="receiver_tax_regime_code" value="<?php $match=array_values(array_filter($tax_regimes,fn($r)=>(int)$r->id===(int)($receiverProfile->tax_regime_id??0)));echo esc($match[0]->code??''); ?>"></div>
 <div class="col-md-3"><label>Uso CFDI</label><select name="default_cfdi_use_id" class="form-control"><?php foreach($cfdi_uses as$row){ ?><option value="<?php echo$row->id; ?>" <?php echo((int)($receiverProfile->default_cfdi_use_id??0)===(int)$row->id)?'selected':''; ?>><?php echo esc($row->code.' · '.$row->description); ?></option><?php } ?></select><input type="hidden" name="cfdi_use_code" value="<?php $match=array_values(array_filter($cfdi_uses,fn($r)=>(int)$r->id===(int)($receiverProfile->default_cfdi_use_id??0)));echo esc($match[0]->code??''); ?>"></div>
 <div class="col-md-3"><label>Correo fiscal</label><input type="email" name="email" class="form-control" value="<?php echo esc($receiverProfile->email??''); ?>"></div>
</div>
<label class="mt10"><input type="checkbox" name="confirm_receiver_update" value="1"> Confirmo que deseo actualizar el perfil fiscal del cliente con estos datos.</label>
<input type="hidden" name="expedition_postal_code" value="<?php echo esc($issuer->expedition_postal_code??''); ?>">
<div id="draft-validation-message" class="mt15"></div>
<div class="mt20"><button class="btn btn-primary" type="submit">Guardar borrador</button> <a class="btn btn-default" href="<?php echo get_uri('fiscal/drafts'); ?>">Cancelar</a></div>
<?php echo form_close(); ?>
</div></div>
<script>
$(document).ready(function(){
 $("#fiscal-draft-form").appForm({closeModalOnSuccess:false,onSuccess:function(result){window.location=result.redirect;},onAjaxSuccess:function(result){if(!result.success)$("#draft-validation-message").html('<div class="alert alert-danger">'+result.message+'</div>');}});
 $(".sale-block input[type=checkbox]").on("change",function(){$(this).closest(".sale-block").find(".concept-qty").prop("disabled",!this.checked);}).trigger("change");
});
</script>
