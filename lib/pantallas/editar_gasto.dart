import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/gasto.dart';

class PantallaEditarGasto extends StatefulWidget {
  final Gasto gasto;
  const PantallaEditarGasto({super.key, required this.gasto});

  @override
  State<PantallaEditarGasto> createState() => _PantallaEditarGastoState();
}

class _PantallaEditarGastoState extends State<PantallaEditarGasto> {
  late final TextEditingController descripcionCtrl;
  late final TextEditingController montoCtrl;
  late CategoriaGasto categoria;

  @override
  void initState() {
    super.initState();
    descripcionCtrl = TextEditingController(text: widget.gasto.descripcion);
    montoCtrl = TextEditingController(text: widget.gasto.monto.toStringAsFixed(0));
    categoria = widget.gasto.categoria;
  }

  @override
  void dispose() {
    descripcionCtrl.dispose();
    montoCtrl.dispose();
    super.dispose();
  }

  void guardar() {
    final descripcion = descripcionCtrl.text.trim();
    final monto = double.tryParse(montoCtrl.text) ?? -1;

    if (descripcion.isEmpty || monto <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe una descripción y un monto válido')),
      );
      return;
    }

    context.read<DatosApp>().editarGasto(
      widget.gasto,
      descripcion: descripcion,
      categoria: categoria,
      monto: monto,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar gasto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: descripcionCtrl,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: montoCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monto', prefixText: '\$ '),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<CategoriaGasto>(
              initialValue: categoria,
              decoration: const InputDecoration(labelText: 'Categoría'),
              items: CategoriaGasto.values.map((c) {
                return DropdownMenuItem(value: c, child: Text(c.name));
              }).toList(),
              onChanged: (nueva) => setState(() => categoria = nueva!),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: guardar, child: const Text('Guardar cambios')),
          ],
        ),
      ),
    );
  }
}