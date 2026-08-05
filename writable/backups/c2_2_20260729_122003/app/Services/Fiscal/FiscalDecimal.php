<?php
declare(strict_types=1);

namespace App\Services\Fiscal;

use RuntimeException;

final class FiscalDecimal
{
    public static function micros(string $value): int
    {
        $value = trim($value);
        if (!preg_match('/^(-?)(\d+)(?:\.(\d{1,6}))?$/', $value, $match)) {
            throw new RuntimeException('FISCAL_ALLOCATION_DECIMAL_INVALID');
        }
        $micros = ((int) $match[2] * 1000000) + (int) str_pad($match[3] ?? '', 6, '0');
        return $match[1] === '-' ? -$micros : $micros;
    }

    public static function format(int $micros): string
    {
        $sign = $micros < 0 ? '-' : '';
        $micros = abs($micros);
        return $sign . intdiv($micros, 1000000) . '.'
            . str_pad((string) ($micros % 1000000), 6, '0', STR_PAD_LEFT);
    }

    public static function add(string ...$values): string
    {
        return self::format(array_sum(array_map([self::class, 'micros'], $values)));
    }

    public static function subtract(string $left, string ...$right): string
    {
        return self::format(self::micros($left) - array_sum(array_map([self::class, 'micros'], $right)));
    }
}
