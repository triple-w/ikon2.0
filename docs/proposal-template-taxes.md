# Salida fiscal de Proposals

## Uso en la plantilla existente

No es necesario rediseñar ni reemplazar la plantilla. Conservar `{PROPOSAL_ITEMS}` y usar:

```text
Subtotal: {PROPOSAL_SUBTOTAL}
Descuento: {PROPOSAL_DISCOUNT}
Base después de descuento: {PROPOSAL_TOTAL_AFTER_DISCOUNT}
Impuestos: {PROPOSAL_TAXES}
Total: {PROPOSAL_GRAND_TOTAL}
```

La presencia de `{PROPOSAL_TAXES}` o `{PROPOSAL_GRAND_TOTAL}` activa la salida fiscal. Ambos aparecen en Variables disponibles.

`{PROPOSAL_TOTAL}` conserva exactamente el resumen anterior (partidas + impuestos legacy de encabezado − descuento). No usarlo como total final en la plantilla fiscal. No se modificaron plantillas guardadas ni registros históricos. Para una Proposal ya creada, actualizar también su contenido si conserva el placeholder antiguo.

## Datos y columnas

`prepare_proposal_view()` utiliza `ProposalTemplateFiscalService`, que consume `CommercialTaxBreakdownService` y el presentador de `CommercialItemTaxDisplayService`. Ambos comparten `CommercialItemTaxResolver` con la UI. No hay cálculo de tasas en el partial.

| Columna | Origen |
| --- | --- |
| Imagen | La imagen actual; data URI local validada en PDF |
| Producto o servicio | Título y descripción actuales |
| Cantidad | Cantidad y unidad actuales |
| Precio sin impuestos | `unit_base`, igual que la UI: base fiscal resuelta / cantidad |
| Impuestos | Todas las filas fiscales resueltas; código, tasa/factor e importe. Retenciones negativas |
| Total | `total` resuelto por el motor para la partida |

Con descuento, `unit_base` sigue la semántica actual de la UI (base neta por unidad). El subtotal, descuento y total general proceden del resumen canónico; no se suman otra vez los impuestos legacy de encabezado. `{PROPOSAL_TAXES}` expresa traslados menos retenciones. Una configuración fiscal incompleta produce un error explícito y no se presenta como impuesto cero.

## Redondeo detectado

- Base exacta `10545.45`: IVA `1687.27`, partida y resumen `12232.72`.
- Base interna `10545.454545`: precio mostrado `10545.45`, IVA mostrado `1687.27`, partida `12232.73`; resumen canónico actual `12232.72`.

La diferencia de un centavo entre partida y resumen ya existe en el motor: la partida conserva seis decimales y el resumen redondea los componentes antes de sumar. Esta corrección reutiliza ambos resultados sin cambiar el motor ni inventar ajustes. No se puede garantizar un resumen de `12232.73` para una base exacta de `10545.45` y un impuesto de `1687.27`.

La Proposal real (10 u 11) está en el servidor del usuario y no fue consultada ni modificada.

## Validación

```powershell
php tests/ProposalTemplateTaxes/run.php
php -d upload_tmp_dir=C:/xampp/htdocs/ikontrol2/ikon2.0/writable tests/ProposalPdfConversion/run.php
```

La suite fiscal usa un repositorio en memoria sin tocar bases de datos ni PAC. Ejecuta los servicios fiscales reales, el parser, el partial y TCPDF. Cubre impuesto cero, productos con distintas tasas, descuentos fijos y porcentuales, múltiples impuestos, retenciones, precios incluidos/excluidos, cost_margin, overrides, cantidad mayor que uno, cuotas, exentos, compatibilidad histórica y configuración incompleta.

Verifica igualdad de texto/importes entre preview y HTML para PDF, importes dentro del PDF binario y objetos de imagen incrustados. La suite existente verifica PNG/JPEG, imágenes inválidas, saltos de página y el flujo de conversión. No se hizo inspección visual en navegador del servidor.

Artefactos locales de prueba: `writable/proposal-tax-preview.html` y `writable/proposal-tax-preview.pdf`.
