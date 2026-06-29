import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/nota.dart';

class PantallaEditorNota extends StatefulWidget {
  final Nota? nota; // null = crear; con valor = editar
  const PantallaEditorNota({super.key, this.nota});

  @override
  State<PantallaEditorNota> createState() => _PantallaEditorNotaState();
}

class _PantallaEditorNotaState extends State<PantallaEditorNota> {
  late final TextEditingController asuntoCtrl;
  late final TextEditingController contenidoCtrl;

  bool get esEdicion => widget.nota != null;

  @override
  void initState() {
    super.initState();
    asuntoCtrl = TextEditingController(text: widget.nota?.asunto ?? '');
    contenidoCtrl = TextEditingController(text: widget.nota?.contenido ?? '');
  }

  @override
  void dispose() {
    asuntoCtrl.dispose();
    contenidoCtrl.dispose();
    super.dispose();
  }

  void guardar() {
    final asunto = asuntoCtrl.text.trim();
    final contenido = contenidoCtrl.text.trim();
    if (asunto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe al menos el asunto de la nota')),
      );
      return;
    }
    final datos = context.read<DatosApp>();
    if (esEdicion) {
      datos.editarNota(widget.nota!, asunto: asunto, contenido: contenido);
    } else {
      datos.agregarNota(
          Nota(asunto: asunto, contenido: contenido, fecha: DateTime.now()));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(esEdicion ? 'Editar nota' : 'Nueva nota')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: asuntoCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Asunto',
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: contenidoCtrl,
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: 'Contenido',
                  alignLabelWithHint: true,
                  hintText: 'Escribe el detalle de la nota...',
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: guardar, child: const Text('Guardar nota')),
          ],
        ),
      ),
    );
  }
}