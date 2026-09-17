# Phase 0 — Investigación: convertir cotización en pedido

Todo lo que había que averiguar salía del código existente, no de fuentes
externas. Estas son las decisiones que fija esta fase.

---

## D1. Dónde vive la conversión

**Decisión**: un constructor de fábrica `Pedido.desdeCotizacion(...)` en
`lib/models/pedido.dart`, puro y sin Firebase. Recibe la cotización, el
catálogo de productos, el teléfono del cliente y la fecha de entrega, y
devuelve un `Pedido` en memoria. `DatosApp` solo lo persiste con el
`registrarPedido` que ya existe.

**Razón**: el Principio III dice que los modelos son el único lugar que conoce
su forma, y que la lógica derivada no vive en los `build()`. El Principio del
Flujo de Desarrollo exige justificar toda estructura nueva frente a extender
los modelos existentes: aquí no hace falta ni un servicio ni un archivo nuevo.
Además, una función pura es lo único que se puede probar sin emulador, que es
lo que pide el Principio V.

**Alternativas descartadas**:

- *Un archivo `lib/conversion_pedido.dart`*: estructura nueva sin ganancia; el
  modelo destino es el dueño natural de saber cómo se construye.
- *Método en `DatosApp`*: quedaría atado a Firestore y no se podría probar sin
  emulador.
- *`lib/pantallas/cotizacion_util.dart`*: ese archivo es presentación (texto
  para WhatsApp y PDF). Meter ahí una regla de negocio la escondería.

---

## D2. Qué consume un pedido, calculado una sola vez

**Decisión**: extraer a `lib/models/pedido.dart` una función pura
`consumoDeInsumos(Pedido)` que devuelve `Map<insumoId, cantidad>` sumando la
copia de receta de cada ítem por su cantidad. La usan dos sitios: el aviso de
inventario insuficiente al convertir, y el descuento real en
`DatosApp.marcarPedidoEntregado`.

**Razón**: hoy esa acumulación está escrita dentro de `marcarPedidoEntregado`.
Si el aviso la duplicara, el aviso y el descuento podrían discrepar — y un
aviso que miente es peor que no tener aviso. Una sola fuente evita eso, y de
paso deja probable la parte que hoy no lo es.

**Alternativas descartadas**:

- *Duplicar el bucle en la pantalla*: contradice el Principio III y arriesga la
  divergencia descrita.

---

## D3. Cómo se cuadra el dinero

**Decisión**: cada línea con producto vivo se convierte en `ItemPedido` con el
**precio cotizado**; el `costoUnitario` y la receta salen del producto tal como
está hoy. El resto del dinero de la cotización —adiciones, domicilio,
descuento e IVA— se resume en `Pedido.otroValor`, calculado como
`cotizacion.total − Σ(precioTotal de los ítems)`.

**Razón**: por construcción, `Pedido.precio` queda idéntico a
`Cotizacion.total`, que es FR-009 y SC-002. Y separa las dos verdades que
conviven: el precio es una promesa al cliente (se congela), mientras que el
costo y la receta son lo que la cocina va a consumir (se toman de hoy).

**Consecuencia aceptada**: si el descuento supera a las adiciones más el
domicilio, `otroValor` queda negativo. Es aritméticamente correcto y el
resumen lo muestra (FR-010).

**Alternativas descartadas**:

- *Recalcular precios con el catálogo actual*: rompería la promesa hecha al
  cliente y haría que el pedido no cuadre con la cotización impresa.
- *Perder adiciones, domicilio y descuento*: el pedido cobraría distinto de lo
  cotizado.

---

## D4. Cuándo se ofrece convertir

**Decisión**: dos puntos de entrada.

1. En `editar_cotizacion`, al guardar con estado `aceptada` una cotización que
   aún no tiene pedido.
2. En la lista de `cotizar`, una acción por fila para las aceptadas sin pedido.

**Razón**: cubre las historias P1 y P2 del spec, que son el mismo destino desde
momentos distintos. El estado `aceptada` ya existe en `kEstadosCotizacion`; no
hace falta inventar uno nuevo.

**Alternativas descartadas**:

- *Convertir automáticamente al aceptar, sin preguntar*: crea pedidos no
  deseados y contradice FR-017.
- *Un estado nuevo tipo `convertida`*: el enlace al pedido ya registra el
  hecho; un estado paralelo se desincronizaría.

---

## D5. Cómo se registra que ya se convirtió

**Decisión**: campo nuevo `pedidoId` (texto, vacío por defecto) en
`Cotizacion`, serializado con la misma clave. Las cotizaciones viejas lo leen
como cadena vacía.

**Razón**: FR-014 y FR-015. Al ser un campo opcional con valor por defecto, los
documentos existentes en Firestore siguen leyéndose sin migración, a
diferencia del cambio de `unidadesMes` a `lotesMes`, donde el valor viejo
habría significado otra cosa. Aquí la ausencia significa exactamente "no
convertida", que es la verdad.

---

## D6. Permisos

**Decisión**: no se tocan las reglas de seguridad.

**Razón**: convertir es crear un pedido y actualizar una cotización. Las reglas
vigentes ya permiten ambas cosas a cualquier miembro del negocio
(`pedidos: read, create, update` y `cotizaciones: read, create, update` para
`esMiembro`). Coincide con la suposición del spec de que quien puede crear
pedidos puede convertir.

**Consecuencia**: por el Principio V, la suite de `test/rules` **no** es
obligatoria en este cambio, porque no se tocan reglas ni el modelo de roles.
Si durante la implementación apareciera la necesidad de restringir la
conversión a dueño o socio, entonces sí habría que tocar reglas, UI y la suite
de reglas en el mismo cambio.

---

## D7. Textos

**Decisión**: todas las cadenas nuevas entran en los cuatro ARB
(`app_es`, `app_en`, `app_pt`, `app_fr`) en el mismo cambio, y se ejecuta
`flutter gen-l10n`.

**Razón**: Principio I. No es negociable ni se pospone a "luego traduzco".
