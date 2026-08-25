# C2.3.1 — Aceptación de cotización y conversión idempotente a venta

## 1. Síntoma reproducido

La acción visible `Marcar como aceptada` se envía mediante `ajax_anchor` a `GET estimates/update_estimate_status/{id}/accepted`. Para usuarios cliente, cuando no se utilizaba el modal de firma, el backend realizaba el proceso pero terminaba únicamente con un flash de sesión: no emitía el JSON que el AJAX esperaba. La interfaz no podía confirmar ni recargar de forma fiable. Los errores de conversión, además, se reducían a un mensaje genérico.

En la base preview, la cotización más reciente auditada permanecía `draft`, sin `converted_sale_id` y sin Invoice relacionada. No había log durable de la solicitud observada que permitiera atribuirle una excepción concreta.

## 2. Causa raíz exacta

El contrato frontend/backend estaba incompleto en la rama cliente sin firma: `ajax_anchor` esperaba JSON y `Estimates::update_estimate_status()` no lo devolvía. A esto se sumaban tres defectos estructurales:

1. La implementación anterior actualizaba primero a `accepted` y luego a `converted`, por lo que “Aceptada” no era el estado final visible.
2. No bloqueaba la fila Estimate con `FOR UPDATE`; dos solicitudes podían observar ausencia de venta y crear duplicados.
3. `EstimateToInvoiceService` entregaba `fiscal_override_json`, pero `InvoiceCreationService` lo descartaba al insertar `invoice_items`.

No se encontró dependencia de perfil emisor, CSD, serie, snapshot ni readiness fiscal en el nuevo flujo.

## 3. Flujo anterior

Vista → `ajax_anchor` → `Estimates::update_estimate_status()` → guardar `accepted` → crear Invoice → cambiar Estimate a `converted` → respuesta JSON sólo en algunas ramas. La búsqueda de duplicados no estaba protegida por lock.

## 4. Flujo corregido

Vista → endpoint → validación de acceso → `EstimateAcceptanceService` (adaptador) → `EstimateAcceptanceCoordinator` → transacción → `SELECT ... FOR UPDATE` → resolver vínculo existente → crear Invoice y partidas → guardar `status=accepted` más `converted_sale_id` → auditoría → commit → JSON con `success`, `invoice_action`, `invoice_id` e `invoice_url`.

## 5. Diferencias respecto de Proposal

Proposal conserva su firma y su servicio sin cambios. Estimate adopta la misma idea de lock, backlink formal, transacción e idempotencia, pero conserva sus rutas pública/interna y no incorpora firma adicional. RISE representa la venta mediante `invoices`/`invoice_items`.

## 6. Estados permitidos

- `draft`, `sent`, `accepted`: pueden entrar a aceptación si no existe venta.
- `accepted` con vínculo: devuelve la venta existente.
- `converted` histórico con vínculo: se reconoce idempotentemente y no duplica.
- `declined/rejected`, `cancelled`, eliminado: no crean venta.
- Un estado no permitido devuelve un error funcional controlado.

El estado final nuevo es `accepted`; la conversión se demuestra con `converted_sale_id`, `converted_at`, `converted_by` e `invoices.estimate_id`.

## 7. Estrategia transaccional

Una única conexión contiene lock, encabezado Invoice, partidas, backlink y auditoría. `InvoiceCreationService` se invoca con manejo transaccional externo. Cualquier excepción provoca rollback; la prueba inyectada demostró que no queda Invoice ni aceptación parcial.

## 8. Estrategia de idempotencia

El lock serializa solicitudes para la misma cotización. Dentro del lock se comprueban ambos lados de la relación. Una venta existente se devuelve con `invoice_action=existing`; vínculos contradictorios o múltiples se detienen para revisión manual.

## 9. Relación Estimate–Venta

- `estimates.converted_sale_id` → `invoices.id`.
- `invoices.estimate_id` → `estimates.id`.

No se buscan coincidencias por cliente, importe ni fecha.

## 10. Conservación de partidas e impuestos

Se conservan cliente, empresa, proyecto aplicable, nota, descuentos, partidas, `item_id`, líneas libres, descripción, cantidad, unidad, costo, margen opcional, precio, orden y `fiscal_override_json` normalizado. `InvoiceCreationService` ahora persiste el override y usa `FiscalDecimal` como fallback de multiplicación.

Un override incompleto conserva `ready=false`; no se inventan impuestos. La configuración fiscal pendiente no bloquea aceptación/conversión y será bloqueada posteriormente por preparación CFDI.

## 11. Separación comercial/fiscal

La aceptación no consulta emisor, CSD, serie, draft, snapshot, PAC ni wallet. Únicamente valida relaciones comerciales, existencia de partidas y valores comerciales básicos. La readiness fiscal permanece responsabilidad del flujo de facturación.

## 12. Archivos modificados

- `app/Services/EstimateAcceptanceCoordinator.php`: transacción, lock, estados e idempotencia canónicos.
- `app/Services/EstimateAcceptanceService.php`: adaptador de compatibilidad hacia el coordinador.
- `app/Services/EstimateToInvoiceService.php`: conexión compartida, proyecto, relaciones y transacción externa.
- `app/Services/InvoiceCreationService.php`: conserva override y cálculo decimal fallback.
- `app/Controllers/Estimates.php`: JSON consistente, URL de venta y error funcional.
- `app/Controllers/Estimate.php`: idempotencia pública y respuesta visible.
- `app/Views/estimates/estimate_info.php`: enlace a venta y eliminación de conversión manual duplicable.
- `tests/IncrementC231/run.php`: integración aislada.
- `tests/Increment02/run.php`: regresión adaptada al contrato vigente.

## 13. Pruebas ejecutadas y resultados

- `tests/IncrementC231/run.php`: copia temporal de `ikontrol20_dold_preview`, 10 casos aprobados, 0 fallidos; la copia fue eliminada.
- `tests/IncrementC230/run.php`: 18 aprobados, 0 fallidos.
- `tests/Increment02/run.php`: 12 aprobados, 0 fallidos.
- `php -l`: archivos PHP modificados sin errores.
- No hubo PAC, timbrado ni movimientos de wallet.

## 14. Pruebas manuales pendientes

1. Abrir una cotización real `draft` o `sent`.
2. Pulsar Marcar como aceptada/Aceptar.
3. Confirmar estado Aceptada y mensaje de venta creada.
4. Pulsar Ver venta.
5. Comparar cliente, empresa/proyecto, partidas, descuentos y totales.
6. Confirmar overrides y líneas libres.
7. Repetir Aceptar o reenviar la misma solicitud.
8. Confirmar que abre/devuelve la misma venta y existe sólo una.

## 15. Riesgos restantes

- La base no tiene índice UNIQUE sobre `invoices.estimate_id`; el lock de Estimate protege el flujo canónico, pero una escritura externa que omita el servicio podría infringir la unicidad. No se creó migración por restricción del incremento.
- Cotizaciones históricas con estado `converted` se mantienen compatibles; no se normalizaron datos existentes.
- La validación visual real depende de la sesión/permisos del usuario y queda pendiente.

## C2.3.1-R1 — Ruta y modal de aceptación

## C2.3.1-R2 — CSRF del formulario público

El Jam `adc7fd14-6da7-4b44-a43c-8ee42c0876b6` demostró que el GET público ya
respondía 200, pero `POST estimate/accept_estimate` devolvía HTTP 403 desde
`CodeIgniter\\Filters\\CSRF::before()`. El cuerpo funcional no contenía el campo
CSRF.

La causa está en el comportamiento de `form_open()`: sólo agrega automáticamente
`csrf_field()` cuando el filtro CSRF figura entre los filtros activos de la
petición que renderiza el formulario. El modal se obtiene mediante GET sin ese
filtro; el filtro está correctamente asignado únicamente al POST. Por ello el
formulario Estimate no recibía el hidden, aunque su destino sí estaba protegido.

Se añadió explícitamente `csrf_field()` en
`app/Views/estimates/accept_estimate_modal_form.php`. Es el helper oficial de
CodeIgniter y obtiene dinámicamente `csrf_token()` y `csrf_hash()`; no se
codificaron el nombre `rise_csrf_token` ni un hash. `appForm` usa `ajaxSubmit` y
serializa los inputs hidden, por lo que el token viaja con ID, clave pública,
nombre, correo y firma. La petición es same-origin y conserva la cookie
`rise_csrf_cookie`. La configuración mantiene protección por cookie y
`regenerate=false`; no se alteró el filtro ni su configuración global.

Prueba HTTP real completa con fixture temporal `QA_C231_R2_HTTP_CSRF`, eliminado
al finalizar:

- GET modal: HTTP 200, formulario, ID, clave pública, campos y hidden CSRF.
- Cookie CSRF: presente.
- POST sin token: HTTP 403.
- POST con token inválido: HTTP 403.
- POST con cookie y token válidos: HTTP 200, `success=true`, una venta creada.
- Segundo POST válido: HTTP 200, `invoice_action=existing`, mismo `invoice_id`.
- Después de limpiar: cero cotizaciones y ventas QA residuales; tampoco quedó
  archivo temporal de firma.

Proposal conserva su vista y firma sin cambios. Su patrón histórico depende de
las rutas genéricas de `Offer`; no se modificó su seguridad dentro de R2. El
logotipo configurado `_file6a72a69ae861d-site-logo.png` sigue ausente y permanece
como pendiente independiente.

**Estado R2: Implementado — pendiente de validación manual del usuario.**

### Evidencia Jam y segunda causa confirmada

El Jam `b9b7b5c0-4d2f-4c25-9db6-c2e58f58e11b` registró la página pública
`http://localhost/ikontrol2/ikon2.0/index.php/estimate/preview/5/FiNlzYdYiU`
y el GET exacto
`http://localhost/ikontrol2/ikon2.0/index.php/estimate/accept_estimate_modal_form/5/FiNlzYdYiU`.
El botón ya contenía `data-action-method=GET`, `data-act=ajax-modal` y el título
correcto. La evidencia local confirmó que la cotización 5 existe, no está
eliminada, la clave coincide y su estado actual es `draft`.

Después de registrar la ruta explícita persistía una segunda contradicción:
`Estimate::accept_estimate_modal_form()` y `Estimate::accept_estimate()` exigían
literalmente `status=sent`, mientras la vista pública mostraba Aceptar para todo
estado no final y el coordinador canónico permite `draft`, `sent` y `accepted`.
El GET válido era rechazado por esa condición y `show_404()` se renderizaba dentro
de `#ajaxModalContent`.

La política quedó centralizada en
`EstimateAcceptanceCoordinator::acceptsStatus()` y expuesta por el adaptador
`EstimateAcceptanceService`. Tanto el render público como la confirmación usan
la misma política que la transacción. `rejected` y `cancelled` siguen bloqueados;
un vínculo ya convertido sigue devolviéndose idempotentemente.

Prueba HTTP real posterior, usando exactamente la URL del Jam:

- HTTP 200.
- `Content-Type: text/html; charset=UTF-8`.
- `accept-estimate-form` presente.
- página 404 ausente.
- ninguna venta creada por el GET.
- clave inválida y cotización inexistente: rechazo 404 controlado.

La confirmación AJAX se probó en copia temporal: crea exactamente una venta,
conserva tres partidas (producto, línea libre completa y línea libre pendiente),
devuelve JSON para `appForm` y la segunda confirmación devuelve la misma venta.
La suite quedó en 15 aprobadas y 0 fallidas.

### Hallazgo independiente del logotipo

La configuración `site_logo` apunta a
`files/system/_file6a72a69ae861d-site-logo.png`, pero el archivo no existe. Es un
activo eliminado o una referencia obsoleta; debe seleccionarse/cargarse de nuevo
el logotipo desde configuración del sistema. No se modificó en este incremento.

La URL del botón era `estimate/accept_estimate_modal_form/{id}` (o
`estimate/accept_estimate_modal_form/{id}/{public_key}` en la vista pública).
Se generaba en `app/Views/estimates/estimate_preview.php` y
`estimate_public_preview.php`. El enlace no declaraba método; `ajaxModal` usa
POST por defecto, mientras `autoRoute=false` y sólo existían las reglas legacy
amplias `estimate/(.*)` y `estimates/(.*)`. Por ello la lectura del modal no
tenía un contrato GET explícito y terminaba en 404 antes del controlador.

Contrato final:

- `GET estimate/accept_estimate_modal_form/{id}` →
  `Estimate::accept_estimate_modal_form($id)` para el contacto autenticado.
- `GET estimate/accept_estimate_modal_form/{id}/{public_key}` → el mismo método
  público, conservando la validación de clave.
- `POST estimate/accept_estimate` → `Estimate::accept_estimate()`, con CSRF.
- Vista del modal: `app/Views/estimates/accept_estimate_modal_form.php`.
- Respuesta de confirmación: JSON para `appForm` con `success`, `message`,
  `invoice_action` e `invoice_id`.
- La ruta administrativa permanece
  `GET estimates/update_estimate_status/{id}/accepted` →
  `Estimates::update_estimate_status()`.

`Estimate.php` conserva la responsabilidad pública/contacto y valida la clave;
`Estimates.php` conserva la responsabilidad administrativa y sus permisos. La
apertura GET sólo renderiza HTML: no cambia estado ni crea una venta.

Archivos R1: `app/Config/Routes.php`, las dos vistas preview y
`tests/IncrementC231/run.php`. `php spark routes` muestra ambas variantes GET,
el POST exacto con filtro CSRF y los controladores esperados. La suite aislada
comprueba además el JSON de confirmación y la idempotencia de la segunda
solicitud.

Se creó una cotización `QA_C231_R1_ROUTE_ONLY`, se solicitó por HTTP real la URL
con `index.php` generada por `get_uri()` y clave pública, y se eliminó el fixture
en el mismo bloque de prueba. El resultado fue HTTP 200, `text/html`, formulario
`accept-estimate-form` presente y ausencia de la página 404. Abrir el modal no
creó venta. La confirmación e idempotencia se validaron sobre una copia temporal
de la base en `tests/IncrementC231/run.php`: 13 aprobadas, 0 fallidas.

La comprobación visual autenticada mediante el Apache del navegador permanece
como prueba manual final. No se habilitó Auto Routing, no se agregaron comodines
amplios y no se retiraron filtros.

**Estado R1: Implementado — pendiente de validación manual del usuario.**

## 16. Confirmación de alcance

No se modificaron Proposal/firma, PAC, TimbradorXpress, CSD, XML, PDF, wallet, cancelación fiscal, complementos de pago, pagos, cuentas ni notas de crédito. No hubo migraciones, commit, push ni llamadas externas.

**Estado: Implementado — pendiente de validación manual del usuario.**
