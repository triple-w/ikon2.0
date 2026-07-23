<?php
declare(strict_types=1);

$root = dirname(__DIR__, 2);
$pass = 0;
$fail = 0;
$assert = static function (bool $ok, string $message) use (&$pass, &$fail): void {
    echo ($ok ? '[PASS] ' : '[FAIL] ') . $message . PHP_EOL;
    $ok ? $pass++ : $fail++;
};

$migrations = glob($root . '/app/Database/Migrations/2026-07-28-*.php');
sort($migrations);
$migrationText = implode("\n", array_map('file_get_contents', $migrations));
$assert(count($migrations) === 2, 'Increment 08 defines two ordered migrations.');
$assert(str_contains($migrationText, 'fiscal_issuer_certificates'), 'Certificate metadata table is defined.');
$assert(str_contains($migrationText, 'fiscal_payment_method_mappings'), 'Explicit administrative-to-SAT payment mapping table is defined.');
$assert(str_contains($migrationText, 'fiscal_document_signatures'), 'Local signature trace table is defined.');
$assert(!preg_match('/[\'"](?:password|private_key_contents|certificate_contents)[\'"]\s*=>/i', $migrationText), 'Database schema stores no password or private key contents.');

$payment = file_get_contents($root . '/app/Services/Fiscal/CfdiPaymentRuleService.php');
$assert(str_contains($payment, "\$method === 'PPD' && \$form !== '99'"), 'PPD requires FormaPago 99 centrally.');
$assert(str_contains($payment, "\$method === 'PUE'") && str_contains($payment, "\$form === '99'"), 'PUE rejects FormaPago 99 centrally.');
$assert(str_contains($payment, 'fiscal_payment_method_mappings'), 'Paid-sale suggestion uses only explicit payment mapping.');

$csd = file_get_contents($root . '/app/Services/Fiscal/CsdCertificateService.php');
$assert(str_contains($csd, 'openssl_x509_parse') && str_contains($csd, 'openssl_pkey_get_private'), 'CSD service parses X.509 and encrypted private keys.');
$assert(str_contains($csd, 'keysMatch') && str_contains($csd, 'certificate_rfc'), 'CSD service checks key pair and issuer RFC.');
$assert(str_contains($csd, 'writeAtomic') && str_contains($csd, 'random_bytes(24)'), 'CSD storage is atomic and unpredictable.');
$assert(str_contains($csd, '0600') && str_contains($csd, '0700'), 'Private CSD storage requests restrictive permissions.');
$assert(!preg_match('/log_message\([^;]*password/i', $csd), 'CSD password is never logged.');

$chain = file_get_contents($root . '/app/Services/Fiscal/Cfdi40/CfdiOriginalChainGenerator.php');
$assert(str_contains($chain, 'XSLTProcessor') && !str_contains($chain, "file_get_contents('http"), 'Original chain uses local XSLT and no request-time download.');
$assert(str_contains($chain, 'XSL_SECPREF_READ_NETWORK') && str_contains($chain, 'resourceMap'), 'XSLT network access is blocked with an allowlisted local resolver.');

$signing = file_get_contents($root . '/app/Services/Fiscal/Cfdi40/CfdiSigningService.php');
$assert(str_contains($signing, 'OPENSSL_ALGO_SHA256'), 'Local seal uses RSA SHA-256 through OpenSSL.');
$assert(str_contains($signing, 'openssl_verify') && str_contains($signing, 'signature_verified'), 'Local seal is cryptographically verified.');
$assert(str_contains($signing, "setAttribute('Sello'") && str_contains($signing, "setAttribute('NoCertificado'") && str_contains($signing, "setAttribute('Certificado'"), 'Signed XML receives the three required CSD attributes.');
$assert(str_contains($signing, 'assertNoTimbre') && !preg_match('/callTimbr|soap|pac_client/i', $signing), 'Signing service forbids Timbre and contains no PAC call.');

$routes = file_get_contents($root . '/app/Config/FiscalRoutes.php');
foreach (['fiscal/certificates/upload', 'fiscal/invoices/sign', 'fiscal/invoices/signed/view/(:num)'] as $route) {
    $assert(str_contains($routes, $route), "Explicit protected route exists: $route.");
}
$roles = file_get_contents($root . '/app/Controllers/Roles.php');
foreach (['fiscal_certificates_view', 'fiscal_certificates_manage', 'fiscal_xml_sign', 'fiscal_signed_xml_view'] as $permission) {
    $assert(str_contains($roles, $permission), "Role persistence supports $permission.");
}
$gitignore = file_get_contents($root . '/.gitignore');
$assert(str_contains($gitignore, 'writable/fiscal/certificates/**') && str_contains($gitignore, 'writable/fiscal/artifacts/**'), 'Private CSD and signed artifacts are ignored by Git.');

$xslt = $root . '/resources/fiscal/sat/cfdi40/xslt/cadenaoriginal_4_0.xslt';
$includes = 0;
$iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator(dirname($xslt) . '/includes'));
foreach ($iterator as $file) if ($file->isFile() && strtolower($file->getExtension()) === 'xslt') $includes++;
$assert(is_file($xslt) && hash_file('sha256', $xslt) === 'b0559b380e73b850ca8a3da53b077a6051a09d87068d8d98e82dfd4acfba7565', 'Official CFDI 4.0 original-chain XSLT has the reviewed SHA-256.');
$assert($includes === 33, 'All 33 official XSLT includes are stored locally.');

echo PHP_EOL . "$pass passed, $fail failed." . PHP_EOL;
exit($fail ? 1 : 0);
