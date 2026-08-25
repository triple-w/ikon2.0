# Hotfix C2.4.1 — Cancelación, estados, consulta y acuse

Estado: **Implementado — pendiente de validación manual del usuario**

## Evidencia A-6

- Documento fiscal: 6; venta: 14; serie/folio: A-6.
- UUID persistido: `A64C0FFB-974E-402D-8E20-CBC7F74E2F58`.
- Solicitud/intento: 2/3; motivo: 03.
- Respuesta inicial observada: `Solicitud de cancelación de UUID exitosa.-`; se clasifica como solicitud recibida, no como cancelación confirmada.
- Consulta real: HTTP 200, `N-998`: intermitencia del servicio SAT; `Estado`: `Favor de consultarlo más tarde.`
- Clasificación final: CFDI Timbrado; cancelación Verificando; `requires_reconciliation=1`.
- Acuse: no disponible.
- Payload de consulta persistido como `provider_status`, 238 bytes, SHA-256 `703d28ee46d5a0f3024d72771397ce1e6b43efbc5e047d4aab7daeb1945d818c`.

## Causas

1. El resultado `pending` devolvía `success=false`; `appForm` conservaba el modal como si pudiera enviarse de nuevo.
2. El presentador convertía una cancelación `unknown` en estado fiscal general `unknown`, aunque el CFDI seguía timbrado.
3. `appTable()` no devuelve una instancia encadenable. `table.appTable(...)` operaba sobre `undefined`.
4. `Ver acuse` se mostraba al existir una solicitud, aunque no existiera un artefacto `cancellation_ack`, causando el 404.
5. El parser esperaba siempre `code/message/data`; `consultarEstadoSAT` devolvió directamente `CodigoEstatus/EsCancelable/Estado/EstatusCancelacion`.

## Corrección

- Pending/cancelled cierran el modal y recargan `#fiscal-invoices-table`.
- Rejected conserva el modal; unknown deshabilita la nueva solicitud.
- Estados visibles separados: Timbrado/Cancelado y Pendiente/Cancelada/Rechazada/Verificando.
- Status AJAX devuelve identificadores, ambos estados, mensaje, código/mensaje PAC, `ack_available` y `ack_url`.
- Consultar estatus no navega al acuse.
- Ver acuse sólo se proyecta cuando existe el artefacto y conserva la ruta por cancellation request id.
- Se persiste el payload del proveedor con hash, sin CSD ni secretos.
- `N-998` permanece unknown/verificando y nunca habilita reenvío.
- Wallet sin cambios: 14 disponibles, 0 reservados.
- Venta 14 y allocation del documento 6 permanecen intactos/activos porque no hay cancelación confirmada.

## Pruebas

- `tests/IncrementC241/run.php`: 24 aprobadas, 0 fallidas, cero PAC.
- `tests/IncrementC24/run.php`: 24 aprobadas, 0 fallidas, cero PAC.
- C2.2.11: 15 aprobadas, 2 expectativas históricas incompatibles con el estado actual de A-6 y el wallet 14/0.
- Una llamada development `consultarEstadoSAT`; cero `cancelarPEM` en C2.4.1.

Los 404 de logo/favicon observados en JAM quedan documentados como incidencia separada y no fueron modificados.

No se hizo commit ni push.
