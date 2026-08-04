<?php
declare(strict_types=1);
namespace App\Services\Fiscal;
use RuntimeException;
final class FiscalDraftSnapshotService
{
 public function __construct(private mixed$db=null){$this->db??=db_connect();}
 public function getCompleteFiscalSnapshot(int$id):array{
  $draft=$this->db->table('fiscal_drafts')->where('id',$id)->get(1)->getRowArray();if(!$draft)throw new RuntimeException('FISCAL_DRAFT_NOT_FOUND');
  if((int)($draft['snapshot_version']??1)<2||(int)($draft['requires_snapshot_refresh']??0)===1)throw new RuntimeException('FISCAL_DRAFT_SNAPSHOT_INCOMPLETE');
  $payload=json_decode((string)$draft['fiscal_payload'],true)?:[];$items=$this->db->table('fiscal_draft_items')->where('fiscal_draft_id',$id)->orderBy('id')->get()->getResultArray();if(!$items||empty($payload['issuer_snapshot'])||empty($payload['receiver_snapshot']))throw new RuntimeException('FISCAL_DRAFT_SNAPSHOT_INCOMPLETE');
  $trans=$with='0.000000';foreach($items as&$item){$item['snapshot']=json_decode((string)$item['fiscal_snapshot'],true)?:[];$item['taxes']=$this->db->table('fiscal_draft_item_taxes')->where('fiscal_draft_item_id',$item['id'])->orderBy('calculation_order')->get()->getResultArray();$object=(string)($item['snapshot']['object_tax']??$item['snapshot']['tax_object_code']??'');if((int)($item['snapshot']['snapshot_version']??0)<2||($object!=='01'&&!$item['taxes']))throw new RuntimeException('FISCAL_DRAFT_SNAPSHOT_INCOMPLETE');foreach($item['taxes']as$t){if($t['tax_type']==='withholding')$with=FiscalDecimal::add($with,(string)$t['tax_amount']);else$trans=FiscalDecimal::add($trans,(string)$t['tax_amount']);}}
  $alloc=$this->db->table('fiscal_draft_sales')->where('fiscal_draft_id',$id)->get()->getResultArray();$flat=[];foreach($items as$i)$flat=array_merge($flat,$i['taxes']);return['draft'=>$draft,'items'=>$items,'item_taxes'=>$flat,'totals'=>['subtotal'=>$draft['subtotal'],'discount'=>$draft['discount'],'transferred'=>$trans,'withheld'=>$with,'total'=>$draft['total']],'issuer_snapshot'=>$payload['issuer_snapshot'],'receiver_snapshot'=>$payload['receiver_snapshot'],'series_snapshot'=>$payload['series_snapshot']??[],'allocations'=>$alloc];
 }
}
