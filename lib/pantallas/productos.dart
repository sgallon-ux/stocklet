import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/producto.dart';
import '../tema.dart';
import '../formato.dart';
import 'crear_producto.dart';
import 'editar_producto.dart';

class PantallaProductos extends StatelessWidget {
  const PantallaProductos({super.key});

  void _confirmarEliminar(BuildContext context, Producto p) {
    final datos = context.read<DatosApp>();
    showDialog(
      context: context,
      builder: (dc) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text(
            '¿Eliminar "${p.nombre}"? Las ventas ya registradas no se modifican.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              datos.eliminarProducto(p);
              Navigator.pop(dc);
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
      appBar: AppBar(title: const Text('Productos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const PantallaCrearProducto())),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
      ),
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          final m = AppColores.of(context);
          final productos = [...datos.productos]
            ..sort((a, b) =>
                a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));

          if (productos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text('Aún no tienes productos.\nCrea uno con el botón +',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: m.textoSuave)),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: productos.map((p) {
              final gananciaColor = p.ganancia >= 0 ? m.verde : m.rojo;
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              PantallaEditarProducto(producto: p))),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          height: 44,
                          width: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: m.verde.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.shopping_bag_outlined,
                              color: m.verde),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.nombre,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: m.texto)),
                              const SizedBox(height: 2),
                              Text(
                                  p.tipo.trim().isEmpty
                                      ? pesos(p.precioVenta)
                                      : '${p.tipo}  ·  ${pesos(p.precioVenta)}',
                                  style: TextStyle(
                                      fontSize: 12, color: m.textoSuave)),
                              Text('Ganancia: ${pesos(p.ganancia)}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: gananciaColor)),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (op) {
                            if (op == 'editar') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          PantallaEditarProducto(producto: p)));
                            } else if (op == 'eliminar') {
                              _confirmarEliminar(context, p);
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'editar', child: Text('Editar')),
                            PopupMenuItem(
                                value: 'eliminar', child: Text('Eliminar')),
                          ],
                        ),
                      ],
                    ),
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