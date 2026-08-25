# C2.3.2 — Contrato de fecha de expedición del borrador fiscal

Estado: `Implementado — pendiente de validación manual del usuario`

## Causa exacta

El GET `fiscal/drafts/create/{sale}` generaba `issue_date` como `Y-m-d\TH:i`. `FiscalReviewPreparation` reemplazaba `T` por espacio sin agregar segundos y entregaba `Y-m-d H:i` a `FiscalIssueDatePolicy`. La política sólo aceptaba `Y-m-d H:i:s` o `Y-m-d\TH:i`, por lo que el GET declaraba inválido su propio valor. En guardado existía otra normalización manual distinta.

El campo exacto es `issue_date`. El input de `review.php` sí tenía `name="issue_date"`; no existe otro input hidden con ese nombre. Jam no mostró el atributo aunque está presente en la vista.

## Contrato final

- Interfaz y valor predeterminado: `Y-m-d\TH:i`, en `<input type="datetime-local" name="issue_date">`.
- Transporte: se aceptan estrictamente `Y-m-d\TH:i` y `Y-m-d\TH:i:s`; no formatos localizados, fechas inexistentes ni horas imposibles.
- Dominio: `DateTimeImmutable`, `createFromFormat()` estricto con comprobación de errores y round trip.
- Zona horaria: `config('App')->appTimezone`, actualmente `America/Mexico_City`.
- Persistencia y snapshot: `Y-m-d H:i:s`; minutos sin segundos agregan `:00`.
- CFDI posterior: conserva la forma canónica con segundos. XML y PAC no fueron modificados ni ejecutados.

Vacío, formato, futuro y antigüedad producen mensajes distintos. Nunca se sustituye una entrada inválida por `now()`.

## Traza y archivos

`Drafts::defaultReviewInput()` genera la hora empresarial actual y no hereda fecha de Estimate, Proposal o cotización. `review.php` serializa el único `issue_date`; `Drafts::store()` recibe el POST como JSON funcional. No existe DTO/command intermedio: el command efectivo es el array de `FiscalDraftWorkflowService::save()`. `FiscalIssueDateNormalizer` normaliza; `FiscalDraftValidationService`/`FiscalIssueDatePolicy` validan; `FiscalReviewPreparation` usa el mismo contrato en el GET; el workflow persiste en `fiscal_drafts.issue_date` y `fiscal_payload`; el preflight revalida la forma canónica. Al reabrir, ambas vistas convierten a interfaz sin `strtotime()`.

Archivos: `FiscalIssueDateNormalizer.php`, `FiscalIssueDatePolicy.php`, `FiscalReviewPreparation.php`, `FiscalDraftWorkflowService.php`, `FiscalDraftValidationService.php`, `Drafts.php`, `review.php`, `form.php` y `tests/IncrementC232IssueDate/run.php`.

## Pruebas

Ejecutado `php tests/IncrementC232IssueDate/run.php`: 11 aprobadas, 0 fallidas. Ejecutados también `IncrementC233`: 32/32 y `IncrementC237`: 23/23; este último comprueba explícitamente cero llamadas PAC y cero consumo de timbres. La cobertura incluye minutos, segundos, round trip, vacío, fecha inexistente, formato localizado, valor arbitrario, hora imposible, HTML sin campos contradictorios y apertura HTTP de la revisión.

La petición POST autenticada real sobre venta 14 y su comprobación visual quedan pendientes de validación manual para no crear ni alterar datos operacionales del usuario durante la automatización. No se realizaron llamadas externas, XML, timbrado ni consumo de timbres.
