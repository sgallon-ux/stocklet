import 'package:flutter/material.dart';
import '../tema.dart';
import 'crear_producto.dart';
import 'inventario.dart';
import 'pedidos.dart';

class CrearHub extends StatelessWidget {
  const CrearHub({super.key});

  Widget _item(BuildContext context, IconData icono, String titulo,
      String sub, Widget destino) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => destino)),
        leading: Container(
          height: 44,
          width: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColores.verde.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icono, color: AppColores.verde),
        ),
        title: Text(titulo,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColores.texto)),
        subtitle: Text(sub),
        trailing: const Icon(Icons.chevron_right, color: AppColores.textoSuave),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear y gestionar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _item(context, Icons.add_business_outlined, 'Nuevo producto',
              'Añade un producto con su receta', const PantallaCrearProducto()),
          _item(context, Icons.inventory_2_outlined, 'Inventario',
              'Insumos, costos y stock', const PantallaInventario()),
          _item(context, Icons.receipt_long_outlined, 'Pedidos',
              'Encargos de clientes', const PantallaPedidos()),
        ],
      ),
    );
  }
}