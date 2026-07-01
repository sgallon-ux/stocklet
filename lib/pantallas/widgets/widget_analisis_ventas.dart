import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../datos_app.dart';
import '../../tema.dart';
import '../../formato.dart';
import '../analisis_ventas.dart';

class WidgetAnalisisVentas extends StatelessWidget {
  const WidgetAnalisisVentas({super.key});

  static const _dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<DatosApp>();
    final a = datos.analisisVentas();

    String resumen;
    if (a.numVentas == 0) {
      resumen = 'Aún no hay ventas para analizar.';
    } else {
      final mejorDia = [...a.porDiaSemana]
        ..sort((x, y) => y.value.compareTo(x.value));
      final nombreDia =
          mejorDia.first.value > 0 ? _dias[mejorDia.first.key - 1] : '—';
      resumen =
          'Ticket promedio ${pesos(a.ticketPromedio)} · Mejor día: $nombreDia';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('Análisis de ventas',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColores.texto)),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PantallaAnalisisVentas())),
                  child: const Text('Ver más'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.insights,
                    size: 18, color: AppColores.textoSuave),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(resumen,
                      style: const TextStyle(color: AppColores.textoSuave)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}