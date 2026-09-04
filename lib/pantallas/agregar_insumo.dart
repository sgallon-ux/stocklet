import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../models/insumo.dart';
import '../tema.dart';
import '../formato.dart';
import '../unidades.dart';

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
  final proveedorCtrl = TextEditingController();
  String categoria = 'Otros';
  String unidadCompra = 'kg';
  bool especial = false;

  @override
  void initState() {
    super.initState();
    cantidadCtrl.addListener(() => setState(() {}));
    precioCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    cantidadCtrl.dispose();
    precioCtrl.dispose();
    minimoCtrl.dispose();
    proveedorCtrl.dispose();
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

    context.read<DatosApp>().agregarInsumo(Insumo.desdePresentacion(
          nombre: nombre,
          categoria: categoria,
          cantidadCompra: cantidad,
          unidadCompra: unidadCompra,
          precioPresentacion: precio,
          stockMinimo: parseCantidad(minimoCtrl.text),
          proveedor: proveedorCtrl.text.trim(),
          especial: especial,
        ));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final m = AppColores.of(context);
    final cantidad = parseCantidad(cantidadCtrl.text);
    final precio = parseCantidad(precioCtrl.text);
    final base = baseDeUnidad(unidadCompra);
    final costo = costoBaseDesde(precio, cantidad, unidadCompra);

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
                    initialValue: categoria,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: t.categoriaLabel,
                      prefixIcon: const Icon(Icons.label_outline),
                    ),
                    items: [
                      for (final c in kCategoriasInsumo)
                        DropdownMenuItem(value: c, child: Text(c)),
                    ],
                    onChanged: (v) => setState(() => categoria = v!),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: cantidadCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [Decimal2Formatter()],
                          decoration: InputDecoration(
                            labelText: t.cantidadQueCompras,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: unidadCompra,
                          isExpanded: true,
                          decoration:
                              InputDecoration(labelText: t.unidadDeCompra),
                          items: [
                            for (final e in kUnidades.entries)
                              DropdownMenuItem(
                                  value: e.key, child: Text(e.value.rot)),
                          ],
                          onChanged: (v) => setState(() => unidadCompra = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: precioCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [Decimal2Formatter()],
                    decoration: InputDecoration(
                      labelText: t.precioPresentacionLabel,
                      prefixIcon: const Icon(Icons.attach_money),
                    ),
                  ),
                  if (costo > 0) ...[
                    const SizedBox(height: 10),
                    Text(
                      t.costoPorUnidadCalculado(pesos(costo), rotBase(base)),
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: m.verde),
                    ),
                  ],
                  const SizedBox(height: 16),
                  TextField(
                    controller: proveedorCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: t.proveedorOpcional,
                      prefixIcon: const Icon(Icons.storefront_outlined),
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
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: especial,
                    onChanged: (v) => setState(() => especial = v),
                    title: Text(t.insumoEspecialLabel),
                    subtitle: Text(t.insumoEspecialAyuda,
                        style: TextStyle(fontSize: 12, color: m.textoSuave)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: guardar, child: Text(t.guardarInsumo)),
        ],
      ),
    );
  }
}
