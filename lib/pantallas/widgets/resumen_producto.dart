import 'package:flutter/material.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../../tema.dart';
import '../../formato.dart';

class ResumenProducto extends StatelessWidget {
  final double costo;
  final double precio;
  const ResumenProducto({super.key, required this.costo, required this.precio});

  @override
  Widget build(BuildContext context) {
    final m = AppColores.of(context);
    final t = AppLocalizations.of(context)!;
    final ganancia = precio - costo;
    final hayPrecio = precio > 0;
    final double margen = hayPrecio ? (ganancia / precio) * 100 : 0.0;
    final gColor = ganancia >= 0 ? m.verde : m.rojo;

    Widget item(String label, String v, Color c) => Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: m.textoSuave)),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(v,
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, color: c)),
              ),
            ],
          ),
        );

    return Card(
      color: m.verde.withValues(alpha: 0.06),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            item(t.costo, pesos(costo), m.texto),
            const SizedBox(width: 8),
            item(t.ganancia, pesos(ganancia), gColor),
            const SizedBox(width: 8),
            item(t.margen, hayPrecio ? '${margen.toStringAsFixed(0)}%' : '—',
                gColor),
          ],
        ),
      ),
    );
  }
}
