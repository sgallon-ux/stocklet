import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/gasto.dart';
import 'editar_gasto.dart';
import '../formato.dart';

class PantallaHistorialGastos extends StatelessWidget {
  const PantallaHistorialGastos({super.key});

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
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de gastos')),
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          if (datos.gastos.isEmpty) {
            return const Center(child: Text('Aún no hay gastos registrados.'));
          }
          final lista = [...datos.gastos]..sort((a, b) => b.fecha.compareTo(a.fecha));
          return ListView(
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (opcion) {
                          if (opcion == 'editar') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PantallaEditarGasto(gasto: gasto),
                              ),
                            );
                          } else if (opcion == 'eliminar') {
                            _confirmarEliminar(context, gasto);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'editar', child: Text('Editar')),
                          PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}