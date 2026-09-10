<?php
declare(strict_types=1);

// Isolated unit harness: real inspect() and wallet; no database or PAC connections.
namespace App\Services\Fiscal {
    function config(string $name): object { return (object)['environment'=>$GLOBALS['fallback']]; }
    final class FiscalDraftWorkflowService {}
    final class FiscalDraftStampingPreflightService {}
    final class FiscalDraftStampingService {}
    final class FiscalDraftSnapshotService {
        public function __construct(private mixed $db) {}
        public function getCompleteFiscalSnapshot(int $id): array { return $this->db->snapshot; }
    }
    final class FiscalDraftValidationService {
        public function __construct(mixed $db) {}
        public function validate(array $draft,array $allocations,array $concepts): array { return ['errors'=>[]]; }
    }
}
namespace {
    require dirname(__DIR__,2).'/app/Services/Fiscal/Stamps/FiscalStampAccountService.php';
    require dirname(__DIR__,2).'/app/Services/Fiscal/FiscalInvoiceFlowService.php';
    final class MemoryWalletDb {
        public array $snapshot;
        public array $queries=[];
        public function __construct(public array $accounts) {}
        public function fieldExists(string $field,string $table): bool { return true; }
        public function table(string $table): MemoryWalletQuery {
            if($table!=='fiscal_stamp_accounts') throw new RuntimeException('Unexpected table: '.$table);
            return new MemoryWalletQuery($this);
        }
    }
    final class MemoryWalletQuery {
        private array $filters=[];
        public function __construct(private MemoryWalletDb $db) {}
        public function where(string $field,mixed $value): self { $this->filters[$field]=$value; return $this; }
        public function get(int $limit): self { $this->db->queries[]=$this->filters; return $this; }
        public function getRow(): ?object {
            foreach($this->db->accounts as $account) {
                if(array_intersect_assoc($account,$this->filters)===$this->filters) return (object)$account;
            }
            return null;
        }
    }
    $passed=0;$failed=0;
    function check(bool $condition,string $label): void {
        global $passed,$failed;
        echo ($condition?'[PASS] ':'[FAIL] ').$label.PHP_EOL;
        $condition?$passed++:$failed++;
    }
    function runCase(array $environment,mixed $fallback,array $balances,?string $expectedEnvironment,?string $error,string $label): void {
        $GLOBALS['fallback']=$fallback;
        $accounts=[];
        foreach($balances as $env=>$balance) $accounts[]=['issuer_profile_id'=>2,'environment'=>$env,'available_balance'=>$balance,'reserved_balance'=>0,'status'=>'active'];
        $accounts[]=['issuer_profile_id'=>99,'environment'=>'production','available_balance'=>100,'reserved_balance'=>0];
        $db=new MemoryWalletDb($accounts);
        $db->snapshot=['draft'=>$environment+['issuer_id'=>2,'issue_date'=>'2026-09-10','cfdi_use_code'=>'G03','payment_method_code'=>'PUE','payment_form_code'=>'03'],
            'items'=>[],'allocations'=>[],'totals'=>['subtotal'=>'100','transferred'=>'16','withheld'=>'0','total'=>'116']];
        $flow=new App\Services\Fiscal\FiscalInvoiceFlowService($db,
            new App\Services\Fiscal\FiscalDraftWorkflowService(),
            new App\Services\Fiscal\FiscalDraftStampingPreflightService(),
            new App\Services\Fiscal\FiscalDraftStampingService(),
            new App\Services\Fiscal\Stamps\FiscalStampAccountService($db));
        $result=$flow->inspect(12);
        check($result['ready']===($error===null) && array_column($result['blockers'],'code')===($error===null?[]:[$error]),$label);
        check($db->queries===($expectedEnvironment===null?[]:[['issuer_profile_id'=>2,'environment'=>$expectedEnvironment]]),$label.' - exact account or no query');
        if($error==='STAMP_BALANCE_EMPTY') check($result['blockers'][0]['message']==='No hay timbres disponibles para generar esta factura.',$label.' - exact balance error');
        if($error==='FISCAL_ENVIRONMENT_INVALID') check(str_contains($result['blockers'][0]['message'],'configuración del ambiente fiscal'),$label.' - explicit configuration error');
        if($error===null) check($result['summary']['wallet_available']===$balances[$expectedEnvironment],$label.' - selected balance');
    }
    runCase(['environment'=>'production'],'development',['production'=>50],'production',null,'1 production balance 50');
    runCase(['environment'=>'production'],'development',['production'=>0,'development'=>50],'production','STAMP_BALANCE_EMPTY','2 production cannot use development');
    runCase(['environment'=>'development'],'production',['development'=>50],'development',null,'3 development balance');
    runCase(['environment'=>'development'],'production',['production'=>50],'development','STAMP_BALANCE_EMPTY','4 development cannot use production');
    runCase(['environment'=>'production'],'production',['production'=>0],'production','STAMP_BALANCE_EMPTY','5 production zero balance');
    foreach(['sandbox','invalid','',null] as $environment) {
        runCase(['environment'=>$environment],null,['development'=>50,'production'=>50],null,'FISCAL_ENVIRONMENT_INVALID','6 invalid/null environment '.var_export($environment,true));
    }
    runCase([],null,['development'=>50],null,'FISCAL_ENVIRONMENT_INVALID','6 missing environment and fallback');
    runCase(['environment'=>'sandbox'],'production',['production'=>50],null,'FISCAL_ENVIRONMENT_INVALID','Invalid draft cannot be replaced by valid fallback');
    runCase(['environment'=>null],'production',['production'=>50],'production',null,'Null draft uses production config');
    runCase([],'development',['development'=>50],'development',null,'Missing draft uses development config');
    runCase(['environment'=>' PRODUCTION '],'invalid',['production'=>50],'production',null,'Normalize persisted environment; ignore invalid config');
    echo "$passed passed, $failed failed.".PHP_EOL;
    exit($failed?1:0);
}