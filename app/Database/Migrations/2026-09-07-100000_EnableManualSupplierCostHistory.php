<?php
declare(strict_types=1);
namespace App\Database\Migrations;
use CodeIgniter\Database\Migration;
final class EnableManualSupplierCostHistory extends Migration
{
 public function up(){ $h='product_supplier_cost_history';if(!$this->db->tableExists($h))return;$t=$this->db->prefixTable($h);$this->db->query("ALTER TABLE {$t} MODIFY client_id INT NULL, MODIFY sale_unit_price DECIMAL(18,6) NULL, MODIFY quantity DECIMAL(18,6) NULL");foreach(['notes'=>['type'=>'TEXT','null'=>true,'after'=>'quoted_at'],'idempotency_key'=>['type'=>'CHAR','constraint'=>64,'null'=>true,'after'=>'economic_hash'],'updated_at'=>['type'=>'DATETIME','null'=>true,'after'=>'created_at']]as$n=>$d)if(!$this->db->fieldExists($n,$h))$this->forge->addColumn($h,[$n=>$d]);$this->db->resetDataCache();if(!isset($this->db->getIndexData($h)['uq_cost_history_manual_idempotency']))$this->db->query("ALTER TABLE {$t} ADD UNIQUE KEY uq_cost_history_manual_idempotency(idempotency_key)"); }
 public function down(){/* Non-destructive: manual history and nullable semantics are preserved. */}
}