# Validación de la funcionalidad

Cómo comprobar que convertir una cotización en pedido funciona de verdad.
Las pruebas automáticas cubren la aritmética; la app cubre el flujo. El
Principio V pide las dos cosas.

## Requisitos previos

- Dependencias instaladas: `flutter pub get`
- Un negocio con al menos un producto con receta, para que haya inventario que
  descontar

## 1. Comprobaciones automáticas

```bash
flutter analyze
```

```bash
flutter test
```

La suite nueva vive en `test/conversion_pedido_test.dart` y fija lo que no se
puede ver a simple vista:

| Qué se prueba | Por qué importa |
|---|---|
| `precio` del pedido == `total` de la cotización | SC-002. Es la garantía central. |
| Línea con producto → ítem con receta y costo | Sin receta no se descontaría inventario al entregar. |
| Línea sin producto → ítem sin receta ni costo | FR-008. No debe inventar consumo. |
| Producto borrado → se degrada, no falla | Caso real: el catálogo cambia. |
| Precio cotizado se conserva aunque el producto haya subido | FR-006, la promesa al cliente. |
| Costo y receta salen del producto de hoy | FR-007, lo que se consume de verdad. |
| `otroValor` cuadra el total, incluso negativo | FR-010, descuento mayor que los extras. |
| `consumoDeInsumos` suma receta × cantidad | Lo usan el aviso y el descuento real. |
| `faltantesDeInventario` nombra solo lo que falta | Un aviso que miente es peor que ninguno. |

No hace falta correr `test/rules`: esta funcionalidad no toca reglas ni roles
(ver D6 en `research.md`).

## 2. Flujo en la app

```bash
flutter run
```

**Camino principal (P1)**

1. Crear una cotización con dos productos del catálogo, una adición y un
   domicilio. Anotar el total.
2. Marcarla **aceptada** y guardar.
3. Debe aparecer el diálogo. Completar teléfono y fecha de entrega.
4. Confirmar.
5. En Pedidos: el pedido existe, con el mismo cliente y **el mismo total**.
6. En Inventario: **nada cambió**.

**Convertir más tarde (P2)**

1. Aceptar otra cotización y rechazar el ofrecimiento.
2. Volver a la lista: debe ofrecer "crear pedido".
3. Convertirla desde ahí y comprobar que el resultado es el mismo.
4. Volver a mirarla: ya no lo ofrece, y se ve que tiene pedido.

**El resumen (P3)**

1. Cotizar mezclando un producto del catálogo con una línea escrita a mano.
2. Dejar el stock de un insumo por debajo de lo necesario.
3. Al convertir, el resumen debe distinguir la línea que descuenta de la que
   no, nombrar el insumo corto, y **dejar continuar igual**.

**Lo que no debe pasar**

- Convertir dos veces la misma cotización.
- Que el inventario se mueva al convertir.
- Que cancelar deje algo escrito.

**Con rol empleado** (Principio V, porque toca datos de negocio): un empleado
debe poder convertir, ya que puede crear pedidos y editar cotizaciones. Si
sale `PERMISSION_DENIED`, la premisa de D6 era falsa y hay que revisar las
reglas.

## 3. Después de entregar

Marcar entregado el pedido convertido y comprobar que descuenta los insumos de
las líneas con receta —y solo esas— y que registra la venta. Es el punto donde
`consumoDeInsumos` pasa a usarse de verdad.
