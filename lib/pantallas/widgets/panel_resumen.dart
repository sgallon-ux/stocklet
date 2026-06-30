import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../datos_app.dart';
import '../../tema.dart';
import '../../formato.dart';
import '../historial_ventas.dart';
import '../historial_gastos.dart';
import 'grafica_tendencia.dart';

class PanelResumen extends StatefulWidget {
  const PanelResumen({super.key});

  @override
  State<PanelResumen> createState() => _PanelResumenState();
}

class _PanelResumenState extends State<PanelResumen> {
  RangoTendencia _rango = RangoTendencia.mes;

  static const _opciones = {
    RangoTendencia.mes: 'Este mes',
    RangoTendencia.tres: '3 meses',
    RangoTendencia.seis: '6 meses',
    RangoTendencia.anio: 'Año',
  };

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<DatosApp>();
    final ingresos = datos.ingresosEnRango(_rango);
    final gastos = datos.gastosEnRango(_rango);
    final ganancia = ingresos - gastos;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado + filtro
            Row(
              children: [
                const Expanded(
                  child: Text('Resumen',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColores.texto)),
                ),
                DropdownButton<RangoTendencia>(
                  value: _rango,
                  underline: const SizedBox.shrink(),
                  borderRadius: BorderRadius.circular(12),
                  items: _opciones.entries
                      .map((e) =>
                          DropdownMenuItem(value: e.key, child: Text(e.value)))
                      .toList(),
                  onChanged: (v) => setState(() => _rango = v!),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Ingresos y Gastos en una fila
            Row(
              children: [
                Expanded(
                  child: _tile(
                    'Ingresos',
                    pesos(ingresos),
                    Icons.trending_up,
                    AppColores.verde,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PantallaHistorialVentas())),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _tile(
                    'Gastos',
                    pesos(gastos),
                    Icons.trending_down,
                    AppColores.rojo,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PantallaHistorialGastos())),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Ganancia debajo, a todo el ancho
            _tile('Ganancia', pesos(ganancia), Icons.account_balance_wallet,
                const Color(0xFF2563EB), null),
            const SizedBox(height: 18),

            const Text('Tendencia de ganancia',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColores.textoSuave)),
            const SizedBox(height: 8),
            GraficaTendencia(rango: _rango),
          ],
        ),
      ),
    );
  }

  Widget _tile(String titulo, String valor, IconData icono, Color color,
      VoidCallback? onTap) {
    final contenido = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icono, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: const TextStyle(
                        fontSize: 12, color: AppColores.textoSuave)),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(valor,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color)),
                ),
              ],
            ),
          ),
          if (onTap != null)
            const Icon(Icons.chevron_right,
                color: AppColores.textoSuave, size: 18),
        ],
      ),
    );
    if (onTap == null) return contenido;
    return InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(12), child: contenido);
  }
}