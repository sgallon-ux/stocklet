// Formato de cantidades, búsqueda sin tildes y formateadores de entrada.
//
// Estos helpers deciden cómo se ve cada número de la app. Un cambio aquí se
// nota en todas las pantallas a la vez.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reposteria_app/formato.dart';

// Simula escribir `nuevo` en un campo que tenía `viejo`, y devuelve lo que el
// formateador deja pasar.
String escribir(TextInputFormatter f, String viejo, String nuevo) {
  return f
      .formatEditUpdate(
        TextEditingValue(text: viejo),
        TextEditingValue(text: nuevo),
      )
      .text;
}

void main() {
  group('sinTildes', () {
    test('quita acentos y pasa a minúsculas', () {
      expect(sinTildes('Azúcar'), 'azucar');
      expect(sinTildes('AZÚCAR'), 'azucar');
      expect(sinTildes('azucar'), 'azucar');
    });

    test('cubre las vocales acentuadas, la eñe y la cedilla', () {
      expect(sinTildes('áàäâã'), 'aaaaa');
      expect(sinTildes('éèëê'), 'eeee');
      expect(sinTildes('íìïî'), 'iiii');
      expect(sinTildes('óòöôõ'), 'ooooo');
      expect(sinTildes('úùüû'), 'uuuu');
      expect(sinTildes('ñ'), 'n');
      expect(sinTildes('ç'), 'c');
    });

    test('permite buscar sin importar cómo se escriba', () {
      // El caso que motivó el helper: buscar "limon" encuentra "Limón".
      expect(sinTildes('Limón').contains(sinTildes('limon')), isTrue);
      expect(sinTildes('Piña').contains(sinTildes('pina')), isTrue);
    });

    test('no toca lo que no lleva acento', () {
      expect(sinTildes('Harina 000'), 'harina 000');
      expect(sinTildes(''), '');
    });
  });

  group('cantidadStr', () {
    test('un entero se muestra sin decimales', () {
      expect(cantidadStr(2), '2');
      expect(cantidadStr(2.0), '2');
      expect(cantidadStr(1000), '1000');
      expect(cantidadStr(0), '0');
    });

    test('los decimales se muestran sin ceros sobrantes', () {
      expect(cantidadStr(2.5), '2.5');
      expect(cantidadStr(2.25), '2.25');
      expect(cantidadStr(2.50), '2.5');
      expect(cantidadStr(0.1), '0.1');
    });

    test('se redondea a dos decimales', () {
      expect(cantidadStr(2.256), '2.26');
      expect(cantidadStr(2.254), '2.25');
    });

    test('los negativos conservan el signo', () {
      // El stock puede quedar negativo y hay que poder verlo.
      expect(cantidadStr(-3), '-3');
      expect(cantidadStr(-2.5), '-2.5');
    });
  });

  group('parseCantidad', () {
    test('acepta coma y punto como separador decimal', () {
      expect(parseCantidad('2.5'), 2.5);
      expect(parseCantidad('2,5'), 2.5);
    });

    test('ignora espacios alrededor', () {
      expect(parseCantidad('  7  '), 7);
    });

    test('acepta negativos', () {
      expect(parseCantidad('-4.5'), -4.5);
    });

    test('lo vacío o ilegible es cero', () {
      expect(parseCantidad(''), 0);
      expect(parseCantidad('   '), 0);
      expect(parseCantidad('abc'), 0);
    });

    test('un separador de miles NO se entiende: devuelve cero', () {
      // Documenta el límite real: "1.234,56" no se interpreta como 1234.56.
      // Los formateadores de entrada impiden teclearlo, pero si alguna vez se
      // parsea texto de otra fuente, hay que normalizarlo antes.
      expect(parseCantidad('1.234,56'), 0);
    });
  });

  group('Decimal2Formatter', () {
    final f = Decimal2Formatter();

    test('deja escribir enteros y hasta dos decimales', () {
      expect(escribir(f, '', '5'), '5');
      expect(escribir(f, '5', '5.2'), '5.2');
      expect(escribir(f, '5.2', '5.25'), '5.25');
      expect(escribir(f, '5', '5,25'), '5,25');
    });

    test('permite vaciar el campo', () {
      expect(escribir(f, '5', ''), '');
    });

    test('bloquea el tercer decimal', () {
      expect(escribir(f, '5.25', '5.256'), '5.25');
    });

    test('bloquea letras y signos', () {
      expect(escribir(f, '5', '5a'), '5');
      expect(escribir(f, '5', '5+'), '5');
    });

    test('bloquea el signo negativo', () {
      // Es la diferencia con DecimalSignedFormatter.
      expect(escribir(f, '', '-'), '');
      expect(escribir(f, '', '-5'), '');
    });
  });

  group('DecimalSignedFormatter', () {
    final f = DecimalSignedFormatter();

    test('admite el signo negativo inicial', () {
      expect(escribir(f, '', '-'), '-');
      expect(escribir(f, '-', '-5'), '-5');
      expect(escribir(f, '-5', '-5.25'), '-5.25');
    });

    test('sigue aceptando positivos', () {
      expect(escribir(f, '', '5'), '5');
      expect(escribir(f, '5', '5,5'), '5,5');
    });

    test('permite vaciar el campo', () {
      expect(escribir(f, '-5', ''), '');
    });

    test('bloquea el tercer decimal y las letras', () {
      expect(escribir(f, '-5.25', '-5.256'), '-5.25');
      expect(escribir(f, '-5', '-5x'), '-5');
    });

    test('el signo solo va al principio', () {
      expect(escribir(f, '5', '5-'), '5');
    });
  });

  group('moneda', () {
    setUp(reiniciarMoneda);
    tearDown(reiniciarMoneda);

    test('por defecto formatea en pesos colombianos sin decimales', () {
      expect(pesos(1500), contains('1.500'));
      expect(pesos(1500), isNot(contains(',00')));
    });

    test('configurarMoneda cambia símbolo y decimales', () {
      configurarMoneda(moneda: 'USD', idioma: 'en', pais: 'US');
      final s = pesos(1500.5);
      expect(s, contains('1,500.5'));
      expect(s, contains(r'$'));
    });

    test('un locale inexistente no rompe: cae a uno seguro', () {
      // La combinación idioma_pais puede no existir en intl; el helper
      // reintenta solo con el idioma en vez de lanzar.
      expect(() => configurarMoneda(moneda: 'COP', idioma: 'es', pais: 'ZZ'),
          returnsNormally);
      expect(() => pesos(1000), returnsNormally);
    });

    test('reiniciarMoneda vuelve al valor por defecto', () {
      configurarMoneda(moneda: 'USD', idioma: 'en', pais: 'US');
      reiniciarMoneda();
      expect(pesos(1500), contains('1.500'));
    });
  });
}
