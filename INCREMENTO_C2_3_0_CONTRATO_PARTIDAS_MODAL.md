# C2.3.0 — Contrato único de partidas y corrección del modal fiscal

Fecha: 2026-08-24  
Base activa identificada: ikontrol20_dold_preview  
Estado de la base durante el incremento: no modificada.

## 1. Objetivo

Homologar la captura y resolución fiscal de partidas de Proposal, Estimate e Invoice sin tocar timbrado, PAC, XML, PDF, wallet, pagos ni módulos financieros. El backend queda como autoridad de normalización, completitud y cálculo decimal.

## 2. Diagnóstico final

Se corrigieron estas causas:

1. CommercialItemTaxResolver rechazaba item_id=0 antes de evaluar override.
2. Proposal y Estimate incluían dos veces el parcial fiscal en una misma apertura.
3. El parcial anterior renderizaba dos colecciones de impuestos y después eliminaba names mediante JavaScript.
4. El editor dependía de IDs invoice-* y de window.invoiceRenderFiscalTaxes, aun siendo compartido.
5. Proposal/Estimate confiaban en ready almacenado, mientras Invoice aplicaba otra validación.
6. Proposal normalizaba el override antes de resolver el item_id final; Estimate lo hacía antes de crear un producto solicitado.
7. CommercialItemTaxDisplayService enviaba descuento cero, pero CommercialTaxBreakdownService prorrateaba el descuento del documento.
8. ProposalToInvoiceService calculaba total mediante float y multiplicación nativa.
9. Las conversiones copiaban JSON sin normalizar ni corregir su product_id.

## 3. Contrato fiscal_override_json

La versión vigente es schema_version=2. FiscalItemOverrideContract es la definición canónica.

Campos persistidos:

- schema_version: 2.
- override: true.
- product_id: ID final o 0 para línea libre.
- product_service_code.
- unit_code.
- commercial_unit.
- tax_object_code.
- fiscal_description.
- pricing_mode: tax_inclusive o tax_exclusive.
- prices_include_tax: derivado de pricing_mode.
- taxes: lista normalizada de tax_code, tax_type, factor_type y rate_or_quota.
- missing: blockers derivados.
- ready y complete: valores derivados, nunca confiados desde navegador o JSON anterior.

ObjetoImp 01 vacía taxes y no requiere tasa. Otros objetos conservan la regla existente de requerir configuración de impuestos. ISR 001 conserva la validación existente como retención. Los códigos soportados por el dominio actual son 001, 002 y 003; los factores son Tasa, Cuota y Exento.

## 4. Reglas implementadas

- Prioridad: override válido, producto maestro, pendiente.
- Un override completo funciona con product_id=0.
- Una línea libre incompleta se guarda con ready=false y blockers; sólo bloquea preparación fiscal.
- El producto maestro no se modifica desde el modal de partida.
- Incluido/excluido pertenece al override cuando el usuario lo cambia.
- El backend calcula con FiscalDecimal a seis decimales.
- La UI sólo previsualiza y presenta.
- Taxable y taxes de encabezado permanecen neutrales/legacy, no se vuelven autoridad.

## 5. Archivos modificados

Servicios:

- app/Services/Fiscal/FiscalItemOverrideContract.php (nuevo).
- app/Services/Fiscal/CommercialItemTaxCalculator.php (nuevo).
- app/Services/Fiscal/InvoiceItemFiscalOverrideService.php.
- app/Services/Fiscal/CommercialItemFiscalOverrideService.php.
- app/Services/Fiscal/CommercialItemTaxResolver.php.
- app/Services/Fiscal/InvoiceItemTaxResolver.php.
- app/Services/Fiscal/CommercialTaxBreakdownService.php.
- app/Services/Fiscal/CommercialItemTaxDisplayService.php.
- app/Services/Fiscal/FiscalDraftWorkflowService.php.
- app/Services/ProposalToInvoiceService.php.
- app/Services/EstimateToInvoiceService.php.

Controladores:

- app/Controllers/Proposals.php.
- app/Controllers/Estimates.php.
- app/Controllers/Invoices.php.

Vistas:

- app/Views/items/_fiscal_item_fields.php (nuevo componente activo).
- app/Views/invoices/_fiscal_item_fields.php (adaptador de compatibilidad).
- app/Views/proposals/item_modal_form.php.
- app/Views/estimates/item_modal_form.php.
- app/Views/invoices/item_modal_form.php.

Pruebas/documentación:

- tests/IncrementC230/run.php.
- INCREMENTO_C2_3_0_CONTRATO_PARTIDAS_MODAL.md.

Varios de estos archivos ya contenían cambios locales no confirmados antes de C2.3.0. Se editaron por secciones y no se descartó ningún cambio previo.

## 6. Explicación por componente

FiscalItemOverrideContract normaliza input/JSON anterior, corrige product_id y recalcula missing/ready. CommercialItemTaxCalculator es puro y concentra la matemática de cantidad, precio, descuento, base, traslados, retenciones y total.

Los servicios públicos de override siguen existiendo como adaptadores para sus tablas, pero delegan serialización al contrato común. InvoiceItemTaxResolver conserva la modalidad de un override, en lugar de reemplazarla siempre por la del emisor.

CommercialTaxBreakdownService expone cálculo canónico por renglón con el mismo prorrateo del resumen. CommercialItemTaxDisplayService presenta ese resultado y deja de pasar descuento cero.

Los controladores resuelven primero el item_id definitivo y después serializan el override. Un override incompleto válido estructuralmente puede guardarse; una combinación fiscal mal formada devuelve error funcional. La opción de actualizar maestro desde partida fue retirada del flujo activo.

El nuevo parcial usa clases acotadas a su contenedor/formulario, evento fiscal:item:load y handlers namespaced. No usa globals ni IDs exclusivos de Invoice. Cada modal lo incluye exactamente una vez.

Las conversiones normalizan JSON con el product_id de destino lógico, conservan línea libre y usan FiscalDecimal::multiply. taxable queda neutralizado en las nuevas filas convertidas.

## 7. Compatibilidad con JSON anterior

normalizeStored acepta estructuras anteriores con campos directos o dentro de setting, y prices_include_tax o pricing_mode. Ignora ready/complete almacenados, vuelve a normalizar taxes y deriva la completitud. Al guardar o convertir se serializa schema_version=2.

JSON inválido o incompleto no se considera listo. Para una línea libre se conserva como override pendiente para reapertura. Si existe producto maestro listo y el override antiguo es incompleto, el maestro continúa como fallback según la prioridad aprobada.

## 8. Incluido y excluido

Ejemplos comprobados por suite pura:

- Incluido: 2 × 58, IVA 16% → base 100.000000, IVA 16.000000, total 116.000000.
- Excluido: 2 × 58, IVA 16% → base 116.000000, IVA 18.560000, total 134.560000.

pricing_mode viaja en el override, reaparece en el modal y se conserva en conversiones. Sin override se mantiene el fallback del producto/emisor existente.

## 9. Descuentos

Se conserva la regla existente del resumen: el descuento global se calcula desde discount_amount/discount_amount_type y se distribuye proporcionalmente según el bruto de cada partida. La fila pide ahora esa misma asignación a CommercialTaxBreakdownService.

El descuento se resta antes de extraer o sumar impuestos:

- Excluido: 2 × 100, descuento 20, IVA 16% → base 180, IVA 28.80, total 208.80.
- Incluido: 2 × 116, descuento 23.20, IVA 16% → base 180, IVA 28.80, total 208.80.

La base neta por fila coincide con el resumen; el resumen sigue mostrando subtotal previo y descuento por separado.

## 10. Líneas libres

No crean producto automáticamente. Pueden tener product_id=0 y override completo. Si el override está incompleto, se persiste con ready=false/missing y la partida comercial permanece válida. CommercialItemTaxResolver devuelve source=manual_line y blockers concretos hasta completar la configuración.

## 11. Conversiones

ProposalToInvoiceService y EstimateToInvoiceService conservan item_id, descripción, cantidad, unidad, costo, margen, precio, descuento de encabezado y override. El JSON se normaliza a v2 y se corrige product_id. Las líneas libres permanecen con 0. El total de partida se obtiene con FiscalDecimal::multiply, no con float.

## 12. Pruebas ejecutadas

Se ejecutó exclusivamente una suite pura, sin bootstrap CI, conexión DB, migraciones ni red:

    php tests/IncrementC230/run.php

Resultado: 14 aprobadas, 0 fallidas.

Cobertura:

- contrato v2 y completitud derivada;
- línea libre completa e incompleta;
- JSON anterior;
- ObjetoImp 01;
- incluido/excluido;
- descuento incluido/excluido;
- múltiples impuestos y retención;
- modal acotado y parcial único;
- conversiones con contrato/decimal;
- presentación delegando descuento.

También se ejecutó php -l en 18 archivos: sin errores. git diff --check no reportó errores, sólo advertencias preexistentes de conversión LF/CRLF.

## 13. Resultados

- Casos numéricos aprobados a seis decimales.
- Override de línea libre resuelto sin DB/producto.
- JSON legacy recalculado y normalizado.
- No quedan globals del editor activo.
- Proposal, Estimate e Invoice incluyen una sola instancia del componente.
- No hay multiplicación quantity × rate con float en conversiones corregidas.

## 14. Pruebas no ejecutadas

No se ejecutaron C224-C229, C232-C237 ni UX porque sus runners personalizados no demostraron aislamiento completo respecto de ikontrol20_dold_preview y algunos cubren persistencia/fiscal/PAC. Tampoco se guardaron partidas desde navegador porque eso modificaría la base operativa, prohibido por este incremento.

No se ejecutaron migraciones ni se probó PAC/XML/PDF.

## 15. Procedimiento manual exacto pendiente

Ejecutar en una copia temporal de la base:

### Proposal: alta, edición y reapertura

1. Crear Proposal temporal.
2. Abrir Agregar producto; comprobar un solo bloque fiscal.
3. Seleccionar producto y verificar precarga.
4. Activar override, alternar incluido/excluido, agregar IVA/retención y guardar.
5. Reabrir dos veces; verificar filas, valores y un solo evento por click.
6. Crear línea libre, completar override, guardar/reabrir.
7. Crear otra línea libre incompleta; confirmar guardado y estado pendiente.

### Estimate

Repetir exactamente el procedimiento de Proposal y comparar campos/resultado.

### Invoice/Venta

1. Crear venta temporal draft/open.
2. Repetir producto, línea libre completa e incompleta.
3. Confirmar que editar partida no cambia item_fiscal_settings/taxes.
4. Verificar tabla y resumen con descuentos incluido/excluido.
5. Cerrar venta y confirmar que la revisión bloquea sólo la línea incompleta.

### Conversión

1. Convertir Proposal con producto, línea libre y override a venta.
2. Reabrir cada partida destino y comparar JSON/valores/modalidad.
3. Repetir Estimate→Invoice.
4. Comparar subtotal, descuento, traslados, retenciones y total antes/después.

## 16. Riesgos y pendientes

- No hubo prueba real de navegador por la restricción de no modificar base operativa.
- Las columnas comerciales siguen siendo DOUBLE; se evitó nuevo float autoritativo, pero la migración global queda fuera de alcance.
- FiscalDraftTaxSnapshotService conserva su implementación matemática histórica; sus resultados esperados coinciden con el calculador puro en los casos cubiertos, pero conviene consolidarlo en un incremento posterior con fixtures más amplios.
- Los servicios legacy de impuestos de encabezado siguen existiendo, fuera de C2.3.0.
- El componente anterior permanece como adaptador de compatibilidad; el activo es items/_fiscal_item_fields.php.
- Cuotas y combinaciones SAT complejas requieren una matriz de casos de negocio adicional.

## C2.3.0-R1 — Corrección funcional del ciclo AJAX

### Síntomas y causa exacta

- El editor aparecía pero no funcionaba en alta: el parcial dependía de un script inline y de `document.currentScript`. Al insertar la respuesta mediante `$("#ajaxModalContent").html(response)`, ese contexto no era estable y el inicializador podía terminar silenciosamente sin enlazar eventos.
- Agregar impuesto no actuaba porque su handler estaba dentro de ese inicializador fallido. El botón era correcto (`type="button"`), pero no existía listener activo.
- Los endpoints de selección sí devolvían `item_info.fiscal` desde `ProductFiscalConfigurationResolver` y los tres formularios sí emitían `fiscal:item:load`; el listener que debía consumirlo no había quedado inicializado.
- El margen no tenía `required` HTML, pero el JavaScript convertía vacío a cero y podía recalcular el precio; además los tres controladores derivaban y persistían margen siempre que hubiera costo, aunque el margen POST estuviera vacío.

Las pruebas anteriores no detectaron estos defectos porque validaban contrato PHP y cadenas del HTML, pero no el ciclo de inserción AJAX ni la disponibilidad previa del inicializador.

### Ciclo anterior y ciclo corregido

Antes: respuesta AJAX → `html(response)` → dependencia implícita de script inline/currentScript.

Ahora: `assets/js/fiscal_item_editor.js` se carga desde `includes/head.php` antes de abrir modales; `app.js` invoca explícitamente los inicializadores después de insertar la respuesta. Como refuerzo del ciclo real, el asset atiende `ajaxComplete` y `shown.bs.modal`. La función pública `initializeFiscalItemEditors(container)` busca sólo dentro del contenedor, elimina únicamente handlers `.fiscalItem` propios y vuelve a enlazarlos idempotentemente. `initializeCommercialMarginFields(container)` aplica el mismo patrón al margen.

### Soluciones R1

- Primera apertura y línea libre: el editor se inicializa con impuestos vacíos y `item_id=0`; no requiere persistencia previa.
- Producto maestro: cada endpoint usa `ProductFiscalConfigurationResolver`; al recibir `fiscal:item:load` se renderizan setting, ObjetoImp, modalidad y todos los impuestos. Visualizar el maestro no activa override; la primera modificación fiscal sí lo activa.
- Agregar impuesto: binding delegado y acotado a `.fiscal-item-editor`; cada clic crea una sola fila con nombres `fiscal_taxes[n][...]`, eliminación y tratamiento Exento.
- Margen opcional: vacío se conserva como NULL/no informado en los tres controladores y no modifica el precio. Si el usuario proporciona margen, conserva el cálculo auxiliar existente.
- El script inline fiscal anterior quedó con MIME no ejecutable sólo como referencia transitoria; el comportamiento activo reside exclusivamente en el asset estable.

### Archivos modificados en R1

- `assets/js/fiscal_item_editor.js`
- `assets/js/app.js`
- `app/Views/includes/head.php`
- `app/Views/items/_fiscal_item_fields.php`
- `app/Views/items/_commercial_margin_fields.php`
- `app/Controllers/Proposals.php`
- `app/Controllers/Estimates.php`
- `app/Controllers/Invoices.php`
- `tests/IncrementC230/run.php`
- `tests/IncrementC230/R1_BROWSER_CHECKLIST.md`

### Pruebas y estado

Se ampliaron las verificaciones aisladas de contrato para integración del asset, binding idempotente, precarga desde endpoints y margen opcional. El entorno no dispone de Node.js/jsdom/Playwright/Selenium ni navegador headless, por lo que la prueba DOM real queda documentada en `tests/IncrementC230/R1_BROWSER_CHECKLIST.md` y debe ejecutarla el usuario en navegador.

**Estado: Implementado — pendiente de confirmación manual del usuario.**

## 17. Confirmación de alcance

No se modificaron adaptadores PAC, TimbradorXpress, sellado, CSD, XML, PDF, wallet de timbres, créditos PAC, cancelación, complementos, notas de crédito, pagos, egresos, cuentas, autenticación, CSRF global ni tenant. No hubo llamadas externas, consumo de timbres, migraciones, commit ni cambio de rama.
