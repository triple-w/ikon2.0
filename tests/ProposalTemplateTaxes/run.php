<?php
declare(strict_types=1);

// No live database: only the repository boundary is replaced. Fiscal services,
// resolver, decimal calculators, template parser and TCPDF run unchanged.
function db_connect($group = null, bool $shared = true) { return $GLOBALS['proposalFixtureDb']; }
function model($name, bool $shared = true, $connection = null) {
    if ($name !== 'App\Models\Company_model') throw new RuntimeException('Unexpected model ' . $name);
    return new class {
        public function get_one_where($options) {
            return (object) ['id'=>1,'name'=>'Empresa de prueba','address'=>'','phone'=>'','email'=>'','website'=>''];
        }
    };
}
function company_widget($id = 0, $billFrom = '') { return 'Empresa de prueba'; }

final class ProposalFixtureDb {
    public array $tables = [];
    public function table($name) { return new ProposalFixtureQuery($this->tables[$name] ?? []); }
}
final class ProposalFixtureQuery {
    public function __construct(private array $rows) {}
    public function where($conditions, $value = null) {
        foreach (is_array($conditions) ? $conditions : [$conditions=>$value] as $key=>$expected) {
            $this->rows = array_values(array_filter($this->rows, fn($row)=>($row->$key ?? null) == $expected));
        }
        return $this;
    }
    public function orderBy($field) { usort($this->rows, fn($a,$b)=>$a->$field <=> $b->$field); return $this; }
    public function get($limit = null) { return $this; }
    public function getRow() { return $this->rows[0] ?? null; }
    public function getResult() { return $this->rows; }
}

$root = is_file(dirname(__DIR__, 2) . '/tests/bootstrap.php') ? dirname(__DIR__, 2) : dirname(__DIR__);
require $root . '/tests/bootstrap.php';
require_once APPPATH . 'ThirdParty/PHP-Hooks/php-hooks.php';
helper(['plugin','general','app_files','currency','date_time']);
define('K_PATH_CACHE', WRITEPATH);
$settings = config('Rise');
$settings->app_settings_array = array_merge($settings->app_settings_array ?? [], [
    'system_file_path'=>'files/system/', 'timeline_file_path'=>'files/timeline_files/',
    'currency_symbol'=>'$', 'currency_position'=>'left', 'decimal_separator'=>'.', 'thousand_separator'=>',',
]);
$GLOBALS['proposalFixtureDb'] = $db = new ProposalFixtureDb();
$pass = $fail = 0;
$assert = static function ($condition, $message) use (&$pass, &$fail) {
    echo ($condition ? '[PASS] ' : '[FAIL] ') . $message . PHP_EOL;
    $condition ? $pass++ : $fail++;
};
$tax = static fn($code,$rate,$type='transfer',$factor='Tasa') => ['tax_code'=>$code,'tax_type'=>$type,'factor_type'=>$factor,'rate_or_quota'=>$rate];
$iva = $tax('002','0.160000');
$ieps = $tax('003','0.080000');
$isr = $tax('001','0.100000','withholding');
$image = get_store_item_image_pdf_source('');
$fixture = static function ($specs, $discount='0', $amountType='fixed') use ($db,$image) {
    $parent = (object) ['id'=>10,'company_id'=>1,'deleted'=>0,'discount_amount'=>$discount,'discount_amount_type'=>$amountType,'discount_type'=>'before_tax'];
    $items=[];
    foreach ($specs as $i=>$spec) {
        $override = ['product_service_code'=>'24101500','unit_code'=>'H87','commercial_unit'=>'PIEZA',
            'fiscal_description'=>'CONTENEDOR DE TAPAS PLASTICO','tax_object_code'=>empty($spec['taxes'])?'01':'02',
            'pricing_mode'=>$spec['mode']??'tax_exclusive','taxes'=>$spec['taxes']??[]];
        $items[]=(object) ['id'=>$i+1,'proposal_id'=>10,'company_id'=>1,'deleted'=>0,'sort'=>$i,'item_id'=>0,
            'title'=>'CONTENEDOR DE TAPAS PLASTICO','description'=>'','quantity'=>$spec['quantity']??'1','unit_type'=>'PIEZA',
            'rate'=>$spec['rate'],'total'=>App\Services\Fiscal\FiscalDecimal::multiply($spec['rate'],$spec['quantity']??'1'),
            'price_origin'=>$spec['origin']??'manual','fiscal_override_json'=>json_encode($override),
            'currency_symbol'=>'$','product_image'=>'assets/images/image_preview.png','product_image_pdf'=>$image];
    }
    $db->tables=['proposals'=>[$parent],'proposal_items'=>$items];
    $legacy=(object)['proposal_subtotal'=>999,'proposal_total'=>999,'discount_total'=>0,'discount_type'=>'before_tax',
        'tax'=>0,'tax2'=>0,'tax_name'=>'','tax_name2'=>'','currency_symbol'=>'$'];
    $info=(object)['id'=>10,'company_id'=>1,'proposal_date'=>'2026-09-22','valid_until'=>'2026-10-22','note'=>'',
        'content'=>file_get_contents(APPPATH.'../docs/proposal-with-taxes.html')];
    $client=(object)array_fill_keys(['company_name','address','city','state','zip','country','vat_number','gst_number'],'');
    return ['proposal_info'=>$info,'proposal_items'=>$items,'proposal_total_summary'=>$legacy,'client_info'=>$client];
};

$cases = [
    'caso-real'=>[[['rate'=>'10545.50','taxes'=>[$iva]]], '0','fixed','10545.50','1687.28','12232.78'],
    'iva-exacta'=>[[['rate'=>'10545.45','taxes'=>[$iva]]], '0','fixed','10545.45','1687.27','12232.72'],
    'sin-impuesto'=>[[['rate'=>'100','taxes'=>[]]], '0','fixed','100.00','0.00','100.00'],
    'dos-productos'=>[[['rate'=>'100','taxes'=>[$iva]],['rate'=>'200','taxes'=>[$ieps]]], '0','fixed','300.00','32.00','332.00'],
    'descuento-fijo'=>[[['rate'=>'100','taxes'=>[$iva]]], '10','fixed','100.00','14.40','104.40'],
    'descuento-porcentaje'=>[[['rate'=>'100','taxes'=>[$iva]],['rate'=>'200','taxes'=>[$ieps]]], '10','percentage','300.00','28.80','298.80'],
    'multiples'=>[[['rate'=>'100','taxes'=>[$iva,$ieps]]], '0','fixed','100.00','24.00','124.00'],
    'retencion'=>[[['rate'=>'100','taxes'=>[$iva,$isr]]], '0','fixed','100.00','6.00','106.00'],
    'incluido'=>[[['rate'=>'116','taxes'=>[$iva],'mode'=>'tax_inclusive']], '0','fixed','100.00','16.00','116.00'],
    'cost-margin'=>[[['rate'=>'100','taxes'=>[$iva],'mode'=>'tax_inclusive','origin'=>'cost_margin']], '0','fixed','100.00','16.00','116.00'],
    'cantidad'=>[[['rate'=>'100','taxes'=>[$iva],'quantity'=>'2']], '0','fixed','200.00','32.00','232.00'],
    'cuota'=>[[['rate'=>'100','taxes'=>[$tax('003','2.000000','transfer','Cuota')],'quantity'=>'2']], '0','fixed','200.00','4.00','204.00'],
    'exento'=>[[['rate'=>'100','taxes'=>[$tax('002','','transfer','Exento')]]], '0','fixed','100.00','0.00','100.00'],
];
try {
    foreach ($cases as $name=>[$specs,$discount,$discountType,$base,$taxTotal,$grand]) {
        $data=$fixture($specs,$discount,$discountType);
        $resolved=(new App\Services\ProposalTemplateFiscalService($db))->prepare(10,$data['proposal_items'],$data['proposal_total_summary']);
        $summary=$resolved['proposal_total_summary'];
        $assert($summary->proposal_subtotal===$base && (float)$summary->tax_total===(float)$taxTotal && $summary->proposal_total===$grand, "$name: resumen fiscal esperado");
        $html=prepare_proposal_view($data);
        $pdfHtml=prepare_proposal_pdf($data,'html');
        $assert($data['proposal_items'][0]->product_image==='assets/images/image_preview.png', "$name: PDF no modifica imagen del preview");
        $normalize=static fn($s)=>trim(preg_replace('/\s+/u',' ',html_entity_decode(strip_tags($s))));
        $assert($normalize($html)===$normalize($pdfHtml), "$name: importes y texto identicos en preview y PDF");
        $assert(!str_contains($html,'{PROPOSAL_') && str_contains($html,to_currency($grand,'$')), "$name: placeholders resueltos y grand total correcto");
        $dom=new DOMDocument(); @$dom->loadHTML('<?xml encoding="UTF-8">'.$html); $xpath=new DOMXPath($dom);
        $tables=$xpath->query('//table');
        $assert($tables->length===2, "$name: una tabla de partidas y un unico resumen");
        $assert($xpath->query('.//tr',$tables->item(0))->length===count($specs)+1 && $xpath->query('.//th',$tables->item(0))->length===6, "$name: tabla fiscal solo tiene encabezado y partidas");
        $summaryRows=$xpath->query('.//tr',$tables->item(1));
        $labels=[];
        foreach ($summaryRows as $row) $labels[]=trim($xpath->query('./td',$row)->item(0)->textContent);
        $expected=(float)$discount>0?['Sub Total',app_lang('discount'),app_lang('total_after_discount'),'Impuestos','Total']:['Sub Total','Impuestos','Total'];
        $assert($labels===$expected, "$name: filas y orden correctos, sin descuento cero");
        if ((float)$discount>0) {
            $assert(str_contains($summaryRows->item(1)->textContent,to_currency($summary->discount_total,'$')) && str_contains($summaryRows->item(2)->textContent,to_currency((float)$base-(float)$summary->discount_total,'$')), "$name: descuento y base neta reales");
        }
        $assert(str_contains($html,'Precio sin impuestos') && str_contains($html,'Producto o servicio'), "$name: columnas fiscales");
        if ($name==='retencion') $assert(str_contains($html,'Retención ISR 10%') && str_contains($html,to_currency('-10','$')), 'Retencion conserva signo negativo');
        if ($name==='multiples') $assert(str_contains($html,'IVA 16%') && str_contains($html,'IEPS 8%'), 'Dos impuestos en una partida');
        $pdf=new App\Libraries\Pdf('proposal');
        $pdf->setPrintHeader(false); $pdf->setPrintFooter(false); $pdf->SetCompression(false); $pdf->AddPage();
        $pdf->writeHTML($pdfHtml,true,false,true,false,'');
        $binary=$pdf->Output('proposal.pdf','S');
        $assert(str_starts_with($binary,'%PDF-') && substr_count($binary,'/Subtype /Image')>0, "$name: PDF valido con imagen incrustada");
        foreach ([$base,$taxTotal,$grand] as $amount) {
            $formatted=to_currency($amount,'$');
            $assert(str_contains($binary,mb_convert_encoding($formatted,'UTF-16BE','UTF-8')) || str_contains($binary,$formatted), "$name: importe $formatted presente en el PDF binario");
        }
        if ($name==='caso-real') {
            file_put_contents(WRITEPATH.'proposal-tax-preview.html',$html);
            file_put_contents(WRITEPATH.'proposal-tax-preview.pdf',$binary);
        }
    }
    $data=$fixture([['rate'=>'10545.454545','taxes'=>[$iva]]]);
    $result=(new App\Services\ProposalTemplateFiscalService($db))->prepare(10,$data['proposal_items'],$data['proposal_total_summary']);
    $assert(to_currency($result['proposal_fiscal_lines'][1]['total'],'$')===to_currency('12232.73','$'), 'Seis decimales: total de partida 12232.73 igual que UI');
    $assert($result['proposal_total_summary']->proposal_total==='12232.72', 'Seis decimales: resumen canonico redondea componentes a 12232.72 (diferencia preexistente)');
    $data['proposal_info']->content='{PROPOSAL_ITEMS}<p>{PROPOSAL_TOTAL}</p>';
    $legacy=prepare_proposal_view($data);
    $assert(!str_contains($legacy,'Precio sin impuestos') && str_contains($legacy,to_currency(999,'$')), 'Plantilla historica conserva columnas y total');
    $data['proposal_info']->content='{PROPOSAL_ITEMS}<p>{PROPOSAL_TAXES}</p><p>{PROPOSAL_GRAND_TOTAL}</p><p>LEGACY={PROPOSAL_TOTAL}</p>';
    $mixed=prepare_proposal_view($data);
    $assert(!str_contains($mixed,'Precio sin impuestos') && !str_contains($mixed,'>Impuestos</th>') && str_contains($mixed,'LEGACY='.to_currency(999,'$')), 'Totales fiscales no agregan columnas a ITEMS legacy');
    $data['proposal_info']->content='{PROPOSAL_ITEMS_WITH_TAXES}';
    $itemsOnly=prepare_proposal_view($data);
    $assert(!str_contains($itemsOnly,app_lang('sub_total')) && str_contains($itemsOnly,'IVA 16%'), 'Tabla fiscal independiente no genera resumen');
    $data['proposal_info']->content='{PROPOSAL_ITEMS}{PROPOSAL_ITEMS_WITH_TAXES}';
    $both=prepare_proposal_view($data);
    $dom=new DOMDocument(); @$dom->loadHTML('<?xml encoding="UTF-8">'.$both); $xpath=new DOMXPath($dom);
    $assert($xpath->query('//table[1]//th')->length===5 && $xpath->query('//table[2]//th')->length===6, 'Ambos placeholders coexisten sin contaminar columnas');
    $helper=file_get_contents(APPPATH.'Helpers/general_helper.php');
    $variables=substr($helper,strpos($helper,'function get_available_proposal_variables()'),1800);
    $assert(str_contains($variables,'"PROPOSAL_TAXES"') && str_contains($variables,'"PROPOSAL_GRAND_TOTAL"'), 'Editor ofrece ambos placeholders');
    foreach (['PROPOSAL_ITEMS_WITH_TAXES','PROPOSAL_DISCOUNT_ROW','PROPOSAL_TOTAL_AFTER_DISCOUNT_ROW'] as $variable) {
        $assert(str_contains($variables,'"'.$variable.'"'), 'Editor ofrece '.$variable);
    }
    $data=$fixture([['rate'=>'100','taxes'=>[$iva]]]);
    $data['proposal_info']->content='{PROPOSAL_DISCOUNT_ROW}{PROPOSAL_TOTAL_AFTER_DISCOUNT_ROW}';
    $assert(trim(prepare_proposal_view($data))==='', 'Filas de descuento devuelven cadena vacia con cero');
    $data=$fixture([['rate'=>'100','taxes'=>[$iva]]]);
    $db->tables['proposal_items'][0]->fiscal_override_json='';
    try { prepare_proposal_view($data); $assert(false,'Configuracion incompleta bloquea salida fiscal'); }
    catch (RuntimeException $e) { $assert(str_contains($e->getMessage(),'No se puede generar'),'Configuracion incompleta no imprime falsos impuestos cero'); }
} catch (Throwable $e) {
    $assert(false,get_class($e).': '.$e->getMessage().' at '.$e->getFile().':'.$e->getLine());
    echo $e->getTraceAsString().PHP_EOL;
}
echo "$pass passed, $fail failed.".PHP_EOL;
exit($fail?1:0);
