import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/producto.dart';
import '../tema.dart';
import '../formato.dart';

class PantallaIngresarVenta extends StatefulWidget {
  const PantallaIngresarVenta({super.key});

  @override
  State<PantallaIngresarVenta> createState() => _PantallaIngresarVentaState();
}

class _PantallaIngresarVentaState extends State<PantallaIngresarVenta> {
  final descripcionCtrl = TextEditingController();
  final valorCtrl = TextEditingController();
  String tipoFiltro = 'Todos';

  @override
  void dispose() {
    descripcionCtrl.dispose();
    valorCtrl.dispose();
    super.dispose();
  }

  // --- Venta desde el catálogo ---
  void _venderProducto(Producto producto) {
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Venta de ${producto.nombre} registrada')),
              );
            },
            child: const Text('Vender'),
          ),
        ],
      ),
    );
  }

  // --- Venta manual ---
  void _venderManual() {
    final descripcion = descripcionCtrl.text.trim();
    final valor = double.tryParse(valorCtrl.text) ?? 0;
    if (descripcion.isEmpty || valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe una descripción y un valor válido')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar venta'),
        content: Text('¿Registrar la venta "$descripcion" por ${pesos(valor)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<DatosApp>().registrarVentaManual(descripcion, valor);
              Navigator.pop(dialogContext);
              descripcionCtrl.clear();
              valorCtrl.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Venta registrada')),
              );
            },
            child: const Text('Registrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingresar venta')),
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          final productos = (tipoFiltro == 'Todos'
              ? [...datos.productos]
              : datos.productos.where((p) => p.tipo == tipoFiltro).toList())
            ..sort((a, b) =>
                a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
          final tipos = (<String>{
            for (final p in datos.productos)
              if (p.tipo.trim().isNotEmpty) p.tipo
          }.toList()
            ..sort());

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ====== Venta manual ======
              const Text('Venta rápida',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColores.texto)),
              const SizedBox(height: 4),
              const Text('Para ventas que no son de un producto del catálogo',
                  style: TextStyle(fontSize: 12, color: AppColores.textoSuave)),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: descripcionCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                          hintText: 'Ej: café, domicilio…',
                          prefixIcon: Icon(Icons.edit_note),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: valorCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Valor',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _venderManual,
                          child: const Text('Registrar venta'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ====== Catálogo ======
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            tipoFiltro == 'Todos'
                                ? 'Vender un producto'
                                : 'Productos: $tipoFiltro',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColores.texto),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.arrow_drop_down),
                          tooltip: 'Filtrar por tipo',
                          onSelected: (valor) =>
                              setState(() => tipoFiltro = valor),
                          itemBuilder: (context) =>
                              ['Todos', ...tipos].map((t) {
                            return PopupMenuItem(value: t, child: Text(t));
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              if (productos.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                      child: Text('No hay productos. Créalos desde el menú Crear.')),
                )
              else
                ...productos.map((producto) {
                  return Card(
                    child: ListTile(
                      onTap: () => _venderProducto(producto),
                      leading: Container(
                        height: 44,
                        width: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColores.verde.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.shopping_bag_outlined,
                            color: AppColores.verde),
                      ),
                      title: Text(producto.nombre,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(pesos(producto.precioVenta)),
                      trailing: const Icon(Icons.add_shopping_cart_outlined, color: AppColores.verde),
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