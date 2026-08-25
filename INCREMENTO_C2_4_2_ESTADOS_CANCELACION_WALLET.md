# Hotfix C2.4.2 — Estados reales y wallet comercial

Estado: **Implementado — pendiente de validación manual del usuario**

## Respaldo

`writable/backups/c2_4_2_cancellation_status_wallet_20260825_154938`

## Contrato TimbradorXpress observado

### cancelarPEM

Respuesta development observada para documentos 3, 4 y 5:

- HTTP 200.
- `code=201`.
- `message=Solicitud de cancelación de UUID exitosa.-`.
- `data.acuse`: XML firmado.
- `data.uuid[UUID]=201` y `<EstatusUUID>201</EstatusUUID>`.
- Clasificación: solicitud recibida, `pending`; no cancelación confirmada.

### consultarEstadoSAT

Contrato real observado sin envoltura `code/message/data`:

- `CodigoEstatus`
- `EsCancelable`
- `Estado`
- `EstatusCancelacion`

Respuesta real obtenida: `N-998`, intermitencia SAT, `Estado=Favor de consultarlo más tarde`; se clasifica `verifying`, con CFDI todavía `stamped` y `requires_reconciliation=1`.

## Mapper canónico

`FiscalCancellationStatusMapper` interpreta ambos contratos y devuelve estado fiscal, estado de cancelación, conciliación y retry. Reglas principales:

- cancelarPEM 201 → pending.
- 202/confirmación Cancelado → cancelled.
- 203/204/205 o rechazo explícito → rejected.
- consulta `Estado=Cancelado` → cancelled.
- `Vigente + En proceso/Pendiente` → pending.
- rechazo SAT → rejected.
- timeout, respuesta ilegible o N-998 → verifying.

## Wallet comercial

La migración agrega los movimientos `cancellation_request` y `cancellation_status_query`. Ambos descuentan directamente un timbre disponible, sin reserva y sin consultar créditos PAC.

- Solicitud idempotente por cancellation request id.
- Consulta idempotente por request id + `query_key` generado por el modal.
- Validación local, CSD y saldo ocurren antes de la llamada.
- Si la llamada real se ejecuta, se cobra una vez aunque el resultado sea unknown.
- Modal, visualización y acuse no cobran.

## Prueba development controlada

Documento 4, A-4, UUID `83FA2C35-7A08-45C3-8E92-D8AF08490E04`, total $2,000, motivo 03:

1. `cancelarPEM`: HTTP 200, código 201, pending, acuse persistido. Wallet 14 → 13; movimiento 18 `cancellation_request`.
2. Una `consultarEstadoSAT`: HTTP 200, N-998, verifying. Wallet 13 → 12; movimiento 19 `cancellation_status_query`.
3. Repetición con la misma clave: cero red y wallet 12 → 12.

El caso development de $116 (documento 3) también devolvió 201/pending. Esto demuestra que iKontrol no debe decidir cancelación inmediata sólo por monto. No existe evidencia development confirmada como cancelada para probar consulta del estado final.

## UX

La consulta abre un modal previo con fecha de solicitud, fecha recomendada, saldo y costo. El texto usa `3 días hábiles`; el helper omite sábado y domingo, sin afirmar manejo de festivos. Para A-4, solicitado el 25/08/2026, la consulta recomendada es 28/08/2026.

## Pruebas

- C2.4.2: 19/19, cero red.
- C2.4.1: 24/24, cero red.
- C2.4: 24/24, cero red.
- Control comercial: 25 checks pasan; 5 fallan porque su base disposable reutilizada no comienza en saldo cero.

No se hizo commit ni push.
