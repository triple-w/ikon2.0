# Complementos de Pago: documentos externos y folio fiscal

## Auditoría

La relación existente `payment_complement_documents` exige un CFDI interno. Contiene UUID, moneda, equivalencia, parcialidad, saldos y referencias administrativas; los impuestos se resuelven desde `fiscal_document_items` y `fiscal_document_item_taxes` mediante `FiscalDocumentHistoricalTaxResolver`. Las capturas externas no pertenecen a `fiscal_draft_*`: son documentos relacionados del pago, no nuevos CFDI de ingreso.

`PaymentComplementFiscalSnapshotService` construye la entrada de `PaymentComplementCfdiMaterializer`. Antes de este cambio, `PaymentComplementFiscalDocumentService` reservaba serie/folio después de construir el XML y guardaba ese XML sin incorporarlos. El proveedor PDF recibía Serie/Folio exclusivamente del XML, explicando el folio vacío.

## Implementación

- `payment_complement_external_documents`: complemento y pago fiscal propietario, UUID, serie, folio, moneda, equivalencia de hasta diez decimales, PPD, objeto de impuesto, parcialidad, saldos, autor, fechas y borrado lógico.
- `payment_complement_external_taxes`: impuestos DR por documento con tipo traslado/retención, base, impuesto, factor, tasa/cuota e importe. No hay JSON de captura.
- `fiscal_documents.invoice_id` admite NULL para complementos exclusivamente externos; no se crea una venta de relleno.
- `PaymentComplementRelatedDocuments` normaliza internos/externos. La resolución y el prorrateo histórico de impuestos internos siguen en el servicio existente.
- `PaymentComplementPaymentBuilder` genera DR e impuestos por pago. Divide importes DR entre EquivalenciaDR, mantiene ImpuestosP en MonedaP y convierte Totales a MXN con TipoCambioP. Las retenciones se agrupan por impuesto; los traslados por impuesto/factor/tasa.
- `MetodoDePagoDR` se captura como PPD para trazabilidad; no se emite como atributo XML porque no pertenece al nodo DoctoRelacionado de Pagos 2.0.
- Validaciones: UUID, catálogo de moneda activo, PPD, parcialidad entera, saldos, equivalencia obligatoria para monedas distintas, objeto 01/02/03, impuestos múltiples, Exento y retenciones. Los importes DR se validan con límites decimales de BaseDR por TasaOCuotaDR; el PAC conserva su validación de catálogos SAT.
- MXN, USD y EUR usan dos decimales en saldos/monto. ImpuestosDR/P conservan hasta seis decimales; no se truncan automáticamente a centavos. La suma aplicada se compara con el pago origen en su moneda.
- Guardado, edición y eliminación son transaccionales, con bloqueo del complemento y pago. Se rechazan ediciones tras timbrado, durante timbrado o con un envío pendiente de conciliación. Se comprueba nuevamente el snapshot antes de materializar.
- El botón “Agregar factura externa” aparece aunque existan facturas internas elegibles. En CFDI relacionados se muestran origen, moneda, editar y quitar. Las nuevas rutas usan autorización administrativa coherente con el menú actual y CSRF en POST.
- Las operaciones externas no escriben invoices, pagos administrativos, aplicaciones ni movimientos financieros.

## Serie/Folio e históricos

La materialización incorpora al XML nuevo la misma Serie/Folio que acaba de persistir en `fiscal_documents`. Para PDF de tipo P, `FiscalPdfPrintMetadataBuilder` utiliza esos campos persistidos. Al regenerar un PDF anterior se conservan UUID y XML timbrado; no se intenta cambiar un CFDI firmado.

La vista previa de un complemento timbrado lee su XML almacenado y su documento fiscal. No vuelve a construirlo con perfiles/configuración actuales. Se corrigió además el namespace Pagos20 del lector de impresión.

## Archivos

Nuevos:

- `app/Database/Migrations/2026-09-28-120000_CreatePaymentComplementExternalDocuments.php`
- `app/Services/PaymentComplementExternalDocumentService.php`
- `app/Services/PaymentComplementRelatedDocuments.php`
- `app/Services/PaymentComplementPaymentBuilder.php`
- `app/Views/payment_complements/external_form.php`
- `tests/PaymentComplementExternalDocuments/run.php`
- `tests/PaymentComplementExternalDocuments/validation.php`
- Este documento.

Modificados:

- `app/Config/Routes.php`
- `app/Controllers/Payment_complements.php`
- `app/Services/PaymentComplementDraftService.php`
- `app/Services/PaymentComplementReadinessService.php`
- `app/Services/PaymentComplementFiscalSnapshotService.php`
- `app/Services/PaymentComplementCfdiMaterializer.php`
- `app/FiscalServices/PaymentComplementFiscalDocumentService.php`
- `app/FiscalServices/PaymentComplementPrintDataBuilder.php`
- `app/Services/Fiscal/Pdf/FiscalPdfPrintMetadataBuilder.php`
- `app/Views/payment_complements/edit.php`
- `tests/PaymentComplementStamping/run.php` (versión del snapshot 8).

## Verificación y despliegue

La migración está aplicada en la base local y debe ejecutarse en el servidor antes de habilitar este código. Usar el procedimiento habitual de migraciones del proyecto; no es necesario modificar plantillas PDF ni crear facturas administrativas. El cálculo decimal utiliza BCMath. Un PDF ya almacenado debe regenerarse para recibir los metadatos corregidos.

Pruebas sobre copias aisladas de la base local, PAC falso y proveedor PDF simulado:

| Caso | Resultado |
|---|---|
| Sólo factura iKontrol | Preparación, XML, timbrado falso e idempotencia correctos |
| Sólo externo | Timbrado falso con `invoice_id = NULL` |
| Mixto | Internos y externos en la misma lista DR y control de capacidad |
| Externo MXN | Edición y saldo insoluto correctos |
| Moneda distinta | Equivalencia obligatoria; 50 USD / 0.05 consume 1,000 MXN |
| Impuestos DR | Traslados, retenciones y precisión preservados |
| Pago mayor que saldo anterior | Rechazo |
| Aplicación mayor que pago disponible | Rechazo y rollback |
| PA / 123 | XML, metadatos y contenido de PDF renderizado correctos |
| XML timbrado externo | UUID externo e ImpuestosDR presentes |
| Inmutabilidad | Edición/eliminación rechazadas tras timbrado |
| Contabilidad | Hashes administrativos iguales antes/después |

Comandos (ejecutar las suites de timbrado secuencialmente, pues los bloqueos MySQL existentes usan IDs compartidos entre bases):

```text
php tests/PaymentComplementExternalDocuments/run.php
php tests/PaymentComplementExternalDocuments/validation.php
php tests/PaymentComplementStamping/run.php
php tests/PaymentComplementsPhase3/run.php
php tests/PaymentComplementsFiscalUx/run.php
php tests/FiscalPdfRegeneration/run.php
```

Resultados: 60 comprobaciones de integración externa, 12 de validación, 32 de timbrado existente, 41 de preparación, 14 de UX fiscal y 15 de regeneración PDF: **174 aprobadas, cero fallos en las ejecuciones finales**. PHP lint y git diff --check también pasaron. Una ejecución simultánea de las dos suites de timbrado chocó con el bloqueo MySQL compartido; se repitió secuencialmente y pasó.

La prueba PDF usa el servicio de generación y persistencia real con un adaptador local. Deja `writable/payment-complement-validation/PA-123.pdf`, marcado SIN VALIDEZ FISCAL. No se contactó al PAC real ni al proveedor remoto; falta esa comprobación después del despliegue. Se renderizó el modal en pruebas PHP; no se ejecutó una sesión interactiva de navegador.

Referencia técnica: [Estándar SAT Pagos 2.0](https://wwwmat.sat.gob.mx/cs/Satellite?blobcol=urldata&blobkey=id&blobtable=MungoBlobs&blobwhere=1461175070885&ssbinary=true), secciones EquivalenciaDR, ImpuestosDR, ImpuestosP y Totales. También se utilizó el XSD SAT incluido en `resources/fiscal/sat/pagos20/Pagos20.xsd`.
