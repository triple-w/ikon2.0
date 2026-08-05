<?php
declare(strict_types=1);

namespace App\Services\Fiscal\Pac;

use App\Contracts\Fiscal\Pac\PacAdapterInterface;
use App\Domain\Fiscal\Pac\PacResponse;
use App\Domain\Fiscal\Pac\StampRequest;
use Config\TimbradorXpress;
use RuntimeException;

final class TimbradorXpressRestAdapter implements PacAdapterInterface
{
    private $client;
    public function __construct(private readonly ?TimbradorXpress $configuration = null, $client = null)
    {
        $this->client = $client ?: service('curlrequest');
    }
    public function stamp(StampRequest $request): PacResponse
    {
        $config=$this->configuration??config('TimbradorXpress');
        if ($request->provider !== 'timbradorxpress'||$request->environment!==$config->environment) throw new RuntimeException('Proveedor o ambiente PAC no permitido.');
        if(!$config->isConfigured())throw new RuntimeException('PAC no configurado.');
        if($config->environment==='production')throw new RuntimeException('El adaptador productivo está bloqueado para esta etapa.');
        $config->assertSandbox();
        if (strlen($request->signedXml) > 2097152) throw new RuntimeException('El XML firmado excede el límite permitido.');
        if ($request->keyPem === null || preg_match('/-----BEGIN (?:RSA )?PRIVATE KEY-----/', $request->keyPem) !== 1) {
            throw new RuntimeException('La llave CSD no está disponible para timbrarConSello.');
        }
        $url = $config->baseUrl.'timbrarConSello';
        try {
            $response = $this->client->post($url, [
                'form_params'=>['apikey'=>$config->apiKey,'xmlCFDI'=>$request->signedXml,'keyPEM'=>$request->keyPem],
                'connect_timeout'=>$config->connectTimeout,'timeout'=>$config->requestTimeout,
                'verify'=>true,'http_errors'=>false,
                'headers'=>['Accept'=>'application/json','Content-Type'=>'application/x-www-form-urlencoded'],
            ]);
            return (new TimbradorXpressResponseParser())->parse((string)$response->getBody(), (int)$response->getStatusCode());
        } catch (\Throwable $e) {
            log_message('warning','PAC transport failure for document {document}: {type}',['document'=>$request->fiscalDocumentId,'type'=>get_class($e)]);
            $timeout = str_contains(strtolower($e->getMessage()), 'timed out') || str_contains(strtolower($e->getMessage()), 'timeout');
            return new PacResponse(null,'No fue posible confirmar la respuesta del PAC.',null,0,['exception_type'=>get_class($e)],true,$timeout);
        }
    }
    public function getStampStatus(array $query): PacResponse
    {
        $config=$this->configuration??config('TimbradorXpress');foreach(['environment','uuid','rfcEmisor','rfcReceptor','total'] as $key)if(empty($query[$key]))throw new RuntimeException("Falta {$key} para consultar el estado SAT.");
        if($query['environment']!==$config->environment||!$config->isConfigured())throw new RuntimeException('PAC no configurado para el ambiente.');
        $url=$config->baseUrl.'consultarEstadoSAT';
        try{
            $response=$this->client->post($url,['form_params'=>['apikey'=>$config->apiKey,'uuid'=>$query['uuid'],'rfcEmisor'=>$query['rfcEmisor'],'rfcReceptor'=>$query['rfcReceptor'],'total'=>$query['total']],'connect_timeout'=>$config->connectTimeout,'timeout'=>$config->requestTimeout,'verify'=>true,'http_errors'=>false,'headers'=>['Accept'=>'application/json','Content-Type'=>'application/x-www-form-urlencoded']]);
            return (new TimbradorXpressResponseParser())->parse((string)$response->getBody(),(int)$response->getStatusCode());
        }catch(\Throwable $e){return new PacResponse(null,'No fue posible consultar el estado SAT.',null,0,['exception_type'=>get_class($e)],true,false);}
    }
}
