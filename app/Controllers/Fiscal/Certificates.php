<?php
declare(strict_types=1);

namespace App\Controllers\Fiscal;

use App\Controllers\Security_Controller;
use App\Models\Fiscal\Fiscal_issuer_certificates_model;
use App\Services\Fiscal\CsdCertificateService;

final class Certificates extends Security_Controller
{
    private Fiscal_issuer_certificates_model $certificates;

    public function __construct()
    {
        parent::__construct();
        $this->certificates = new Fiscal_issuer_certificates_model();
    }

    public function index($issuerId = 0)
    {
        $this->guard(false);
        $issuer = $this->issuer((int) $issuerId);
        return $this->template->rander('fiscal/certificates/index', [
            'issuer' => $issuer,
            'can_manage' => $this->allowed(true),
        ]);
    }

    public function list_data($issuerId = 0): void
    {
        $this->guard(false);
        $this->issuer((int) $issuerId);
        $rows = [];
        foreach ($this->certificates->forIssuer((int) $issuerId)->getResult() as $certificate) {
            $actions = '';
            if ($this->allowed(true) && !in_array($certificate->status, ['inactive', 'revoked_internal'], true)) {
                $actions = js_anchor('<i data-feather="x" class="icon-16"></i>', [
                    'title' => app_lang('deactivate'), 'class' => 'delete',
                    'data-action-url' => get_uri('fiscal/certificates/deactivate'),
                    'data-post-id' => $certificate->id, 'data-act' => 'ajax-request',
                    'data-reload-on-success' => '1',
                ]);
            }
            $rows[] = [
                htmlspecialchars($certificate->certificate_number),
                htmlspecialchars($certificate->certificate_rfc),
                format_to_datetime($certificate->valid_from),
                format_to_datetime($certificate->valid_to),
                app_lang('csd_status_' . $certificate->status),
                $certificate->is_default ? app_lang('yes') : app_lang('no'),
                $actions,
            ];
        }
        echo json_encode(['data' => $rows]);
    }

    public function form()
    {
        $this->guard(true);
        $issuer = $this->issuer((int) $this->request->getPost('issuer_profile_id'));
        return $this->template->view('fiscal/certificates/modal_form', ['issuer' => $issuer]);
    }

    public function upload(): void
    {
        $this->guard(true);
        $issuerId = (int) $this->request->getPost('issuer_profile_id');
        $this->issuer($issuerId);
        $certificate = $this->request->getFile('certificate_file');
        $key = $this->request->getFile('private_key_file');
        if (!$certificate || !$key || !$certificate->isValid() || !$key->isValid()) {
            echo json_encode(['success' => false, 'message' => app_lang('csd_files_required')]);
            return;
        }
        try {
            $certificateBytes = file_get_contents($certificate->getTempName());
            $keyBytes = file_get_contents($key->getTempName());
            if ($certificateBytes === false || $keyBytes === false) {
                throw new \RuntimeException('No fue posible leer los archivos cargados.');
            }
            $result = (new CsdCertificateService())->import(
                $issuerId, $certificateBytes, $certificate->getClientName(),
                $keyBytes, $key->getClientName(),
                (string) $this->request->getPost('private_key_password'),
                (bool) $this->request->getPost('is_default'),
                (int) $this->login_user->id, true
            );
            echo json_encode([
                'success' => true,
                'message' => app_lang('csd_uploaded') . ' ' . app_lang('csd_local_validity_notice'),
                'data' => ['id' => $result['certificate']->id, 'status' => $result['status']],
            ]);
        } catch (\Throwable $e) {
            log_message('warning', 'CSD upload rejected for issuer {issuer}: {type}', [
                'issuer' => $issuerId, 'type' => get_class($e),
            ]);
            echo json_encode(['success' => false, 'message' => $e->getMessage()]);
        } finally {
            unset($certificateBytes, $keyBytes);
        }
    }

    public function deactivate(): void
    {
        $this->guard(true);
        $id = (int) $this->request->getPost('id');
        $record = $this->certificates->get_one($id);
        $ok = false;
        if ($record->id) {
            $ok = (bool) $this->certificates->ci_save([
                'status' => 'inactive', 'is_default' => 0, 'updated_at' => get_current_utc_time(),
            ], $id);
        }
        echo json_encode(['success' => $ok, 'message' => $ok ? app_lang('record_saved') : app_lang('error_occurred')]);
    }

    private function issuer(int $id): object
    {
        $issuer = db_connect()->table('fiscal_profiles')->where([
            'id' => $id, 'profile_type' => 'issuer',
        ])->get(1)->getRow();
        if (!$issuer) {
            app_redirect('not_found');
        }
        return $issuer;
    }

    private function allowed(bool $manage): bool
    {
        if ($this->login_user->is_admin) {
            return true;
        }
        $permissions = $this->login_user->permissions;
        if (!is_array($permissions)) {
            $permissions = @unserialize((string) $permissions) ?: [];
        }
        return (bool) get_array_value($permissions, $manage ? 'fiscal_certificates_manage' : 'fiscal_certificates_view');
    }

    private function guard(bool $manage): void
    {
        if (!$this->allowed($manage)) {
            app_redirect('forbidden');
        }
    }
}
