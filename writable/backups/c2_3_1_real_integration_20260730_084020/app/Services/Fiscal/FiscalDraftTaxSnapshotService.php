<?php
declare(strict_types=1);
namespace App\Services\Fiscal;
use RuntimeException;
final class FiscalDraftTaxSnapshotService
{
 public function __construct(private mixed$db=null){$this->db??=db_connect();}
 public function calculate(array$concept,string$mode='tax_inclusive'):array{
  $setting=$this->db->table('item_fiscal_settings')->where(['item_id'=>(int)$concept['product_id'],'is_default'=>1,'deleted'=>0])->get(1)->getRow();if(!$setting)throw new RuntimeException('Falta la configuración fiscal del concepto.');
  $rows=$this->db->table('item_fiscal_taxes ft')->select('t.fiscal_tax_type,t.xml_rate,t.xml_quota,t.is_fiscal_ready,t.use_for_fiscal,c.code tax_code,f.name factor_type,ft.sort_order')
   ->join('taxes t','t.id=ft.tax_id')->join('sat_tax_codes c','c.id=t.sat_tax_code_id','left')->join('sat_tax_factor_types f','f.id=t.factor_type_id','left')
   ->where(['ft.item_fiscal_setting_id'=>$setting->id,'ft.is_active'=>1,'t.deleted'=>0])->orderBy('ft.sort_order')->get()->getResultArray();
  $object=(string)($concept['snapshot']['tax_object_code']??'');if($object!=='01'&&!$rows)throw new RuntimeException('Falta el desglose de impuestos del concepto.');
  $net=FiscalDecimal::subtract((string)$concept['subtotal'],(string)$concept['discount']);$signedRates='0.000000';
  foreach($rows as$r)if($r['factor_type']==='Tasa')$signedRates=FiscalDecimal::add($signedRates,$r['fiscal_tax_type']==='withholding'?'-'.ltrim((string)$r['xml_rate'],'-'):(string)$r['xml_rate']);
  $base=$mode==='tax_exclusive'?$net:($rows?FiscalDecimal::prorate((string)$concept['total'],'1.000000',FiscalDecimal::add('1.000000',$signedRates)):$net);
  $taxes=[];$trans=$with='0.000000';foreach($rows as$i=>$r){if(!(int)$r['is_fiscal_ready']||!(int)$r['use_for_fiscal']||!in_array($r['fiscal_tax_type'],['transfer','withholding'],true)||!in_array($r['factor_type'],['Tasa','Cuota','Exento'],true)||!$r['tax_code'])throw new RuntimeException('La configuración fiscal del impuesto está incompleta.');$factor=$r['factor_type'];$rate=$factor==='Tasa'?(string)$r['xml_rate']:($factor==='Cuota'?(string)$r['xml_quota']:null);$amount=$factor==='Tasa'?FiscalDecimal::multiply($base,(string)$rate):($factor==='Cuota'?FiscalDecimal::multiply((string)$concept['quantity'],(string)$rate):'0.000000');if($r['fiscal_tax_type']==='withholding')$with=FiscalDecimal::add($with,$amount);else$trans=FiscalDecimal::add($trans,$amount);$taxes[]=['tax_type'=>$r['fiscal_tax_type'],'tax_code'=>$r['tax_code'],'factor_type'=>$factor,'rate_or_quota'=>$rate,'tax_base'=>$base,'tax_amount'=>$amount,'is_exempt'=>$factor==='Exento'?1:0,'calculation_order'=>(int)$r['sort_order']];}
  $total=FiscalDecimal::subtract(FiscalDecimal::add($base,$trans),$with);return['base'=>$base,'transferred'=>$trans,'withheld'=>$with,'total'=>$total,'taxes'=>$taxes];
 }
}
