# REPORTE DE CONTEXTO TÉCNICO Y FUNCIONAL DE IKONTROL

Fecha: 2026-08-24  
Proyecto: C:\xampp\htdocs\ikontrol2\ikon2.0  
Base activa comprobada: ikontrol20_dold_preview  
Alcance: diagnóstico y documentación. No se escribieron datos, ejecutaron migraciones, llamadas PAC/PDF ni suites con efectos operativos.

## 1. Resumen ejecutivo

iKontrol es una extensión profunda de RISE CRM/ERP sobre CodeIgniter 4.6.1. Incorpora perfiles fiscales, CSD, series, drafts y snapshot v2, CFDI 4.0, TimbradorXpress, evidencia forense, wallet de timbres, conciliación y WSTools33. Esta arquitectura es sustancial y verificable, pero convive con cálculos comerciales legacy y servicios fiscales anteriores. Todavía no hay una sola fuente de verdad de extremo a extremo.

Cinco hallazgos principales:

1. No existe contabilidad de cuentas de dinero. Los pagos apuntan a una factura y método; egresos no identifican caja/banco. No hay ledger, saldos por cuenta ni conciliación.
2. Hay dos motores tributarios activos: el nuevo usa override/producto; servicios legacy siguen leyendo y escribiendo impuestos de encabezado y invoice_items.taxable.
3. El modal homologado tiene defectos confirmados: líneas libres de Proposal/Estimate no aprovechan override; JavaScript usa IDs/globals no acotados; el detalle por fila ignora descuento que el resumen sí prorratea.
4. El dinero comercial sigue almacenado en double y hay conversiones con float, mientras el fiscal usa decimales exactos de seis posiciones.
5. Complementos de pago y notas de crédito fiscales no forman todavía un flujo integral comprobable.

Conviene conservar el núcleo RISE, esquema fiscal nuevo, resolvers, snapshot, idempotencia, conciliación, wallet y adaptadores. Antes de ampliar funciones hay que consolidar el motor monetario/impositivo y diseñar ledger/aplicación de pagos.

## 2. Identificación técnica

| Elemento | Resultado | Evidencia | Confianza |
|---|---|---|---|
| Framework | CodeIgniter 4.6.1 | php spark --version | Confirmado |
| PHP CLI | 8.2.12 ZTS | php -v | Confirmado |
| DB | MariaDB 10.4.32, MySQLi | consulta de lectura; app/Config/Database.php | Confirmado |
| Base/prefijo | ikontrol20_dold_preview / ikontrol_ | SELECT DATABASE y .env sanitizado | Confirmado |
| Entorno | development; fiscal integration/development; PAC timbradorxpress | .env sanitizado | Confirmado |
| URL local | http://localhost/ikontrol2/ikon2.0/ | .env sanitizado | Confirmado |
| Arquitectura | MVC CI4 más servicios de dominio; modelos RISE con SQL manual | app/Controllers, Models, Services, Views | Confirmado |
| Git | main, HEAD b248c68; antes del reporte: 58 modificados y 64 no rastreados | git status | Confirmado |

El árbol auditado no es un commit reproducible: contiene muchos incrementos locales. Las conclusiones describen el working tree actual.

No hay ejecutable Composer disponible ni manifiesto raíz accesible. Las dependencias observables incluyen vendor integrado, cURL, OpenSSL, DOM/SimpleXML y SOAP; además Stripe, Google, Microsoft, PayPal y Paytm en RISE.

## 3. Arquitectura actual

- Presentación: vistas PHP, Bootstrap/jQuery, modal AJAX y appForm en assets/js/app.js.
- Aplicación: controladores legacy grandes (Invoices, Proposals, Estimates, Invoice_payments) más app/Controllers/Fiscal.
- Dominio: lifecycle, conversiones, resolvers, snapshots, stamping, wallet, PAC y PDF en app/Services.
- Persistencia: Crud_model, Query Builder y SQL manual. Hay 149 tablas y cero foreign keys declaradas; la integridad depende del código.
- Rutas: autoRoute=false en app/Config/Routing.php:97. Coexisten fiscal/invoices/review/{sale} y fiscal/drafts/create/{sale} en app/Config/FiscalRoutes.php:25-26,78.
- Autenticación: sesión en Security_Controller; Users_model::login_user_id; permisos serializados por módulo y bypass admin, app/Controllers/Security_Controller.php:24-119.
- Empresa/tenant: company_id y empresa por defecto, con filtrado aplicativo desigual. No hay restricción global ni FKs.
- Seguridad: CSRF global comentado en app/Config/Filters.php:70-76; sólo ciertas rutas lo aplican. Riesgo confirmado de cobertura inconsistente, pendiente matriz endpoint por endpoint.

## 4. Inventario de módulos

| Módulo | Componentes | Estado | Evidencia/dependencias |
|---|---|---|---|
| Clientes/CRM | Clients, Contacts, Leads; clients/users | Funcional con observaciones | Perfil fiscal separado; depende de ventas/receptor |
| Productos | Items; items, item_fiscal_settings/taxes | Funcional con observaciones | Catálogo y fiscal existen; sólo 3 taxes para 255 settings locales |
| Propuestas | Proposals, ProposalAcceptanceService, ProposalToInvoiceService | Funcional con defectos | Conversión/override presentes; falla línea libre |
| Cotizaciones | Estimates, EstimateAcceptanceService, EstimateToInvoiceService | Funcional con defectos | Problemas análogos a Proposal |
| Ventas | Invoices, Invoices_model, SaleLifecycleService | Funcional con observaciones | commercial_status y pago separados; conviven taxes nuevos/legacy |
| Pagos | Invoice_payments, invoice_payments | Parcial | Un pago pertenece a una factura; sin cuenta ni aplicación múltiple |
| Wallet cliente | Client_wallet_model, client_wallet | Legacy/parcial | Saldo a favor, no ledger bancario ni wallet fiscal |
| Egresos | Expenses, Expenses_model | Parcial | Sin cuenta de salida ni conciliación |
| Cuentas de dinero | No encontrado | Incompleto | Bloquea trazabilidad financiera |
| Emisor/CSD/series | Controllers Fiscal, resolvers, fiscal_profiles/certificates/series | Funcional con observaciones | Resolución dinámica y validadores presentes |
| Review/draft/snapshot | Fiscal\Drafts, FiscalReviewPreparation, FiscalDraftWorkflowService | Funcional con observaciones | Snapshot v2; rutas/servicios anteriores coexisten |
| Timbrado | FiscalInvoiceFlowService, FiscalDraftStampingService, Pac\FiscalStampingService | Funcional con observaciones | Intentos/evidencia/idempotencia; sin llamada en auditoría |
| XML/PDF | builders, validators, artifacts, WSTools33 | Funcional con observaciones | Evidencia en código/histórico; no red aquí |
| Wallet timbres | FiscalStampAccountService y movimientos | Funcional con observaciones | Reserva/consumo separados de créditos PAC |
| Créditos PAC | FiscalPacCreditService y snapshots | Técnico | Separado del wallet comercial |
| Cancelación fiscal | requests/attempts/artifacts/adapters | Parcial | Sin verificación E2E |
| Complementos de pago | Catálogos PPD/PUE solamente | Incompleto | No se encontró CFDI tipo P ni aplicación |
| Nota de crédito | Campos/estado invoice legacy | Parcial/legacy | No se comprobó CFDI egreso integrado |
| Proyectos/tareas/tickets | Módulos RISE | Funcional con observaciones | Fuera de prueba E2E |
| Suscripciones/store/pasarelas | Stripe/PayPal/Paytm | No verificable | Requiere credenciales/red |
| Reportes/dashboard | Reports, Dashboard | Funcional con observaciones | Ingreso deriva de pagos, no ledger |

## 5. Modelo de datos y relaciones

Flujo relacional efectivo:

    clients --< proposals --< proposal_items >-- items
       |             \ conversión -> invoices
       |--< estimates --< estimate_items >-- items
       |             \ conversión -> invoices
       \--< invoices --< invoice_items >-- items
                |             \ fiscal_override_json
                |             \ item_fiscal_settings --< item_fiscal_taxes
                |--< invoice_payments >-- payment_methods
                |--< fiscal_draft_sales >-- fiscal_drafts --< draft_items/taxes
                \--< fiscal_document_sales >-- fiscal_documents
                                                |-- items/taxes/stamps/artifacts
                                                |-- stamp_attempts
                                                \-- cancellation requests/attempts

    company --< fiscal_profiles --< certificates/series
    issuer/environment -- fiscal_stamp_accounts --< movements
    provider/environment -- fiscal_pac_credit_snapshots

Las relaciones son IDs sin constraints de base: FOREIGN_KEYS=0. Esto permite huérfanos si un servicio o eliminación lógica falla.

Conteos locales: 5 invoices, 7 invoice_items, 4 proposal_items, 3 estimate_items, 0 pagos, 0 egresos y 0 wallet cliente. Son evidencia de estado, no prueba funcional.

## 6. Flujo comercial actual

1. Se capturan cliente y producto en RISE.
2. Proposal/Estimate guardan item_id, cantidades/precios y fiscal_override_json.
3. Aceptación/conversión crea Sale/Invoice y copia partidas/override mediante servicios transaccionales.
4. Venta directa usa Invoices::item_modal_form/save_item y lifecycle draft/open/closed.
5. Los tres modales comparten _commercial_margin_fields.php y _fiscal_item_fields.php.
6. Resúmenes nuevos llaman CommercialTaxBreakdownService, pero Invoices_model y ajustes legacy conservan cálculos paralelos.
7. El pago se registra contra invoice_id y payment_method_id; actualiza status.
8. No genera movimiento de caja/banco.

Riesgos: ProposalToInvoiceService.php:41-58 usa float y recalcula total; JSON puede contener product_id desfasado; no hay FK; conversiones nuevas neutralizan taxes de encabezado, pero código anterior vuelve a usarlos.

## 7. Flujo fiscal actual

    Sale
      -> FiscalReviewPreparation
      -> draft + snapshot v2 al guardar/facturar
      -> validación, preflight y ready interno
      -> reserva de timbre comercial
      -> CFDI 4.0 + firma CSD
      -> TimbradorXpress development
      -> parser/validación XML y UUID
      -> document stamped + XML + consumo wallet
      -> WSTools33 template 1 + PDF
      -> detalle/listado/descargas

El flujo está ampliamente implementado e incluye resultado incierto, evidencia cifrada y conciliación. No se invocó PAC. Coexisten InvoiceReview/FiscalDraftCreationService/SaleTaxPricingSimulationService anteriores con el flujo canónico nuevo.

No hay complemento de pago completo comprobable. La nota de crédito no tiene política administrativa/fiscal formal. Cancelación tiene infraestructura parcial.

## 8. Ventas, pagos, cuentas y CFDI

- Venta-CFDI: formalizada por fiscal_document_sales y asignaciones.
- Venta-pago: invoice_payments.invoice_id, uno-a-muchos; cada pago sólo apunta a una invoice.
- Pago-cuenta: inexistente; método de pago no equivale a cuenta.
- Egreso-cuenta: inexistente.
- Pago-complemento: no se encontró relación formal.
- CFDI-nota de crédito: relaciones genéricas/legacy, no ciclo cerrado.
- Saldo administrativo: total invoice menos pagos; wallet cliente separado. No incorpora ledger ni política de notas fiscales.
- Estado fiscal: documentos/attempts independientes, correcto conceptualmente; mapeos visibles nuevos y legacy coexisten.

Expenses_model.php:92-117 trata invoice_payments como ingresos pese a no conocer cuenta o conciliación. Confianza: confirmado.

## 9. Homologación de partidas C2.2.9

Comprobado:

- Modales reales: app/Views/proposals/item_modal_form.php, estimates/item_modal_form.php e invoices/item_modal_form.php.
- Los tres incluyen _commercial_margin_fields.php y app/Views/invoices/_fiscal_item_fields.php.
- Migración 2026-08-21-090500_AddFiscalOverrideToCommercialItems aplicada en batch 7.
- proposal_items/estimate_items.fiscal_override_json son LONGTEXT NULL.
- Selección de producto usa ProductFiscalConfigurationResolver.
- Proposal/Estimate guardan con CommercialItemFiscalOverrideService; Invoice con InvoiceItemFiscalOverrideService.
- Conversiones copian fiscal_override_json.
- Tablas usan CommercialItemTaxDisplayService; resúmenes CommercialTaxBreakdownService.

No está completa: el parcial común no garantiza igual dominio; línea libre, descuento, lifecycle JS y validación JSON divergen.

## 10. Diagnóstico del modal

### M-01. Línea libre Proposal/Estimate no usa override

- Síntoma: datos fiscales capturados, pero partida queda pendiente.
- Causa: CommercialItemTaxResolver::product retorna notReady con productId<=0 antes de evaluar override.
- Archivo: app/Services/Fiscal/CommercialItemTaxResolver.php:24-27.
- Afecta: Proposal, Estimate, conversión, desglose y review.
- Recomendación: prioridad override válido > producto > blocker.
- Confianza: confirmado por flujo de control.

### M-02. Tabla ignora descuentos

- Síntoma: filas no suman resumen cuando hay descuento.
- Causa: CommercialItemTaxDisplayService::document pasa descuento cero en línea 8; CommercialTaxBreakdownService::document lo prorratea en líneas 16-19.
- Afecta: base/impuesto/total mostrado.
- Recomendación: presentar el mismo resultado canónico.
- Confianza: confirmado.

### M-03. JSON se valida distinto

- Síntoma: JSON viejo con ready=true puede aceptarse en Proposal/Estimate y fallar después.
- Causa: CommercialItemFiscalOverrideService::effective confía en ready; InvoiceItemFiscalOverrideService::effective exige complete.
- Recomendación: esquema versionado y validador único.
- Confianza: confirmado.

### M-04. JavaScript global/no acotado

- Síntoma: impuestos o handlers pueden mezclarse/perderse al reabrir.
- Causa: _fiscal_item_fields.php:5-15 usa IDs invoice-* fijos, selectores globales y window.invoiceRenderFiscalTaxes. assets/js/app.js:86-125 inyecta HTML directo; líneas 145-153 vacían el modal.
- Recomendación: inicializador por contenedor/formulario, sin globals ni IDs repetibles.
- Confianza: estructura confirmada; impacto requiere reproducción manual.

### M-05. Dos editores en el mismo parcial

- Síntoma: serialización frágil.
- Causa: _fiscal_item_fields.php:9-10 renderiza inputs iniciales, después CSS/JS los oculta y elimina name; líneas 11-15 construyen otro editor. Inputs disabled de Exento no se envían, aunque backend permite la omisión.
- Recomendación: una sola colección normalizada.
- Confianza: confirmado en estructura; impacto manual pendiente.

### Inconsistencias probables

- Proposals::save_item valida override antes de resolver completamente item_id de alta/edición; product_id dentro del JSON puede quedar 0/desfasado aunque la columna final sea correcta. Estimate tiene orden parecido al agregar al catálogo.
- Selectores por name no se limitan al formulario activo.
- Preview usa Number/toFixed(6); backend sigue siendo autoritativo, pero la vista puede diferir.

### Elementos correctos

- appForm espera JSON al guardar (assets/js/app.js:497-656) y HTML directo al abrir (31-142).
- Exento sin tasa es deliberado.
- Selección conserva item_id y precarga configuración maestra.
- Un cambio fiscal activa override y no actualiza el maestro por defecto.
- La migración C2.2.9 está aplicada.

## 11. Modelo monetario e impuestos

| Importe | Fuente nueva | Riesgo legacy |
|---|---|---|
| Precio/cantidad | rate/quantity y servicios pricing | double y JS Number |
| Margen | backend + preview JS | conversiones float |
| Impuesto | override > producto | taxable y tax_id/tax_id2/tax_id3 |
| Desglose | CommercialTaxBreakdownService | Invoices_model/totales persistidos |
| Snapshot | FiscalDraftTaxSnapshotService/FiscalDecimal | servicios anteriores |
| Pago/saldo | invoice_payments y total-pagos | double, sin cuenta |
| Wallet fiscal | movimientos propios | correctamente separado de créditos PAC |

quantity, rate y total son double en los tres tipos de partidas; invoice_payments.amount y expenses.amount también. ProposalToInvoiceService.php:41-58 castea a float y multiplica. Client_wallet_model.php:58-80 formatea a dos decimales antes de ciertas operaciones.

FiscalDecimal opera a seis decimales, pero no recupera precisión ya perdida en double. CommercialItemTaxDisplayService usa float/number_format sólo para presentación; es aceptable mientras no se reutilice como fuente.

Riesgos confirmados: centavos venta/CFDI; descuento fila/resumen; doble interpretación included/excluded; reintroducción de headers por SaleTaxAdjustmentService::confirmAndApply; conversiones float; sumas SQL sobre double.

## 12. Integraciones externas

- TimbradorXpress REST: timbrado, consulta SAT y créditos; adapters/parsers/validator presentes.
- WSTools33 SOAP: PDF template 1 con validación.
- Stripe: pagos, suscripciones, taxes y webhooks legacy.
- PayPal/Paytm: redirecciones de pago.
- Google/Microsoft: integraciones RISE.
- Slack/GitHub/Bitbucket: notificaciones/webhooks.

No se probó red ni se expusieron secretos. Operación real de integraciones no fiscales: no verificable.

## 13. Pruebas y validaciones

| Validación segura | Resultado |
|---|---|
| php -v | PHP 8.2.12 |
| php spark --version | CI 4.6.1 |
| php spark routes | Carga; ruta fiscal canónica y legacy coexisten |
| php spark migrate:status | Aplicadas; C2.2.9 batch 7 |
| information_schema/conteos | Base confirmada, 149 tablas, 0 FKs, tipos auditados |
| php -l en 7 archivos críticos | Sin errores |
| git diff --check | Sin errores; advertencias LF a CRLF |
| Inventario tests | C224-C229, C232-C237, UX1/UX12/UX2/UX21/UX22 y otras |
| Suites | No ejecutadas: runners personalizados pueden escribir DB, migrar o alcanzar PAC |
| Navegador/PAC/PDF | No ejecutados |

## 14. Hallazgos con evidencia

| ID | Hallazgo | Evidencia | Confianza |
|---|---|---|---|
| H01 | Sin ledger de cuentas | Invoice_payments::save_payment; esquema sin accounts/movements | Confirmado |
| H02 | Sin FKs | information_schema devuelve 0 | Confirmado |
| H03 | Dos fuentes tributarias | resolver nuevo vs SaleTaxAdjustmentService.php:10 y SaleTaxPricingSimulationService.php:14-23 | Confirmado |
| H04 | Línea libre falla | CommercialItemTaxResolver.php:24-27 | Confirmado |
| H05 | Descuento inconsistente | DisplayService.php:8 vs BreakdownService.php:16-19 | Confirmado |
| H06 | JSON desigual | servicios override comercial/invoice | Confirmado |
| H07 | Modal con globals/IDs | _fiscal_item_fields.php:5-15; app.js:31-153 | Probable impacto |
| H08 | Dinero double/float | esquema; ProposalToInvoiceService.php:41-58 | Confirmado |
| H09 | CSRF no global | app/Config/Filters.php:70-76 | Confirmado |
| H10 | Tenant sólo aplicativo | company_id disperso, sin FK/filtro global | Riesgo probable |
| H11 | Complementos ausentes E2E | sin controlador/servicio/tablas específicas CFDI pago | Confirmado por inventario |
| H12 | Árbol no reproducible | 122 cambios locales antes del reporte | Confirmado |

## 15. Riesgos técnicos y funcionales

Críticos: importes divergentes venta/CFDI; ausencia de cuentas; integridad sólo por código; CSRF inconsistente.

Altos: modal inestable en líneas libres/reapertura; descuentos incoherentes; JSON no versionado; posible cruce de empresa; complementos/notas sin política.

Medios: N+1 por CommercialItemTaxDisplayService; assets compilados potencialmente desincronizados; LF/CRLF; dependencias sin manifiesto reproducible.

## 16. Brechas contra el objetivo

Bloqueantes:

1. Un solo motor de impuestos/totales; retirar autoridad de taxable/header taxes.
2. Corregir contrato modal/override/descuento.
3. Cuentas, movimientos y aplicación de pagos.
4. Integridad/idempotencia entre venta, pago, documento y saldo.

Prioridad alta:

- Complementos con aplicación muchos-a-muchos.
- Nota de crédito CFDI y efecto administrativo explícito.
- Matriz CSRF/autorización/tenant.
- Migración gradual de importes críticos a DECIMAL con conciliación.

Prioridad media:

- Consolidar rutas/servicios fiscales legacy.
- Reducir N+1.
- Pruebas con DB desechable y red bloqueada.
- Dependencias/build reproducibles.

Futuro: conciliación bancaria, cajas/sucursales, inventario, compras/proveedores/CxP según decisión.

## 17. Legacy, duplicado o sin uso aparente

- SaleTaxPricingSimulationService y SaleTaxAdjustmentService contradicen la fuente producto/override.
- FiscalDraftCreationService e InvoiceReview coexisten con FiscalReviewPreparation/FiscalDraftWorkflowService.
- tax_id/tax_id2/tax_id3 y invoice_items.taxable son compatibilidad, no deberían ser autoridad nueva.
- _fiscal_item_fields.php:9-10 contiene inputs iniciales ocultos duplicados por JS.
- Estados invoice históricos coexisten con commercial_status.

Legacy no significa seguro de borrar: requiere cobertura y telemetría de consumidores.

## 18. Recomendaciones por prioridad

1. Congelar por escrito reglas included/excluded, descuento, retenciones y redondeo con fixtures.
2. Unificar resolver/calculador para Proposal/Estimate/Sale/Review/Snapshot.
3. Rehacer componente modal por contenedor, JSON versionado y soporte de línea libre.
4. Aislar pruebas en base temporal con guard de red/PAC.
5. Diseñar ledger: cuentas, movimientos inmutables, aplicaciones, transferencias y reembolsos.
6. Construir complementos/notas sobre aplicaciones y relaciones.
7. CSRF global, scoping company y constraints graduales.
8. Retirar legacy por cobertura, no por búsqueda textual.

## 19. Preguntas al propietario

1. ¿Una nota de crédito reduce siempre saldo administrativo, sólo fiscal o depende del motivo?
2. ¿Un pago puede aplicarse a varias ventas/facturas y viceversa?
3. ¿Una factura puede consolidar ventas? ¿Una venta admite facturación parcial?
4. ¿Cómo se registran anticipos, depósitos no identificados y saldos a favor?
5. ¿Cómo se diferencian devolución, bonificación, reembolso y nota de crédito?
6. ¿Cómo se coordinan cancelación comercial, fiscal y reversa de pago?
7. ¿Se requieren proveedores, compras, inventario, CxP y costeo?
8. ¿Hay sucursales, cajas, almacenes y traspasos?
9. ¿Se requiere conciliación bancaria/fecha valor?
10. ¿Qué estado manda en cada decisión: comercial, pago o fiscal?
11. ¿Included/excluded depende de empresa, sucursal, lista o documento?
12. ¿Cómo se distribuye descuento global con IEPS/retenciones?
13. ¿Las líneas libres pueden convertirse en producto maestro?
14. ¿Qué rol modifica maestro fiscal y cuál sólo override?

## 20. Siguientes incrementos propuestos

### Incremento 1: contrato de partida y modal

Caracterizar cálculo, corregir prioridad override/producto/línea libre, eliminar globals/IDs, versionar JSON y unificar fila/resumen. No tocar PAC/XML/wallet.

### Incremento 2: consolidación monetaria

Un motor para Proposal/Estimate/Sale/Review/Snapshot; neutralizar header taxes/taxable; diseñar transición double a DECIMAL; pruebas aisladas.

### Incremento 3: ledger y pagos

Cuentas/cajas/bancos, movimientos inmutables, aplicaciones pago-factura y adaptación gradual de pagos/egresos.

### Incremento 4: ciclo fiscal posterior

Complementos, notas de crédito y cancelaciones sobre relaciones formales, separando efecto administrativo y fiscal.

---

La única escritura de esta auditoría es este reporte. No se modificó código ni base, no se ejecutaron migraciones ni llamadas externas, y se omitieron datos sensibles.
