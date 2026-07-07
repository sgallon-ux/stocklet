import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_picker/country_picker.dart';
import 'package:currency_picker/currency_picker.dart';
import '../datos_app.dart';
import '../tema.dart';

class PantallaCrearNegocio extends StatefulWidget {
  const PantallaCrearNegocio({super.key});

  @override
  State<PantallaCrearNegocio> createState() => _PantallaCrearNegocioState();
}

class _PantallaCrearNegocioState extends State<PantallaCrearNegocio> {
  final nombreCtrl = TextEditingController();

  String paisCodigo = 'CO';
  String paisNombre = 'Colombia';
  String moneda = 'COP';
  String monedaTexto = 'Peso colombiano (COP)';
  String idioma = 'es';
  bool creando = false;

  // Idiomas que de verdad soportaremos (se amplía al traducir)
  static const idiomas = {'es': 'Español', 'en': 'English', 'pt': 'Português'};

  // Moneda sugerida por país (los demás se eligen en el selector de moneda)
  static const monedaPorPais = {
    'CO': 'COP', 'MX': 'MXN', 'AR': 'ARS', 'PE': 'PEN', 'CL': 'CLP',
    'EC': 'USD', 'VE': 'VES', 'BO': 'BOB', 'PY': 'PYG', 'UY': 'UYU',
    'BR': 'BRL', 'US': 'USD', 'CA': 'CAD', 'GB': 'GBP', 'PA': 'USD',
    'GT': 'GTQ', 'CR': 'CRC', 'HN': 'HNL', 'NI': 'NIO', 'SV': 'USD',
    'DO': 'DOP', 'ES': 'EUR', 'DE': 'EUR', 'FR': 'EUR', 'IT': 'EUR', 'PT': 'EUR',
  };

  @override
  void dispose() {
    nombreCtrl.dispose();
    super.dispose();
  }

  void _elegirPais() {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        inputDecoration: const InputDecoration(
          labelText: 'Buscar país',
          prefixIcon: Icon(Icons.search),
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          paisCodigo = country.countryCode;
          paisNombre = country.name;
          final sugerida = monedaPorPais[country.countryCode];
          if (sugerida != null) {
            moneda = sugerida;
            final c = CurrencyService().findByCode(sugerida);
            monedaTexto = c != null ? '${c.name} (${c.code})' : sugerida;
          }
        });
      },
    );
  }

  void _elegirMoneda() {
    showCurrencyPicker(
      context: context,
      onSelect: (Currency currency) {
        setState(() {
          moneda = currency.code;
          monedaTexto = '${currency.name} (${currency.code})';
        });
      },
    );
  }

  void crear() async {
    final nombre = nombreCtrl.text.trim();
    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe el nombre de tu negocio')),
      );
      return;
    }
    setState(() => creando = true);
    try {
      await context.read<DatosApp>().crearNegocio(
            nombre: nombre, pais: paisCodigo, moneda: moneda, idioma: idioma,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => creando = false);
      }
    }
  }

  // Campo que parece input pero abre un selector al tocarlo
  Widget _campoTap({
    required IconData icono,
    required String etiqueta,
    required String valor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: etiqueta,
          prefixIcon: Icon(icono),
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: Text(valor, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

 @override
  Widget build(BuildContext context) {
    final m = AppColores.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 72, width: 72, alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: m.verde.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.storefront, color: m.verde, size: 36),
                  ),
                  const SizedBox(height: 20),
                  Text('¡Bienvenido!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: m.texto)),
                  const SizedBox(height: 6),
                  Text(
                    'Cuéntanos de tu microempresa para personalizar la app',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: m.textoSuave),
                  ),
                  const SizedBox(height: 28),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: nombreCtrl,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Nombre del negocio',
                              prefixIcon: Icon(Icons.badge_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _campoTap(
                            icono: Icons.public,
                            etiqueta: 'País',
                            valor: paisNombre,
                            onTap: _elegirPais,
                          ),
                          const SizedBox(height: 16),
                          _campoTap(
                            icono: Icons.payments_outlined,
                            etiqueta: 'Moneda',
                            valor: monedaTexto,
                            onTap: _elegirMoneda,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: idioma,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Idioma',
                              prefixIcon: Icon(Icons.translate),
                            ),
                            items: idiomas.entries
                                .map((e) => DropdownMenuItem(
                                    value: e.key, child: Text(e.value)))
                                .toList(),
                            onChanged: (v) => setState(() => idioma = v!),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: creando ? null : crear,
                            child: creando
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white))
                                : const Text('Crear mi negocio'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Cerrar sesión'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}