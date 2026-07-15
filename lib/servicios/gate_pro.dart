import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../pantallas/paywall.dart';

/// Compuerta de acceso a funciones Pro.
///
/// Si el usuario ya es Pro (o la monetización está inactiva → `esPro` = true),
/// devuelve `true` de inmediato. Si no, abre el paywall y devuelve `true` solo
/// si al volver el usuario ya es Pro (es decir, si compró).
///
/// Uso típico:
///   if (!await exigirPro(context) || !mounted) return;
Future<bool> exigirPro(BuildContext context) async {
  if (context.read<DatosApp>().esPro) return true;
  await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const PantallaPaywall()),
  );
  return context.mounted && context.read<DatosApp>().esPro;
}
