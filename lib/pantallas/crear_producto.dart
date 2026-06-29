import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/insumo.dart';
import '../models/producto.dart';
import '../models/ingrediente_de_receta.dart';
import '../tema.dart';
import '../formato.dart';
import 'selector_insumo.dart';
import 'widgets/resumen_producto.dart';
import 'selector_tipo.dart';

class PantallaCrearProducto extends StatefulWidget {
  const PantallaCrearProducto({super.key});

  @override
  State<PantallaCrearProducto> createState() => _PantallaCrearProductoState();
}

class _PantallaCrearProductoState extends State<PantallaCrearProducto> {
  final nombreCtrl = TextEditingController();
  final precioCtrl = TextEditingController();
  String tipo = '';

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
      receta.add(
          IngredienteDeReceta(insumo: insumoSeleccionado!, cantidad: cantidad));
      insumoSeleccionado = null;
      cantidadCtrl.clear();
    });
  }

  void guardarProducto() {
    final nombre = nombreCtrl.text.trim();
    final precio = double.tryParse(precioCtrl.text) ?? 0;
    if (nombre.isEmpty || precio <= 0 || receta.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Falta el nombre, el precio o al menos un ingrediente')),
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
    final datos = context.watch<DatosApp>();
    final insumosDisponibles = [...datos.insumos]
      ..sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
    final tiposExistentes = (<String>{
      for (final p in datos.productos)
        if (p.tipo.trim().isNotEmpty) p.tipo
    }.toList()
      ..sort());
    final precio = double.tryParse(precioCtrl.text) ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Crear producto')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Datos del producto ---
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: nombreCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del producto',
                      hintText: 'Ej: Torta de chocolate',
                      prefixIcon: Icon(Icons.shopping_bag_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final elegido =
                          await elegirTipo(context, tiposExistentes);
                      if (elegido != null && mounted) {
                        setState(() => tipo = elegido);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Tipo de producto',
                        prefixIcon: Icon(Icons.category_outlined),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                      child: Text(tipo.isEmpty ? 'Sin tipo' : tipo,
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: precioCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Precio de venta',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // --- Receta ---
          const Text('Receta',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColores.texto)),
          const SizedBox(height: 4),
          const Text('Agrega los insumos y cantidades que lleva una unidad',
              style: TextStyle(fontSize: 12, color: AppColores.textoSuave)),
          const SizedBox(height: 12),

          if (insumosDisponibles.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                    'Primero agrega insumos en la pantalla de Inventario.'),
              ),
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final elegido =
                              await elegirInsumo(context, insumosDisponibles);
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
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: cantidadCtrl,
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(labelText: 'Cantidad'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          icon: const Icon(Icons.add),
                          onPressed: agregarIngrediente,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),

          if (receta.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Aún no has agregado ingredientes.',
                  style: TextStyle(color: AppColores.textoSuave)),
            )
          else
            ...receta.map((ing) {
              return Card(
                child: ListTile(
                  title: Text(ing.insumo.nombre,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    '${ing.cantidad.toStringAsFixed(0)} ${ing.insumo.unidad}  ·  ${pesos(ing.costo)}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: AppColores.rojo),
                    onPressed: () => setState(() => receta.remove(ing)),
                  ),
                ),
              );
            }),
          const SizedBox(height: 20),

          // --- Resumen en vivo ---
          ResumenProducto(costo: costoActual, precio: precio),
          const SizedBox(height: 20),

          ElevatedButton(
              onPressed: guardarProducto,
              child: const Text('Guardar producto')),
        ],
      ),
    );
  }
}