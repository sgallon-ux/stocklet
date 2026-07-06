import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../datos_app.dart';
import '../models/resumen_mensual.dart';
import '../tema.dart';
import '../formato.dart';
import 'widgets/widget_top_productos.dart';
import 'widgets/widget_analisis_ventas.dart';
import 'reportes_mensuales.dart';

class PantallaReportes extends StatelessWidget {
  const PantallaReportes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Análisis y reportes')),
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          final m = AppColores.of(context);
          final resumen = datos.resumenPorMes;
          if (resumen.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                    'Aún no hay datos para analizar.\nRegistra ventas y gastos para ver tus reportes.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: m.textoSuave)),
              ),
            );
          }

          final actual = resumen.last;
          final anterior =
              resumen.length >= 2 ? resumen[resumen.length - 2] : null;

          double? crecimiento;
          if (anterior != null && anterior.ganancia > 0) {
            crecimiento =
                (actual.ganancia - anterior.ganancia) / anterior.ganancia * 100;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _tarjetaGanancia(m, actual, anterior, crecimiento),
              const SizedBox(height: 16),
              _tarjetaGrafica(m, resumen),
              const SizedBox(height: 16),
              const WidgetTopProductos(),
              const SizedBox(height: 16),
              const WidgetAnalisisVentas(),
              const SizedBox(height: 16),
              _entradaReportesMensuales(context, m),
            ],
          );
        },
      ),
    );
  }

  Widget _tarjetaGanancia(MarcaColores m, ResumenMensual actual,
      ResumenMensual? anterior, double? crecimiento) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Ganancia de ${actual.etiqueta}',
                      style: TextStyle(fontSize: 13, color: m.textoSuave)),
                ),
                _badgeCrecimiento(m, crecimiento),
              ],
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                pesos(actual.ganancia),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: actual.ganancia >= 0 ? m.texto : m.rojo,
                ),
              ),
            ),
            if (anterior != null) ...[
              const SizedBox(height: 4),
              Text('Mes anterior (${anterior.etiquetaCorta}): ${pesos(anterior.ganancia)}',
                  style: TextStyle(fontSize: 12, color: m.textoSuave)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _badgeCrecimiento(MarcaColores m, double? pct) {
    if (pct == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: m.textoSuave.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text('— sin comparación',
            style: TextStyle(fontSize: 12, color: m.textoSuave)),
      );
    }
    final sube = pct >= 0;
    final color = sube ? m.verde : m.rojo;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(sube ? Icons.arrow_upward : Icons.arrow_downward,
              size: 14, color: color),
          const SizedBox(width: 3),
          Text('${pct.abs().toStringAsFixed(0)}%',
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _tarjetaGrafica(MarcaColores m, List<ResumenMensual> resumen) {
    final ultimos =
        resumen.length > 6 ? resumen.sublist(resumen.length - 6) : resumen;

    final maxG =
        ultimos.map((r) => r.ganancia).fold<double>(0, (a, b) => b > a ? b : a);
    final minG =
        ultimos.map((r) => r.ganancia).fold<double>(0, (a, b) => b < a ? b : a);
    final maxY = maxG <= 0 ? 100.0 : maxG * 1.2;
    final minY = minG < 0 ? minG * 1.2 : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ganancia por mes',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: m.texto)),
            const SizedBox(height: 16),
            SizedBox(
              height: 240,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  minY: minY,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
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
                                style: TextStyle(
                                    fontSize: 11, color: m.textoSuave)),
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
                          color: r.ganancia >= 0 ? m.verde : m.rojo,
                          width: 18,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4)),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _entradaReportesMensuales(BuildContext context, MarcaColores m) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const PantallaReportesMensuales())),
        leading: Container(
          height: 44,
          width: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: m.verde.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.description_outlined, color: m.verde),
        ),
        title: Text('Reportes mensuales',
            style: TextStyle(fontWeight: FontWeight.bold, color: m.texto)),
        subtitle:
            const Text('Descarga el extracto en PDF de cada mes cerrado'),
        trailing: Icon(Icons.chevron_right, color: m.textoSuave),
      ),
    );
  }
}