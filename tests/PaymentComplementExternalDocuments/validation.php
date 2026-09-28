<?php
declare(strict_types=1);
require dirname(__DIR__).'/bootstrap.php';
// Read-only catalog validation. No source-database writes.
$config=config('Database');$db=\Config\Database::connect($config->default,false);
$service=new App\Services\PaymentComplementExternalDocumentService($db);$passed=0;$failed=0;
$check=function(bool$value,string$message)use(&$passed,&$failed){echo($value?'[PASS] ':'[FAIL] ').$message.PHP_EOL;$value?$passed++:$failed++;};
$input=['uuid'=>'ABCDEF12-1234-1234-1234-ABCDEF123456','currency_code'=>'MXN','exchange_rate'=>'1','payment_method_code'=>'PPD','tax_object_code'=>'02','installment_number'=>1,'previous_balance'=>'1000','paid_amount'=>'500','taxes'=>[['tax_type'=>'transfer','base'=>'100','tax_code'=>'003','factor_type'=>'Tasa','rate_or_quota'=>'1.600000','amount'=>'160']]];
$check($service->validate($input,'MXN')['taxes'][0]['rate_or_quota']==='1.600000','IEPS admite tasas mayores a uno; no se asume IVA.');
$rounded=$input;$rounded['taxes'][0]=['tax_type'=>'transfer','base'=>'100.03','tax_code'=>'002','factor_type'=>'Tasa','rate_or_quota'=>'0.16','amount'=>'16.00'];
$check($service->validate($rounded,'MXN')['taxes'][0]['amount']==='16.000000','Límites DR admiten redondeo fiscal según precisión.');
$exempt=$input;$exempt['taxes'][0]['factor_type']='Exento';$exempt['taxes'][0]['tax_code']='002';
$check($service->validate($exempt,'MXN')['taxes'][0]['amount']===null,'Exento omite importe y tasa.');
$reject=function(array$data,string$message)use($service,$check){try{$service->validate($data,'MXN');$check(false,$message);}catch(RuntimeException){$check(true,$message);}};
$bad=$rounded;$bad['taxes'][0]['amount']='16.02';$reject($bad,'Impuesto fuera de límites se rechaza.');
$bad=$exempt;$bad['taxes'][0]['tax_type']='withholding';$reject($bad,'Retención Exento se rechaza.');
$reject(array_replace($input,['exchange_rate'=>'1e0']),'Equivalencia no admite notación exponencial.');
$reject(array_replace($input,['tax_object_code'=>'01']),'No objeto rechaza desglose de impuestos.');
$reject(array_replace($input,['taxes'=>[]]),'Objeto 02 exige desglose.');
$reject(array_replace($input,['remaining_balance'=>'499']),'Saldo insoluto incongruente se rechaza.');
$reject(array_replace($input,['paid_amount'=>'0']),'Pago cero se rechaza.');
$reject(array_replace($input,['paid_amount'=>'1.001']),'Saldos MXN de más de dos decimales se rechazan.');
$reject(array_replace($input,['taxes'=>[$input['taxes'][0],$input['taxes'][0]]]),'Impuestos duplicados deben agruparse.');
echo "TOTAL PASS=$passed FAIL=$failed\n";exit($failed?1:0);
