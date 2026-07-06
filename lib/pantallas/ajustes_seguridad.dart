import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currency_picker/currency_picker.dart';
import '../datos_app.dart';
import '../tema.dart';
import 'cambiar_contrasena.dart';

class PantallaAjustesSeguridad extends StatelessWidget {
  const PantallaAjustesSeguridad({super.key});

  static String _idioma(String code) {
    const mapa = {'es': 'Español', 'en': 'English', 'pt': 'Português'};
    return mapa[code] ?? code;
  }

  Widget _fila(MarcaColores m, IconData icono, String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icono, size: 20, color: m.textoSuave),
          const SizedBox(width: 12),
          Text(etiqueta, style: TextStyle(color: m.textoSuave)),
          const Spacer(),
          Flexible(
            child: Text(valor,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: m.texto, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = AppColores.of(context);
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
          Text('Preferencias del negocio',
              style: TextStyle(fontWeight: FontWeight.bold, color: m.texto)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: [
                  _fila(m, Icons.public, 'País', negocio?.pais ?? '-'),
                  const Divider(height: 1),
                  _fila(m, Icons.payments_outlined, 'Moneda', monedaTexto),
                  const Divider(height: 1),
                  _fila(m, Icons.translate, 'Idioma',
                      _idioma(negocio?.idioma ?? '')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
                'País y moneda no se pueden cambiar por ahora. El idioma será editable cuando la app tenga traducción.',
                style: TextStyle(fontSize: 12, color: m.textoSuave)),
          ),
          const SizedBox(height: 24),
          Text('Seguridad',
              style: TextStyle(fontWeight: FontWeight.bold, color: m.texto)),
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
                  color: m.verde.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.lock_outline, color: m.verde, size: 20),
              ),
              title: Text('Cambiar contraseña',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, color: m.texto)),
              trailing: Icon(Icons.chevron_right, color: m.textoSuave),
            ),
          ),
        ],
      ),
    );
  }
}