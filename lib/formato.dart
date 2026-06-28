import 'package:intl/intl.dart';
import 'package:currency_picker/currency_picker.dart';

NumberFormat _formato =
    NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);

void configurarMoneda({
  required String moneda,
  required String idioma,
  required String pais,
}) {
  final c = CurrencyService().findByCode(moneda);
  final simbolo = c?.symbol ?? '\$';
  final decimales = c?.decimalDigits ?? 2;
  try {
    _formato = NumberFormat.currency(
      locale: '${idioma}_$pais', symbol: simbolo, decimalDigits: decimales);
  } catch (_) {
    // Si esa combinación de locale no existe, caemos a una segura
    _formato = NumberFormat.currency(
      locale: idioma, symbol: simbolo, decimalDigits: decimales);
  }
}

void reiniciarMoneda() {
  _formato =
      NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);
}

String pesos(num valor) => _formato.format(valor);