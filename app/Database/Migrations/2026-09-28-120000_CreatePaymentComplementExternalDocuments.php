<?php
namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreatePaymentComplementExternalDocuments extends Migration
{
    public function up()
    {
        $id=['type'=>'INT','unsigned'=>true];
        $money=['type'=>'DECIMAL','constraint'=>'18,6'];
        $date=['type'=>'DATETIME'];
        if (!$this->db->tableExists('payment_complement_external_documents')) {
            $this->forge->addField([
                'id'=>$id+['auto_increment'=>true], 'payment_complement_id'=>$id, 'payment_complement_payment_id'=>$id,
                'uuid'=>['type'=>'CHAR','constraint'=>36], 'series'=>['type'=>'VARCHAR','constraint'=>25,'default'=>''],
                'folio'=>['type'=>'VARCHAR','constraint'=>40,'default'=>''], 'currency_code'=>['type'=>'CHAR','constraint'=>3],
                'exchange_rate'=>['type'=>'DECIMAL','constraint'=>'28,10'], 'payment_method_code'=>['type'=>'VARCHAR','constraint'=>3],
                'tax_object_code'=>['type'=>'CHAR','constraint'=>2], 'installment_number'=>$id,
                'previous_balance'=>$money, 'paid_amount'=>$money, 'remaining_balance'=>$money,
                'created_by'=>['type'=>'INT','null'=>true], 'created_at'=>$date, 'updated_at'=>$date,
                'deleted'=>['type'=>'TINYINT','constraint'=>1,'default'=>0]
            ]);
            $this->forge->addKey('id',true);
            $this->forge->addKey(['payment_complement_id','deleted']);
            $this->forge->addKey(['payment_complement_payment_id','deleted']);
            $this->forge->addKey('uuid');
            $this->forge->addForeignKey('payment_complement_id','payment_complements','id','RESTRICT','RESTRICT','fk_pc_ext_complement');
            $this->forge->addForeignKey('payment_complement_payment_id','payment_complement_payments','id','RESTRICT','RESTRICT','fk_pc_ext_payment');
            $this->forge->createTable('payment_complement_external_documents');
        }
        if (!$this->db->tableExists('payment_complement_external_taxes')) {
            $this->forge->addField([
                'id'=>$id+['auto_increment'=>true], 'external_document_id'=>$id,
                'tax_type'=>['type'=>'VARCHAR','constraint'=>15], 'base'=>$money,
                'tax_code'=>['type'=>'CHAR','constraint'=>3], 'factor_type'=>['type'=>'VARCHAR','constraint'=>10],
                'rate_or_quota'=>$money+['null'=>true], 'amount'=>$money+['null'=>true]
            ]);
            $this->forge->addKey('id',true);
            $this->forge->addKey('external_document_id');
            $this->forge->addForeignKey('external_document_id','payment_complement_external_documents','id','RESTRICT','RESTRICT','fk_pc_ext_tax');
            $this->forge->createTable('payment_complement_external_taxes');
        }
        // Payment CFDIs can refer exclusively to external UUIDs; no synthetic sale is needed.
        $this->forge->modifyColumn('fiscal_documents',['invoice_id'=>['type'=>'INT','unsigned'=>true,'null'=>true]]);
    }

    public function down()
    {
        // Fiscal records and nullable source references must survive rollback.
    }
}
