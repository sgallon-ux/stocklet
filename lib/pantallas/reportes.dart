import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../datos_app.dart';
import '../formato.dart';

class PantallaReportes extends StatelessWidget {
  const PantallaReportes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportes por mes')),
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          final resumen = datos.resumenPorMes;
          if (resumen.isEmpty) {
            return const Center(child: Text('Aún no hay datos para mostrar.'));
          }

          // últimos 6 meses para la gráfica
          final ultimos = resumen.length > 6
              ? resumen.sublist(resumen.length - 6)
              : resumen;

          final maxG = ultimos.map((r) => r.ganancia).fold<double>(0, (a, b) => b > a ? b : a);
          final minG = ultimos.map((r) => r.ganancia).fold<double>(0, (a, b) => b < a ? b : a);
          final maxY = maxG <= 0 ? 100.0 : maxG * 1.2;
          final minY = minG < 0 ? minG * 1.2 : 0.0;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Ganancia por mes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SizedBox(
                height: 260,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxY,
                    minY: minY,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i >= ultimos.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(ultimos[i].etiquetaCorta,
                                  style: const TextStyle(fontSize: 11)),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(ultimos.length, (i) {
                      final r = ultimos[i];
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: r.ganancia,
                            color: r.ganancia >= 0 ? Colors.green : Colors.red,
                            width: 18,
                            borderRadius:
                                const BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Detalle por mes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...resumen.reversed.map((r) {
                return Card(
                  child: ListTile(
                    title: Text(r.etiqueta),
                    subtitle: Text(
                      'Ingresos: ${pesos(r.ingresos)}  ·  '
                      'Gastos: ${pesos(r.gastos)}',
                    ),
                    trailing: Text(
                      pesos(r.ganancia),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: r.ganancia >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}