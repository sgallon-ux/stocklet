import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
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
    final t = AppLocalizations.of(context)!;
    final cantidad = double.tryParse(cantidadCtrl.text) ?? 0;
    if (insumoSeleccionado == null || cantidad <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.eligeInsumoCantidad)),
      );
      return;
    }
    if (receta.any((ing) => ing.insumo == insumoSeleccionado)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.insumoYaEnReceta)),
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
    final t = AppLocalizations.of(context)!;
    final nombre = nombreCtrl.text.trim();
    final precio = double.tryParse(precioCtrl.text) ?? 0;
    if (nombre.isEmpty || precio <= 0 || receta.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.faltaNombrePrecioIngrediente)),
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
    final t = AppLocalizations.of(context)!;
    final datos = context.watch<DatosApp>();
    final m = AppColores.of(context);
    final insumosDisponibles = [...datos.insumos]
      ..sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
    final tiposExistentes = (<String>{
      for (final p in datos.productos)
        if (p.tipo.trim().isNotEmpty) p.tipo
    }.toList()
      ..sort());
    final precio = double.tryParse(precioCtrl.text) ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text(t.crearProductoTitulo)),
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
                    decoration: InputDecoration(
                      labelText: t.nombreProducto,
                      hintText: t.nombreProductoHint,
                      prefixIcon: const Icon(Icons.shopping_bag_outlined),
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
                      decoration: InputDecoration(
                        labelText: t.tipoProducto,
                        prefixIcon: const Icon(Icons.category_outlined),
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                      ),
                      child: Text(tipo.isEmpty ? t.sinTipo : tipo,
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: precioCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: t.precioVenta,
                      prefixIcon: const Icon(Icons.attach_money),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(t.recetaTitulo,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: m.texto)),
          const SizedBox(height: 4),
          Text(t.recetaAyuda,
              style: TextStyle(fontSize: 12, color: m.textoSuave)),
          const SizedBox(height: 12),
          if (insumosDisponibles.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(t.recetaSinInsumos),
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
                          insumoSeleccionado?.nombre ?? t.elegirInsumoTitulo,
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
                                InputDecoration(labelText: t.cantidad),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(t.sinIngredientes,
                  style: TextStyle(color: m.textoSuave)),
            )
          else
            ...receta.map((ing) {
              return Card(
                child: ListTile(
                  title: Text(ing.insumo.nombre,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    t.ingredienteSubtitulo(
                        ing.cantidad.toStringAsFixed(0),
                        ing.insumo.unidad,
                        pesos(ing.costo)),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: m.rojo),
                    onPressed: () => setState(() => receta.remove(ing)),
                  ),
                ),
              );
            }),
          const SizedBox(height: 20),
          ResumenProducto(costo: costoActual, precio: precio),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: guardarProducto,
              child: Text(t.guardarProducto)),
        ],
      ),
    );
  }
}
