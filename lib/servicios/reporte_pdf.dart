import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/venta.dart';
import '../models/gasto.dart';
import '../formato.dart';

const _meses = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
];

class _Mov {
  final DateTime fecha;
  final String concepto;
  final double ingreso;
  final double gasto;
  _Mov(this.fecha, this.concepto, this.ingreso, this.gasto);
}

Future<Uint8List> generarReporteMensualPdf({
  required String negocio,
  required int anio,
  required int mes,
  required List<Venta> ventas,
  required List<Gasto> gastos,
}) async {
  final movs = <_Mov>[];
  for (final v in ventas) {
    if (v.fecha.year == anio && v.fecha.month == mes) {
      movs.add(_Mov(v.fecha, v.descripcion, v.total, 0));
    }
  }
  for (final g in gastos) {
    if (g.fecha.year == anio && g.fecha.month == mes) {
      movs.add(_Mov(g.fecha, g.descripcion, 0, g.monto));
    }
  }
  movs.sort((a, b) => a.fecha.compareTo(b.fecha));

  final totalIng = movs.fold<double>(0, (s, m) => s + m.ingreso);
  final totalGas = movs.fold<double>(0, (s, m) => s + m.gasto);
  final ganancia = totalIng - totalGas;

  final verde = PdfColor.fromInt(0xFF0E9F6E);
  final rojo = PdfColor.fromInt(0xFFE2483D);
  final gris = PdfColor.fromInt(0xFF6B7785);

  String f(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  pw.Widget celda(String t,
          {pw.Alignment align = pw.Alignment.centerLeft,
          bool bold = false,
          PdfColor? color}) =>
      pw.Container(
        alignment: align,
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: pw.Text(t,
            style: pw.TextStyle(
                fontSize: 9,
                fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
                color: color)),
      );

  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(28),
      header: (ctx) => ctx.pageNumber == 1
          ? pw.SizedBox()
          : pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Text('$negocio — ${_meses[mes - 1]} $anio',
                  style: pw.TextStyle(fontSize: 8, color: gris)),
            ),
      footer: (ctx) => pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: const pw.EdgeInsets.only(top: 8),
        child: pw.Text('Página ${ctx.pageNumber} de ${ctx.pagesCount}',
            style: pw.TextStyle(fontSize: 8, color: gris)),
      ),
      build: (ctx) => [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(negocio,
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 2),
            pw.Text('Reporte mensual — ${_meses[mes - 1]} $anio',
                style: pw.TextStyle(fontSize: 12, color: gris)),
            pw.Text('Generado el ${f(DateTime.now())}',
                style: pw.TextStyle(fontSize: 9, color: gris)),
          ],
        ),
        pw.SizedBox(height: 16),
        if (movs.isEmpty)
          pw.Text('No hubo movimientos en este mes.',
              style: pw.TextStyle(color: gris))
        else
          pw.Table(
            border: pw.TableBorder(
              horizontalInside:
                  pw.BorderSide(color: PdfColors.grey300, width: 0.5),
              bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
            ),
            columnWidths: const {
              0: pw.FixedColumnWidth(55),
              1: pw.FlexColumnWidth(),
              2: pw.FixedColumnWidth(75),
              3: pw.FixedColumnWidth(75),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  celda('Fecha', bold: true),
                  celda('Concepto', bold: true),
                  celda('Ingreso', align: pw.Alignment.centerRight, bold: true),
                  celda('Gasto', align: pw.Alignment.centerRight, bold: true),
                ],
              ),
              ...movs.map((m) => pw.TableRow(
                    children: [
                      celda(f(m.fecha)),
                      celda(m.concepto),
                      celda(m.ingreso > 0 ? pesos(m.ingreso) : '',
                          align: pw.Alignment.centerRight, color: verde),
                      celda(m.gasto > 0 ? pesos(m.gasto) : '',
                          align: pw.Alignment.centerRight, color: rojo),
                    ],
                  )),
            ],
          ),
        pw.SizedBox(height: 16),
        pw.Container(
          alignment: pw.Alignment.centerRight,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              _totalLinea('Total ingresos', pesos(totalIng), verde),
              _totalLinea('Total gastos', pesos(totalGas), rojo),
              pw.SizedBox(height: 4),
              _totalLinea('Ganancia', pesos(ganancia),
                  ganancia >= 0 ? verde : rojo,
                  grande: true),
            ],
          ),
        ),
      ],
    ),
  );

  return pdf.save();
}

pw.Widget _totalLinea(String t, String v, PdfColor color,
    {bool grande = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text('$t: ',
            style: pw.TextStyle(
                fontSize: grande ? 12 : 10,
                color: PdfColor.fromInt(0xFF6B7785))),
        pw.SizedBox(width: 8),
        pw.Text(v,
            style: pw.TextStyle(
                fontSize: grande ? 14 : 10,
                fontWeight: pw.FontWeight.bold,
                color: color)),
      ],
    ),
  );
}