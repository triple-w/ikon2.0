<?php
$d=$document??(object)['uuid'=>'','series'=>'','folio'=>'','currency_code'=>'MXN','exchange_rate'=>'1','payment_method_code'=>'PPD','tax_object_code'=>'01','installment_number'=>1,'previous_balance'=>'','paid_amount'=>'','remaining_balance'=>'','taxes'=>[]];
?>
<?php echo form_open('payment_complements/'.$complement_id.'/external-documents/save',['id'=>'external-cfdi-form','class'=>'general-form']); ?>
<div class="modal-body">
<?php echo csrf_field(); ?><input type="hidden" name="id" value="<?php echo (int)($d->id??0); ?>">
<p>Capture los datos del CFDI emitido fuera de iKontrol. Esta relación sólo participa en el complemento fiscal.</p>
<div class="alert alert-danger hide" id="external-cfdi-error"></div>
<div class="row">
<?php foreach(['uuid'=>'UUID','series'=>'Serie','folio'=>'Folio','installment_number'=>'NumParcialidad','previous_balance'=>'ImpSaldoAnt','paid_amount'=>'ImpPagado'] as $field=>$label): ?>
<div class="col-md-<?php echo $field==='uuid'?12:6; ?> mb10"><label><?php echo esc($label); ?></label><input name="<?php echo $field; ?>" class="form-control" value="<?php echo esc($d->$field); ?>" <?php echo in_array($field,['series','folio'])?'':'required'; ?>></div>
<?php endforeach; ?>
<div class="col-md-6 mb10"><label>MonedaDR</label><select name="currency_code" class="form-control" id="external-currency"><?php foreach($currencies as $currency): ?><option value="<?php echo esc($currency->code); ?>" <?php echo $d->currency_code===$currency->code?'selected':''; ?>><?php echo esc($currency->code.' - '.$currency->name); ?></option><?php endforeach; ?></select></div>
<div class="col-md-6 mb10"><label>EquivalenciaDR</label><input name="exchange_rate" class="form-control" value="<?php echo esc($d->exchange_rate); ?>" required><small>Unidades de MonedaDR por una unidad de <?php echo esc($payment_currency); ?>. Hasta 10 decimales.</small></div>
<div class="col-md-6 mb10"><label>MetodoDePagoDR</label><select name="payment_method_code" class="form-control"><option value="PPD">PPD · Parcialidades o diferido</option></select></div>
<div class="col-md-6 mb10"><label>ObjetoImpDR</label><select name="tax_object_code" class="form-control" id="external-tax-object"><?php foreach(['01'=>'No objeto de impuesto','02'=>'Sí objeto de impuesto','03'=>'Sí objeto y no obligado al desglose'] as $code=>$label): ?><option value="<?php echo $code; ?>" <?php echo $d->tax_object_code===$code?'selected':''; ?>><?php echo esc($code.' · '.$label); ?></option><?php endforeach; ?></select></div>
<div class="col-md-6 mb10"><label>ImpSaldoInsoluto</label><input class="form-control" id="external-remaining" value="<?php echo esc($d->remaining_balance); ?>" readonly><small>Se guarda como saldo anterior menos importe pagado.</small></div>
</div>
<div id="external-taxes"><h5>Impuestos DR del importe pagado</h5><div class="table-responsive"><table class="table"><thead><tr><th>Tipo</th><th>BaseDR</th><th>ImpuestoDR</th><th>TipoFactorDR</th><th>TasaOCuotaDR</th><th>ImporteDR</th><th></th></tr></thead><tbody></tbody></table></div><button type="button" class="btn btn-default" id="external-add-tax">Agregar impuesto</button></div>
</div><div class="modal-footer"><button type="button" class="btn btn-default" data-bs-dismiss="modal">Cerrar</button><button type="submit" class="btn btn-primary">Guardar CFDI externo</button></div>
<?php echo form_close(); ?>
<script>
$(function(){
    const form=$('#external-cfdi-form'), paymentCurrency=<?php echo json_encode($payment_currency); ?>;
    let index=0;
    function addTax(t){
        const row=$('<tr>'), prefix='taxes['+(index++)+']';
        const fields={tax_type:{transfer:'Traslado',withholding:'Retención'},base:null,tax_code:{'001':'ISR','002':'IVA','003':'IEPS'},factor_type:{Tasa:'Tasa',Cuota:'Cuota',Exento:'Exento'},rate_or_quota:null,amount:null};
        $.each(fields,function(name,options){
            const input=options?$('<select>'):$('<input>');input.attr('name',prefix+'['+name+']').addClass('form-control');
            if(options)$.each(options,function(value,label){input.append($('<option>').val(value).text(label));});
            input.val(t[name]??(options?Object.keys(options)[0]:''));row.append($('<td>').append(input));
        });
        row.append($('<td>').append($('<button type="button" class="btn btn-danger btn-sm">').text('Quitar').on('click',()=>row.remove())));
        $('#external-taxes tbody').append(row);
    }
    <?php echo json_encode($d->taxes,JSON_HEX_TAG|JSON_HEX_AMP|JSON_HEX_APOS|JSON_HEX_QUOT); ?>.forEach(addTax);
    $('#external-add-tax').on('click',()=>addTax({}));
    $('#external-tax-object').on('change',function(){const active=$(this).val()==='02';$('#external-taxes').toggle(active).find(':input').prop('disabled',!active);}).trigger('change');
    $('#external-currency').on('change',function(){const same=$(this).val()===paymentCurrency, field=form.find('[name=exchange_rate]');field.prop('readonly',same);if(same)field.val('1');}).trigger('change');
    form.find('[name=previous_balance],[name=paid_amount]').on('input',function(){const balance=Number(form.find('[name=previous_balance]').val())-Number(form.find('[name=paid_amount]').val());$('#external-remaining').val(Number.isFinite(balance)?balance.toFixed(6):'');});
    form.on('submit',function(event){event.preventDefault();const button=form.find('[type=submit]');button.prop('disabled',true);$('#external-cfdi-error').addClass('hide');$.ajax({url:form.attr('action'),type:'POST',data:form.serialize(),success:function(r){if(r.success)location.reload();else{$('#external-cfdi-error').text(r.message).removeClass('hide');button.prop('disabled',false);}},error:function(xhr){$('#external-cfdi-error').text(xhr.responseJSON?.message||'No fue posible guardar el CFDI externo.').removeClass('hide');button.prop('disabled',false);}});});
});
</script>
