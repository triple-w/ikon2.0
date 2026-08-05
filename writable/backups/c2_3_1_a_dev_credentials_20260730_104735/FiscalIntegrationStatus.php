<?php
declare(strict_types=1);
namespace App\Commands;
use App\Services\Fiscal\FiscalIntegrationStatusService;
use CodeIgniter\CLI\BaseCommand;
use CodeIgniter\CLI\CLI;

final class FiscalIntegrationStatus extends BaseCommand
{
    protected $group='Fiscal';protected $name='fiscal:integration:status';
    protected $description='Muestra el estado seguro del entorno PAC de integración, sin secretos.';
    public function run(array$params):void
    {
        foreach((new FiscalIntegrationStatusService())->inspect()as$key=>$value)CLI::write($key.': '.(is_bool($value)?($value?'sí':'no'):($value??'—')),$key==='ready'&&$value?'green':null);
    }
}
