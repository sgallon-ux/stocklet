import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/insumo.dart';
import '../tema.dart';

class PantallaAgregarInsumo extends StatefulWidget {
  const PantallaAgregarInsumo({super.key});

  @override
  State<PantallaAgregarInsumo> createState() => _PantallaAgregarInsumoState();
}

class _PantallaAgregarInsumoState extends State<PantallaAgregarInsumo> {
  final nombreCtrl = TextEditingController();
  final cantidadCtrl = TextEditingController();
  final precioCtrl = TextEditingController();
  final minimoCtrl = TextEditingController();
  String unidad = 'g';

  @override
  void dispose() {
    nombreCtrl.dispose();
    cantidadCtrl.dispose();
    precioCtrl.dispose();
    minimoCtrl.dispose();
    super.dispose();
  }

  void guardar() {
    final nombre = nombreCtrl.text.trim();
    final cantidad = double.tryParse(cantidadCtrl.text) ?? 0;
    final precio = double.tryParse(precioCtrl.text) ?? 0;

    if (nombre.isEmpty || cantidad <= 0 || precio <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Completa todos los campos con valores válidos')),
      );
      return;
    }

    final costoPorUnidad = precio / cantidad; // la app hace la cuenta

    final minimo = double.tryParse(minimoCtrl.text) ?? 0;

    context.read<DatosApp>().agregarInsumo(Insumo(
          nombre: nombre,
          unidad: unidad,
          costoPorUnidad: costoPorUnidad,
          stockActual: cantidad, // lo que compraste es tu stock inicial
          stockMinimo: minimo,
        ));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar insumo')),
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
                      hintText: 'Ej: Harina',
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
                    controller: cantidadCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad comprada',
                      hintText: 'Ej: 1000',
                      prefixIcon: Icon(Icons.scale_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: precioCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Precio total pagado',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  TextField(
                    controller: minimoCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Stock mínimo (opcional)',
                      hintText: 'Avisar cuando baje de...',
                      prefixIcon: Icon(Icons.notifications_active_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Con la cantidad y el precio, la app calcula sola el costo por unidad.',
              style:
                  TextStyle(fontSize: 12, color: AppColores.of(context).textoSuave),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: guardar, child: const Text('Guardar insumo')),
        ],
      ),
    );
  }
}