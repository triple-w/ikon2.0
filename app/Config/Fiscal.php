<?php

namespace Config;

use CodeIgniter\Config\BaseConfig;

/**
 * Safe bootstrap configuration for the future Mexican fiscal domain.
 *
 * Increment 0 deliberately provides no endpoint, credential, certificate,
 * taxpayer data, or CFDI rule.
 */
class Fiscal extends BaseConfig
{
    public bool $enabled = false;

    public string $environment = 'local';

    public bool $allowRealPac = false;

    public string $privateStoragePath = WRITEPATH . 'fiscal-private';

    public string $pacAdapter = 'fake';
}

