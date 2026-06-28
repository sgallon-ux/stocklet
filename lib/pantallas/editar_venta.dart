import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/venta.dart';

class PantallaEditarVenta extends StatefulWidget {
  final Venta venta;
  const PantallaEditarVenta({super.key, required this.venta});

  @override
  State<PantallaEditarVenta> createState() => _PantallaEditarVentaState();
}

class _PantallaEditarVentaState extends State<PantallaEditarVenta> {
  late final TextEditingController descripcionCtrl;
  late final TextEditingController cantidadCtrl;
  late final TextEditingController precioCtrl;

  @override
  void initState() {
    super.initState();
    descripcionCtrl = TextEditingController(text: widget.venta.descripcion);
    cantidadCtrl = TextEditingController(text: widget.venta.cantidad.toString());
    precioCtrl = TextEditingController(text: widget.venta.precioUnitario.toStringAsFixed(0));
  }

  @override
  void dispose() {
    descripcionCtrl.dispose();
    cantidadCtrl.dispose();
    precioCtrl.dispose();
    super.dispose();
  }

  void guardar() {
    final descripcion = descripcionCtrl.text.trim();
    final cantidad = int.tryParse(cantidadCtrl.text) ?? 0;
    final precio = double.tryParse(precioCtrl.text) ?? 0;

    if (descripcion.isEmpty || cantidad <= 0 || precio <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Revisa los campos: valores válidos y mayores a cero')),
      );
      return;
    }

    context.read<DatosApp>().editarVenta(
      widget.venta,
      descripcion: descripcion,
      cantidad: cantidad,
      precioUnitario: precio,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar venta')),
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
              controller: cantidadCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cantidad'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: precioCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio unitario', prefixText: '\$ '),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: guardar, child: const Text('Guardar cambios')),
          ],
        ),
      ),
    );
  }
}