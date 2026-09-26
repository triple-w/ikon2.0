# Proposal: resumen fiscal y selección persistente

## Diagnóstico

La carga inicial `Proposals::view()` usa `get_proposal_making_data()`. Antes solo llevaba `proposal_total_summary` legacy. El partial `proposal_total_section.php` usaba el breakdown únicamente si estaba presente; `_get_proposal_total_view()` sí lo enviaba tras operaciones AJAX. Esto explicaba un total distinto al cargar/recargar. Además, la condición del descuento permitía cero y comparaba el decimal con el entero `0` usando `!==`.

El botón Guardar y mostrar disparaba submit y preview de inmediato en `proposals/view.php`. El POST podía abortarse o completarse después de que el preview leyera contenido anterior. `save_view()` respondía éxito sin verificar el guardado. No se puede inferir si un POST concreto del servidor persistió a partir de ERR_ABORTED.

El sistema guardaba solo `proposals.content`; no tenía ID de plantilla seleccionado. El default solo se copiaba al crear la Proposal. Preview interno, enlace público y PDF ya leían ese snapshot, sin resolver nuevamente el default. Cambiar de plantilla en el modal solo cambiaba el editor hasta guardar.

## Implementación

- `ProposalTotalsService` presenta el breakdown canónico: `subtotal`, `discount`, `after_discount`, `tax_total` (traslados − retenciones) y `grand_total`. No calcula tasas ni altera partidas.
- Carga inicial y AJAX entregan esos valores al mismo partial administrativo. Se ocultan las dos filas de descuento con cero; el botón para editar/agregar descuento sigue disponible. Una configuración fiscal incompleta se identifica como pendiente, sin presentar un total legacy como total fiscal.
- `ProposalTemplateFiscalService` usa el mismo servicio para preview/PDF fiscales. Los placeholders y la presentación legacy permanecen separados: una plantilla sin impuestos puede ocultarlos sin cambiar los datos económicos reales.
- La conversión sigue copiando los campos comerciales/fiscales y descuentos. Compara subtotal, descuento, impuestos netos y total entre Proposal y Sale antes del commit de aceptación. Una discrepancia fiscal provoca rollback; los documentos legacy sin configuración completa conservan su compatibilidad previa.
- La migración agrega `proposals.proposal_template_id` nullable sin reescribir contenido ni inferir IDs históricos. Creación con default y clonación conservan el ID correspondiente.
- Al seleccionar plantilla se carga su contenido y se guardan ID + snapshot en una sola actualización. Solo se cierra el selector cuando el guardado tiene éxito. Ediciones posteriores conservan el ID; cambios globales a la plantilla no reescriben snapshots.
- Guardar y mostrar espera confirmación del POST y lectura de verificación. Peticiones duplicadas se coordinan; errores de red/servidor no navegan. No se agregaron timeouts. El editor informa de una navegación manual mientras existe un guardado pendiente.

## Despliegue y comprobación del servidor

Aplicar mediante el flujo habitual de migraciones de la aplicación la migración:

`2026-09-25-120000_AddProposalTemplateSelection.php`

El runner del proyecto es `php spark migrate -n App` (revisar primero `php spark migrate:status`, pues ejecuta las migraciones App pendientes). La migración fue probada en SQLite en memoria; no se aplicó a la base del servidor.

Ejecutar en el servidor, antes y después de seleccionar la plantilla:

```shell
php spark proposals:audit-presentation 5
```

Es de solo lectura: informa ID persistido, placeholders de `proposals.content`, coincidencias exactas con templates activos, y totales canónicos. Para cada template indica `fiscal_template_valid`, placeholders faltantes y tokens legacy. No expone el HTML completo ni credenciales.

La plantilla “cotizacion impuestos” debe contener `PROPOSAL_ITEMS_WITH_TAXES`, `PROPOSAL_SUBTOTAL`, `PROPOSAL_DISCOUNT_ROW`, `PROPOSAL_TOTAL_AFTER_DISCOUNT_ROW`, `PROPOSAL_TAXES`, `PROPOSAL_GRAND_TOTAL`, sin `PROPOSAL_ITEMS` ni `PROPOSAL_TOTAL`. Si el diagnóstico no lo confirma, corregir únicamente su bloque económico con [proposal-with-taxes.html](proposal-with-taxes.html), conservando su diseño. Después seleccionarla en Proposal 5 para guardar su snapshot. No modificar “Cotizacion”.

No se consultaron ni modificaron los templates o Proposal 5 del servidor; sus IDs y contenido concreto siguen sin verificarse remotamente.

## Validación

```shell
php tests/ProposalTemplateTaxes/run.php
php -d extension=sqlite3 tests/ProposalTemplatePersistence/run.php
node tests/ProposalTemplatePersistence/save-flow.js
php -d upload_tmp_dir=C:/xampp/htdocs/ikontrol2/ikon2.0/writable tests/ProposalPdfConversion/run.php
```

Los tests cubren UI con IVA independientemente de la plantilla, cambio y lectura nueva de ID/snapshot, contenido fiscal para preview/PDF, selección legacy, descuentos cero/positivos, retenciones, imágenes PDF, mismas cuatro cantidades en resolvers Proposal/Sale, rechazo de discrepancias, guardados fallidos, migración repetible e inexistencia de fallback. El enlace público comparte el loader y renderer, comprobado en código; no se realizó navegación autenticada o pública contra el servidor.

Caso solicitado: subtotal `10545.50`, descuento `0.00`, impuestos `1687.28`, total `12232.78`. Con base `100`, descuento `10`: base neta `90`, impuesto `14.40`, total `104.40`.

## Archivos de esta corrección

- `app/Controllers/Proposals.php`
- `app/Controllers/Proposal_templates.php`
- `app/Helpers/general_helper.php`
- `app/Services/ProposalTotalsService.php` (nuevo)
- `app/Services/ProposalTemplateSelectionService.php` (nuevo)
- `app/Services/ProposalTemplateFiscalService.php`
- `app/Services/ProposalToInvoiceService.php`
- `app/Views/proposals/details.php`
- `app/Views/proposals/view.php`
- `app/Views/proposals/proposal_editor.php`
- `app/Views/proposals/proposal_total_section.php`
- `assets/js/proposal_editor_save.js` (nuevo)
- `app/Database/Migrations/2026-09-25-120000_AddProposalTemplateSelection.php` (nuevo)
- `app/Commands/ProposalsAuditPresentation.php` (nuevo)
- `tests/ProposalTemplateTaxes/run.php`
- `tests/ProposalTemplatePersistence/run.php` (nuevo)
- `tests/ProposalTemplatePersistence/save-flow.js` (nuevo)
- `docs/proposal-ui-template-persistence.md` (nuevo)
- `writable/proposal-tax-preview.html` y `writable/proposal-tax-preview.pdf` (artefactos regenerados)

Resultado local: 222 comprobaciones fiscales/persistencia, 26 de PDF, 3 de migración/base de datos y 4 escenarios asíncronos aprobados. Sintaxis PHP/JavaScript validada y `git diff --check` sin errores. Las pruebas de Sale ejercitan ambos resolvers y el rechazo de discrepancias sobre datos controlados; no crean una venta real en el servidor. La persistencia se prueba con lecturas nuevas de una base SQLite en memoria, no con una sesión de navegador remoto.
