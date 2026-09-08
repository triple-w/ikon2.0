<?php

declare(strict_types=1);

define('ROOTPATH', dirname(__DIR__, 2) . DIRECTORY_SEPARATOR);
define('FCPATH', ROOTPATH);
require ROOTPATH . 'app/Config/Paths.php';
$paths = new Config\Paths();
define('APPPATH', realpath($paths->appDirectory) . DIRECTORY_SEPARATOR);
define('SYSTEMPATH', realpath($paths->systemDirectory) . DIRECTORY_SEPARATOR);
define('WRITEPATH', realpath($paths->writableDirectory) . DIRECTORY_SEPARATOR);
define('ENVIRONMENT', 'development');
require $paths->systemDirectory . '/Boot.php';
CodeIgniter\Boot::bootTest($paths);

$passed = 0;
$failed = 0;
$assert = static function (bool $condition, string $message) use (&$passed, &$failed): void {
    echo ($condition ? '[PASS] ' : '[FAIL] ') . $message . PHP_EOL;
    $condition ? $passed++ : $failed++;
};
$fiscal = static function (string $environment, bool $stamping = true, bool $preview = false): Config\Fiscal {
    $value = (new ReflectionClass(Config\Fiscal::class))->newInstanceWithoutConstructor();
    $value->runtimeMode = 'integration';
    $value->enabled = true;
    $value->stampingEnabled = $stamping;
    $value->previewMode = $preview;
    $value->environment = $environment;
    $value->allowRealPac = true;
    $value->pacAdapter = 'timbradorxpress';
    return $value;
};
$pac = static function (string $environment, string $url, bool $productionEnabled, string $key = 'configured-key'): Config\TimbradorXpress {
    $value = (new ReflectionClass(Config\TimbradorXpress::class))->newInstanceWithoutConstructor();
    $value->environment = $environment;
    $value->baseUrl = $url;
    $value->productionEnabled = $productionEnabled;
    $value->apiKey = $key;
    $value->connectTimeout = 10;
    $value->requestTimeout = 60;
    $value->maxSignedXmlBytes = 2097152;
    $value->maxResponseBytes = 8388608;
    $value->maxPdfBytes = 10485760;
    $value->pdfTemplate = 'Principal';
    return $value;
};
$factoryAllows = static function (Config\Fiscal $fiscal, Config\TimbradorXpress $pac): bool {
    try {
        (new App\Services\Fiscal\Pac\FiscalPacAdapterFactory($fiscal, $pac))->create();
        return true;
    } catch (Throwable) {
        return false;
    }
};

$sandbox = $pac('sandbox', Config\TimbradorXpress::SANDBOX_URL, false);
$production = $pac('production', Config\TimbradorXpress::PRODUCTION_URL, true);
$assert($sandbox->isCoherentWithFiscal('development') && $factoryAllows($fiscal('development'), $sandbox), 'Development con PAC sandbox queda READY.');
$assert($production->isCoherentWithFiscal('production') && $factoryAllows($fiscal('production'), $production), 'Production alineado y habilitado queda READY.');
$assert(!$sandbox->isCoherentWithFiscal('production'), 'Production con PAC sandbox queda NOT READY.');
$assert(!$production->isCoherentWithFiscal('development'), 'Development con PAC production queda NOT READY.');
$assert(!$pac('production', Config\TimbradorXpress::PRODUCTION_URL, false)->isCoherentWithFiscal('production'), 'Production deshabilitado queda NOT READY.');
$assert(!$pac('production', Config\TimbradorXpress::PRODUCTION_URL, true, '')->isCoherentWithFiscal('production'), 'Production sin API key queda NOT READY.');
$assert(!$pac('production', Config\TimbradorXpress::SANDBOX_URL, true)->isCoherentWithFiscal('production'), 'Production con URL sandbox queda NOT READY.');
$assert(!$factoryAllows($fiscal('production', true, true), $production), 'Preview mode bloquea timbrado production.');
$assert(!$factoryAllows($fiscal('production', false, false), $production), 'Stamping disabled bloquea timbrado production.');

$topbar = file_get_contents(APPPATH . 'Views/includes/topbar.php');
$assert(str_contains($topbar, 'AMBIENTE DE PRUEBAS PAC') && str_contains($topbar, 'development'), 'Topbar conserva badge development.');
$assert(str_contains($topbar, 'PAC PRODUCCI&#211;N') && str_contains($topbar, 'production'), 'Topbar muestra badge production diferenciado.');

echo PHP_EOL . $passed . ' passed, ' . $failed . ' failed.' . PHP_EOL;
exit($failed ? 1 : 0);
