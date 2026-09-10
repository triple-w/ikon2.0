<?php
declare(strict_types=1);

// No framework boot, .env, database or network. Only BaseConfig is substituted;
// the PAC configuration, factory, adapter, parser and persistence methods are real.
namespace CodeIgniter\Config { class BaseConfig {} }
namespace {
    define('WRITEPATH', sys_get_temp_dir().DIRECTORY_SEPARATOR);
    define('ENVIRONMENT', 'testing');
    spl_autoload_register(static function(string $class): void {
        $relative = str_starts_with($class,'App\\') ? substr($class,4) : $class;
        $file = dirname(__DIR__,2).'/app/'.str_replace('\\','/',$relative).'.php';
        if (is_file($file)) require $file;
    });
    function config(string $name): object { return $GLOBALS['config'][$name]; }
    function service(string $name): never { throw new LogicException('Unmocked service forbidden: '.$name); }
    function log_message(string $level,string $message,array $context=[]): void {}
    function get_current_utc_time(): string { return gmdate('Y-m-d H:i:s'); }

    use Config\Fiscal;
    use Config\TimbradorXpress;
    use App\Domain\Fiscal\Pac\StampRequest;
    use App\Domain\Fiscal\Pac\PacResponse;
    use App\Services\Fiscal\Pac\FiscalPacAdapterFactory;
    use App\Services\Fiscal\Pac\TimbradorXpressRestAdapter;
    use App\Services\Fiscal\Pac\FiscalStampingService;

    final class MockHttp {
        public array $calls=[];
        public bool $timeout=false;
        public function post(string $url,array $options): object {
            $this->calls[]=[$url,$options];
            if ($this->timeout) throw new RuntimeException('Mock timeout');
            return new class {
                public function getBody(): string { return '{"code":"TEST_REJECTED","message":"Synthetic response; no CFDI stamped","data":null}'; }
                public function getStatusCode(): int { return 422; }
                public function getHeaderLine(string $name): string { return 'application/json'; }
            };
        }
    }
    $pass=0;$fail=0;
    function check(bool $condition,string $message): void {
        global $pass,$fail;
        echo ($condition?'[PASS] ':'[FAIL] ').$message.PHP_EOL;
        $condition?$pass++:$fail++;
    }
    function settings(string $environment): array {
        $f=(new ReflectionClass(Fiscal::class))->newInstanceWithoutConstructor();
        $f->enabled=true;$f->runtimeMode='integration';$f->pacAdapter='timbradorxpress';
        $f->environment=$environment;$f->allowRealPac=true;$f->stampingEnabled=true;$f->previewMode=false;
        $p=(new ReflectionClass(TimbradorXpress::class))->newInstanceWithoutConstructor();
        $p->environment=$environment==='production'?'production':'sandbox';
        $p->baseUrl=$environment==='production'?TimbradorXpress::PRODUCTION_URL:TimbradorXpress::SANDBOX_URL;
        $p->productionEnabled=$environment==='production';$p->apiKey='synthetic-'.$environment.'-key';
        $p->connectTimeout=10;$p->requestTimeout=60;
        $GLOBALS['config']=['Fiscal'=>$f,'TimbradorXpress'=>$p];
        return [$f,$p];
    }
    function request(string $environment,string $provider='timbradorxpress',?string $key='-----BEGIN PRIVATE KEY----- synthetic test only'): StampRequest {
        $xml='<synthetic-test/>';
        return new StampRequest(123,$xml,hash('sha256',$xml),$provider,$environment,'test-only',$key);
    }
    function blocked(callable $action): bool {
        try { $action(); return false; } catch (RuntimeException) { return true; }
    }
    function scenario(string $label,string $environment,callable $change,bool $allowed): void {
        [$f,$p]=settings($environment);$change($f,$p);$http=new MockHttp();
        $factoryBlocked=blocked(fn()=>(new FiscalPacAdapterFactory($f,$p))->create());
        check($factoryBlocked===!$allowed,$label.' factory');
        $adapter=new TimbradorXpressRestAdapter($p,$http,$f);
        $response=null;
        $adapterBlocked=blocked(function()use($adapter,$p,&$response){$response=$adapter->stamp(request($p->environment));});
        check($adapterBlocked===!$allowed && count($http->calls)===($allowed?1:0),$label.' adapter / HTTP boundary');
        if ($allowed) {
            check($http->calls[0][0]===$p->baseUrl.'timbrarConSello'
                && $http->calls[0][1]['form_params']['apikey']===$p->apiKey
                && $http->calls[0][1]['verify']===true,$label.' exact endpoint, credential and TLS');
            check($response->httpStatus===422 && $response->code==='TEST_REJECTED'
                && $response->metadata['request_sent']===true && !empty($response->metadata['sent_at']),
                $label.' HTTP response and sent evidence');
        }
    }
    $none=static function(Fiscal $f,TimbradorXpress $p):void {};
    scenario('1 development + sandbox','development',$none,true);
    scenario('2 production + production','production',$none,true);
    scenario('3 production + sandbox','production',static function($f,$p){$p->environment='sandbox';$p->baseUrl=TimbradorXpress::SANDBOX_URL;$p->productionEnabled=false;},false);
    scenario('4 development + production','development',static function($f,$p){$p->environment='production';$p->baseUrl=TimbradorXpress::PRODUCTION_URL;$p->productionEnabled=true;},false);
    scenario('5 production disabled','production',static function($f,$p){$p->productionEnabled=false;},false);
    scenario('6 production sandbox URL','production',static function($f,$p){$p->baseUrl=TimbradorXpress::SANDBOX_URL;},false);
    scenario('7 missing production key','production',static function($f,$p){$p->apiKey='';},false);
    scenario('8 preview enabled','production',static function($f,$p){$f->previewMode=true;},false);
    scenario('9 stamping disabled','production',static function($f,$p){$f->stampingEnabled=false;},false);
    foreach(['allowRealPac'=>false,'enabled'=>false,'runtimeMode'=>'production','pacAdapter'=>'invalid','environment'=>'local'] as $field=>$value) {
        scenario('Master guard '.$field,'production',static function($f,$p)use($field,$value){$f->{$field}=$value;},false);
    }
    scenario('Automated test mode','production',static function($f,$p){$f->runtimeMode='automated_test';},false);
    scenario('Whitespace key','production',static function($f,$p){$p->apiKey='   ';},false);
    scenario('Unapproved production URL','production',static function($f,$p){$p->baseUrl=TimbradorXpress::PRODUCTION_URL.'other/';},false);
    scenario('Sandbox production flag','development',static function($f,$p){$p->productionEnabled=true;},false);
    scenario('Sandbox missing key','development',static function($f,$p){$p->apiKey='';},false);
    scenario('Sandbox production URL','development',static function($f,$p){$p->baseUrl=TimbradorXpress::PRODUCTION_URL;},false);

    // Case 10: use the actual factory product and replace only its HTTP client.
    [$f,$p]=settings('production');$http=new MockHttp();
    $adapter=(new FiscalPacAdapterFactory($f,$p))->create();
    (new ReflectionProperty($adapter,'client'))->setValue($adapter,$http);
    $response=$adapter->stamp(request('production'));
    check(count($http->calls)===1 && $http->calls[0][0]===TimbradorXpress::PRODUCTION_URL.'timbrarConSello',
        '10 production factory adapter reaches mocked HTTP');
    $http->calls=[];$f->allowRealPac=false;
    check(blocked(fn()=>$adapter->stamp(request('production'))) && $http->calls===[],
        'Adapter rechecks master guards after factory creation');
    $f->allowRealPac=true;
    check(blocked(fn()=>$adapter->stamp(request('sandbox'))) && $http->calls===[],'Request environment mismatch sends nothing');
    check(blocked(fn()=>$adapter->stamp(request('production','fake'))) && $http->calls===[],'Request provider mismatch sends nothing');
    check(blocked(fn()=>$adapter->stamp(request('production','timbradorxpress',null))) && $http->calls===[],'CSD guard preserved');
    $large=str_repeat('x',2097153);
    check(blocked(fn()=>$adapter->stamp(new StampRequest(123,$large,hash('sha256',$large),'timbradorxpress','test','-----BEGIN PRIVATE KEY-----'))) && $http->calls===[],'XML size guard preserved');
    check(blocked(fn()=>$p->assertSandbox()),'First sandbox guard still blocks production');
    [$sandboxFiscal,$sandboxProvider]=settings('development');
    check(!blocked(fn()=>$sandboxProvider->assertSandbox()),'First sandbox guard allows safe sandbox');

    [$f,$p]=settings('production');$http=new MockHttp();$http->timeout=true;
    $responseTimeout=(new TimbradorXpressRestAdapter($p,$http,$f))->stamp(request('production'));
    check(count($http->calls)===1 && $responseTimeout->transportError && $responseTimeout->timeout
        && ($responseTimeout->metadata['request_sent']??null)!==false,'HTTP timeout remains unknown, never confirmed not sent');

    // Inspect real persistence boundaries using an in-memory write recorder.
    final class MemoryDb {
        public array $rows=['fiscal_stamp_attempts'=>['status'=>'pending','sent_at'=>null]];
        public function table(string $table): object {
            return new class($this,$table) {
                public function __construct(private MemoryDb $db,private string $table) {}
                public function where(mixed ...$args): self { return $this; }
                public function update(array $row): bool { $this->db->rows[$this->table]=array_replace($this->db->rows[$this->table]??[],$row);return true; }
            };
        }
        public function transBegin():void {}
        public function transCommit():void {}
        public function transStart():void {}
        public function transComplete():void {}
        public function transStatus():bool {return true;}
        public function affectedRows():int {return 1;}
    }
    $db=new MemoryDb();$stamping=new FiscalStampingService($db);
    (new ReflectionMethod($stamping,'markSending'))->invoke($stamping,1,123);
    check($db->rows['fiscal_stamp_attempts']['status']==='sending' && $db->rows['fiscal_stamp_attempts']['sent_at']===null,
        'Before HTTP, sending lock does not claim sent_at');
    (new ReflectionMethod($stamping,'persistResponseForensics'))->invoke($stamping,1,$response);
    check($db->rows['fiscal_stamp_attempts']['sent_at']===$response->metadata['sent_at'],
        'After HTTP response, sent_at persists from adapter evidence');
    (new ReflectionMethod($stamping,'finishNotSent'))->invoke($stamping,1,123,'Guard blocked',0);
    check($db->rows['fiscal_stamp_attempts']['status']==='transport_not_sent'
        && $db->rows['fiscal_stamp_attempts']['sent_at']===null
        && $db->rows['fiscal_stamp_attempts']['requires_reconciliation']===0,
        'Pre-transport failure retains transport_not_sent and null sent_at');
    $notSent=new PacResponse(null,'Not sent',null,0,['request_sent'=>false],true);
    (new ReflectionMethod($stamping,'persistResponseForensics'))->invoke($stamping,1,$notSent);
    check($db->rows['fiscal_stamp_attempts']['sent_at']===null,'request_sent=false cannot create sent_at');
    echo PHP_EOL."$pass passed, $fail failed.".PHP_EOL;
    exit($fail?1:0);
}