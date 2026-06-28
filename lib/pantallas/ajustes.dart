import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:currency_picker/currency_picker.dart';
import '../datos_app.dart';
import '../tema.dart';

class PantallaAjustes extends StatelessWidget {
  const PantallaAjustes({super.key});

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
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          Center(
            child: Column(
              children: [
                Container(
                  height: 72,
                  width: 72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColores.verde.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.storefront,
                      color: AppColores.verde, size: 36),
                ),
                const SizedBox(height: 12),
                Text(negocio?.nombre ?? 'Mi negocio',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColores.texto)),
                const SizedBox(height: 4),
                const Text('Datos de tu negocio',
                    style:
                        TextStyle(fontSize: 13, color: AppColores.textoSuave)),
              ],
            ),
          ),
          const SizedBox(height: 24),
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
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar sesión'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColores.rojo,
              side: const BorderSide(color: AppColores.rojo),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text('Más opciones próximamente',
                style: TextStyle(fontSize: 12, color: AppColores.textoSuave)),
          ),
        ],
      ),
    );
  }
}