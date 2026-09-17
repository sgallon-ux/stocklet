# Contratos internos

Stocklet no expone API a terceros: sus contratos son las superficies que las
pantallas consumen. Esto es lo que la funcionalidad añade o cambia, y lo que
otra parte del código puede dar por estable.

---

## `lib/models/pedido.dart`

### `Pedido.desdeCotizacion` — nuevo

```dart
factory Pedido.desdeCotizacion(
  Cotizacion cotizacion, {
  required List<Producto> productos,
  required String telefono,
  required DateTime fechaEntrega,
  required String descripcionFallback,
})
```

- **Puro**: no toca Firestore, no lee `DatosApp`, no depende del contexto.
- `productos` es el catálogo actual; si una línea referencia un producto que ya
  no está, se degrada a ítem sin receta en lugar de fallar.
- `descripcionFallback` es el texto para una cotización sin líneas, que la
  pantalla saca de las traducciones (el modelo no conoce `AppLocalizations`).
- **Garantiza**: `resultado.precio == cotizacion.total`.

### `consumoDeInsumos` — nuevo

```dart
Map<String, double> consumoDeInsumos(Pedido pedido)
```

Cuánto consume el pedido por insumo, según la copia de receta de cada ítem.
Puro.

### `faltantesDeInventario` — nuevo

```dart
List<String> faltantesDeInventario(Pedido pedido, List<Insumo> insumos)
```

Nombres de los insumos que no alcanzan. Puro. Lista vacía = alcanza todo.

---

## `lib/models/cotizacion.dart`

### `Cotizacion.pedidoId` — campo nuevo

```dart
String pedidoId; // '' = aún no convertida
```

Serializado como `pedidoId`. Ausente al leer → `''`.

### `Cotizacion.convertida` — conveniencia

```dart
bool get convertida => pedidoId.isNotEmpty;
```

Lo que consultan las pantallas para decidir si ofrecen la acción.

---

## `lib/datos_app.dart`

### `convertirCotizacionEnPedido` — nuevo

```dart
Pedido? convertirCotizacionEnPedido(
  Cotizacion cotizacion, {
  required String telefono,
  required DateTime fechaEntrega,
  required String descripcionFallback,
})
```

Orquesta: construye el pedido con `Pedido.desdeCotizacion`, lo registra con el
`registrarPedido` existente, escribe `pedidoId` en la cotización y la guarda.
Devuelve el pedido creado, o `null` si la cotización ya estaba convertida.

- **No descuenta inventario** (FR-011).
- Ambas escrituras van bajo `negocios/{negocioId}` del negocio activo, por la
  vía `_col(...)` que ya usa el resto (Principio II).

### `marcarPedidoEntregado` — cambia por dentro

Pasa a usar `consumoDeInsumos` en vez de su bucle propio. **Su comportamiento
observable no cambia**: sigue descontando lo mismo, registrando la venta y
devolviendo los insumos que quedaron en negativo.

---

## Contrato de UI

| Pantalla | Qué añade |
|---|---|
| `editar_cotizacion` | Al guardar con estado `aceptada` y sin pedido, ofrece convertir antes de salir. |
| `cotizar` (lista) | Acción por fila para aceptadas sin pedido. Marca visible en las ya convertidas. |
| Diálogo de conversión | Pide teléfono y fecha de entrega. Muestra cliente, total, número de ítems, qué líneas descuentan inventario y cuáles no, faltantes de stock si los hay, el ajuste cuando es negativo, y el aviso de que el descuento ocurre al entregar. |

Confirmar es la única acción con efecto. Cancelar no escribe nada (FR-017).

---

## Textos nuevos

Todos en los cuatro ARB, con `flutter gen-l10n` después (Principio I). Cubren:
título y cuerpo del diálogo, etiquetas de teléfono y fecha de entrega, el
aviso de "estas líneas no descuentan inventario", el de faltantes, el de
"se descuenta al entregar", la marca de "ya tiene pedido", el error de
cotización vacía y la confirmación de pedido creado.
