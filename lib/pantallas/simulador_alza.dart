import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../costeo.dart';
import '../tema.dart';
import '../formato.dart';

class PantallaSimuladorAlza extends StatefulWidget {
  const PantallaSimuladorAlza({super.key});

  @override
  State<PantallaSimuladorAlza> createState() => _PantallaSimuladorAlzaState();
}

class _PantallaSimuladorAlzaState extends State<PantallaSimuladorAlza> {
  double alza = 10;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final m = AppColores.of(context);
    final datos = context.watch<DatosApp>();
    final cfg = datos.configCosteo;
    final factor = 1 + alza / 100;
    final productos = [...datos.productos]
      ..sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));

    return Scaffold(
      appBar: AppBar(title: Text(t.simuladorTitulo)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.simuladorAyuda,
                    style: TextStyle(fontSize: 12, color: m.textoSuave)),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: alza,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: '${alza.round()}%',
                        onChanged: (v) => setState(() => alza = v),
                      ),
                    ),
                    SizedBox(
                      width: 56,
                      child: Text('+${alza.round()}%',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: m.verde)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: productos.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(t.simuladorSinProductos,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: m.textoSuave)),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: productos.map((p) {
                      final r0 = costear(p, cfg);
                      final r1 = costear(p, cfg, factorInsumos: factor);
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.nombre,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: m.texto)),
                              const SizedBox(height: 6),
                              _linea(m, t.costeoCostoUnidad,
                                  pesos(r0.costoUnidad), pesos(r1.costoUnidad)),
                              _linea(m, t.costeoPrecioSugerido,
                                  pesos(r0.precioSugerido),
                                  pesos(r1.precioSugerido),
                                  fuerte: true),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _linea(MarcaColores m, String etq, String antes, String despues,
          {bool fuerte = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Expanded(
                child: Text(etq,
                    style: TextStyle(fontSize: 13, color: m.textoSuave))),
            Text(antes,
                style: TextStyle(fontSize: 13, color: m.textoSuave)),
            Icon(Icons.arrow_forward, size: 14, color: m.textoSuave),
            Text(despues,
                style: TextStyle(
                    fontSize: fuerte ? 14 : 13,
                    fontWeight: fuerte ? FontWeight.bold : FontWeight.w500,
                    color: fuerte ? m.verde : m.texto)),
          ],
        ),
      );
}
