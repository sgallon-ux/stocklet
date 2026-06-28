import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/insumo.dart';

class PantallaAgregarInsumo extends StatefulWidget {
  const PantallaAgregarInsumo({super.key});

  @override
  State<PantallaAgregarInsumo> createState() => _PantallaAgregarInsumoState();
}

class _PantallaAgregarInsumoState extends State<PantallaAgregarInsumo> {
  final nombreCtrl = TextEditingController();
  final cantidadCtrl = TextEditingController();
  final precioCtrl = TextEditingController();
  String unidad = 'g';

  @override
  void dispose() {
    nombreCtrl.dispose();
    cantidadCtrl.dispose();
    precioCtrl.dispose();
    super.dispose();
  }

  void guardar() {
    final nombre = nombreCtrl.text.trim();
    final cantidad = double.tryParse(cantidadCtrl.text) ?? 0;
    final precio = double.tryParse(precioCtrl.text) ?? 0;

    if (nombre.isEmpty || cantidad <= 0 || precio <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos con valores válidos')),
      );
      return;
    }

    final costoPorUnidad = precio / cantidad; // la app hace la cuenta

    context.read<DatosApp>().agregarInsumo(Insumo(
      nombre: nombre,
      unidad: unidad,
      costoPorUnidad: costoPorUnidad,
      stockActual: cantidad, // lo que compraste es tu stock inicial
    ));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar insumo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre', hintText: 'Ej: Harina'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: unidad,
              decoration: const InputDecoration(labelText: 'Unidad de medida'),
              items: const [
                DropdownMenuItem(value: 'g', child: Text('Gramos (g)')),
                DropdownMenuItem(value: 'ml', child: Text('Mililitros (ml)')),
                DropdownMenuItem(value: 'unidad', child: Text('Unidades')),
              ],
              onChanged: (nueva) => setState(() => unidad = nueva!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cantidadCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cantidad comprada', hintText: 'Ej: 1000'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: precioCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio total pagado', prefixText: '\$ '),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: guardar, child: const Text('Guardar insumo')),
          ],
        ),
      ),
    );
  }
}