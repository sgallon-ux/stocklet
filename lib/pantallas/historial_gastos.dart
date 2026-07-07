import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/gasto.dart';
import '../tema.dart';
import '../formato.dart';
import 'editar_gasto.dart';

class PantallaHistorialGastos extends StatefulWidget {
  const PantallaHistorialGastos({super.key});

  @override
  State<PantallaHistorialGastos> createState() =>
      _PantallaHistorialGastosState();
}

class _PantallaHistorialGastosState extends State<PantallaHistorialGastos> {
  DateTime? _mes; // primer día del mes elegido (null = mes actual)

  static const _nombresMes = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  String _label(DateTime f) => '${_nombresMes[f.month - 1]} ${f.year}';

  void _confirmarEliminar(BuildContext context, Gasto gasto) {
    final datos = context.read<DatosApp>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar gasto'),
        content: Text('¿Seguro que quieres eliminar "${gasto.descripcion}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              datos.eliminarGasto(gasto);
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
      appBar: AppBar(title: const Text('Historial de gastos')),
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          if (datos.gastos.isEmpty) {
            return Center(
              child: Text('Aún no hay gastos registrados.',
                  style: TextStyle(color: m.textoSuave)),
            );
          }

          final ahora = DateTime.now();
          final actual = DateTime(ahora.year, ahora.month);
          final set = <DateTime>{actual};
          for (final g in datos.gastos) {
            set.add(DateTime(g.fecha.year, g.fecha.month));
          }
          final meses = set.toList()..sort((a, b) => b.compareTo(a));

          final sel = _mes ?? actual;
          final selValido = meses.contains(sel) ? sel : meses.first;

          final lista = datos.gastos
              .where((g) =>
                  g.fecha.year == selValido.year &&
                  g.fecha.month == selValido.month)
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
                        child: Text('No hubo gastos en ${_label(selValido)}.',
                            style: TextStyle(color: m.textoSuave)),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: lista.map((gasto) {
                          return Card(
                            child: ListTile(
                              title: Text(gasto.descripcion),
                              subtitle: Text(
                                '${gasto.fecha.day}/${gasto.fecha.month}/${gasto.fecha.year}'
                                '  ·  ${gasto.categoria.name}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    pesos(gasto.monto),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (opcion) {
                                      if (opcion == 'editar') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PantallaEditarGasto(
                                                    gasto: gasto),
                                          ),
                                        );
                                      } else if (opcion == 'eliminar') {
                                        _confirmarEliminar(context, gasto);
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