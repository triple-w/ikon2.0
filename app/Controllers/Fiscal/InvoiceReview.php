<?php
namespace App\Controllers\Fiscal;
use App\Controllers\Security_Controller;
use App\Services\Fiscal\InvoiceFiscalReviewService;
class InvoiceReview extends Security_Controller { private function guard(int$invoiceId):void{$permissions=$this->login_user->permissions;if(!is_array($permissions))$permissions=@unserialize((string)$permissions)?:[];$hasFiscalAccess=$this->login_user->is_admin||(bool)get_array_value($permissions,'fiscal_items_view');if(!$hasFiscalAccess||!$this->can_view_invoices($invoiceId))app_redirect('forbidden');} public function show($invoiceId=0){validate_numeric_value($invoiceId);$this->guard((int)$invoiceId);return$this->template->view('fiscal/invoices/review',['review'=>(new InvoiceFiscalReviewService())->review((int)$invoiceId)]);} }
