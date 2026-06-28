import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/venta.dart';
import 'editar_venta.dart';
import '../formato.dart';

class PantallaHistorialVentas extends StatelessWidget {
  const PantallaHistorialVentas({super.key});

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
            child: const Text('Cancelar'),
          ),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de ventas')),
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          if (datos.ventas.isEmpty) {
            return const Center(child: Text('Aún no hay ventas registradas.'));
          }
          final lista = [...datos.ventas]..sort((a, b) => b.fecha.compareTo(a.fecha));
          return ListView(
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
                      Text(
                        pesos(venta.total),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (opcion) {
                          if (opcion == 'editar') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PantallaEditarVenta(venta: venta),
                              ),
                            );
                          } else if (opcion == 'eliminar') {
                            _confirmarEliminar(context, venta);
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