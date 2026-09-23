# Templates de Proposals: dos presentaciones

La plantilla es una elección visual del usuario. Tener IVA no selecciona una plantilla ni cambia impuestos guardados.

## Uso y compatibilidad

- `{PROPOSAL_ITEMS}` conserva las cinco columnas legacy y su resumen. No agrega columna fiscal aunque se soliciten otros placeholders fiscales. La plantilla sin impuestos no necesita cambios.
- `{PROPOSAL_ITEMS_WITH_TAXES}` muestra Imagen, Producto o servicio, Cantidad, Precio sin impuestos, Impuestos y Total. Solo contiene encabezado y partidas, sin resumen.
- `{PROPOSAL_DISCOUNT_ROW}` y `{PROPOSAL_TOTAL_AFTER_DISCOUNT_ROW}` devuelven una fila `<tr>` de dos celdas únicamente cuando el descuento del resumen es positivo. Con cero devuelven cadena vacía.

Los tres placeholders nuevos están en Variables disponibles. Las filas deben colocarse directamente dentro de la tabla de resumen, sin otro `<tr>` o `<p>` alrededor.

[proposal-with-taxes.html](proposal-with-taxes.html) contiene el fragmento para incorporar al cuerpo de la segunda plantilla, conservando su encabezado, pie y diseño. Usa la tabla fiscal y un único resumen: Sub Total, filas condicionales, Impuestos y Total (`PROPOSAL_GRAND_TOTAL`). No se insertaron plantillas en BD ni se modificaron documentos históricos.

La versión anterior activaba columnas fiscales de `PROPOSAL_ITEMS` al detectar `TAXES` o `GRAND_TOTAL`. Esa activación implícita se elimina. Para adaptar una plantilla fiscal creada con esa versión, sustituir `PROPOSAL_ITEMS` por `PROPOSAL_ITEMS_WITH_TAXES`, el total final por `PROPOSAL_GRAND_TOTAL` y las filas fijas de descuento por las nuevas variables de fila. Si la Proposal ya guarda una copia del contenido, actualizar también esa copia mediante su editor.

## Semántica económica exacta

Solicitar `ITEMS_WITH_TAXES`, `TAXES`, `GRAND_TOTAL` o cualquiera de las nuevas filas solicita datos al motor fiscal. Esto no cambia las columnas de `PROPOSAL_ITEMS` ni los impuestos persistidos. Las plantillas antiguas que solo usan variables legacy conservan sus importes previos.

| Placeholder | Contexto fiscal | Contexto legacy |
| --- | --- | --- |
| `PROPOSAL_SUBTOTAL` | Subtotal canónico: suma monetaria de base neta resuelta más descuento de cada partida, antes del descuento e impuestos del resumen | Suma de totales guardados de partidas |
| `PROPOSAL_DISCOUNT` | Descuento del resumen canónico | Descuento del resumen legacy |
| `PROPOSAL_TOTAL_AFTER_DISCOUNT` | Subtotal canónico menos descuento canónico | Subtotal legacy menos descuento legacy |
| `PROPOSAL_TAXES` | Traslados menos retenciones, con signo | Solicita contexto fiscal |
| `PROPOSAL_GRAND_TOTAL` | Total canónico: subtotal − descuento + traslados − retenciones | Solicita contexto fiscal |
| `PROPOSAL_TOTAL` | Siempre conserva el total legacy | Partidas + impuestos antiguos de encabezado − descuento legacy |

`PROPOSAL_TOTAL` no es necesariamente un total sin impuestos ni equivale al total fiscal por partida; no usarlo como total final de la nueva plantilla. Las reglas antiguas de descuento antes/después de impuestos siguen en el resumen legacy. El resumen fiscal conserva el prorrateo y las reglas vigentes de `CommercialTaxBreakdownService`, sin reinterpretarlas en la presentación.

## Origen de las columnas

Se reutilizan `ProposalTemplateFiscalService`, `CommercialTaxBreakdownService`, `CommercialItemTaxDisplayService` y `CommercialItemTaxResolver`; no se calcula IVA en las vistas.

| Columna | Fuente |
| --- | --- |
| Imagen | Imagen existente, con data URI local validada para PDF |
| Producto o servicio | Título y descripción existentes |
| Cantidad | Cantidad y unidad existentes |
| Precio sin impuestos | `unit_base`, base neta fiscal resuelta / cantidad, igual que la UI |
| Impuestos | Todas las filas fiscales resueltas, incluidos factor, tasa e importe; retenciones negativas |
| Total | Total de partida resuelto por el motor |

Con descuento, el precio unitario sigue la semántica de la UI (base neta por unidad). Una configuración fiscal incompleta no se presenta como impuesto cero: la salida fiscal devuelve un error explícito. La presentación legacy no requiere resolver esa configuración.

## Resultados y redondeo

- Base `10545.50`, IVA `1687.28`, total de partida y resumen `12232.78`. Sin descuento: solo Sub Total, Impuestos y Total.
- Base `100`, descuento `10`, base neta `90`, IVA `14.40`, total `104.40`. Aparecen las cinco filas del resumen.
- Sin impuestos, base `100`: impuestos `0.00`, total `100.00`.
- La diferencia preexistente con seis decimales se conserva: base interna `10545.454545` muestra partida `12232.73`, pero el resumen canónico redondea sus componentes y devuelve `12232.72`. Con base exacta `10545.45`, ambos devuelven `12232.72`. No se alteró el motor para ajustar centavos.

## Pruebas

```powershell
php tests/ProposalTemplateTaxes/run.php
php -d upload_tmp_dir=C:/xampp/htdocs/ikontrol2/ikon2.0/writable tests/ProposalPdfConversion/run.php
```

La suite fiscal usa un repositorio en memoria, servicios fiscales reales, parser, partials y TCPDF. Cubre A–F, múltiples impuestos, retenciones, descuentos fijos/porcentuales, precios incluidos/excluidos, cost_margin, overrides, cantidades, cuotas y exentos. Con DOM comprueba que la tabla fiscal solo contiene encabezado y partidas, que existe un único resumen y que las filas condicionales están en el orden requerido. Comprueba también ambos placeholders juntos y que solicitar totales fiscales no agrega columnas a la tabla legacy.

HTML y PDF contienen los mismos datos económicos. Se verifican importes en el PDF binario e imágenes incrustadas. La regresión existente cubre PNG/JPEG, imágenes inválidas y saltos de página. No se validó visualmente la instancia del servidor.

Artefactos locales del caso `10545.50`: `writable/proposal-tax-preview.html` y `writable/proposal-tax-preview.pdf`.
