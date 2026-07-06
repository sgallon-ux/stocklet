import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';
import '../datos_app.dart';
import '../models/resumen_mensual.dart';
import '../tema.dart';
import '../formato.dart';
import '../servicios/reporte_pdf.dart';

class PantallaReportesMensuales extends StatefulWidget {
  const PantallaReportesMensuales({super.key});

  @override
  State<PantallaReportesMensuales> createState() =>
      _PantallaReportesMensualesState();
}

class _PantallaReportesMensualesState extends State<PantallaReportesMensuales> {
  String? _generando;

  Future<void> _descargar(ResumenMensual r) async {
    final datos = context.read<DatosApp>();
    setState(() => _generando = '${r.anio}-${r.mes}');
    try {
      final bytes = await generarReporteMensualPdf(
        negocio: datos.negocio?.nombre ?? 'Mi negocio',
        anio: r.anio,
        mes: r.mes,
        ventas: datos.ventas,
        gastos: datos.gastos,
      );
      final nombre =
          'Reporte_${r.anio}_${r.mes.toString().padLeft(2, '0')}.pdf';
      await Printing.sharePdf(bytes: bytes, filename: nombre);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo generar el PDF.')),
        );
      }
    } finally {
      if (mounted) setState(() => _generando = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<DatosApp>();
    final m = AppColores.of(context);
    final ahora = DateTime.now();

    final meses = datos.resumenPorMes
        .where((r) => !(r.anio == ahora.year && r.mes == ahora.month))
        .toList()
      ..sort((a, b) {
        if (a.anio != b.anio) return b.anio.compareTo(a.anio);
        return b.mes.compareTo(a.mes);
      });

    return Scaffold(
      appBar: AppBar(title: const Text('Reportes mensuales')),
      body: meses.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                    'Aún no hay meses cerrados para reportar.\nAl terminar el mes actual, aparecerá aquí.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: m.textoSuave)),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: meses.map((r) {
                final clave = '${r.anio}-${r.mes}';
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.etiqueta,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: m.texto)),
                              const SizedBox(height: 4),
                              Text(
                                  'Ingresos: ${pesos(r.ingresos)}  ·  Gastos: ${pesos(r.gastos)}',
                                  style: TextStyle(
                                      fontSize: 12, color: m.textoSuave)),
                              Text('Ganancia: ${pesos(r.ganancia)}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          r.ganancia >= 0 ? m.verde : m.rojo)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _generando == clave
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2))
                            : IconButton.filledTonal(
                                icon: const Icon(Icons.download_outlined),
                                tooltip: 'Descargar PDF',
                                onPressed: () => _descargar(r),
                              ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}