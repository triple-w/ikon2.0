<?php
declare(strict_types=1);

namespace App\Services\Fiscal\Pac;

use App\Contracts\Fiscal\Pac\PacAdapterInterface;
use Config\Fiscal;
use Config\TimbradorXpress;
use RuntimeException;

/**
 * Single authority boundary for selecting any PAC implementation.
 */
final class FiscalPacAdapterFactory
{
    public function __construct(
        private readonly ?Fiscal $fiscal = null,
        private readonly ?TimbradorXpress $timbradorXpress = null,
        private readonly ?PacAdapterInterface $fake = null
    ) {
    }

    public function create(): PacAdapterInterface
    {
        $fiscal = $this->fiscal ?? config('Fiscal');

        if (!$fiscal->enabled) {
            throw new RuntimeException('El módulo fiscal está deshabilitado por configuración del servidor.');
        }

        return match ($fiscal->pacAdapter) {
            'fake' => $this->fake ?? new FakePacAdapter($fiscal->fakePacScenario ?? 'success'),
            'timbradorxpress' => $this->createTimbradorXpress($fiscal),
            default => throw new RuntimeException('El adaptador PAC configurado no está permitido.'),
        };
    }

    public function provider(): string
    {
        return ($this->fiscal ?? config('Fiscal'))->pacAdapter;
    }

    public function environment(): string
    {
        return ($this->fiscal ?? config('Fiscal'))->environment;
    }

    private function createTimbradorXpress(Fiscal $fiscal): PacAdapterInterface
    {
        if (!$fiscal->allowRealPac) {
            throw new RuntimeException('Las llamadas reales al PAC están deshabilitadas.');
        }
        if ($fiscal->environment !== 'sandbox') {
            throw new RuntimeException('TimbradorXpress sólo está permitido en sandbox durante esta etapa.');
        }

        $provider = $this->timbradorXpress ?? config('TimbradorXpress');
        if ($provider->environment !== 'sandbox' || $provider->productionEnabled) {
            throw new RuntimeException('La configuración maestra y TimbradorXpress no coinciden en sandbox seguro.');
        }
        $provider->assertSandbox();
        if (!$provider->isConfigured()) {
            throw new RuntimeException('PAC no configurado.');
        }

        return new TimbradorXpressRestAdapter($provider);
    }
}
