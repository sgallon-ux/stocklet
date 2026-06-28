import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/insumo.dart';
import '../models/producto.dart';
import '../models/ingrediente_de_receta.dart';
import '../formato.dart';
import 'selector_insumo.dart';

class PantallaCrearProducto extends StatefulWidget {
  const PantallaCrearProducto({super.key});

  @override
  State<PantallaCrearProducto> createState() => _PantallaCrearProductoState();
}

class _PantallaCrearProductoState extends State<PantallaCrearProducto> {
  final nombreCtrl = TextEditingController();
  final precioCtrl = TextEditingController();
  String tipo = 'Otro';

  final List<IngredienteDeReceta> receta = [];

  Insumo? insumoSeleccionado;
  final cantidadCtrl = TextEditingController();

  @override
  void dispose() {
    nombreCtrl.dispose();
    precioCtrl.dispose();
    cantidadCtrl.dispose();
    super.dispose();
  }

  double get costoActual {
    double total = 0;
    for (final ing in receta) {
      total += ing.costo;
    }
    return total;
  }

  void agregarIngrediente() {
    final cantidad = double.tryParse(cantidadCtrl.text) ?? 0;
    if (insumoSeleccionado == null || cantidad <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Elige un insumo y una cantidad válida')),
      );
      return;
    }
    if (receta.any((ing) => ing.insumo == insumoSeleccionado)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ese insumo ya está en la receta')),
      );
      return;
    }
    setState(() {
      receta.add(IngredienteDeReceta(insumo: insumoSeleccionado!, cantidad: cantidad));
      insumoSeleccionado = null;
      cantidadCtrl.clear();
    });
  }

  void guardarProducto() {
    final nombre = nombreCtrl.text.trim();
    final precio = double.tryParse(precioCtrl.text) ?? 0;
    if (nombre.isEmpty || precio <= 0 || receta.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falta el nombre, el precio o al menos un ingrediente')),
      );
      return;
    }
    context.read<DatosApp>().agregarProducto(Producto(
      nombre: nombre,
      tipo: tipo,
      precioVenta: precio,
      receta: receta,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // insumos ordenados A-Z
    final insumosDisponibles = [...context.watch<DatosApp>().insumos]
      ..sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
    final precio = double.tryParse(precioCtrl.text) ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Crear producto')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: nombreCtrl,
            decoration: const InputDecoration(
              labelText: 'Nombre del producto',
              hintText: 'Ej: Torta de chocolate',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: tipo,
            decoration: const InputDecoration(labelText: 'Tipo de producto'),
            items: tiposDeProducto.map((t) {
              return DropdownMenuItem(value: t, child: Text(t));
            }).toList(),
            onChanged: (nuevo) => setState(() => tipo = nuevo!),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: precioCtrl,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(labelText: 'Precio de venta', prefixText: '\$ '),
          ),
          const SizedBox(height: 24),
          const Text('Receta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (insumosDisponibles.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Primero agrega insumos en la pantalla de Inventario.'),
            )
          else
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final elegido = await elegirInsumo(context, insumosDisponibles);
                      if (elegido != null && mounted) {
                        setState(() => insumoSeleccionado = elegido);
                      }
                    },
                    icon: const Icon(Icons.search),
                    label: Text(
                      insumoSeleccionado?.nombre ?? 'Elegir insumo',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: cantidadCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Cantidad'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add_circle),
                      onPressed: agregarIngrediente,
                    ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 16),
          if (receta.isEmpty)
            const Text('Aún no has agregado ingredientes.')
          else
            ...receta.map((ing) {
              return ListTile(
                dense: true,
                title: Text(ing.insumo.nombre),
                subtitle: Text(
                  '${ing.cantidad.toStringAsFixed(0)} ${ing.insumo.unidad}'
                  '  ·  ${pesos(ing.costo)}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => setState(() => receta.remove(ing)),
                ),
              );
            }),
          const Divider(height: 32),
          Text('Costo de producción: ${pesos(costoActual)}',
              style: const TextStyle(fontSize: 16)),
          Text('Ganancia por unidad: ${pesos(precio - costoActual)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: guardarProducto, child: const Text('Guardar producto')),
        ],
      ),
    );
  }
}