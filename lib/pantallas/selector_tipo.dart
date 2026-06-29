import 'package:flutter/material.dart';
import '../tema.dart';

// Devuelve el tipo elegido ('' = sin tipo, o un nombre nuevo/existente),
// o null si se cancela.
Future<String?> elegirTipo(BuildContext context, List<String> tipos) {
  return showDialog<String>(
    context: context,
    builder: (context) => _DialogoTipo(tipos: tipos),
  );
}

class _DialogoTipo extends StatefulWidget {
  final List<String> tipos;
  const _DialogoTipo({required this.tipos});

  @override
  State<_DialogoTipo> createState() => _DialogoTipoState();
}

class _DialogoTipoState extends State<_DialogoTipo> {
  final nuevoCtrl = TextEditingController();

  @override
  void dispose() {
    nuevoCtrl.dispose();
    super.dispose();
  }

  void _crear() {
    final nombre = nuevoCtrl.text.trim();
    if (nombre.isEmpty) return;
    Navigator.pop(context, nombre);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tipo de producto'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nuevoCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'Crear tipo de producto, ej: Bebidas',
                      prefixIcon: Icon(Icons.add),
                    ),
                    onSubmitted: (_) => _crear(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                    icon: const Icon(Icons.check), onPressed: _crear),
              ],
            ),
            const Divider(height: 24),
            ListTile(
              dense: true,
              leading:
                  const Icon(Icons.block, color: AppColores.textoSuave),
              title: const Text('Sin tipo'),
              onTap: () => Navigator.pop(context, ''),
            ),
            Flexible(
              child: widget.tipos.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Aún no has creado tipos.',
                          style: TextStyle(color: AppColores.textoSuave)),
                    )
                  : ListView(
                      shrinkWrap: true,
                      children: widget.tipos.map((t) {
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.label_outline,
                              color: AppColores.verde),
                          title: Text(t),
                          onTap: () => Navigator.pop(context, t),
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
            child: const Text('Cancelar')),
      ],
    );
  }
}