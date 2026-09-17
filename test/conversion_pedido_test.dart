// Convertir una cotización aceptada en pedido.
//
// Lo que se fija aquí es lo que el cliente termina pagando y lo que la cocina
// termina consumiendo. Un error en cualquiera de las dos cosas no se nota
// hasta que ya costó dinero.

import 'package:flutter_test/flutter_test.dart';
import 'package:reposteria_app/models/cotizacion.dart';
import 'package:reposteria_app/models/ingrediente_de_receta.dart';
import 'package:reposteria_app/models/insumo.dart';
import 'package:reposteria_app/models/pedido.dart';
import 'package:reposteria_app/models/producto.dart';

Insumo insumo(String id, double costo, {double stock = 1000}) => Insumo(
      id: id,
      nombre: id,
      unidad: 'g',
      costoPorUnidad: costo,
      stockActual: stock,
    );

/// Una torta: cuesta $1.000 de materia prima el lote, rinde 1, se vende a 50k.
Producto torta({double rendimiento = 1}) => Producto(
      id: 'torta',
      nombre: 'Torta',
      receta: [IngredienteDeReceta(insumo: insumo('harina', 10), cantidad: 100)],
      precioVenta: 50000,
      rendimiento: rendimiento,
    );

LineaCotizacion linea(String nombre, double precio, double cantidad,
        {String? productoId}) =>
    LineaCotizacion(
      nombre: nombre,
      precioUnitario: precio,
      cantidad: cantidad,
      productoId: productoId,
    );

Cotizacion cotizacion({
  List<LineaCotizacion>? lineas,
  List<AdicionCotizacion>? adiciones,
  double domicilio = 0,
  double descuento = 0,
  bool aplicaIva = false,
  double tasaIva = 19,
}) =>
    Cotizacion(
      id: 'c1',
      cliente: 'Ana',
      estado: 'aceptada',
      lineas: lineas ?? [linea('Torta', 50000, 1, productoId: 'torta')],
      adiciones: adiciones,
      domicilio: domicilio,
      descuento: descuento,
      aplicaIva: aplicaIva,
      tasaIva: tasaIva,
    );

Pedido convertir(Cotizacion c, {List<Producto>? productos}) =>
    Pedido.desdeCotizacion(
      c,
      productos: productos ?? [torta()],
      telefono: '3110000000',
      fechaEntrega: DateTime(2026, 10, 1),
      descripcionFallback: 'Pedido',
    );

void main() {
  group('el dinero cuadra', () {
    test('el total del pedido es exactamente el de la cotización', () {
      final c = cotizacion();
      expect(convertir(c).precio, c.total);
    });

    test('cuadra con adiciones, domicilio, descuento e IVA a la vez', () {
      final c = cotizacion(
        lineas: [linea('Torta', 50000, 2, productoId: 'torta')],
        adiciones: [AdicionCotizacion(nombre: 'Vela', valor: 3000)],
        domicilio: 8000,
        descuento: 5000,
        aplicaIva: true,
      );
      final p = convertir(c);
      expect(p.precio, closeTo(c.total, 0.001));
      // Los ítems solo llevan las líneas; el resto va en el ajuste.
      expect(p.precio - p.otroValor, closeTo(100000, 0.001));
    });

    test('el ajuste queda negativo si el descuento pesa más que los extras',
        () {
      final c = cotizacion(
        lineas: [linea('Torta', 50000, 1, productoId: 'torta')],
        descuento: 10000,
      );
      final p = convertir(c);
      expect(p.otroValor, closeTo(-10000, 0.001));
      expect(p.precio, closeTo(c.total, 0.001)); // sigue cuadrando
    });

    test('el costo del pedido es la suma de los costos de sus ítems', () {
      final c = cotizacion(lineas: [
        linea('Torta', 50000, 3, productoId: 'torta'),
      ]);
      // La torta cuesta $1.000 producirla; 3 unidades = $3.000.
      expect(convertir(c).costo, closeTo(3000, 0.001));
    });
  });

  group('el precio cotizado manda', () {
    test('se conserva aunque el producto haya subido de precio', () {
      // Se cotizó a 40.000; hoy el catálogo dice 50.000.
      final c = cotizacion(
        lineas: [linea('Torta', 40000, 1, productoId: 'torta')],
      );
      final p = convertir(c);
      expect(p.items.first.precioUnitario, 40000);
      expect(p.precio, 40000);
    });

    test('pero el costo y la receta salen del producto de hoy', () {
      final c = cotizacion(
        lineas: [linea('Torta', 40000, 1, productoId: 'torta')],
      );
      final p = convertir(c);
      expect(p.items.first.costoUnitario, closeTo(1000, 0.001));
      expect(p.items.first.receta, isNotEmpty);
    });
  });

  group('qué descuenta inventario y qué no', () {
    test('una línea con producto trae copia de receta', () {
      final p = convertir(cotizacion());
      expect(p.items.first.receta.single.insumoId, 'harina');
      expect(p.items.first.receta.single.cantidad, 100);
    });

    test('la receta se prorratea por el rendimiento del producto', () {
      // 100 g de harina por lote, y el lote rinde 50 unidades.
      final p = convertir(cotizacion(),
          productos: [torta(rendimiento: 50)]);
      expect(p.items.first.receta.single.cantidad, closeTo(2, 0.001));
    });

    test('una línea escrita a mano no lleva costo ni receta', () {
      final c = cotizacion(lineas: [linea('Decoración especial', 20000, 1)]);
      final p = convertir(c);
      expect(p.items.first.costoUnitario, 0);
      expect(p.items.first.receta, isEmpty);
    });

    test('un producto borrado del catálogo se degrada, no revienta', () {
      final c = cotizacion(
        lineas: [linea('Torta', 50000, 1, productoId: 'ya-no-existe')],
      );
      final p = convertir(c);
      expect(p.items.first.nombre, 'Torta');
      expect(p.items.first.precioUnitario, 50000); // se respeta lo cotizado
      expect(p.items.first.costoUnitario, 0);
      expect(p.items.first.receta, isEmpty);
    });

    test('mezcla de líneas: cada una se resuelve por separado', () {
      final c = cotizacion(lineas: [
        linea('Torta', 50000, 1, productoId: 'torta'),
        linea('Montaje', 15000, 1),
      ]);
      final p = convertir(c);
      expect(p.items[0].receta, isNotEmpty);
      expect(p.items[1].receta, isEmpty);
    });
  });

  group('el resto del pedido', () {
    test('lleva el cliente de la cotización y el teléfono capturado', () {
      final p = convertir(cotizacion());
      expect(p.cliente.nombre, 'Ana');
      expect(p.cliente.telefono, '3110000000');
    });

    test('nace sin entregar ni archivar', () {
      final p = convertir(cotizacion());
      expect(p.entregado, isFalse);
      expect(p.archivado, isFalse);
    });

    test('la descripción resume las líneas', () {
      final c = cotizacion(lineas: [
        linea('Torta', 50000, 2, productoId: 'torta'),
        linea('Galletas', 2000, 12),
      ]);
      expect(convertir(c).descripcion, '2x Torta, 12x Galletas');
    });

    test('una cotización sin líneas usa el texto de respaldo', () {
      final c = cotizacion(lineas: []);
      expect(convertir(c).descripcion, 'Pedido');
    });

    test('respeta la fecha de entrega indicada', () {
      expect(convertir(cotizacion()).fechaEntrega, DateTime(2026, 10, 1));
    });
  });

  group('consumo de insumos', () {
    test('suma receta por cantidad, agrupando por insumo', () {
      final c = cotizacion(lineas: [
        linea('Torta', 50000, 3, productoId: 'torta'),
      ]);
      // 100 g por unidad × 3 unidades.
      expect(consumoDeInsumos(convertir(c)), {'harina': 300.0});
    });

    test('los ítems sin receta no aportan nada', () {
      final c = cotizacion(lineas: [linea('Montaje', 15000, 5)]);
      expect(consumoDeInsumos(convertir(c)), isEmpty);
    });

    test('acumula el mismo insumo usado por varias líneas', () {
      final c = cotizacion(lineas: [
        linea('Torta', 50000, 2, productoId: 'torta'),
        linea('Torta grande', 80000, 1, productoId: 'torta'),
      ]);
      expect(consumoDeInsumos(convertir(c)), {'harina': 300.0});
    });
  });

  group('faltantes de inventario', () {
    test('lista vacía cuando alcanza', () {
      final p = convertir(cotizacion());
      expect(faltantesDeInventario(p, [insumo('harina', 10, stock: 500)]),
          isEmpty);
    });

    test('nombra el insumo que no alcanza', () {
      final c = cotizacion(lineas: [
        linea('Torta', 50000, 10, productoId: 'torta'), // consume 1000 g
      ]);
      final p = convertir(c);
      final faltan =
          faltantesDeInventario(p, [insumo('harina', 10, stock: 400)]);
      expect(faltan, ['harina']);
    });

    test('justo lo necesario no se considera faltante', () {
      final p = convertir(cotizacion()); // consume 100 g
      expect(faltantesDeInventario(p, [insumo('harina', 10, stock: 100)]),
          isEmpty);
    });

    test('un insumo que ya no existe no se reporta', () {
      // Tampoco se descuenta al entregar, así que avisar de él confundiría.
      final p = convertir(cotizacion());
      expect(faltantesDeInventario(p, []), isEmpty);
    });

    test('el stock negativo también cuenta como faltante', () {
      final p = convertir(cotizacion());
      expect(faltantesDeInventario(p, [insumo('harina', 10, stock: -5)]),
          ['harina']);
    });
  });
}
