<?php
declare(strict_types=1);

require dirname(__DIR__) . '/bootstrap.php';

use App\Domain\Fiscal\Cfdi40\{CfdiConcept, CfdiConceptTax, CfdiDocument, CfdiParty, CfdiTaxSummary};
use App\Services\Fiscal\Cfdi40\{CfdiCurrencyTotalsCalculator, CfdiSemanticValidator, CfdiXmlBuilder};

$passed = 0;
$failed = 0;
$assert = static function (bool $ok, string $message) use (&$passed, &$failed): void {
    echo ($ok ? '[PASS] ' : '[FAIL] ') . $message . PHP_EOL;
    $ok ? $passed++ : $failed++;
};

$totals = new CfdiCurrencyTotalsCalculator();
$aquashoes = $totals->fromLines([[
    'subtotal' => '4545.454550',
    'discount' => '0',
    'transferred' => '727.272728',
    'withheld' => '0',
]]);
$assert($aquashoes === [
    'subtotal' => '4545.45',
    'discount' => '0.00',
    'transferred' => '727.27',
    'withheld' => '0.00',
    'total' => '5272.72',
], 'Aquashoes derives Total from the same two-decimal CFDI components.');

$standard = $totals->fromLines([[
    'subtotal' => '14286.000000',
    'discount' => '0',
    'transferred' => '2285.760000',
    'withheld' => '0',
]]);
$assert($standard['total'] === '16571.76', '100 x 142.86 plus IVA 16% remains stable.');

$multiple = $totals->fromLines([
    ['subtotal'=>'0.335000','discount'=>'0','transferred'=>'0.053600','withheld'=>'0'],
    ['subtotal'=>'0.335000','discount'=>'0','transferred'=>'0.053600','withheld'=>'0'],
    ['subtotal'=>'0.335000','discount'=>'0','transferred'=>'0.053600','withheld'=>'0'],
]);
$assert($multiple === [
    'subtotal'=>'1.02','discount'=>'0.00','transferred'=>'0.15','withheld'=>'0.00','total'=>'1.17',
], 'Several fractional-cent lines close from their serialized values.');

$discount = $totals->fromLines([[
    'subtotal'=>'100.005000','discount'=>'10.005000','transferred'=>'14.400000','withheld'=>'0',
]]);
$assert($discount['total'] === '104.40', 'Discount plus IVA closes exactly.');

$mixed = $totals->fromLines([[
    'subtotal'=>'100.000000','discount'=>'0','transferred'=>'16.000000','withheld'=>'10.000000',
]]);
$assert($mixed['total'] === '106.00', 'Transfer plus withholding closes exactly.');

$partyIssuer = new CfdiParty(['rfc'=>'AAA010101AAA','legal_name'=>'EMISOR','tax_regime_code'=>'601']);
$partyReceiver = new CfdiParty(['rfc'=>'XAXX010101000','legal_name'=>'PUBLICO GENERAL','tax_regime_code'=>'616','fiscal_postal_code'=>'06000','cfdi_use_code'=>'S01']);
$tax = new CfdiConceptTax('002','transferred','Tasa','0.160000','4545.454550','727.272728');
$concept = new CfdiConcept([
    'product_service_code'=>'53121600','quantity'=>'10.000000','unit_code'=>'H87',
    'description'=>'Aquashoes Unisex','unit_value'=>'454.545455',
    'gross_amount'=>'4545.454550','discount'=>'0.000000','tax_object_code'=>'02',
], [$tax]);
$document = new CfdiDocument([
    'status'=>'locked','document_type'=>'income','series'=>'T','folio'=>'4',
    'issue_date'=>'2026-09-02 10:00:00','currency_code'=>'MXN',
    'payment_form_code'=>'01','payment_method_code'=>'PUE','export_code'=>'01',
    'expedition_postal_code'=>'06000','subtotal'=>'4545.45','discount'=>'0.00',
    'transferred_tax_total'=>'727.27','withheld_tax_total'=>'0.00','total'=>'5272.72',
], $partyIssuer, $partyReceiver, [$concept], [
    new CfdiTaxSummary('002','transferred','Tasa','0.160000','4545.45','727.27'),
]);
$semantic = (new CfdiSemanticValidator())->validate($document);
$assert($semantic['is_valid'], 'Aquashoes passes semantic validation with canonical header totals.');
$xml=(new CfdiXmlBuilder())->build($document);
$assert(str_contains($xml,'SubTotal="4545.45"')&&str_contains($xml,'TotalImpuestosTrasladados="727.27"')&&str_contains($xml,'Total="5272.72"'),'Aquashoes XML serializes the same canonical equation.');

$inclusive = $totals->fromAggregates('86.21','0','13.79','0');
$exclusive = $totals->fromAggregates('100.00','0','16.00','0');
$assert($inclusive['total']==='100.00', 'Resolved tax-inclusive components close exactly.');
$assert($exclusive['total']==='116.00', 'Resolved tax-exclusive components close exactly.');

echo PHP_EOL . $passed . ' passed, ' . $failed . ' failed.' . PHP_EOL;
exit($failed ? 1 : 0);
