<?php
declare(strict_types=1);namespace App\Services\Fiscal\Pdf;
use RuntimeException;
final class FiscalIssuerBrandingService{
 public function __construct(private readonly mixed$resolver=null,private readonly int$maxBytes=2097152){}
 public function logoBase64(int$issuerId):?string{if(!is_callable($this->resolver))return null;$resolved=($this->resolver)($issuerId);if($resolved===null||$resolved==='')return null;if(!is_string($resolved)||!is_file($resolved))throw new RuntimeException('FISCAL_PDF_LOGO_NOT_FOUND');$bytes=file_get_contents($resolved);if($bytes===false||strlen($bytes)>$this->maxBytes)throw new RuntimeException('FISCAL_PDF_LOGO_INVALID_SIZE');$mime=(new \finfo(FILEINFO_MIME_TYPE))->buffer($bytes);if(!in_array($mime,['image/png','image/jpeg'],true))throw new RuntimeException('FISCAL_PDF_LOGO_INVALID_MIME');return base64_encode($bytes);}
}
