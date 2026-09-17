# Phase 1 — Modelo de datos

Solo una entidad cambia de forma. El resto se leen o se construyen.

---

## Cotización — un campo nuevo

`lib/models/cotizacion.dart`

| Campo | Tipo | Cambio | Regla |
|---|---|---|---|
| `pedidoId` | `String` | **nuevo** | Vacío = aún no convertida. Con valor = id del pedido que generó. |

- Se serializa con la clave `pedidoId`.
- Al leer, ausente → `''`. Los documentos existentes no necesitan migración:
  la ausencia significa exactamente "no convertida".
- Una vez con valor, no se vacía. Eliminar el pedido no lo limpia (ver
  *Decisiones abiertas*).

**Invariante**: `pedidoId` no vacío ⟹ la cotización no puede volver a
convertirse (FR-015).

---

## Pedido — un constructor nuevo

`lib/models/pedido.dart`. La forma del pedido **no cambia**; se añade cómo
construirlo a partir de una cotización.

### `Pedido.desdeCotizacion`

Entradas:

| Entrada | De dónde sale | Para qué |
|---|---|---|
| `cotizacion` | el documento aceptado | líneas, cliente, total |
| `productos` | catálogo actual del negocio | costo y receta de hoy |
| `telefono` | lo escribe la persona | `Cliente` exige nombre y teléfono |
| `fechaEntrega` | lo escribe la persona | el pedido lo exige |

Reglas de construcción:

1. `cliente` = `Cliente(nombre: cotizacion.cliente, telefono: telefono)`.
2. `fechaPedido` = ahora. `fechaEntrega` = la indicada.
3. Cada `LineaCotizacion` produce un `ItemPedido`:
   - `nombre` y `cantidad`: los de la línea.
   - `precioUnitario`: **el cotizado**, nunca el actual del producto (FR-006).
   - Si la línea tiene `productoId` y ese producto existe hoy:
     `costoUnitario` = `producto.costoProduccion()`, `receta` =
     `producto.consumoPorUnidad()` (FR-007).
   - Si no lo tiene, o el producto fue borrado: `costoUnitario` = 0,
     `receta` = vacía (FR-008). Esa línea no descontará inventario.
4. `precio` = `cotizacion.total` (FR-009).
5. `costo` = Σ `costoTotal` de los ítems.
6. `otroValor` = `cotizacion.total − Σ precioTotal de los ítems`. Puede ser
   negativo (FR-010).
7. `descripcion` = las líneas como `"2x Torta, 12x Galleta"`, igual que hace
   hoy la pantalla de crear pedido.
8. `entregado` = false, `archivado` = false. **No se toca inventario**
   (FR-011).

**Invariante de dinero**: `precio == cotizacion.total`, exacto. Es SC-002 y es
lo que fija la prueba.

---

## Consumo de insumos — una función compartida

`lib/models/pedido.dart`, pura.

### `consumoDeInsumos(Pedido) → Map<String, double>`

Suma, para cada ítem, `receta[i].cantidad × item.cantidad`, agrupando por
`insumoId`. Los ítems sin receta no aportan nada.

Dos consumidores, un solo cálculo:

- El aviso de inventario insuficiente al convertir (FR-013).
- El descuento real en `DatosApp.marcarPedidoEntregado`, que hoy lleva ese
  bucle escrito dentro y pasa a usar esta función.

### `faltantesDeInventario(Pedido, List<Insumo>) → List<String>`

Devuelve los **nombres** de los insumos cuyo stock actual no cubre lo que el
pedido consumiría. Un insumo que ya no existe en el catálogo no se reporta:
tampoco se descuenta al entregar, así que avisar de él confundiría.

Es informativa: no bloquea (FR-013, y la suposición del spec de que entre
convertir y entregar suele haber compras).

---

## Entidades que solo se leen

| Entidad | Uso |
|---|---|
| `Producto` | costo y receta de hoy, vía `costoProduccion()` y `consumoPorUnidad()` |
| `Insumo` | stock actual para el aviso |
| `LineaCotizacion` | origen de cada ítem; su `productoId` decide si descuenta inventario |
| `AdicionCotizacion` | entra en el total, no genera ítem propio |

---

## Transiciones de estado

La cotización mantiene sus estados (`borrador`, `enviada`, `aceptada`,
`entregada`, `rechazada`). La conversión **no los cambia**: entra estando
`aceptada` y sigue `aceptada`. Lo único que se mueve es `pedidoId`.

```
aceptada + pedidoId vacío   --convertir-->   aceptada + pedidoId asignado
        (ofrece convertir)                        (ya no lo ofrece)
```

---

## Decisiones abiertas, resueltas por defecto

- **Editar la cotización después de convertir** no modifica el pedido. Son
  documentos independientes (suposición del spec).
- **Eliminar el pedido** no limpia `pedidoId`, así que la cotización no vuelve
  a ofrecer conversión. Se prefiere el falso negativo —obliga a crear el
  pedido a mano— antes que arriesgar pedidos duplicados por accidente.
