<?php
declare(strict_types=1);

// Real lifecycle, preflight, materializer and draft stamping orchestration.
// Snapshot/availability/crypto/PAC dependencies and SQL storage are isolated doubles.
namespace App\Services\Fiscal {
    final class FiscalDraftSnapshotService {
        public function __construct(private mixed $db) {}
        public function getCompleteFiscalSnapshot(int $id):array {
            return ['draft'=>$this->db->table('fiscal_drafts')->where('id',$id)->get()->getRowArray()]+$this->db->snapshot;
        }
    }
    final class FiscalSaleAllocationService {
        public function __construct(mixed $db) {}
        public function validateDraftAvailability(int $sale,int $draft,string $total):void {}
        public function validateDraftDocumentConsistency(int $draft,int $document):array { return []; }
    }
    final class FiscalIssueDatePolicy { public function validate(string $date):void {} }
}
namespace App\Services\Fiscal\Cfdi40 {
    final class CfdiPreXmlArtifactService {
        public function __construct(private mixed $db) {}
        public function generate(int $id,int $user,bool $authorized):array {
            $this->db->table('fiscal_document_artifacts')->insert(['fiscal_document_id'=>$id,'artifact_type'=>'pre_xml','validation_status'=>'valid','superseded_at'=>null]);
            return ['artifact'=>(object)['id'=>$this->db->insertID()]];
        }
    }
    final class CfdiSigningService {
        public function __construct(private mixed $db) {}
        public function sign(int $id,int $artifact,int $certificate,int $user,bool $authorized):void {
            $this->db->table('fiscal_document_artifacts')->insert(['fiscal_document_id'=>$id,'artifact_type'=>'signed_xml','validation_status'=>'valid','superseded_at'=>null]);
            $this->db->table('fiscal_document_signatures')->insert(['fiscal_document_id'=>$id,'signature_verified'=>1,'xsd_status'=>'valid','signed_xml_artifact_id'=>$this->db->insertID()]);
        }
    }
}
namespace App\Services\Fiscal\Pac {
    final class FiscalStampingService {
        public string $outcome='local_failure';
        public int $calls=0;
        public function __construct(private mixed $db) {}
        public function stamp(int $id,int $user,bool $authorized):object {
            $this->calls++;
            $unknown=$this->outcome==='unknown';
            $local=$this->outcome==='local_failure';
            $this->db->table('fiscal_stamp_attempts')->insert([
                'fiscal_document_id'=>$id,'status'=>$local?'transport_not_sent':($unknown?'timeout_unknown':'provider_rejected'),
                'response_structure'=>json_encode(['request_sent'=>!$local]),
                'sent_at'=>$local?null:'2026-09-10 12:00:00','http_status'=>$local||$unknown?null:422,
                'requires_reconciliation'=>$unknown?1:0,'uuid'=>null,
                'error_category'=>$local?'transport_not_sent':null,
            ]);
            $this->db->table('fiscal_documents')->where('id',$id)->update(['status'=>$unknown?'stamp_status_unknown':'stamping_error']);
            if($local) throw new \RuntimeException('Synthetic local guard: HTTP not sent');
            return new class($unknown) {
                public bool $xmlAvailable=false;
                public ?string $uuid=null;
                public function __construct(public bool $requiresReconciliation) {}
                public function toArray():array {return ['requiresReconciliation'=>$this->requiresReconciliation,'uuid'=>null,'xmlAvailable'=>false];}
            };
        }
    }
}
namespace {
    use App\Services\Fiscal\FiscalDraftStampingService;
    use App\Services\Fiscal\FiscalPreparedDocumentLifecycleService as Lifecycle;
    use App\Services\Fiscal\FiscalDocumentFromDraftSnapshotService;
    use App\Services\Fiscal\FiscalDraftStampingPreflightService;
    use App\Services\Fiscal\Pac\FiscalStampingService as MockPac;

    spl_autoload_register(static function(string $class):void {
        if(str_starts_with($class,'App\\')) {
            $file=dirname(__DIR__,2).'/app/'.str_replace('\\','/',substr($class,4)).'.php';
            if(is_file($file)) require $file;
        }
    });
    function config(string $name):object {return (object)['runtimeMode'=>'automated_test'];}
    function get_current_utc_time():string {return '2026-09-10 12:00:00';}
    function log_message(string $level,string $message,array $context=[]):void {}

    final class Result {
        public function __construct(private array $rows) {}
        public function getRow():?object {return isset($this->rows[0])?(object)$this->rows[0]:null;}
        public function getRowArray():?array {return $this->rows[0]??null;}
        public function getResultArray():array {return $this->rows;}
    }
    final class MemoryDb {
        public array $tables=[],$snapshot=[],$locks=[];
        public bool $failAudit=false;
        private array $transactions=[];
        private int $last=0;
        public function table(string $table):Builder {return new Builder($this,$table);}
        public function prefixTable(string $table):string {return $table;}
        public function query(string $sql,array $params=[]):Result {
            $this->locks[]=$sql;
            if(str_contains($sql,'GET_LOCK')) return new Result([['acquired'=>1]]);
            if(str_contains($sql,'RELEASE_LOCK')) return new Result([['released'=>1]]);
            if(!preg_match('/FROM (\w+) WHERE (\w+)=\?/',$sql,$m)) throw new \LogicException('Unhandled SQL: '.$sql);
            $builder=$this->table($m[1])->where($m[2],$params[0]);
            if(str_contains($sql,'issuer_profile_id=?')) $builder->where('issuer_profile_id',$params[1])->where('is_active',1)->where('deleted',0);
            if(str_contains($sql,'ORDER BY id DESC')) $builder->orderBy('id','DESC');
            return $builder->get();
        }
        public function insert(string $table,array $row):bool {
            if($table==='fiscal_draft_audit'&&$this->failAudit&&($row['event']??'')==='draft_prepared_document_invalidated') throw new \RuntimeException('Synthetic audit failure');
            if($table==='fiscal_documents'&&isset($row['source_draft_id'])) {
                foreach($this->tables[$table]??[] as $existing) if(($existing['source_draft_id']??null)===$row['source_draft_id']) throw new \RuntimeException('Unique source_draft_id violated');
            }
            $row['id']??=count($this->tables[$table]??[])+1;$this->last=$row['id'];
            $this->tables[$table][$row['id']]=$row;return true;
        }
        public function insertID():int {return $this->last;}
        public function transBegin():void {$this->transactions[]=$this->tables;}
        public function transCommit():void {array_pop($this->transactions);}
        public function transRollback():void {$this->tables=array_pop($this->transactions);}
        public function transStatus():bool {return true;}
    }
    final class Builder {
        private array $groups=[[]];
        private ?array $order=null;
        public function __construct(private MemoryDb $db,private string $table) {}
        public function select(string $fields):self {return $this;}
        private function add(callable $predicate,bool $or=false):self {$this->groups[count($this->groups)-1][]=[$or,$predicate];return $this;}
        private static function evaluate(array $terms,array $row):bool {
            $value=null;foreach($terms as [$or,$predicate]) {$test=$predicate($row);$value=$value===null?$test:($or?($value||$test):($value&&$test));}return $value??true;
        }
        public function where(string|array $field,mixed $value=null):self {
            if(is_array($field)){foreach($field as $key=>$entry)$this->where($key,$entry);return $this;}
            if(preg_match('/^(\w+) (<=|>=)$/',$field,$m)) return $this->add(fn($r)=>$m[2]==='<='?($r[$m[1]]??'')<=$value:($r[$m[1]]??'')>=$value);
            return $this->add(fn($r)=>($r[$field]??null)==$value);
        }
        public function whereIn(string $field,array $values):self {return $this->add(fn($r)=>in_array($r[$field]??null,$values,true));}
        public function orWhere(string $field,mixed $value):self {return $this->add(fn($r)=>($r[$field]??null)==$value,true);}
        public function groupStart():self {$this->groups[]=[];return $this;}
        public function groupEnd():self {$terms=array_pop($this->groups);return $this->add(fn($r)=>self::evaluate($terms,$r));}
        public function orderBy(string $field,string $direction='ASC'):self {$this->order=[$field,$direction];return $this;}
        public function get(?int $limit=null):Result {
            $rows=array_values(array_filter($this->db->tables[$this->table]??[],fn($r)=>self::evaluate($this->groups[0],$r)));
            if($this->order){[$field,$direction]=$this->order;usort($rows,fn($a,$b)=>($a[$field]<=>$b[$field])*($direction==='DESC'?-1:1));}
            return new Result($limit?array_slice($rows,0,$limit):$rows);
        }
        public function countAllResults():int {return count($this->get()->getResultArray());}
        public function insert(array $row):bool {return $this->db->insert($this->table,$row);}
        public function update(array $values):bool {
            foreach($this->db->tables[$this->table]??[] as $id=>$row) if(self::evaluate($this->groups[0],$row)) $this->db->tables[$this->table][$id]=array_replace($row,$values);
            return true;
        }
    }
    $pass=0;$fail=0;
    function check(bool $condition,string $message):void {
        global $pass,$fail;echo($condition?'[PASS] ':'[FAIL] ').$message.PHP_EOL;$condition?$pass++:$fail++;
    }
    function fixture():MemoryDb {
        $db=new MemoryDb();
        $db->table('fiscal_drafts')->insert([
            'id'=>1,'fiscal_document_id'=>null,'status'=>'ready','environment'=>'production','issuer_id'=>2,'receiver_profile_id'=>3,
            'fiscal_series_id'=>1,'issue_date'=>'2026-09-10 11:00:00','expedition_postal_code'=>'01000','currency_code'=>'MXN',
            'exchange_rate'=>'1','payment_form_code'=>'03','payment_method_code'=>'PUE','cfdi_use_code'=>'G03',
            'receiver_tax_regime_code'=>'616','receiver_postal_code'=>'01000','snapshot_version'=>2,
            'requires_snapshot_refresh'=>0,'snapshot_completed_at'=>'2026-09-10 11:00:00',
        ]);
        $db->table('fiscal_series')->insert(['id'=>1,'issuer_profile_id'=>2,'is_active'=>1,'deleted'=>0,'initial_folio'=>1,'current_folio'=>0,'series'=>'TEST']);
        $db->table('invoices')->insert(['id'=>1,'status'=>'not_paid','commercial_status'=>'closed','deleted'=>0]);
        $db->table('fiscal_issuer_certificates')->insert(['id'=>1,'issuer_profile_id'=>2,'status'=>'valid','deleted'=>0,'valid_from'=>'2020-01-01','valid_to'=>'2030-01-01']);
        $db->snapshot=[
            'issuer_snapshot'=>['rfc'=>'AAA010101AAA','legal_name'=>'SYNTHETIC','tax_regime_code'=>'601','fiscal_postal_code'=>'01000'],
            'receiver_snapshot'=>['rfc'=>'XAXX010101000','legal_name'=>'SYNTHETIC'],
            'series_snapshot'=>['id'=>1,'series'=>'TEST'],
            'items'=>[['id'=>1,'sale_item_id'=>1,'product_id'=>1,'quantity'=>'1','subtotal'=>'100','discount'=>'0','total'=>'100',
                'snapshot'=>['object_tax'=>'01','product_service_code'=>'01010101','unit_code'=>'H87','fiscal_description'=>'Synthetic item',
                    'taxable_base'=>'0','transferred_total'=>'0','withheld_total'=>'0'],'taxes'=>[]]],
            'item_taxes'=>[],'totals'=>['subtotal'=>'100','discount'=>'0','transferred'=>'0','withheld'=>'0','total'=>'100'],
            'allocations'=>[['sale_id'=>1,'allocation_status'=>'reserved','allocated_total'=>'100']],
        ];
        return $db;
    }
    try {
        $db=fixture();$pac=new MockPac($db);$flow=new FiscalDraftStampingService($db,stamping:$pac);
        try{$flow->stamp(1,7,true);throw new \LogicException('Expected local failure');}
        catch(\RuntimeException $error){check($error->getMessage()==='Synthetic local guard: HTTP not sent','First attempt fails locally before HTTP');}
        $old=$db->tables['fiscal_drafts'][1]['fiscal_document_id'];
        check(count($db->tables['fiscal_documents'])===1 && $old>0,'Draft materializes its first principal document');
        $artifacts=$db->tables['fiscal_document_artifacts'];$signatures=$db->tables['fiscal_document_signatures'];
        check(count($artifacts)===2 && count($signatures)===1,'Prepared document has pre_xml and signed_xml');
        $attempt=$db->tables['fiscal_stamp_attempts'][1];
        check($attempt['status']==='transport_not_sent' && json_decode($attempt['response_structure'],true)['request_sent']===false,'Durable request_sent=false before retry');
        $pac->outcome='rejected';$result=$flow->stamp(1,7,true);$new=$result['document_id'];
        check($new!==$old && count($db->tables['fiscal_documents'])===2 && $pac->calls===2,'Retry creates exactly one new document and continues to PAC boundary');
        check($db->tables['fiscal_documents'][$old]['status']==='superseded'
            && $db->tables['fiscal_documents'][$old]['source_draft_id']===null
            && $db->tables['fiscal_drafts'][1]['fiscal_document_id']===$new
            && $db->tables['fiscal_documents'][$new]['source_draft_id']===1,'Old principal invalidated; unique new principal linked');
        check(array_intersect_key($db->tables['fiscal_document_artifacts'],$artifacts)===$artifacts
            && array_intersect_key($db->tables['fiscal_document_signatures'],$signatures)===$signatures
            && $db->tables['fiscal_stamp_attempts'][1]===$attempt,'Old XML, signature and failed attempt preserved');
        $audits=array_values(array_filter($db->tables['fiscal_draft_audit'],fn($r)=>$r['event']==='draft_prepared_document_invalidated'));
        $audit=json_decode($audits[0]['summary_json'],true);
        check(count($audits)===1 && $audit['old_document_id']===$old && $audit['reason']==='transport_not_sent' && $audit['attempt_id']===1,'Invalidation explicitly audited with previous document and attempt');
        $again=(new Lifecycle($db))->invalidateIfSnapshotChanged(1,7);
        check($again['action']==='reused' && count($db->tables['fiscal_documents'])===2,'Subsequent lifecycle check does not create another document');
        check((new FiscalDraftStampingPreflightService($db))->inspect(1,true)['allowed'],'New principal passes prepared-document preflight');

        $unknown=fixture();$unknownPac=new MockPac($unknown);$unknownPac->outcome='unknown';
        $unknownFlow=new FiscalDraftStampingService($unknown,stamping:$unknownPac);
        $unknownFlow->stamp(1,7,true);$before=$unknown->tables;
        try{$unknownFlow->stamp(1,7,true);check(false,'Unknown retry must block');}
        catch(\RuntimeException $error){check($error->getMessage()===Lifecycle::RECONCILIATION_REQUIRED,'request_sent=true + unknown explicitly requires reconciliation');}
        check(count($unknown->tables['fiscal_documents'])===1 && $unknownPac->calls===1
            && $unknown->tables['fiscal_drafts']===$before['fiscal_drafts']
            && $unknown->tables['fiscal_documents']===$before['fiscal_documents'],'Unknown retry neither regenerates nor calls PAC');

        $rollback=fixture();$rollbackPac=new MockPac($rollback);$rollbackFlow=new FiscalDraftStampingService($rollback,stamping:$rollbackPac);
        try{$rollbackFlow->stamp(1,7,true);}catch(\RuntimeException){}
        $before=$rollback->tables;$rollback->failAudit=true;
        try{(new Lifecycle($rollback))->invalidateIfSnapshotChanged(1,7);check(false,'Audit failure must block');}
        catch(\RuntimeException){check($rollback->tables===$before,'Audit failure rolls back both links and superseded status');}
        $rollback->failAudit=false;
        $rollback->tables['fiscal_drafts'][1]['fiscal_document_id']=null;
        $recovered=(new Lifecycle($rollback))->invalidateIfSnapshotChanged(1,7);
        check($recovered['action']==='invalidated' && $rollback->tables['fiscal_documents'][1]['source_draft_id']===null,
            'Legacy one-sided detachment is recovered through source_draft_id');
        $new=(new FiscalDocumentFromDraftSnapshotService($rollback))->materialize(1,7);
        check($new===2 && count($rollback->tables['fiscal_documents'])===2,'Legacy case clears unique principal constraint without deleting history');

        $safe=['id'=>2,'status'=>'transport_not_sent','request_sent'=>false,'requires_reconciliation'=>0,'uuid'=>null];
        check(Lifecycle::decision('same','same',false,[$safe])==='invalidate','Confirmed not sent rebuilds even when snapshot is unchanged');
        foreach([
            'request_sent true'=>['request_sent'=>true],
            'request_sent null'=>['request_sent'=>null],
            'timeout unknown'=>['status'=>'timeout_unknown'],
            'unknown'=>['status'=>'unknown'],
            'transport unknown'=>['status'=>'transport_unknown'],
            'pending'=>['status'=>'pending'],
            'sending'=>['status'=>'sending'],
            'reconciliation flag'=>['requires_reconciliation'=>1],
            'UUID'=>['uuid'=>'KNOWN-UUID'],
            'sent_at'=>['sent_at'=>'2026-09-10 12:00:00'],
            'HTTP response'=>['http_status'=>200],
            'response hash'=>['response_hash'=>'HASH'],
            'stored response'=>['contingency_path'=>'stored-response'],
            'response body'=>['response_body_length'=>12],
            'response requires reconciliation'=>['parsing_phase'=>'outer_response_invalid'],
            'contradictory metadata'=>['response_structure'=>'{"request_sent":true}'],
            'malformed metadata'=>['response_structure'=>'{"request_sent":'],
            'PAC data'=>['response_structure'=>'{"request_sent":false,"has_data":true}'],
            'PAC response keys'=>['response_structure'=>'{"request_sent":false,"keys":["code"]}'],
            'PAC provider code'=>['provider_code'=>'200'],
            'PAC response header'=>['response_content_type'=>'application/json'],
        ] as $label=>$override) check(Lifecycle::decision('same','same',false,[array_replace($safe,$override)])==='protected',$label.' prevents regeneration');
        check(Lifecycle::decision('same','changed',true,[$safe])==='protected','Existing stamp prevents regeneration');
        check(Lifecycle::decision('same','same',true,[$safe])!=='invalidate','Existing stamp is never replaced even for unchanged snapshot');
        check(Lifecycle::decision('same','same',false,[$safe,['id'=>1,'status'=>'unknown','request_sent'=>true]])==='protected','Older possible submission cannot be hidden by newer local failure');
        check(Lifecycle::decision('same','same',false,[['status'=>'transport_not_sent']])==='protected','Missing not-sent evidence is not silently treated as false');
        check(Lifecycle::decision('same','same',false,[['status'=>'transport_not_sent','error_category'=>'transport_not_sent']])==='invalidate','Legacy terminal not-sent evidence supported without schema changes');
    }catch(\Throwable $error){check(false,get_class($error).': '.$error->getMessage().' at '.$error->getLine());}
    echo PHP_EOL."$pass passed, $fail failed.".PHP_EOL;exit($fail?1:0);
}