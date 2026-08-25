# Incremento C2.4 — Cancelación de CFDI

Estado: **Implementado — pendiente de validación manual del usuario**

## Respaldo

`writable/backups/c2_4_cfdi_cancellation_20260825_143915`

Incluye dump de `ikontrol20_dold_preview`, controladores, servicios fiscales/PAC, vistas, rutas, wallet, logs y pruebas.

## Implementación previa encontrada

Existían rutas, controlador, modal, tablas de solicitudes/intentos/artefactos, presentador de estados y un `FiscalCancellationService`. El flujo utilizaba exclusivamente `FakeFiscalCancellationAdapter`, mostraba el UUID sustituto permanentemente y reservaba/consumía timbres comerciales. El módulo formal de Facturas mantenía Cancelar y Consultar estatus como placeholders deshabilitados.

## Contrato final

- Motivos SAT: 01, 02, 03 y 04.
- Motivo 01 exige UUID sustituto con forma `8-4-4-4-12` y distinto del UUID cancelado.
- Motivos 02/03/04 normalizan `replacement_uuid` a `null`.
- Sólo documentos development timbrados, con UUID/XML y sin solicitud activa incompatible son cancelables.
- Rechazo definitivo permite una nueva solicitud corregida.
- Pendiente, unknown y cancelada bloquean solicitudes paralelas.
- `unknown` conserva `requires_reconciliation=1`; nunca produce reenvío automático.
- Cancelar o consultar no crea movimientos de wallet.

## PAC y CSD

Se implementó `TimbradorXpressCancellationAdapter` con las operaciones documentadas `cancelarPEM` y `consultarEstadoSAT`. El servicio resuelve el emisor desde el documento y su CSD activo, verifica el RFC, descifra la contraseña y exporta llave/certificado sólo en memoria. El adaptador exige la configuración sandbox y no registra material privado.

Fuente oficial consultada: `https://dev.timbradorxpress.mx/ws/servicio.do`.

## Persistencia y UX

Se reutilizan `fiscal_cancellation_requests`, `fiscal_cancellation_attempts`, `fiscal_cancellation_artifacts` y `fiscal_document_relations`. Los estados visibles son No solicitada, Pendiente, Cancelada, Rechazada y Verificando. El XML, PDF, UUID, factura, venta y allocations originales se conservan. Una cancelación confirmada cambia el estado fiscal; las allocations permanecen como historia y dejan de consumir saldo mediante la regla existente que excluye documentos cancelados.

## Prueba development

- Documento: 7 / venta 15 / A-7.
- UUID: `0978131E-5631-4E1E-8900-8E4248D35067`.
- Motivo: 02.
- Respuesta inicial PAC: `Solicitud de cancelación de UUID exitosa.-`.
- Estado inicial persistido: pendiente.
- Request/attempt: 1/1.
- Wallet antes/después: 14 disponibles, 0 reservados / 14 disponibles, 0 reservados.
- La primera consulta reveló una restricción única legacy de un intento por solicitud; se corrigió para reutilizar el intento durable.
- La consulta posterior no produjo una respuesta interpretable y se clasificó `unknown`, `requires_reconciliation=1`.
- Documento local: `cancellation_pending`; `cancelled_at` permanece nulo.
- No se realizó un nuevo envío de cancelación después de unknown.
- No se ejecutó motivo 01 por no seleccionar un par OLD/NEW adecuado.

## Archivos modificados

- `app/Contracts/Fiscal/Cancellation/FiscalCancellationAdapterInterface.php`
- `app/Services/Fiscal/Cancellation/FakeFiscalCancellationAdapter.php`
- `app/Services/Fiscal/Cancellation/FiscalCancellationService.php`
- `app/Services/Fiscal/Cancellation/TimbradorXpressCancellationAdapter.php`
- `app/Controllers/Fiscal/Invoices.php`
- `app/Controllers/Fiscal/InvoiceModule.php`
- `app/Services/Fiscal/FiscalInvoiceCenterQueryService.php`
- `app/Views/fiscal/invoices/cancel_form.php`
- `app/Views/fiscal/invoices/module_index.php`
- `app/Views/fiscal/invoices/show.php`
- `app/Config/FiscalRoutes.php`
- `tests/IncrementC1/run.php`
- `tests/IncrementC24/run.php`
- runners manuales development de C2.4.

## Pruebas

- C2.4: 24 aprobadas, 0 fallidas, cero red.
- C224: 20/20.
- C225: 18/21 (tres fallos de fixtures/expectativas previas).
- C226: 28/29 (una expectativa previa de override).
- C227: 24/24.
- C228: 29/29.
- C229: 29/31 (dos expectativas previas de UI Proposal/Estimate).
- UX1: 22/22; UX2: 24/24; UX12: 20/20; UX21: 23/23; UX22: 17/17.
- C1 heredada no inició porque su base aislada no contiene el documento fixture 12.

No se hizo commit ni push.
