<?php
namespace App\Models\Fiscal;
use App\Models\Crud_model;
class Fiscal_profiles_model extends Crud_model {
    public function __construct(){ parent::__construct('fiscal_profiles'); }
    public function forClient(int $clientId){ return $this->get_all_where(['client_id'=>$clientId,'profile_type'=>'receiver'],1000000,0,'is_default'); }
    public function setDefault(int $clientId,int $profileId): bool { $this->db->transStart(); $this->db->table($this->table)->where('client_id',$clientId)->update(['is_default'=>0]); $this->db->table($this->table)->where(['id'=>$profileId,'client_id'=>$clientId])->update(['is_default'=>1]); $this->db->transComplete(); return $this->db->transStatus(); }
}
