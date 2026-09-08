<?php
declare(strict_types=1);
namespace App\Commands;
use App\Services\Fiscal\FiscalIntegrationStatusService;
use CodeIgniter\CLI\BaseCommand;
use CodeIgniter\CLI\CLI;
use RuntimeException;
use Throwable;

final class FiscalIntegrationPrepare extends BaseCommand
{
    protected $group='Fiscal';protected $name='fiscal:integration:prepare';
    protected $description='Prepara de forma idempotente emisor, serie y datos existentes para integración real.';
    public function run(array$params):void
    {
        $db=db_connect();$f=config('Fiscal');$pac=config('TimbradorXpress');$pdf=config('FiscalPdfProvider');
        try{
            if($f->runtimeMode!=='integration'||!$f->enabled||!$f->stampingEnabled||$f->previewMode||$f->pacAdapter!=='timbradorxpress'||!$f->allowRealPac)throw new RuntimeException('Configura el módulo fiscal para integración y timbrado PAC real.');
            if(!$pac->isCoherentWithFiscal($f->environment))throw new RuntimeException('El ambiente fiscal y TimbradorXpress no están configurados de forma coherente.');
            if(!$pdf->enabled||$pdf->username===''||$pdf->password===''||$pdf->wsdl==='')throw new RuntimeException('Faltan credenciales o WSDL de WSTools33.');
            $environment=$f->environment;
            $issuer=$db->table('fiscal_profiles')->where(['profile_type'=>'issuer','environment'=>$environment])->whereIn('status',['active','ready'])->orderBy('is_default','DESC')->get(1)->getRow();
            if(!$issuer)throw new RuntimeException('Falta un emisor activo.');
            $certificate=$db->table('fiscal_issuer_certificates')->where(['issuer_profile_id'=>$issuer->id,'status'=>'valid','deleted'=>0])->get(1)->getRow();
            if(!$certificate)throw new RuntimeException('Falta un CSD válido.');
            (new \App\Services\Fiscal\Signing\CsdCertificateSecretService($db))->passwordForSigning((int)$certificate->id,0);
            if(strtoupper((string)$certificate->certificate_rfc)!==strtoupper((string)$issuer->rfc))throw new RuntimeException('El RFC del CSD no coincide con el emisor.');
            if(!$db->table('fiscal_profiles')->where(['profile_type'=>'receiver'])->whereIn('status',['active','ready'])->countAllResults())throw new RuntimeException('Falta un cliente fiscal completo.');
            if(!$db->table('item_fiscal_settings')->whereIn('status',['active','ready'])->where('deleted',0)->countAllResults())throw new RuntimeException('Falta un producto con configuración fiscal.');
            $series=$db->table('fiscal_series')->where(['issuer_profile_id'=>$issuer->id,'environment'=>$environment,'is_active'=>1,'deleted'=>0])->whereIn('document_type',['income','ingreso','I'])->get(1)->getRow();
            if(!$series)throw new RuntimeException('Falta una serie de ingreso activa en el ambiente fiscal actual.');
            $status=(new FiscalIntegrationStatusService($db))->inspect();
            CLI::write('Preparación idempotente completada.','green');CLI::write('issuer_id: '.$status['issuer_id']);CLI::write('series_id: '.$status['series_id']);CLI::write('ready: '.($status['ready']?'sí':'no'));
        }catch(Throwable$e){CLI::error($e->getMessage());}
    }
}
