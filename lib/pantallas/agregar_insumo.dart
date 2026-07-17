import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../models/insumo.dart';
import '../tema.dart';
import '../formato.dart';

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
    final t = AppLocalizations.of(context)!;
    final nombre = nombreCtrl.text.trim();
    final cantidad = parseCantidad(cantidadCtrl.text);
    final precio = parseCantidad(precioCtrl.text);

    if (nombre.isEmpty || cantidad <= 0 || precio <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.completaCamposValidos)),
      );
      return;
    }

    final costoPorUnidad = precio / cantidad; // la app hace la cuenta

    final minimo = parseCantidad(minimoCtrl.text);

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
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.agregarInsumoTitulo)),
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
                      hintText: t.insumoNombreHint,
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
                    controller: cantidadCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [Decimal2Formatter()],
                    decoration: InputDecoration(
                      labelText: t.cantidadComprada,
                      hintText: t.cantidadCompradaHint,
                      prefixIcon: const Icon(Icons.scale_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: precioCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [Decimal2Formatter()],
                    decoration: InputDecoration(
                      labelText: t.precioTotalPagado,
                      prefixIcon: const Icon(Icons.attach_money),
                    ),
                  ),
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              t.agregarInsumoAyuda,
              style:
                  TextStyle(fontSize: 12, color: AppColores.of(context).textoSuave),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: guardar, child: Text(t.guardarInsumo)),
        ],
      ),
    );
  }
}
