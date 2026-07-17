import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../models/gasto.dart';
import '../formato.dart';
import 'gasto_categoria_l10n.dart';

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
    montoCtrl = TextEditingController(text: cantidadStr(widget.gasto.monto));
    categoria = widget.gasto.categoria;
  }

  @override
  void dispose() {
    descripcionCtrl.dispose();
    montoCtrl.dispose();
    super.dispose();
  }

  void guardar() {
    final t = AppLocalizations.of(context)!;
    final descripcion = descripcionCtrl.text.trim();
    final monto = double.tryParse(montoCtrl.text.replaceAll(',', '.')) ?? -1;

    if (descripcion.isEmpty || monto <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.gastoDescripcionMonto)),
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
    final t = AppLocalizations.of(context)!;
    final datos = context.watch<DatosApp>();
    return Scaffold(
      appBar: AppBar(title: Text(t.editarGastoTitulo)),
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
              controller: montoCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [Decimal2Formatter()],
              decoration:
                  InputDecoration(labelText: t.monto, prefixText: '\$ '),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<CategoriaGasto>(
              initialValue: categoria,
              decoration: InputDecoration(labelText: t.categoria),
              items: CategoriaGasto.values.map((c) {
                return DropdownMenuItem(
                    value: c, child: Text(nombreCategoria(t, c)));
              }).toList(),
              onChanged: (nueva) => setState(() => categoria = nueva!),
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
