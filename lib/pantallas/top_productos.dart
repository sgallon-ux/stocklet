import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../tema.dart';
import '../formato.dart';

class PantallaTopProductos extends StatefulWidget {
  const PantallaTopProductos({super.key});

  @override
  State<PantallaTopProductos> createState() => _PantallaTopProductosState();
}

class _PantallaTopProductosState extends State<PantallaTopProductos> {
  DateTime? _mes;

  // Mes localizado (ej. "Julio 2026").
  String _label(BuildContext context, DateTime fecha) {
    final locale = Localizations.localeOf(context).toString();
    final texto = DateFormat.yMMMM(locale).format(fecha);
    return texto.isEmpty ? texto : texto[0].toUpperCase() + texto.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<DatosApp>();
    final m = AppColores.of(context);
    final t = AppLocalizations.of(context)!;
    final meses = datos.mesesConVentasDeProductos();

    DateTime? sel = _mes;
    if (sel == null && meses.isNotEmpty) {
      final ahora = DateTime.now();
      final actual = DateTime(ahora.year, ahora.month, 1);
      sel = meses.contains(actual) ? actual : meses.first;
    }

    final top = sel == null
        ? <ProductoVendido>[]
        : datos.topProductos(sel.year, sel.month);

    return Scaffold(
      appBar: AppBar(title: Text(t.topProductosTitulo)),
      body: meses.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(t.sinVentasProductos,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: m.textoSuave)),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Text(t.mesLabel, style: TextStyle(color: m.textoSuave)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButton<DateTime>(
                        value: sel,
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(12),
                        items: meses
                            .map((mes) => DropdownMenuItem(
                                value: mes,
                                child: Text(_label(context, mes))))
                            .toList(),
                        onChanged: (v) => setState(() => _mes = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (top.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(t.sinVentasProductosMes,
                        style: TextStyle(color: m.textoSuave)),
                  )
                else
                  ...top.asMap().entries.map((e) {
                    final puesto = e.key + 1;
                    final p = e.value;
                    return Card(
                      child: ListTile(
                        leading: Container(
                          height: 36,
                          width: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: m.verde.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Text('$puesto',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: m.verdeOscuro)),
                        ),
                        title: Text(p.nombre,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(t.totalTexto(pesos(p.total))),
                        trailing: Text('${p.cantidad}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: m.texto)),
                      ),
                    );
                  }),
              ],
            ),
    );
  }
}
