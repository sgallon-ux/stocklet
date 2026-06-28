import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/pedido.dart';
import 'crear_pedido.dart';
import 'editar_pedido.dart';
import '../formato.dart';

class PantallaPedidos extends StatelessWidget {
  const PantallaPedidos({super.key});

  void _confirmarEliminar(BuildContext context, Pedido pedido) {
    final datos = context.read<DatosApp>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar pedido'),
        content: Text('¿Seguro que quieres eliminar el pedido de ${pedido.cliente.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              datos.eliminarPedido(pedido);
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
      appBar: AppBar(title: const Text('Pedidos'),
        actions: [
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'Agregar pedido',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PantallaCrearPedido()),
            );
          },
        ),
      ],
    ),
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          if (datos.pedidos.isEmpty) {
            return const Center(
              child: Text('Aún no hay pedidos. Crea el primero con el botón +'),
            );
          }

          int porNombre(Pedido a, Pedido b) =>
              a.cliente.nombre.toLowerCase().compareTo(b.cliente.nombre.toLowerCase());
          final pendientes = datos.pedidos.where((p) => !p.entregado).toList()
            ..sort(porNombre);
          final entregados = datos.pedidos.where((p) => p.entregado).toList()
            ..sort(porNombre);
          final ordenados = [...pendientes, ...entregados];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: ordenados.map((pedido) {
              return Card(
                child: ListTile(
                  leading: Icon(
                    pedido.entregado ? Icons.check_circle : Icons.schedule,
                    color: pedido.entregado ? Colors.green : Colors.orange,
                  ),
                  title: Text('${pedido.cliente.nombre} — ${pedido.descripcion}'),
                  subtitle: Text(
                    'Entrega: ${pedido.fechaEntrega.day}/${pedido.fechaEntrega.month}/${pedido.fechaEntrega.year}'
                    '  ·  ${pesos(pedido.precio)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!pedido.entregado)
                        TextButton(
                          onPressed: () =>
                              context.read<DatosApp>().marcarPedidoEntregado(pedido),
                          child: const Text('Entregar'),
                        ),
                      PopupMenuButton<String>(
                        onSelected: (opcion) {
                          if (opcion == 'editar') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PantallaEditarPedido(pedido: pedido),
                              ),
                            );
                          } else if (opcion == 'eliminar') {
                            _confirmarEliminar(context, pedido);
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