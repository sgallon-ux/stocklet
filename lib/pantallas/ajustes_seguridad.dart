import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../tema.dart';
import 'cambiar_contrasena.dart';

// Nombres de cada idioma en su propio idioma (autónimos). No se traducen.
const Map<String, String> kNombresIdioma = {
  'es': 'Español',
  'en': 'English',
  'pt': 'Português',
  'fr': 'Français',
};

class PantallaAjustesSeguridad extends StatelessWidget {
  const PantallaAjustesSeguridad({super.key});

  // Selector del idioma de la app (preferencia GLOBAL del dispositivo).
  void _elegirIdioma(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final datos = context.read<DatosApp>();
    final actual = datos.idiomaId; // null = automático

    showDialog(
      context: context,
      builder: (dc) {
        return AlertDialog(
          title: Text(t.idiomaTituloDialogo),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Opción automática: sigue el idioma del dispositivo.
              ListTile(
                leading: Icon(
                  actual == null
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                title: Text(t.idiomaAutomatico),
                onTap: () {
                  datos.setIdioma(null);
                  Navigator.pop(dc);
                },
              ),
              // Un ítem por cada idioma disponible.
              ...kNombresIdioma.entries.map(
                (e) => ListTile(
                  leading: Icon(
                    actual == e.key
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                  ),
                  title: Text(e.value),
                  onTap: () {
                    datos.setIdioma(e.key);
                    Navigator.pop(dc);
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dc),
              child: Text(t.cancelar),
            ),
          ],
        );
      },
    );
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
    final t = AppLocalizations.of(context)!;
    final datos = context.watch<DatosApp>();
    final negocio = datos.negocio;
    final cur =
        negocio != null ? CurrencyService().findByCode(negocio.moneda) : null;
    final monedaTexto =
        cur != null ? '${cur.name} (${cur.code})' : (negocio?.moneda ?? '-');
    // Idioma de la app: preferencia global (no el negocio.idioma).
    final idiomaApp = datos.idiomaId == null
        ? t.idiomaAutomatico
        : (kNombresIdioma[datos.idiomaId] ?? datos.idiomaId!);

    return Scaffold(
      appBar: AppBar(title: Text(t.ajustesSeguridad)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(t.preferenciasNegocio,
              style: TextStyle(fontWeight: FontWeight.bold, color: m.texto)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: [
                  _fila(m, Icons.public, t.campoPais, negocio?.pais ?? '-'),
                  const Divider(height: 1),
                  _fila(m, Icons.payments_outlined, t.campoMoneda, monedaTexto),
                  const Divider(height: 1),
                  // Fila Idioma editable: abre el selector de idioma de la app.
                  InkWell(
                    onTap: () => _elegirIdioma(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.translate, size: 20, color: m.textoSuave),
                          const SizedBox(width: 12),
                          Text(t.idioma, style: TextStyle(color: m.textoSuave)),
                          const Spacer(),
                          Flexible(
                            child: Text(idiomaApp,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: m.texto,
                                    fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(width: 6),
                          Icon(Icons.chevron_right,
                              size: 20, color: m.textoSuave),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(t.ajustesSeguridadCaption,
                style: TextStyle(fontSize: 12, color: m.textoSuave)),
          ),
          const SizedBox(height: 24),
          Text(t.seguridad,
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
              title: Text(t.cambiarContrasena,
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