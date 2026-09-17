// Motor de costeo: de la receta al precio sugerido.
//
// Los números que salen de aquí son el argumento de venta de Stocklet. Cada
// prueba fija una regla del cálculo con cifras a mano, para que una
// refactorización no cambie en silencio lo que el negocio cobra.

import 'package:flutter_test/flutter_test.dart';
import 'package:reposteria_app/costeo.dart';
import 'package:reposteria_app/models/insumo.dart';
import 'package:reposteria_app/models/ingrediente_de_receta.dart';
import 'package:reposteria_app/models/producto.dart';

// Un insumo que cuesta `costo` por unidad base.
Insumo insumo(String nombre, double costo) => Insumo(
      id: nombre,
      nombre: nombre,
      unidad: 'g',
      costoPorUnidad: costo,
      stockActual: 1000,
    );

IngredienteDeReceta ing(double costoUnitario, double cantidad) =>
    IngredienteDeReceta(insumo: insumo('x$costoUnitario', costoUnitario), cantidad: cantidad);

Producto producto({
  List<IngredienteDeReceta>? receta,
  List<IngredienteDeReceta>? empaque,
  double precioVenta = 0,
  double rendimiento = 1,
  double mermaPct = 0,
  double minutosPrep = 0,
  double minutosHorno = 0,
  String metodoMargen = '',
  double? margenPct,
  bool sinAzucar = false,
  double unidadesMesEstimadas = 0,
}) =>
    Producto(
      id: 'p',
      nombre: 'Producto',
      receta: receta ?? [ing(10, 100)], // $1.000 de materia prima por lote
      empaque: empaque,
      precioVenta: precioVenta,
      rendimiento: rendimiento,
      mermaPct: mermaPct,
      minutosPrep: minutosPrep,
      minutosHorno: minutosHorno,
      metodoMargen: metodoMargen,
      margenPct: margenPct,
      sinAzucar: sinAzucar,
      unidadesMesEstimadas: unidadesMesEstimadas,
    );

void main() {
  group('materia prima y rendimiento', () {
    test('la materia prima es la suma de la receta del lote', () {
      final r = costear(
        producto(receta: [ing(10, 100), ing(5, 200)]),
        const ConfigCosteo(),
      );
      expect(r.materiaPrima, 2000); // 10*100 + 5*200
    });

    test('el rendimiento reparte el lote entre las unidades', () {
      final r = costear(producto(rendimiento: 10), const ConfigCosteo());
      expect(r.materiaPrima, 1000);
      expect(r.materiaUnidad, 100);
    });

    test('un rendimiento inválido se trata como 1', () {
      for (final rend in [0.0, -5.0, 0.5]) {
        final r = costear(producto(rendimiento: rend), const ConfigCosteo());
        expect(r.materiaUnidad, 1000, reason: 'rendimiento $rend');
      }
    });
  });

  group('merma', () {
    test('la merma encarece por división, no por suma', () {
      // Perder el 10% no encarece un 10%, sino un 11,1%: lo que queda útil es
      // el 90% de lo comprado.
      final r = costear(producto(mermaPct: 10), const ConfigCosteo());
      expect(r.conMerma, closeTo(1111.11, 0.01));
    });

    test('sin merma no cambia nada', () {
      final r = costear(producto(mermaPct: 0), const ConfigCosteo());
      expect(r.conMerma, 1000);
    });

    test('la merma se limita al 95% para no dividir por cero', () {
      final r = costear(producto(mermaPct: 100), const ConfigCosteo());
      // 1000 / 0.05. Va con tolerancia porque 1 - 95/100 no es exactamente
      // 0.05 en coma flotante.
      expect(r.conMerma, closeTo(20000, 0.01));
      expect(r.conMerma.isFinite, isTrue);
    });

    test('una merma negativa se trata como cero', () {
      final r = costear(producto(mermaPct: -10), const ConfigCosteo());
      expect(r.conMerma, 1000);
    });
  });

  group('empaque, mano de obra y energía', () {
    test('el empaque es por unidad, no por lote', () {
      final r = costear(
        producto(empaque: [ing(50, 1)], rendimiento: 10),
        const ConfigCosteo(),
      );
      // El empaque no se divide entre el rendimiento.
      expect(r.empaqueUnidad, 50);
    });

    test('la mano de obra se prorratea por hora y por unidad', () {
      final r = costear(
        producto(minutosPrep: 30, rendimiento: 10),
        const ConfigCosteo(tarifaHora: 20000),
      );
      // Media hora a $20.000 = $10.000 el lote, entre 10 unidades.
      expect(r.manoObraUnidad, 1000);
    });

    test('la energía se prorratea igual que la mano de obra', () {
      final r = costear(
        producto(minutosHorno: 60, rendimiento: 4),
        const ConfigCosteo(costoEnergiaHora: 2000),
      );
      expect(r.energiaUnidad, 500);
    });
  });

  group('gastos fijos: se reparten por lote, no por unidad', () {
    // $1.000.000 al mes entre 20 lotes = $50.000 que carga cada preparación.
    const cfg = ConfigCosteo(gastosMes: 1000000, lotesMes: 20);

    test('un lote de una unidad carga el lote entero', () {
      // Una torta ocupa el horno y el turno igual que cualquier otro lote.
      final r = costear(producto(rendimiento: 1), cfg);
      expect(r.fijosUnidad, 50000);
    });

    test('un lote de 50 carga lo mismo, repartido entre las 50', () {
      final r = costear(producto(rendimiento: 50), cfg);
      expect(r.fijosUnidad, 1000); // 50000 / 50
    });

    test('el lote siempre carga lo mismo, rinda lo que rinda', () {
      // La invariante del modelo: fijosUnidad × rendimiento es constante.
      for (final rend in [1.0, 4.0, 12.0, 50.0, 200.0]) {
        final r = costear(producto(rendimiento: rend), cfg);
        expect(r.fijosUnidad * rend, closeTo(50000, 0.01),
            reason: 'rendimiento $rend');
      }
    });

    test('el mes recupera exactamente los gastos fijos', () {
      // Sin esta igualdad el prorrateo estaría mal planteado: 20 lotes al mes
      // tienen que sumar el millón, ni más ni menos.
      final r = costear(producto(rendimiento: 50), cfg);
      final recuperadoAlMes = r.fijosUnidad * 50 * cfg.lotesMes;
      expect(recuperadoAlMes, closeTo(cfg.gastosMes, 0.01));
    });

    test('un rendimiento inválido carga el lote entero', () {
      // rendimiento 0 se trata como 1, igual que en la materia prima.
      final r = costear(producto(rendimiento: 0), cfg);
      expect(r.fijosUnidad, 50000);
    });

    test('sin lotes al mes no se prorratea y se avisa', () {
      final r = costear(producto(), const ConfigCosteo(gastosMes: 1000000));
      expect(r.fijosUnidad, 0);
      expect(r.fijosIncompletos, isTrue);
    });

    test('con gastos y lotes cargados, no se avisa', () {
      expect(costear(producto(), cfg).fijosIncompletos, isFalse);
    });

    test('el costo variable excluye los fijos', () {
      final r = costear(
        producto(),
        const ConfigCosteo(gastosMes: 100000, lotesMes: 100),
      );
      expect(r.fijosUnidad, 1000);
      expect(r.costoUnidad - r.costoVariableUnidad, 1000);
    });
  });

  group('precio sugerido', () {
    test('método markup: se suma el margen al costo', () {
      final r = costear(
        producto(metodoMargen: 'markup', margenPct: 50),
        const ConfigCosteo(),
      );
      expect(r.costoUnidad, 1000);
      expect(r.precioSugerido, 1500);
    });

    test('método venta: el margen es sobre el precio final', () {
      // 40% sobre venta con costo 1000 -> 1000/0.6 = 1666,67, no 1400.
      final r = costear(
        producto(metodoMargen: 'venta', margenPct: 40),
        const ConfigCosteo(),
      );
      expect(r.precioSugerido, closeTo(1666.67, 0.01));
      expect(r.margenSobreVenta, closeTo(40, 0.01));
    });

    test('el margen sobre venta se limita al 95%', () {
      final r = costear(
        producto(metodoMargen: 'venta', margenPct: 99),
        const ConfigCosteo(),
      );
      expect(r.margen, 95);
      expect(r.precioSugerido, closeTo(20000, 0.01));
      expect(r.precioSugerido.isFinite, isTrue);
    });

    test('el producto hereda el método y el margen del negocio', () {
      final r = costear(
        producto(),
        const ConfigCosteo(metodoMargen: 'markup', margenPct: 25),
      );
      expect(r.metodo, 'markup');
      expect(r.margen, 25);
      expect(r.precioSugerido, 1250);
    });

    test('el margen del producto manda sobre el del negocio', () {
      final r = costear(
        producto(margenPct: 10),
        const ConfigCosteo(metodoMargen: 'markup', margenPct: 25),
      );
      expect(r.margen, 10);
    });

    test('la línea sin azúcar usa el margen especial', () {
      final r = costear(
        producto(sinAzucar: true),
        const ConfigCosteo(
            metodoMargen: 'markup', margenPct: 40, margenEspecialPct: 60),
      );
      expect(r.usaEspecial, isTrue);
      expect(r.margen, 60);
      expect(r.precioSugerido, 1600);
    });
  });

  group('estado del precio', () {
    ResultadoCosteo conPrecio(double precio) => costear(
          producto(precioVenta: precio, metodoMargen: 'markup', margenPct: 50),
          const ConfigCosteo(),
        );
    // costo 1000, sugerido 1500.

    test('sin precio cargado', () {
      expect(conPrecio(0).estado, EstadoPrecio.sinPrecio);
      expect(conPrecio(-100).estado, EstadoPrecio.sinPrecio);
    });

    test('por debajo del costo es pérdida', () {
      expect(conPrecio(900).estado, EstadoPrecio.perdida);
    });

    test('entre el costo y el sugerido está bajo', () {
      expect(conPrecio(1200).estado, EstadoPrecio.bajo);
    });

    test('en el sugerido o por encima está bien', () {
      expect(conPrecio(1500).estado, EstadoPrecio.bien);
      expect(conPrecio(2000).estado, EstadoPrecio.bien);
    });

    test('hay medio peso de tolerancia bajo el sugerido', () {
      // Evita marcar en rojo un precio redondeado a mano.
      expect(conPrecio(1499.6).estado, EstadoPrecio.bien);
      expect(conPrecio(1499.4).estado, EstadoPrecio.bajo);
    });

    test('cobrar justo el costo no es pérdida, pero sí precio bajo', () {
      expect(conPrecio(1000).estado, EstadoPrecio.bajo);
    });
  });

  group('derivados', () {
    test('utilidad y contribución', () {
      final r = costear(
        producto(metodoMargen: 'markup', margenPct: 50),
        const ConfigCosteo(gastosMes: 100000, lotesMes: 100),
      );
      // costo 1000 + fijos 1000 = 2000; sugerido 3000.
      expect(r.costoUnidad, 2000);
      expect(r.precioSugerido, 3000);
      expect(r.utilidad, 1000);
      expect(r.contribucion, 2000); // 3000 - variable 1000
    });

    test('el punto de equilibrio son los fijos entre la contribución', () {
      final r = costear(
        producto(metodoMargen: 'markup', margenPct: 50),
        const ConfigCosteo(gastosMes: 100000, lotesMes: 100),
      );
      expect(r.equilibrio, closeTo(50, 0.01)); // 100000 / 2000
    });

    test('sin contribución positiva no hay equilibrio que calcular', () {
      final r = costear(
        producto(metodoMargen: 'markup', margenPct: 0),
        const ConfigCosteo(gastosMes: 100000, lotesMes: 0),
      );
      expect(r.contribucion, 0);
      expect(r.equilibrio, isNull);
    });
  });

  group('simulador de alza de insumos', () {
    test('factorInsumos encarece receta y empaque, no la mano de obra', () {
      final p = producto(empaque: [ing(100, 1)], minutosPrep: 60);
      const cfg = ConfigCosteo(tarifaHora: 6000);

      final base = costear(p, cfg);
      final alza = costear(p, cfg, factorInsumos: 1.2);

      expect(alza.materiaPrima, closeTo(base.materiaPrima * 1.2, 0.01));
      expect(alza.empaqueUnidad, closeTo(base.empaqueUnidad * 1.2, 0.01));
      expect(alza.manoObraUnidad, base.manoObraUnidad);
    });
  });

  group('panel de oportunidad', () {
    test('suma la brecha mensual de los productos mal cobrados', () {
      final barato = producto(
        precioVenta: 1000, // sugerido 1500 -> brecha 500
        metodoMargen: 'markup',
        margenPct: 50,
        unidadesMesEstimadas: 10,
      );
      final bienCobrado = producto(
        precioVenta: 1500,
        metodoMargen: 'markup',
        margenPct: 50,
        unidadesMesEstimadas: 10,
      );
      expect(
        dineroMesOportunidad([barato, bienCobrado], const ConfigCosteo()),
        closeTo(5000, 0.01),
      );
    });

    test('un producto sin unidades estimadas no suma', () {
      final p = producto(
        precioVenta: 1000,
        metodoMargen: 'markup',
        margenPct: 50,
      );
      expect(dineroMesOportunidad([p], const ConfigCosteo()), 0);
    });

    test('productosPorDebajo cuenta pérdidas y precios bajos', () {
      final enPerdida = producto(
          precioVenta: 500, metodoMargen: 'markup', margenPct: 50);
      final bajo = producto(
          precioVenta: 1200, metodoMargen: 'markup', margenPct: 50);
      final bien = producto(
          precioVenta: 1500, metodoMargen: 'markup', margenPct: 50);
      expect(
        productosPorDebajo([enPerdida, bajo, bien], const ConfigCosteo()),
        2,
      );
    });
  });

  group('ConfigCosteo.deNegocio', () {
    test('sin negocio devuelve los valores por defecto', () {
      final cfg = ConfigCosteo.deNegocio(null);
      expect(cfg.margenPct, 40);
      expect(cfg.metodoMargen, 'venta');
      expect(cfg.fijosIncompletos, isTrue);
    });
  });
}
