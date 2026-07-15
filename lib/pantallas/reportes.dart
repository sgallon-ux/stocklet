import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../servicios/gate_pro.dart';
import '../datos_app.dart';
import '../models/resumen_mensual.dart';
import '../tema.dart';
import '../formato.dart';
import 'widgets/widget_top_productos.dart';
import 'widgets/widget_analisis_ventas.dart';
import 'reportes_mensuales.dart';

class PantallaReportes extends StatelessWidget {
  const PantallaReportes({super.key});

  static String _cap(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  static String _mesLargo(ResumenMensual r, String locale) =>
      _cap(DateFormat.yMMMM(locale).format(DateTime(r.anio, r.mes)));

  static String _mesCorto(ResumenMensual r, String locale) =>
      _cap(DateFormat.yMMM(locale).format(DateTime(r.anio, r.mes)));

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    return Scaffold(
      appBar: AppBar(title: Text(t.analisisYReportes)),
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          final m = AppColores.of(context);
          final resumen = datos.resumenPorMes;
          if (resumen.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(t.reportesVacio,
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
              _tarjetaGanancia(m, t, locale, actual, anterior, crecimiento),
              const SizedBox(height: 16),
              _tarjetaGrafica(m, t, locale, resumen),
              const SizedBox(height: 16),
              const WidgetTopProductos(),
              const SizedBox(height: 16),
              const WidgetAnalisisVentas(),
              const SizedBox(height: 16),
              _entradaReportesMensuales(context, m, t),
            ],
          );
        },
      ),
    );
  }

  Widget _tarjetaGanancia(MarcaColores m, AppLocalizations t, String locale,
      ResumenMensual actual, ResumenMensual? anterior, double? crecimiento) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(t.gananciaDeMes(_mesLargo(actual, locale)),
                      style: TextStyle(fontSize: 13, color: m.textoSuave)),
                ),
                _badgeCrecimiento(m, t, crecimiento),
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
              Text(
                  t.mesAnterior(
                      _mesCorto(anterior, locale), pesos(anterior.ganancia)),
                  style: TextStyle(fontSize: 12, color: m.textoSuave)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _badgeCrecimiento(MarcaColores m, AppLocalizations t, double? pct) {
    if (pct == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: m.textoSuave.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(t.sinComparacion,
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

  Widget _tarjetaGrafica(MarcaColores m, AppLocalizations t, String locale,
      List<ResumenMensual> resumen) {
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
            Text(t.gananciaPorMes,
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
                            child: Text(_mesCorto(ultimos[i], locale),
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

  Widget _entradaReportesMensuales(
      BuildContext context, MarcaColores m, AppLocalizations t) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () async {
          if (await exigirPro(context) && context.mounted) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const PantallaReportesMensuales()));
          }
        },
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
        title: Text(t.reportesMensuales,
            style: TextStyle(fontWeight: FontWeight.bold, color: m.texto)),
        subtitle: Text(t.reportesMensualesSub),
        trailing: Icon(Icons.chevron_right, color: m.textoSuave),
      ),
    );
  }
}
