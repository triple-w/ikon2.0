<?php
declare(strict_types=1);
namespace App\Services\Fiscal;
use RuntimeException;
final class FiscalPreviewModeGuard
{
    public function __construct(private $db=null) {}
    public function isPreview(): bool
    {
        if(config('Fiscal')->previewMode) return true;
        if(!$this->db) return false;
        return (string)$this->db->getDatabase()==='ikontrol20_dold_preview';
    }
    public function assertStampingAllowed(): void
    {
        $fiscal=config('Fiscal');
        if($this->isPreview() || !$fiscal->stampingEnabled) throw new RuntimeException('AMBIENTE DE VISTA PREVIA — TIMBRADO FISCAL DESHABILITADO');
    }
    public function assertCancellationAllowed(): void
    {
        $fiscal=config('Fiscal');
        if($this->isPreview() || !$fiscal->stampingEnabled) throw new RuntimeException('AMBIENTE DE VISTA PREVIA — CANCELACIÓN FISCAL DESHABILITADA');
    }
}
