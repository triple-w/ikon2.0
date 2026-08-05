<?php
declare(strict_types=1);
namespace App\Controllers\Fiscal;
use App\Controllers\Security_Controller;
use App\Services\Fiscal\Stamps\FiscalStampAccountService;
final class StampBalance extends Security_Controller{
 public function index(){if(!$this->canView())app_redirect('forbidden');$db=db_connect();$issuer=$db->table('fiscal_profiles')->where(['profile_type'=>'issuer','is_default'=>1,'is_active'=>1])->get(1)->getRow();if(!$issuer)$issuer=$db->table('fiscal_profiles')->where(['profile_type'=>'issuer','is_active'=>1])->orderBy('id','ASC')->get(1)->getRow();$service=new FiscalStampAccountService($db);$balance=$issuer?$service->getBalance((int)$issuer->id):['available'=>0,'reserved'=>0,'status'=>'missing'];$movements=$issuer?$service->recentForIssuer((int)$issuer->id,20):[];return$this->template->rander('fiscal/stamps/balance',compact('balance','movements'));}
 private function canView():bool{if($this->login_user->is_admin)return true;$p=is_array($this->login_user->permissions)?$this->login_user->permissions:(@unserialize((string)$this->login_user->permissions)?:[]);return!empty($p['fiscal.stamps.view_balance']);}
}
