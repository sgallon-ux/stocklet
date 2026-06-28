import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';

class PantallaIngresarVenta extends StatefulWidget {
  const PantallaIngresarVenta({super.key});

  @override
  State<PantallaIngresarVenta> createState() => _PantallaIngresarVentaState();
}

class _PantallaIngresarVentaState extends State<PantallaIngresarVenta> {
  final descripcionCtrl = TextEditingController();
  final valorCtrl = TextEditingController();

  @override
  void dispose() {
    descripcionCtrl.dispose();
    valorCtrl.dispose();
    super.dispose();
  }

  void guardar() {
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
        content: Text('¿Registrar la venta "$descripcion" por \$${valor.toStringAsFixed(0)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<DatosApp>().registrarVentaManual(descripcion, valor);
              Navigator.pop(dialogContext); // cierra el diálogo
              Navigator.pop(context);       // cierra la pantalla
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: descripcionCtrl,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Ej: venta de café, domicilio…',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: valorCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Valor de la venta', prefixText: '\$ '),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: guardar, child: const Text('Registrar venta')),
          ],
        ),
      ),
    );
  }
}