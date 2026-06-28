import 'package:flutter/material.dart';
import '../models/insumo.dart';

// Abre un diálogo con buscador y devuelve el insumo elegido (o null si cancela)
Future<Insumo?> elegirInsumo(BuildContext context, List<Insumo> insumos) {
  return showDialog<Insumo>(
    context: context,
    builder: (context) => _DialogoSelectorInsumo(insumos: insumos),
  );
}

class _DialogoSelectorInsumo extends StatefulWidget {
  final List<Insumo> insumos;
  const _DialogoSelectorInsumo({required this.insumos});

  @override
  State<_DialogoSelectorInsumo> createState() => _DialogoSelectorInsumoState();
}

class _DialogoSelectorInsumoState extends State<_DialogoSelectorInsumo> {
  final busquedaCtrl = TextEditingController();
  String consulta = '';

  @override
  void dispose() {
    busquedaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtrados = widget.insumos
        .where((i) => i.nombre.toLowerCase().contains(consulta.toLowerCase()))
        .toList()
      ..sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));

    return AlertDialog(
      title: const Text('Elegir insumo'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: busquedaCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (valor) => setState(() => consulta = valor),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: filtrados.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Ningún insumo coincide.'),
                    )
                  : ListView(
                      shrinkWrap: true,
                      children: filtrados.map((insumo) {
                        return ListTile(
                          title: Text(insumo.nombre),
                          onTap: () => Navigator.pop(context, insumo),
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
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}