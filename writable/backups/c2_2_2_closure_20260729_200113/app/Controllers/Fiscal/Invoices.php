<?php
declare(strict_types=1);

namespace App\Controllers\Fiscal;

use App\Controllers\Security_Controller;
use App\Services\Fiscal\Cancellation\FiscalCancellationService;
use App\Services\Fiscal\FiscalDecimalCalculator;
use App\Services\Fiscal\FiscalInvoiceCenterQueryService;
use App\Services\Fiscal\Pac\PacPdfArtifactService;
use App\Services\Fiscal\Pdf\FiscalPdfTemplateResolver;
use CodeIgniter\Exceptions\PageNotFoundException;
use Throwable;

final class Invoices extends Security_Controller
{
    public function index(){ $this->guard('fiscal_invoices_view');return$this->template->rander('fiscal/invoices/index',['can_cancel'=>$this->allowed('fiscal_invoices_cancel')]);}
    public function listData():void
    {
        $this->guard('fiscal_invoices_view');$rows=[];
        foreach((new FiscalInvoiceCenterQueryService())->search(['search'=>$this->request->getPost('search'),'status'=>$this->request->getPost('status'),'pdf'=>$this->request->getPost('pdf'),'invoice_id'=>$this->request->getPost('invoice_id'),'rfc'=>$this->request->getPost('rfc'),'uuid'=>$this->request->getPost('uuid'),'date_from'=>$this->request->getPost('date_from'),'date_to'=>$this->request->getPost('date_to')])as$r){
            if(!$this->can_view_invoices((int)$r->invoice_id))continue;
            $actions=anchor(get_uri('fiscal/invoices/drafts/'.$r->id.'/view'),'<i data-feather="eye" class="icon-16"></i>',['class'=>'fiscal-draft-view','title'=>app_lang('view')]);
            if($r->xml_available)$actions.=' '.anchor(get_uri('fiscal/stamping/xml/download/'.$r->id),'<i data-feather="file-text" class="icon-16"></i>',['title'=>app_lang('download_stamped_xml')]);
            if($r->pdf_available){$actions.=' '.anchor(get_uri('fiscal/documents/'.$r->id.'/pdf/preview'),'<i data-feather="eye" class="icon-16"></i>',['title'=>app_lang('view_pdf'),'target'=>'_blank']);$actions.=' '.anchor(get_uri('fiscal/documents/'.$r->id.'/pdf/download'),'<i data-feather="download" class="icon-16"></i>',['title'=>app_lang('download_pdf')]);}
            if($this->allowed('fiscal_pdf_generate')&&$r->uuid&&$r->xml_available&&!$r->pdf_available&&in_array($r->visible_status,['stamped_pdf_pending','stamped_pdf_error'],true)){try{$template=(new FiscalPdfTemplateResolver())->resolve((int)$r->issuer_profile_id,(string)config('FiscalPdfProvider')->provider,$this->documentTypeCode((string)$r->document_type))->templateCode;}catch(Throwable){$template='-';}$actions.=' '.js_anchor('Generar PDF del PAC',['class'=>'fiscal-generate-pdf text-warning','data-document-id'=>$r->id,'data-series'=>$r->series,'data-folio'=>$r->folio,'data-uuid'=>$r->uuid,'data-template'=>$template,'title'=>'Generar PDF del PAC']);}
            if($this->allowed('fiscal_invoices_cancel')&&$r->visible_status==='stamped')$actions.=' '.modal_anchor(get_uri('fiscal/invoices/cancel/form'),'<i data-feather="x-circle" class="icon-16"></i>',['data-post-document_id'=>$r->id,'title'=>app_lang('cancel_fiscal_invoice')]);
            if($this->allowed('fiscal_invoices_view_cancellation')&&$r->cancellation_request_id&&$r->visible_status==='cancelled')$actions.=' '.anchor(get_uri('fiscal/invoices/cancellation/ack/'.$r->cancellation_request_id),'<i data-feather="file-text" class="icon-16"></i>',['title'=>app_lang('fiscal_cancellation_ack')]);
            $tax=(new FiscalDecimalCalculator())->sub((string)$r->transferred_tax_total,(string)$r->withheld_tax_total,6);
            $rows[]=[esc(trim($r->series.' '.$r->folio)),esc($r->receiver_name),esc($r->receiver_rfc),anchor(get_uri('invoices/view/'.$r->invoice_id),'#'.$r->invoice_id),esc($r->issue_date),to_currency($r->subtotal),to_currency($tax),to_currency($r->total),esc($r->uuid?:'-'),app_lang('fiscal_visible_status_'.$r->visible_status),esc($r->pdf_status?:'-'),esc($r->stamp_date?:'-'),esc($r->cancelled_at?:'-'),$actions];
        }echo json_encode(['data'=>$rows]);
    }
    public function cancelForm()
    {
        $this->guard('fiscal_invoices_cancel');$id=(int)$this->request->getPost('document_id');$db=db_connect();$doc=$db->table('fiscal_documents')->where('id',$id)->get(1)->getRow();$stamp=$db->table('fiscal_document_stamps')->where('fiscal_document_id',$id)->get(1)->getRow();$receiver=$db->table('fiscal_document_receivers')->where('fiscal_document_id',$id)->get(1)->getRow();if(!$doc||!$stamp||!$this->can_view_invoices((int)$doc->invoice_id))throw PageNotFoundException::forPageNotFound();return$this->template->view('fiscal/invoices/cancel_form',['document'=>$doc,'stamp'=>$stamp,'receiver'=>$receiver]);
    }
    public function cancel():void
    {
        $this->guard('fiscal_invoices_cancel');try{$id=(int)$this->request->getPost('document_id');$doc=db_connect()->table('fiscal_documents')->where('id',$id)->get(1)->getRow();if(!$doc||!$this->can_view_invoices((int)$doc->invoice_id))throw PageNotFoundException::forPageNotFound();$r=(new FiscalCancellationService())->cancel($id,(string)$this->request->getPost('cancellation_reason'),$this->request->getPost('replacement_uuid')?:null,(int)$this->login_user->id,true);echo json_encode($r+['csrf'=>['name'=>csrf_token(),'hash'=>csrf_hash()]]);}catch(Throwable$e){log_message('warning','Fiscal cancellation blocked: {type}',['type'=>get_class($e)]);echo json_encode(['success'=>false,'status'=>'blocked','message'=>'No fue posible iniciar la cancelación fiscal.','csrf'=>['name'=>csrf_token(),'hash'=>csrf_hash()]]);}
    }
    public function ack($requestId=0)
    {
        $this->guard('fiscal_invoices_view_cancellation');$db=db_connect();$request=$db->table('fiscal_cancellation_requests c')->select('c.id,d.invoice_id')->join('fiscal_documents d','d.id=c.fiscal_document_id')->where('c.id',(int)$requestId)->get(1)->getRow();if(!$request||!$this->can_view_invoices((int)$request->invoice_id))throw PageNotFoundException::forPageNotFound();$row=$db->table('fiscal_cancellation_artifacts')->where(['fiscal_cancellation_request_id'=>(int)$requestId,'artifact_type'=>'cancellation_ack'])->get(1)->getRow();if(!$row)throw PageNotFoundException::forPageNotFound();$bytes=base64_decode((string)$row->content_base64,true);if($bytes===false||!hash_equals((string)$row->decoded_sha256,hash('sha256',$bytes)))throw PageNotFoundException::forPageNotFound();return$this->response->setHeader('Content-Type','application/xml; charset=UTF-8')->setHeader('Content-Disposition','attachment; filename="acuse-cancelacion.xml"')->setHeader('Cache-Control','private, no-store')->setBody($bytes);
    }
    private function allowed(string$p):bool{if($this->login_user->is_admin)return true;$all=is_array($this->login_user->permissions)?$this->login_user->permissions:(@unserialize((string)$this->login_user->permissions)?:[]);return(bool)get_array_value($all,$p);}
    private function documentTypeCode(string$type):string{return match(strtolower($type)){'income','i'=>'I','expense','e'=>'E','payment','p'=>'P','transfer','t'=>'T','payroll','n'=>'N',default=>strtoupper(substr($type,0,1))};}
    private function guard(string$p):void{if(!$this->allowed($p))app_redirect('forbidden');}
}
