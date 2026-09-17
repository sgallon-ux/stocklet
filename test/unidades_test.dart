// Conversión de unidades de compra a unidad base (g / ml / unidad).
//
// Es la base de todo lo demás: si un kilo no son 1000 gramos, el costo por
// unidad sale mal y con él el precio sugerido de cada producto.

import 'package:flutter_test/flutter_test.dart';
import 'package:reposteria_app/unidades.dart';

void main() {
  group('baseDeUnidad', () {
    test('agrupa cada unidad en su magnitud', () {
      expect(baseDeUnidad('kg'), 'g');
      expect(baseDeUnidad('lb'), 'g');
      expect(baseDeUnidad('arroba'), 'g');
      expect(baseDeUnidad('oz'), 'g');
      expect(baseDeUnidad('l'), 'ml');
      expect(baseDeUnidad('doc'), 'unidad');
    });

    test('una unidad desconocida cae a gramos', () {
      expect(baseDeUnidad('cucharadita'), 'g');
      expect(baseDeUnidad(''), 'g');
    });
  });

  group('factorDeUnidad', () {
    test('los factores de peso son los esperados', () {
      expect(factorDeUnidad('g'), 1);
      expect(factorDeUnidad('kg'), 1000);
      expect(factorDeUnidad('lb'), 500);
      expect(factorDeUnidad('arroba'), 12500);
      expect(factorDeUnidad('oz'), closeTo(28.3495, 0.0001));
    });

    test('volumen y conteo', () {
      expect(factorDeUnidad('ml'), 1);
      expect(factorDeUnidad('l'), 1000);
      expect(factorDeUnidad('unidad'), 1);
      expect(factorDeUnidad('doc'), 12);
    });

    test('una unidad desconocida no multiplica', () {
      expect(factorDeUnidad('pizca'), 1);
    });
  });

  group('costoBaseDesde', () {
    test('reparte el precio de la presentación entre sus unidades base', () {
      // $4.000 el kilo -> $4 el gramo.
      expect(costoBaseDesde(4000, 1, 'kg'), 4);
      // $3.000 la libra -> $6 el gramo.
      expect(costoBaseDesde(3000, 1, 'lb'), 6);
      // $12.000 la docena -> $1.000 la unidad.
      expect(costoBaseDesde(12000, 1, 'doc'), 1000);
    });

    test('tiene en cuenta la cantidad comprada', () {
      // 2 kg por $8.000 -> $4 el gramo.
      expect(costoBaseDesde(8000, 2, 'kg'), 4);
    });

    test('cantidad cero devuelve cero, no infinito', () {
      // Sin este guardia el costo se propagaría como Infinity a toda la app.
      expect(costoBaseDesde(4000, 0, 'kg'), 0);
      expect(costoBaseDesde(4000, -1, 'kg'), 0);
    });

    test('precio cero es válido y da costo cero', () {
      expect(costoBaseDesde(0, 1, 'kg'), 0);
    });
  });

  group('cantidadBaseDesde', () {
    test('convierte la cantidad comprada a unidad base', () {
      expect(cantidadBaseDesde(1, 'kg'), 1000);
      expect(cantidadBaseDesde(2.5, 'l'), 2500);
      expect(cantidadBaseDesde(1, 'arroba'), 12500);
      expect(cantidadBaseDesde(3, 'doc'), 36);
    });

    test('acepta decimales', () {
      expect(cantidadBaseDesde(0.5, 'kg'), 500);
    });
  });

  group('rotBase', () {
    test('la unidad de conteo se abrevia', () {
      expect(rotBase('unidad'), 'u');
      expect(rotBase('g'), 'g');
      expect(rotBase('ml'), 'ml');
    });

    test('una base desconocida se muestra tal cual', () {
      expect(rotBase('kg'), 'kg');
    });
  });

  group('ida y vuelta', () {
    test('costo x cantidad base reconstruye el precio de la presentación', () {
      for (final u in ['g', 'kg', 'lb', 'arroba', 'oz', 'ml', 'l', 'doc']) {
        final costo = costoBaseDesde(7500, 2, u);
        final cantidad = cantidadBaseDesde(2, u);
        expect(costo * cantidad, closeTo(7500, 0.0001), reason: 'unidad $u');
      }
    });
  });
}
