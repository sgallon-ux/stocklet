import 'package:flutter/services.dart';
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

// ---------------------------------------------------------------------------
// Utilidades de cantidades y búsqueda
// ---------------------------------------------------------------------------

/// Quita tildes/acentos y pasa a minúsculas, para buscar sin importar tildes.
/// Ej: "Azúcar" y "azucar" quedan iguales ("azucar").
String sinTildes(String s) {
  var r = s.toLowerCase();
  const con = 'áàäâãéèëêíìïîóòöôõúùüûñç';
  const sin = 'aaaaaeeeeiiiiooooouuuunc';
  for (var i = 0; i < con.length; i++) {
    r = r.replaceAll(con[i], sin[i]);
  }
  return r;
}

/// Muestra una cantidad con hasta 2 decimales, sin ceros sobrantes.
/// 2 -> "2", 2.5 -> "2.5", 2.25 -> "2.25".
String cantidadStr(num v) {
  final d = v.toDouble();
  if (d == d.roundToDouble()) return d.toInt().toString();
  var s = d.toStringAsFixed(2);
  s = s.replaceFirst(RegExp(r'0+$'), '');
  s = s.replaceFirst(RegExp(r'\.$'), '');
  return s;
}

/// Convierte texto (acepta coma o punto) a double. Vacío/ inválido -> 0.
double parseCantidad(String s) =>
    double.tryParse(s.trim().replaceAll(',', '.')) ?? 0;

/// Formatter para inputs: permite un número con hasta 2 decimales (coma o punto).
class Decimal2Formatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final t = newValue.text;
    if (t.isEmpty) return newValue;
    if (RegExp(r'^\d*([.,]\d{0,2})?$').hasMatch(t)) return newValue;
    return oldValue;
  }
}

/// Como Decimal2Formatter pero admite un signo negativo inicial. Útil para
/// campos como el stock, que puede quedar negativo y hay que poder corregirlo.
class DecimalSignedFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final t = newValue.text;
    if (t.isEmpty || t == '-') return newValue;
    if (RegExp(r'^-?\d*([.,]\d{0,2})?$').hasMatch(t)) return newValue;
    return oldValue;
  }
}
