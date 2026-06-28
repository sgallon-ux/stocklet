import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../datos_app.dart';
import '../models/producto.dart';
import 'registrar_gasto.dart';
import 'inventario.dart';
import 'crear_producto.dart';
import 'editar_producto.dart';
import 'pedidos.dart';
import 'historial_gastos.dart';
import 'historial_ventas.dart';
import 'ingresar_venta.dart';
import 'reportes.dart';
import '../formato.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  String tipoFiltro = 'Todos';

  void _confirmarVenta(Producto producto) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar venta'),
        content: Text(
          '¿Registrar la venta de ${producto.nombre} por ${pesos(producto.precioVenta)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<DatosApp>().registrarVenta(producto, 1);
              Navigator.pop(dialogContext);
            },
            child: const Text('Vender'),
          ),
        ],
      ),
    );
  }

  void _confirmarEliminarProducto(Producto producto) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text(
          '¿Seguro que quieres eliminar "${producto.nombre}"? '
          'Las ventas ya registradas no se modifican.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<DatosApp>().eliminarProducto(producto);
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
      appBar: AppBar(
        title: Text(context.watch<DatosApp>().negocio?.nombre ?? 'Mi negocio'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: (opcion) {
              switch (opcion) {
                case 'inventario':
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const PantallaInventario()));
                  break;
                case 'pedidos':
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const PantallaPedidos()));
                  break;
                case 'reportes':
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const PantallaReportes()));
                  break;
                case 'salir':
                  FirebaseAuth.instance.signOut();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'inventario',
                child: Row(children: const [
                  Icon(Icons.inventory_2), SizedBox(width: 12), Text('Inventario'),
                ]),
              ),
              PopupMenuItem(
                value: 'pedidos',
                child: Row(children: const [
                  Icon(Icons.receipt_long), SizedBox(width: 12), Text('Pedidos'),
                ]),
              ),
              PopupMenuItem(
                value: 'reportes',
                child: Row(children: const [
                  Icon(Icons.bar_chart), SizedBox(width: 12), Text('Reportes'),
                ]),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'salir',
                child: Row(children: const [
                  Icon(Icons.logout), SizedBox(width: 12), Text('Cerrar sesión'),
                ]),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          // Filtra por tipo y ordena alfabéticamente (A-Z)
          final productos = (tipoFiltro == 'Todos'
              ? [...datos.productos]
              : datos.productos.where((p) => p.tipo == tipoFiltro).toList())
            ..sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ingresos: ${pesos(datos.ingresosTotales)}'),
                      Text('Gastos: ${pesos(datos.gastosTotales)}'),
                      const Divider(),
                      Text(
                        'Ganancia: ${pesos(datos.ganancia)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const PantallaHistorialVentas()));
                      },
                      icon: const Icon(Icons.point_of_sale),
                      label: const Text('Ventas'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const PantallaHistorialGastos()));
                      },
                      icon: const Icon(Icons.history),
                      label: const Text('Gastos'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const PantallaIngresarVenta()));
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Registrar venta'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const PantallaRegistrarGasto()));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Registrar gasto'),
                  ),
                ),
               ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            tipoFiltro == 'Todos' ? 'Productos' : 'Productos: $tipoFiltro',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.arrow_drop_down),
                          tooltip: 'Filtrar por tipo',
                          onSelected: (valor) => setState(() => tipoFiltro = valor),
                          itemBuilder: (context) => ['Todos', ...tiposDeProducto].map((t) {
                            return PopupMenuItem(value: t, child: Text(t));
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const PantallaCrearProducto()));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Crear'),
                  ),
                ],
              ),
              if (productos.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('No hay productos de este tipo.'),
                )
              else
                ...productos.map((producto) {
                  return Card(
                    child: ListTile(
                      title: Text(producto.nombre),
                      subtitle: Text(
                        'Precio: ${pesos(producto.precioVenta)}  ·  '
                        'Ganancia: ${pesos(producto.ganancia)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () => _confirmarVenta(producto),
                            child: const Text('Vender'),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (opcion) {
                              if (opcion == 'editar') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PantallaEditarProducto(producto: producto),
                                  ),
                                );
                              } else if (opcion == 'eliminar') {
                                _confirmarEliminarProducto(producto);
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
                }),
            ],
          );
        },
      ),
    );
  }
}