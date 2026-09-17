---

description: "Tareas para convertir una cotización aceptada en pedido"
---

# Tasks: Convertir una cotización aceptada en pedido

**Input**: Documentos de diseño en `specs/001-cotizacion-a-pedido/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md),
[data-model.md](data-model.md), [contracts/api-interna.md](contracts/api-interna.md)

**Pruebas**: **obligatorias, no opcionales.** El Principio V de la constitución
v1.1.0 exige que la lógica pura nueva entre con su prueba. `Pedido.desdeCotizacion`,
`consumoDeInsumos` y `faltantesDeInventario` son lógica pura, así que sus tareas
de prueba están al mismo nivel que las de implementación.

**Organización**: por historia de usuario, para que cada una se pueda terminar,
probar y usar por separado.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: se puede hacer en paralelo (archivos distintos, sin dependencias)
- **[Story]**: a qué historia pertenece (US1, US2, US3)

## Path Conventions

Proyecto Flutter de un solo módulo: `lib/` y `test/` en la raíz del repositorio.
No aplica la separación backend/frontend.

---

## Phase 1: Setup

**Purpose**: partir de un estado conocido.

- [ ] T001 Verificar que la base está en verde antes de tocar nada: `flutter analyze` sin hallazgos y `flutter test` con las 79 pruebas actuales pasando

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: la regla de conversión y su persistencia. Sin esto ninguna historia
puede funcionar.

**⚠️ CRITICAL**: US1 y US2 dependen por completo de esta fase.

- [ ] T002 Añadir el campo `pedidoId` a `lib/models/cotizacion.dart`: `String pedidoId` con valor por defecto `''`, serializado con la clave `pedidoId`, y al leer `(map['pedidoId'] as String?) ?? ''` para que los documentos existentes no necesiten migración — "la ausencia significa exactamente no convertida"
- [ ] T003 Añadir el getter `bool get convertida => pedidoId.isNotEmpty;` a `lib/models/cotizacion.dart`, que es lo que consultan las pantallas
- [ ] T004 Escribir las pruebas de `Pedido.desdeCotizacion` en `test/conversion_pedido_test.dart`, cubriendo: `precio == cotizacion.total` exacto; línea con producto → ítem con costo y receta; línea sin producto → ítem con costo 0 y receta vacía; producto borrado → se degrada sin fallar; el precio cotizado se conserva aunque el producto haya subido; `otroValor` cuadra el total y puede ser negativo cuando el descuento supera adiciones más domicilio (depende de T005 para compilar)
- [ ] T005 Implementar el constructor `Pedido.desdeCotizacion` en `lib/models/pedido.dart` con la firma de [contracts/api-interna.md](contracts/api-interna.md): puro, sin Firestore ni `DatosApp`. Reglas de [data-model.md](data-model.md): `precioUnitario` es "el cotizado, nunca el actual del producto"; `costoUnitario` y `receta` salen del producto de hoy vía `costoProduccion()` y `consumoPorUnidad()`; sin producto o producto borrado → `costoUnitario = 0` y `receta` vacía; `precio = cotizacion.total`; `otroValor = cotizacion.total − Σ precioTotal de los ítems`; `entregado = false`, `archivado = false`
- [ ] T006 Implementar `DatosApp.convertirCotizacionEnPedido` en `lib/datos_app.dart`: construye con `Pedido.desdeCotizacion`, registra con el `registrarPedido` existente, asigna `pedidoId` a la cotización y la guarda con `guardarCotizacion`. Devuelve `null` si la cotización ya estaba convertida. **No debe tocar inventario** (FR-011)
- [ ] T007 [P] Añadir las cadenas base del diálogo a los cuatro ARB (`lib/l10n/app_es.arb`, `app_en.arb`, `app_pt.arb`, `app_fr.arb`): título, teléfono del cliente, fecha de entrega, botón confirmar, aviso de que el inventario se descuenta al marcar entregado, error de cotización sin líneas o con total cero, y confirmación de pedido creado
- [ ] T008 Ejecutar `flutter gen-l10n` tras T007 y comprobar que el resultado compila
- [ ] T009 Crear el diálogo base en `lib/pantallas/widgets/dialogo_convertir_pedido.dart`: pide teléfono y fecha de entrega, muestra cliente, total y número de ítems, y el aviso de que el descuento ocurre al entregar. Rechaza confirmar sin fecha de entrega (FR-004). Cancelar no escribe nada (FR-017)

**Checkpoint**: la conversión existe y está probada, pero aún no hay dónde dispararla.

---

## Phase 3: User Story 1 - Aceptar y convertir de una vez (Priority: P1) 🎯 MVP

**Goal**: quien cotiza marca la cotización como aceptada y la app le ofrece crear
el pedido en ese momento.

**Independent Test**: cotización con dos productos del catálogo → marcarla
aceptada → completar teléfono y fecha → confirmar → el pedido aparece con el
mismo cliente, los mismos productos y el mismo total, sin haber escrito nada de
eso a mano, y el inventario no cambió.

- [ ] T010 [US1] En `lib/pantallas/editar_cotizacion.dart`, detectar al guardar que el estado quedó en `aceptada` y que `!cotizacion.convertida`, y ofrecer el diálogo de conversión antes de salir de la pantalla
- [ ] T011 [US1] Conectar la confirmación del diálogo con `DatosApp.convertirCotizacionEnPedido` y mostrar la confirmación de pedido creado
- [ ] T012 [US1] Manejar el rechazo del ofrecimiento: la cotización queda `aceptada` y no se crea ningún pedido (escenario 3 de US1)
- [ ] T013 [US1] Impedir la conversión cuando la cotización no tiene líneas o su total es cero, explicando por qué (caso límite del spec)

**Checkpoint**: MVP completo. La conversión ya elimina el trabajo duplicado.

---

## Phase 4: User Story 2 - Convertir más tarde (Priority: P2)

**Goal**: una cotización aceptada hace días se convierte desde la lista, sin
volver a editarla.

**Independent Test**: aceptar una cotización sin convertirla, salir, volver a la
lista y convertirla desde ahí, con el mismo resultado que US1. Al volver a
mirarla, ya no lo ofrece.

- [ ] T014 [US2] En `lib/pantallas/cotizar.dart`, añadir la acción "crear pedido" por fila, visible solo cuando `estado == 'aceptada'` y `!convertida` (FR-002)
- [ ] T015 [P] [US2] Añadir a los cuatro ARB la etiqueta de la acción y la marca de "ya tiene pedido", y ejecutar `flutter gen-l10n`
- [ ] T016 [US2] Mostrar en la lista qué cotizaciones ya generaron pedido, sin ofrecer convertirlas otra vez (FR-015, FR-016)

**Checkpoint**: US1 y US2 funcionan por separado; los dos caminos llegan al mismo pedido.

---

## Phase 5: User Story 3 - Saber qué va a pasar antes de confirmar (Priority: P3)

**Goal**: el resumen distingue qué líneas descontarán inventario y avisa si las
existencias no alcanzan.

**Independent Test**: cotización que mezcle un producto del catálogo con una
línea escrita a mano, con stock insuficiente para el primero → el resumen
distingue ambas líneas, nombra el insumo corto y deja continuar igual.

- [ ] T017 [US3] Escribir las pruebas de `consumoDeInsumos` y `faltantesDeInventario` en `test/conversion_pedido_test.dart`: la suma es `receta[i].cantidad × item.cantidad` agrupada por insumo; los ítems sin receta no aportan nada; `faltantesDeInventario` nombra solo los insumos cuyo stock no cubre el consumo; un insumo que ya no existe en el catálogo **no** se reporta, "tampoco se descuenta al entregar, así que avisar de él confundiría"
- [ ] T018 [US3] Implementar `consumoDeInsumos(Pedido) → Map<String, double>` en `lib/models/pedido.dart`, puro
- [ ] T019 [US3] Implementar `faltantesDeInventario(Pedido, List<Insumo>) → List<String>` en `lib/models/pedido.dart`, puro, devolviendo nombres
- [ ] T020 [US3] Refactorizar `DatosApp.marcarPedidoEntregado` en `lib/datos_app.dart` para que use `consumoDeInsumos` en vez de su bucle propio. **Su comportamiento observable no debe cambiar**: sigue descontando lo mismo, registrando la venta y devolviendo los insumos en negativo. Es lo que evita que el aviso y el descuento real puedan discrepar (D2 de research.md)
- [ ] T021 [P] [US3] Añadir a los cuatro ARB las cadenas del resumen: "estas líneas no descuentan inventario", el aviso de faltantes con los nombres, y la etiqueta del ajuste cuando es negativo; ejecutar `flutter gen-l10n`
- [ ] T022 [US3] Ampliar `lib/pantallas/widgets/dialogo_convertir_pedido.dart` para listar qué líneas descontarán inventario y cuáles no (FR-012)
- [ ] T023 [US3] Mostrar en el diálogo el aviso de faltantes usando `faltantesDeInventario`, **sin bloquear la creación** (FR-013)
- [ ] T024 [US3] Mostrar el ajuste en el resumen cuando resulta negativo, es decir cuando el descuento supera a las adiciones más el domicilio (FR-010)

**Checkpoint**: las tres historias funcionan de forma independiente.

---

## Phase 6: Polish & Cross-Cutting Concerns

- [ ] T025 Puerta del Principio V: `flutter analyze` limpio y `flutter test` entero en verde
- [ ] T026 Recorrer [quickstart.md](quickstart.md) en la app con `flutter run`: camino principal, convertir más tarde, el resumen, y los tres "no debe pasar" (convertir dos veces, mover inventario al convertir, que cancelar deje algo escrito)
- [ ] T027 Probar la conversión **con rol empleado**, como exige el Principio V por tocar datos de negocio. Si sale `PERMISSION_DENIED`, la premisa de D6 era falsa y hay que revisar reglas, UI y la suite de `test/rules` en el mismo cambio
- [ ] T028 Verificar el cierre del ciclo: marcar entregado el pedido convertido y comprobar que descuenta solo los insumos de las líneas con receta y registra la venta

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (T001)**: sin dependencias.
- **Foundational (T002–T009)**: bloquea US1 y US2 por completo.
- **US1 (Phase 3)**: depende de Foundational. Es el MVP.
- **US2 (Phase 4)**: depende de Foundational. No depende de US1.
- **US3 (Phase 5)**: depende de Foundational para el diálogo que amplía. No
  depende de US1 ni de US2.
- **Polish (Phase 6)**: depende de las historias que se decidan entregar.

### Dentro de la fase Foundational

- T004 y T005 van juntas: la prueba se escribe con la implementación, que es lo
  que pide el Principio V. T004 no compila sin T005.
- T006 depende de T005.
- T008 depende de T007.
- T009 depende de T008 (necesita las cadenas generadas).

### Dentro de US3

- T018 y T019 dependen de T017 por el mismo motivo que T004/T005.
- T020 depende de T018.
- T022, T023 y T024 dependen de T019 y T021.

### Parallel Opportunities

- T002 y T003 tocan el mismo archivo (`cotizacion.dart`), así que van seguidas, no
  en paralelo.
- T007 es independiente de T002–T006: se puede adelantar.
- T015 y T021 son de traducciones y no chocan con la lógica.
- Una vez cerrada la fase Foundational, US1, US2 y US3 se pueden repartir.

---

## Implementation Strategy

### MVP primero (solo US1)

1. T001
2. T002–T009 (Foundational)
3. T010–T013 (US1)
4. **PARAR Y VALIDAR**: recorrer el camino principal de quickstart.md
5. A partir de aquí ya se eliminó el trabajo duplicado que motivó todo esto

### Entrega incremental

1. Setup + Foundational → la regla existe y está probada
2. + US1 → se puede convertir al aceptar (MVP)
3. + US2 → se puede convertir después
4. + US3 → el resumen avisa de inventario
5. Polish → se valida en la app y con rol empleado

Cada historia añade valor sin romper la anterior.

---

## Notes

- Las tareas de prueba no son opcionales aquí: la constitución las exige para la
  lógica pura nueva.
- La suite de `test/rules` **no** aplica: esta funcionalidad no toca reglas ni el
  modelo de roles (D6 de research.md). T027 existe precisamente para comprobar
  que esa premisa era cierta.
- Tras tocar cualquier ARB hay que ejecutar `flutter gen-l10n`; por eso aparece
  como tarea propia y no como nota al pie.
- Commit por tarea o por grupo lógico, con mensaje en español.
