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

class PantallaEditarProducto extends StatefulWidget {
  final Producto producto;
  const PantallaEditarProducto({super.key, required this.producto});

  @override
  State<PantallaEditarProducto> createState() => _PantallaEditarProductoState();
}

class _PantallaEditarProductoState extends State<PantallaEditarProducto> {
  late final TextEditingController nombreCtrl;
  late final TextEditingController precioCtrl;
  late String tipo;
  late List<IngredienteDeReceta> receta;

  Insumo? insumoSeleccionado;
  final cantidadCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    nombreCtrl = TextEditingController(text: widget.producto.nombre);
    precioCtrl = TextEditingController(
        text: widget.producto.precioVenta.toStringAsFixed(0));
    tipo = widget.producto.tipo;
    receta = List.of(widget.producto.receta);
  }

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

  void guardarCambios() {
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
    context.read<DatosApp>().editarProducto(
          widget.producto,
          nombre: nombre,
          tipo: tipo,
          precioVenta: precio,
          receta: receta,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final insumosDisponibles = [...context.watch<DatosApp>().insumos]
      ..sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
    final precio = double.tryParse(precioCtrl.text) ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Editar producto')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
                      prefixIcon: Icon(Icons.shopping_bag_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: tipo,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de producto',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
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
                child: Text('No hay insumos en el inventario.'),
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
              child: Text('La receta está vacía.',
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

          ResumenProducto(costo: costoActual, precio: precio),
          const SizedBox(height: 20),

          ElevatedButton(
              onPressed: guardarCambios,
              child: const Text('Guardar cambios')),
        ],
      ),
    );
  }
}