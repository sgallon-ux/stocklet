import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
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
    final t = AppLocalizations.of(context)!;
    final descripcion = descripcionCtrl.text.trim();
    final cantidad = int.tryParse(cantidadCtrl.text) ?? 0;
    final precio = double.tryParse(precioCtrl.text) ?? 0;

    if (descripcion.isEmpty || cantidad <= 0 || precio <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.revisaCamposMayorCero)),
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
    final t = AppLocalizations.of(context)!;
    final datos = context.watch<DatosApp>();
    return Scaffold(
      appBar: AppBar(title: Text(t.editarVentaTitulo)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: descripcionCtrl,
              decoration: InputDecoration(labelText: t.descripcion),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cantidadCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: t.cantidad),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: precioCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: t.precioUnitario, prefixText: '\$ '),
            ),
            const SizedBox(height: 24),
            if (datos.puedeEditarFinanzas)
              ElevatedButton(
                  onPressed: guardar, child: Text(t.guardarCambios))
            else
              Center(child: Text(t.soloLectura)),
          ],
        ),
      ),
    );
  }
}
