import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/venta.dart';
import '../tema.dart';
import '../formato.dart';
import 'editar_venta.dart';

class PantallaHistorialVentas extends StatefulWidget {
  const PantallaHistorialVentas({super.key});

  @override
  State<PantallaHistorialVentas> createState() =>
      _PantallaHistorialVentasState();
}

class _PantallaHistorialVentasState extends State<PantallaHistorialVentas> {
  DateTime? _mes; // primer día del mes elegido (null = mes actual)

  static const _nombresMes = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  String _label(DateTime f) => '${_nombresMes[f.month - 1]} ${f.year}';

  void _confirmarEliminar(BuildContext context, Venta venta) {
    final datos = context.read<DatosApp>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar venta'),
        content: const Text(
          'Esto corrige los ingresos, pero no devuelve los insumos al inventario. '
          '¿Quieres continuar?',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              datos.eliminarVenta(venta);
              Navigator.pop(dialogContext);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = AppColores.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de ventas')),
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          if (datos.ventas.isEmpty) {
            return Center(
              child: Text('Aún no hay ventas registradas.',
                  style: TextStyle(color: m.textoSuave)),
            );
          }

          final ahora = DateTime.now();
          final actual = DateTime(ahora.year, ahora.month);
          final set = <DateTime>{actual};
          for (final v in datos.ventas) {
            set.add(DateTime(v.fecha.year, v.fecha.month));
          }
          final meses = set.toList()..sort((a, b) => b.compareTo(a));

          final sel = _mes ?? actual;
          final selValido = meses.contains(sel) ? sel : meses.first;

          final lista = datos.ventas
              .where((v) =>
                  v.fecha.year == selValido.year &&
                  v.fecha.month == selValido.month)
              .toList()
            ..sort((a, b) => b.fecha.compareTo(a.fecha));

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    Text('Mes:', style: TextStyle(color: m.textoSuave)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButton<DateTime>(
                        value: selValido,
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(12),
                        items: meses
                            .map((mes) => DropdownMenuItem(
                                value: mes, child: Text(_label(mes))))
                            .toList(),
                        onChanged: (v) => setState(() => _mes = v),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: lista.isEmpty
                    ? Center(
                        child: Text('No hubo ventas en ${_label(selValido)}.',
                            style: TextStyle(color: m.textoSuave)),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: lista.map((venta) {
                          return Card(
                            child: ListTile(
                              title: Text(venta.descripcion),
                              subtitle: Text(
                                '${venta.fecha.day}/${venta.fecha.month}/${venta.fecha.year}'
                                '  ·  Cant: ${venta.cantidad}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(pesos(venta.total),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  PopupMenuButton<String>(
                                    onSelected: (opcion) {
                                      if (opcion == 'editar') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PantallaEditarVenta(
                                                    venta: venta),
                                          ),
                                        );
                                      } else if (opcion == 'eliminar') {
                                        _confirmarEliminar(context, venta);
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                          value: 'editar',
                                          child: Text('Editar')),
                                      PopupMenuItem(
                                          value: 'eliminar',
                                          child: Text('Eliminar')),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}