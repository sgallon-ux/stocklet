import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../models/insumo.dart';
import '../formato.dart';

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
  late final TextEditingController minimoCtrl;
  late String unidad;

  @override
  void initState() {
    super.initState();
    nombreCtrl = TextEditingController(text: widget.insumo.nombre);
    costoCtrl = TextEditingController(
        text: cantidadStr(widget.insumo.costoPorUnidad));
    stockCtrl =
        TextEditingController(text: cantidadStr(widget.insumo.stockActual));
    minimoCtrl =
        TextEditingController(text: cantidadStr(widget.insumo.stockMinimo));
    unidad = widget.insumo.unidad;
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    costoCtrl.dispose();
    stockCtrl.dispose();
    minimoCtrl.dispose();
    super.dispose();
  }

  void guardar() {
    final t = AppLocalizations.of(context)!;
    final nombre = nombreCtrl.text.trim();
    final costo = double.tryParse(costoCtrl.text.replaceAll(',', '.')) ?? -1;
    final stock = double.tryParse(stockCtrl.text.replaceAll(',', '.')) ?? -1;

    if (nombre.isEmpty || costo < 0 || stock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.revisaCamposNegativos)),
      );
      return;
    }

    final minimo = parseCantidad(minimoCtrl.text);

    context.read<DatosApp>().editarInsumo(
      widget.insumo,
      nombre: nombre,
      unidad: unidad,
      costoPorUnidad: costo,
      stockActual: stock,
      stockMinimo: minimo,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final datos = context.watch<DatosApp>();
    return Scaffold(
      appBar: AppBar(title: Text(t.editarInsumoTitulo)),
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
                      labelText: t.campoNombre,
                      prefixIcon: const Icon(Icons.category_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: unidad,
                    decoration: InputDecoration(
                      labelText: t.unidadMedida,
                      prefixIcon: const Icon(Icons.straighten),
                    ),
                    items: [
                      DropdownMenuItem(value: 'g', child: Text(t.unidadGramos)),
                      DropdownMenuItem(
                          value: 'ml', child: Text(t.unidadMililitros)),
                      DropdownMenuItem(
                          value: 'unidad', child: Text(t.unidadUnidades)),
                    ],
                    onChanged: (nueva) => setState(() => unidad = nueva!),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: costoCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [Decimal2Formatter()],
                    decoration: InputDecoration(
                      labelText: t.costoPorUnidadLabel,
                      prefixIcon: const Icon(Icons.attach_money),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: stockCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [Decimal2Formatter()],
                    decoration: InputDecoration(
                      labelText: t.stockActualLabel,
                      prefixIcon: const Icon(Icons.inventory_2_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: minimoCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [Decimal2Formatter()],
                    decoration: InputDecoration(
                      labelText: t.stockMinimoOpcional,
                      hintText: t.stockMinimoHint,
                      prefixIcon:
                          const Icon(Icons.notifications_active_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (datos.puedeGestionarCatalogo)
            ElevatedButton(
                onPressed: guardar, child: Text(t.guardarCambios))
          else
            Center(child: Text(t.soloLectura)),
        ],
      ),
    );
  }
}
