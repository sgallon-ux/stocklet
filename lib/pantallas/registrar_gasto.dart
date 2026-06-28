import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/gasto.dart';

class PantallaRegistrarGasto extends StatefulWidget {
  const PantallaRegistrarGasto({super.key});

  @override
  State<PantallaRegistrarGasto> createState() => _PantallaRegistrarGastoState();
}

class _PantallaRegistrarGastoState extends State<PantallaRegistrarGasto> {
  final descripcionCtrl = TextEditingController();
  final montoCtrl = TextEditingController();
  CategoriaGasto categoria = CategoriaGasto.insumos;

  @override
  void dispose() {
    descripcionCtrl.dispose();
    montoCtrl.dispose();
    super.dispose();
  }

  void guardar() {
    final descripcion = descripcionCtrl.text.trim();
    final monto = double.tryParse(montoCtrl.text) ?? 0;

    if (descripcion.isEmpty || monto <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe una descripción y un monto válido')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar gasto'),
        content: Text('¿Registrar el gasto "$descripcion" por \$${monto.toStringAsFixed(0)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<DatosApp>().registrarGasto(Gasto(
                fecha: DateTime.now(),
                descripcion: descripcion,
                categoria: categoria,
                monto: monto,
              ));
              Navigator.pop(dialogContext); // cierra el diálogo
              Navigator.pop(context);       // cierra la pantalla de gasto
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar gasto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: descripcionCtrl,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Ej: compra de harina',
              ),
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
            ElevatedButton(onPressed: guardar, child: const Text('Guardar gasto')),
          ],
        ),
      ),
    );
  }
}