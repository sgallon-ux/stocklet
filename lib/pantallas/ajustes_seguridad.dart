import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currency_picker/currency_picker.dart';
import '../datos_app.dart';
import '../tema.dart';
import 'cambiar_contrasena.dart';

class PantallaAjustesSeguridad extends StatelessWidget {
  const PantallaAjustesSeguridad({super.key});

  static String _idioma(String code) {
    const m = {'es': 'Español', 'en': 'English', 'pt': 'Português'};
    return m[code] ?? code;
  }

  Widget _fila(IconData icono, String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icono, size: 20, color: AppColores.textoSuave),
          const SizedBox(width: 12),
          Text(etiqueta, style: const TextStyle(color: AppColores.textoSuave)),
          const Spacer(),
          Flexible(
            child: Text(valor,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: AppColores.texto, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final negocio = context.watch<DatosApp>().negocio;
    final cur =
        negocio != null ? CurrencyService().findByCode(negocio.moneda) : null;
    final monedaTexto =
        cur != null ? '${cur.name} (${cur.code})' : (negocio?.moneda ?? '-');

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes y seguridad')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Preferencias del negocio',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColores.texto)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: [
                  _fila(Icons.public, 'País', negocio?.pais ?? '-'),
                  const Divider(height: 1),
                  _fila(Icons.payments_outlined, 'Moneda', monedaTexto),
                  const Divider(height: 1),
                  _fila(Icons.translate, 'Idioma',
                      _idioma(negocio?.idioma ?? '')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
                'País y moneda no se pueden cambiar por ahora. El idioma será editable cuando la app tenga traducción.',
                style: TextStyle(fontSize: 12, color: AppColores.textoSuave)),
          ),
          const SizedBox(height: 24),
          const Text('Seguridad',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColores.texto)),
          const SizedBox(height: 8),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const PantallaCambiarContrasena())),
              leading: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColores.verde.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.lock_outline,
                    color: AppColores.verde, size: 20),
              ),
              title: const Text('Cambiar contraseña',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: AppColores.texto)),
              trailing:
                  const Icon(Icons.chevron_right, color: AppColores.textoSuave),
            ),
          ),
        ],
      ),
    );
  }
}