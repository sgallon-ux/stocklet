import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
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
    final t = AppLocalizations.of(context)!;
    final asunto = asuntoCtrl.text.trim();
    final contenido = contenidoCtrl.text.trim();
    if (asunto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.notaFaltaAsunto)),
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
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
          title: Text(esEdicion ? t.editarNotaTitulo : t.nuevaNota)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: asuntoCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: t.asunto,
                prefixIcon: const Icon(Icons.title),
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
                decoration: InputDecoration(
                  labelText: t.contenido,
                  alignLabelWithHint: true,
                  hintText: t.notaContenidoHint,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: guardar, child: Text(t.guardarNota)),
          ],
        ),
      ),
    );
  }
}
