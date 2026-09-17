# Feature Specification: Convertir una cotización aceptada en pedido

**Feature Branch**: `001-cotizacion-a-pedido`

**Created**: 2026-09-17

**Status**: Draft

**Input**: Convertir una cotización aceptada en pedido sin volver a capturar los
datos. Hoy, cuando un cliente acepta una cotización, hay que crear el pedido a
mano desde cero, repitiendo cliente, productos, cantidades y precios.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Aceptar y convertir de una vez (Priority: P1)

Quien cotiza recibe el "sí" del cliente, marca la cotización como aceptada y la
app le ofrece crear el pedido en ese mismo momento. Solo tiene que completar el
teléfono del cliente y la fecha de entrega; todo lo demás —productos,
cantidades, precios, adiciones, domicilio, descuento e impuestos— viaja solo.

**Why this priority**: Es el momento en que el trabajo duplicado ocurre hoy.
Resolverlo aquí elimina la causa completa; el resto de historias son caminos
alternativos al mismo destino.

**Independent Test**: Tomar una cotización con dos productos del catálogo,
marcarla aceptada, completar teléfono y fecha, confirmar, y verificar que el
pedido aparece en la lista de pedidos con el mismo cliente, los mismos
productos y el mismo total, sin haber escrito nada de eso a mano.

**Acceptance Scenarios**:

1. **Given** una cotización con productos del catálogo y estado distinto de
   aceptada, **When** la persona la marca como aceptada y guarda, **Then** la
   app le ofrece crear el pedido antes de salir de la pantalla.
2. **Given** el ofrecimiento de crear el pedido, **When** la persona completa
   teléfono y fecha de entrega y confirma, **Then** se crea un pedido con el
   mismo cliente, los mismos productos y cantidades, y un total idéntico al
   cotizado.
3. **Given** el ofrecimiento de crear el pedido, **When** la persona lo
   rechaza, **Then** la cotización queda aceptada y no se crea ningún pedido.
4. **Given** una cotización recién convertida, **When** la persona consulta el
   inventario, **Then** las existencias no han cambiado.

---

### User Story 2 - Convertir más tarde (Priority: P2)

Una cotización se aceptó hace días y todavía no tiene pedido. La persona la
encuentra en la lista y crea el pedido desde ahí, sin tener que volver a
editarla ni cambiarle el estado.

**Why this priority**: Aceptar y convertir no siempre pasan en el mismo
momento: el cliente confirma por WhatsApp un martes y el pedido se arma el
jueves. Sin esta historia, ese caso vuelve a la captura manual.

**Independent Test**: Marcar una cotización como aceptada sin convertirla,
salir, volver a la lista y verificar que ofrece crear el pedido, con el mismo
resultado que la historia 1.

**Acceptance Scenarios**:

1. **Given** una cotización aceptada sin pedido asociado, **When** la persona
   abre la lista de cotizaciones, **Then** esa cotización ofrece la acción de
   crear el pedido.
2. **Given** una cotización que ya generó un pedido, **When** la persona la ve
   en la lista, **Then** se indica que ya tiene pedido y no se ofrece crearlo
   otra vez.
3. **Given** una cotización que no está aceptada, **When** la persona la ve en
   la lista, **Then** no se ofrece crear el pedido.

---

### User Story 3 - Saber qué va a pasar antes de confirmar (Priority: P3)

Antes de crear el pedido, la persona ve un resumen: a quién es, cuánto suma,
cuántos ítems lleva, qué líneas van a descontar inventario cuando se entregue y
cuáles no, y si las existencias de hoy alcanzarían para cumplirlo.

**Why this priority**: Evita dos sorpresas caras: comprometerse con un pedido
que el inventario no aguanta, y creer que una línea escrita a mano va a
descontar insumos cuando no lo hará. Es valioso, pero la conversión ya sirve
sin ello.

**Independent Test**: Convertir una cotización que mezcle un producto del
catálogo con una línea escrita a mano, teniendo inventario insuficiente para el
primero, y verificar que el resumen distingue ambas líneas y nombra los insumos
que quedarían cortos.

**Acceptance Scenarios**:

1. **Given** una cotización con líneas de catálogo y líneas escritas a mano,
   **When** se muestra el resumen de confirmación, **Then** indica cuáles
   descontarán inventario y cuáles no.
2. **Given** existencias insuficientes para cumplir el pedido, **When** se
   muestra el resumen, **Then** advierte la faltante y nombra los insumos
   cortos, pero permite continuar.
3. **Given** cualquier conversión, **When** se muestra el resumen, **Then**
   aclara que el inventario se descuenta al marcar el pedido como entregado, no
   al crearlo.

---

### Edge Cases

- **Línea sin producto del catálogo** (escrita a mano al cotizar): pasa al
  pedido como ítem con su nombre, cantidad y precio, sin costo ni receta. No
  descuenta inventario al entregar, y el resumen lo advierte.
- **Producto borrado del catálogo desde que se cotizó**: la línea se trata como
  escrita a mano. El pedido conserva lo cotizado; no descuenta inventario.
- **Producto cuyo precio cambió desde que se cotizó**: manda el precio
  cotizado, que es lo prometido al cliente. El costo y la receta se toman del
  producto de hoy, que es lo que realmente se va a consumir.
- **Producto cuya receta cambió desde que se cotizó**: se usa la receta de hoy.
- **Descuento mayor que las adiciones más el domicilio**: el ajuste que cuadra
  el total queda negativo. Se permite y se muestra en el resumen.
- **Cotización con total cero o sin líneas**: no se puede convertir; se explica
  por qué.
- **Intento de convertir dos veces**: se impide; la cotización ya tiene pedido.
- **Cliente sin teléfono**: el teléfono es opcional para poder avanzar, pero se
  pide explícitamente porque el pedido lo usa para contactar.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema MUST ofrecer crear un pedido cuando una cotización
  pasa a estado aceptada.
- **FR-002**: El sistema MUST ofrecer crear el pedido, desde la lista de
  cotizaciones, para cualquier cotización aceptada que aún no tenga pedido.
- **FR-003**: El sistema MUST pedir teléfono del cliente y fecha de entrega
  antes de crear el pedido, por ser los únicos datos que el pedido exige y la
  cotización no tiene.
- **FR-004**: El sistema MUST rechazar la creación si no se indica fecha de
  entrega.
- **FR-005**: El sistema MUST trasladar al pedido el nombre del cliente y cada
  línea de la cotización con su nombre, cantidad y precio cotizado.
- **FR-006**: El sistema MUST conservar el precio cotizado de cada línea,
  aunque el precio actual del producto sea distinto.
- **FR-007**: El sistema MUST tomar el costo y la receta de cada línea del
  producto tal como está hoy en el catálogo, para que el descuento de
  inventario refleje lo que realmente se consumirá.
- **FR-008**: El sistema MUST trasladar las líneas sin producto del catálogo
  como ítems sin costo ni receta.
- **FR-009**: El sistema MUST hacer que el total del pedido sea exactamente
  igual al total cotizado, incorporando adiciones, domicilio, descuento e
  impuestos en un único ajuste.
- **FR-010**: El sistema MUST permitir que ese ajuste sea negativo cuando el
  descuento supere a las adiciones y el domicilio, y MUST mostrarlo en el
  resumen.
- **FR-011**: El sistema MUST NOT modificar el inventario al crear el pedido.
- **FR-012**: El sistema MUST mostrar, antes de confirmar, un resumen con
  cliente, total, número de ítems, qué líneas descontarán inventario y cuáles
  no, y la advertencia de que el descuento ocurre al marcar entregado.
- **FR-013**: El sistema MUST advertir en ese resumen si las existencias
  actuales no alcanzarían para cumplir el pedido, nombrando los insumos
  cortos, sin impedir la creación.
- **FR-014**: El sistema MUST dejar la cotización enlazada al pedido que
  generó.
- **FR-015**: El sistema MUST impedir que una cotización genere un segundo
  pedido.
- **FR-016**: El sistema MUST indicar en la lista de cotizaciones cuáles ya
  generaron pedido.
- **FR-017**: El sistema MUST permitir cancelar la conversión sin efectos: la
  cotización conserva su estado aceptada y no se crea nada.
- **FR-018**: El pedido creado MUST comportarse como cualquier otro: se puede
  editar, archivar, y al marcarlo entregado descuenta inventario y registra la
  venta.

### Key Entities

- **Cotización**: propuesta de precio para un cliente. Tiene cliente (texto),
  fecha, estado, líneas, adiciones, domicilio, descuento, impuestos y notas.
  Gana un enlace al pedido que generó.
- **Línea de cotización**: nombre, cantidad, precio unitario y, opcionalmente,
  referencia a un producto del catálogo. Esa referencia es lo que determina si
  la línea descontará inventario.
- **Pedido**: compromiso de entrega. Tiene cliente (nombre y teléfono), fecha
  de pedido, fecha de entrega, precio, costo, ítems y un valor de ajuste.
- **Ítem de pedido**: nombre, cantidad, precio unitario, costo unitario y una
  copia de la receta tomada al agregarlo. Esa copia es lo que se descuenta del
  inventario al entregar.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Convertir una cotización aceptada en pedido requiere escribir
  únicamente dos datos (teléfono y fecha de entrega), frente a reescribir
  cliente, productos, cantidades y precios completos.
- **SC-002**: En el 100% de las conversiones, el total del pedido es idéntico
  al total de la cotización de origen.
- **SC-003**: El inventario permanece sin cambios en el 100% de las
  conversiones; solo cambia al marcar el pedido como entregado.
- **SC-004**: Ninguna cotización puede generar más de un pedido.
- **SC-005**: Antes de confirmar, la persona puede distinguir qué líneas
  descontarán inventario y cuáles no, sin abrir otra pantalla.
- **SC-006**: Cuando las existencias no alcanzan, la persona lo sabe antes de
  comprometerse con el pedido.

## Assumptions

- **La conversión es un corte, no un vínculo vivo.** Editar la cotización
  después de convertirla no modifica el pedido, ni al revés. Son dos documentos
  con propósitos distintos: uno es la propuesta, el otro el compromiso.
- **El teléfono capturado al convertir se guarda en el pedido, no en la
  cotización.** La cotización mantiene su cliente como texto.
- **Solo se convierten cotizaciones aceptadas.** Los estados borrador, enviada,
  entregada y rechazada no ofrecen la conversión.
- **El estado de la cotización no cambia al convertir**: sigue aceptada. El
  enlace al pedido es lo que registra que ya se convirtió.
- **Quien puede crear pedidos puede convertir.** La conversión no introduce un
  permiso nuevo: se apoya en los permisos que ya rigen cotizaciones y pedidos.
- **La advertencia de inventario es informativa.** Se calcula con las
  existencias del momento de convertir y no bloquea, porque entre la conversión
  y la entrega suele haber compras de por medio.
