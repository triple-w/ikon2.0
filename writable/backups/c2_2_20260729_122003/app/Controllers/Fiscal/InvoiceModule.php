<?php
declare(strict_types=1);

namespace App\Controllers\Fiscal;

use App\Controllers\Security_Controller;
use App\Services\Fiscal\FiscalInvoiceCenterQueryService;
use App\Services\Fiscal\Pdf\FiscalPdfTemplateResolver;
use CodeIgniter\Exceptions\PageNotFoundException;
use Throwable;

final class InvoiceModule extends Security_Controller
{
    public function index()
    {
        $this->guard('fiscal_invoices_view');
        return $this->template->rander('fiscal/invoices/module_index');
    }

    public function show($documentId = 0)
    {
        $this->guard('fiscal_invoice_view');
        $data = (new FiscalInvoiceCenterQueryService())->detail((int) $documentId);
        if (!$data || !$this->canAccess()) {
            throw PageNotFoundException::forPageNotFound();
        }
        return $this->template->rander('fiscal/invoices/show', $data + [
            'permissions' => [
                'xml_download' => $this->allowed('fiscal_xml_download'),
                'pdf_generate' => $this->allowed('fiscal_pdf_generate'),
                'pdf_view' => $this->allowed('fiscal_pdf_view'),
                'pdf_download' => $this->allowed('fiscal_pdf_download'),
                'receipt_view' => $this->allowed('fiscal_cancellation_receipt_view'),
                'advanced_view' => $this->allowed('fiscal.advanced.view'),
            ],
        ]);
    }

    public function listData(): void
    {
        $this->guard('fiscal_invoices_view');
        $filters = [];
        foreach (['search','series','folio','uuid','client','rfc','date_from','date_to','type','status','pdf_status','cancellation_status'] as $key) {
            $filters[$key] = $this->request->getPost($key);
        }
        $data = [];
        foreach ((new FiscalInvoiceCenterQueryService())->search($filters) as $row) {
            if (!$this->canAccess()) continue;
            $data[] = [
                esc($row->series).((int)$row->is_imported_fixture===1?' <span class="badge bg-info">Prueba importada</span>':''),
                esc($row->folio), esc($this->typeLabel((string) $row->document_type)),
                esc($this->dateEs((string)$row->issue_date)), esc($row->receiver_name ?: '-'), esc($row->receiver_rfc ?: '-'),
                to_currency($row->total), esc($this->shortUuid((string)($row->uuid??''))),
                $this->badge('fiscal', (string) $row->visible_status),
                $this->badge('pdf', (string) ($row->pdf_status ?: 'pending'))
                    .($row->pdf_available ? '<br><small>'.esc($this->pdfArtifactLabel((string) ($row->pdf_provider ?? ''))).'</small>' : ''),
                $this->badge('cancellation', (string) $row->cancellation_status),
                $this->actions($row),
            ];
        }
        echo json_encode(['data' => $data], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    }

    private function actions(object $row): string
    {
        $items = [];
        if ($this->allowed('fiscal_invoice_view')) $items[] = anchor(get_uri('fiscal/invoices/'.$row->id), 'Ver factura');
        if ($row->xml_available && $this->allowed('fiscal_xml_download')) $items[] = anchor(get_uri('fiscal/stamping/xml/download/'.$row->id), 'Descargar XML');
        $pdfConfig = config('FiscalPdfProvider');
        $provider = (string) $pdfConfig->provider;
        if ($this->allowed('fiscal_pdf_generate')
            && (!$row->pdf_available || $this->allowed('fiscal.advanced.regenerate_pdf'))) {
            $providerLabel = $this->pdfProviderLabel($provider);
            $actionLabel = $row->pdf_available ? 'Regenerar PDF' : 'Generar PDF';
            try {
                $template = (new FiscalPdfTemplateResolver())->resolve(
                    (int) $row->issuer_profile_id,
                    $provider,
                    $this->typeCode((string) $row->document_type)
                )->templateCode;
            } catch (Throwable) { $template = '-'; }
            $items[] = js_anchor($actionLabel, [
                'class'=>'fiscal-generate-pdf','data-document-id'=>$row->id,'data-series'=>$row->series,
                'data-folio'=>$row->folio,'data-uuid'=>$row->uuid,'data-template'=>$template,
                'data-provider-label'=>$providerLabel,'data-action-label'=>$actionLabel,
                'data-regenerate'=>$row->pdf_available?1:0,
            ]);
        }
        if ($row->pdf_available && $this->allowed('fiscal_pdf_view')) $items[] = anchor(get_uri('fiscal/documents/'.$row->id.'/pdf/preview'), 'Ver PDF', ['target'=>'_blank']);
        if ($row->pdf_available && $this->allowed('fiscal_pdf_download')) $items[] = anchor(get_uri('fiscal/documents/'.$row->id.'/pdf/download'), 'Descargar PDF');
        if ($this->allowed('fiscal_cancel_request')) $items[] = '<span class="text-muted" title="Disponible en el incremento de cancelación fiscal">Cancelar</span>';
        if ($row->cancellation_request_id && $this->allowed('fiscal_cancellation_receipt_view')) $items[] = anchor(get_uri('fiscal/invoices/cancellation/ack/'.$row->cancellation_request_id), 'Ver acuse');
        if ($this->allowed('fiscal_status_query')) $items[] = '<span class="text-muted" title="Disponible en un incremento posterior">Consultar estatus</span>';
        return '<div class="dropdown"><button class="btn btn-default btn-sm dropdown-toggle" data-bs-toggle="dropdown">Acciones</button><div class="dropdown-menu dropdown-menu-end">'
            .implode('', array_map(static fn($item) => '<div class="dropdown-item">'.$item.'</div>', $items)).'</div></div>';
    }

    private function badge(string $group, string $status): string
    {
        $maps = [
            'fiscal'=>['draft'=>['Borrador','secondary'],'signed'=>['Listo para timbrar','info'],'processing'=>['Enviando','warning'],'stamped'=>['Timbrado','success'],'stamped_pdf_pending'=>['Timbrado','success'],'stamped_pdf_error'=>['Timbrado','success'],'stamped_pdf_processing'=>['Timbrado','success'],'stamped_pdf_unknown'=>['Timbrado','success'],'correctable_error'=>['Error','danger'],'unknown'=>['Resultado desconocido','dark'],'cancelled'=>['Cancelado','secondary']],
            'pdf'=>['pending'=>['Pendiente','secondary'],'processing'=>['Procesando','warning'],'valid'=>['Disponible','success'],'error'=>['Error','danger'],'unknown'=>['Desconocido','dark']],
            'cancellation'=>['none'=>['No solicitada','secondary'],'requested'=>['Solicitada','info'],'pending'=>['Pendiente','warning'],'accepted'=>['Aceptada','success'],'rejected'=>['Rechazada','danger'],'cancelled'=>['Cancelada','secondary'],'unknown'=>['Desconocida','dark']],
        ];
        [$label,$color] = $maps[$group][$status] ?? [ucfirst(str_replace('_',' ',$status)),'secondary'];
        return '<span class="badge bg-'.$color.'">'.esc($label).'</span>';
    }

    private function canAccess(): bool { return $this->allowed('fiscal_invoices_view') || $this->allowed('fiscal_invoice_view'); }
    private function allowed(string $permission): bool { if ($this->login_user->is_admin) return true; $all=is_array($this->login_user->permissions)?$this->login_user->permissions:(@unserialize((string)$this->login_user->permissions)?:[]); return (bool)get_array_value($all,$permission); }
    private function guard(string $permission): void { if (!$this->allowed($permission)) app_redirect('forbidden'); }
    private function typeCode(string $type): string { return match(strtolower($type)){'income','i'=>'I','expense','e'=>'E','payment','p'=>'P','transfer','t'=>'T','payroll','n'=>'N',default=>strtoupper(substr($type,0,1))}; }
    private function typeLabel(string $type): string { return match($this->typeCode($type)){'I'=>'Ingreso','E'=>'Egreso','P'=>'Pago','T'=>'Traslado','N'=>'Nómina',default=>$type}; }
    private function dateEs(string $date): string { $time=strtotime($date); return $time?date('d/m/Y',$time):'-'; }
    private function shortUuid(string $uuid): string { return $uuid===''?'-':substr($uuid,0,8).'…'.substr($uuid,-4); }
    private function pdfProviderLabel(string $provider): string { return $provider === 'timbradorxpress-tools' ? 'WSTools33 / PAC' : 'Servicio PDF deshabilitado (fake sólo para pruebas)'; }
    private function pdfArtifactLabel(string $provider): string { return $provider === 'timbradorxpress-tools' ? 'PDF generado por PAC' : 'PDF de prueba local'; }
}
