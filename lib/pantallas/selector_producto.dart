import 'package:flutter/material.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../models/producto.dart';
import '../formato.dart';

Future<Producto?> elegirProducto(BuildContext context, List<Producto> productos) {
  return showDialog<Producto>(
    context: context,
    builder: (context) => _DialogoSelectorProducto(productos: productos),
  );
}

class _DialogoSelectorProducto extends StatefulWidget {
  final List<Producto> productos;
  const _DialogoSelectorProducto({required this.productos});

  @override
  State<_DialogoSelectorProducto> createState() =>
      _DialogoSelectorProductoState();
}

class _DialogoSelectorProductoState extends State<_DialogoSelectorProducto> {
  final busquedaCtrl = TextEditingController();
  String consulta = '';

  @override
  void dispose() {
    busquedaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final filtrados = widget.productos
        .where((p) => p.nombre.toLowerCase().contains(consulta.toLowerCase()))
        .toList()
      ..sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));

    return AlertDialog(
      title: Text(t.elegirProductoTitulo),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: busquedaCtrl,
              autofocus: true,
              decoration: InputDecoration(
                hintText: t.buscarHint,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => consulta = v),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: filtrados.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(t.ningunProductoCoincide))
                  : ListView(
                      shrinkWrap: true,
                      children: filtrados.map((p) {
                        return ListTile(
                          title: Text(p.nombre),
                          subtitle: Text(pesos(p.precioVenta)),
                          onTap: () => Navigator.pop(context, p),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.cancelar)),
      ],
    );
  }
}
