import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/insumo.dart';

class PantallaEditarInsumo extends StatefulWidget {
  final Insumo insumo;
  const PantallaEditarInsumo({super.key, required this.insumo});

  @override
  State<PantallaEditarInsumo> createState() => _PantallaEditarInsumoState();
}

class _PantallaEditarInsumoState extends State<PantallaEditarInsumo> {
  late final TextEditingController nombreCtrl;
  late final TextEditingController costoCtrl;
  late final TextEditingController stockCtrl;
  late String unidad;

  @override
  void initState() {
    super.initState();
    nombreCtrl = TextEditingController(text: widget.insumo.nombre);
    costoCtrl =
        TextEditingController(text: widget.insumo.costoPorUnidad.toString());
    stockCtrl =
        TextEditingController(text: widget.insumo.stockActual.toString());
    unidad = widget.insumo.unidad;
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    costoCtrl.dispose();
    stockCtrl.dispose();
    super.dispose();
  }

  void guardar() {
    final nombre = nombreCtrl.text.trim();
    final costo = double.tryParse(costoCtrl.text) ?? -1;
    final stock = double.tryParse(stockCtrl.text) ?? -1;

    if (nombre.isEmpty || costo < 0 || stock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Revisa los campos: valores válidos, sin negativos')),
      );
      return;
    }

    context.read<DatosApp>().editarInsumo(
          widget.insumo,
          nombre: nombre,
          unidad: unidad,
          costoPorUnidad: costo,
          stockActual: stock,
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar insumo')),
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
                      labelText: 'Nombre',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: unidad,
                    decoration: const InputDecoration(
                      labelText: 'Unidad de medida',
                      prefixIcon: Icon(Icons.straighten),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'g', child: Text('Gramos (g)')),
                      DropdownMenuItem(value: 'ml', child: Text('Mililitros (ml)')),
                      DropdownMenuItem(value: 'unidad', child: Text('Unidades')),
                    ],
                    onChanged: (nueva) => setState(() => unidad = nueva!),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: costoCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Costo por unidad',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: stockCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Stock actual',
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: guardar, child: const Text('Guardar cambios')),
        ],
      ),
    );
  }
}