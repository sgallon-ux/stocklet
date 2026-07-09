import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../models/guia_receta.dart';
import '../tema.dart';

class PantallaEditorReceta extends StatefulWidget {
  final GuiaReceta? receta; // null = crear; con valor = editar
  const PantallaEditorReceta({super.key, this.receta});

  @override
  State<PantallaEditorReceta> createState() => _PantallaEditorRecetaState();
}

class _PantallaEditorRecetaState extends State<PantallaEditorReceta> {
  late final TextEditingController tituloCtrl;
  late final TextEditingController ingredientesCtrl;
  late final TextEditingController pasosCtrl;

  bool get esEdicion => widget.receta != null;

  @override
  void initState() {
    super.initState();
    tituloCtrl = TextEditingController(text: widget.receta?.titulo ?? '');
    ingredientesCtrl = TextEditingController(
        text: widget.receta?.ingredientes.join('\n') ?? '');
    pasosCtrl =
        TextEditingController(text: widget.receta?.pasos.join('\n') ?? '');
  }

  @override
  void dispose() {
    tituloCtrl.dispose();
    ingredientesCtrl.dispose();
    pasosCtrl.dispose();
    super.dispose();
  }

  List<String> _lineas(String texto) => texto
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();

  void guardar() {
    final t = AppLocalizations.of(context)!;
    final titulo = tituloCtrl.text.trim();
    final ingredientes = _lineas(ingredientesCtrl.text);
    final pasos = _lineas(pasosCtrl.text);
    if (titulo.isEmpty || pasos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.recetaFaltaTituloPaso)),
      );
      return;
    }
    final datos = context.read<DatosApp>();
    if (esEdicion) {
      datos.editarReceta(widget.receta!,
          titulo: titulo, ingredientes: ingredientes, pasos: pasos);
    } else {
      datos.agregarReceta(GuiaReceta(
          titulo: titulo,
          ingredientes: ingredientes,
          pasos: pasos,
          fecha: DateTime.now()));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final datos = context.watch<DatosApp>();
    return Scaffold(
      appBar: AppBar(
          title: Text(esEdicion ? t.editarRecetaTitulo : t.nuevaRecetaTitulo)),
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
                    controller: tituloCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: t.tituloReceta,
                      hintText: t.nombreProductoHint,
                      prefixIcon: const Icon(Icons.menu_book_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ingredientesCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 3,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: t.ingredientesLabel,
                      hintText: t.ingredientesHint,
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: pasosCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 4,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: t.pasosPreparacion,
                      hintText: t.pasosHint,
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              t.recetaEditorAyuda,
              style:
                  TextStyle(fontSize: 12, color: AppColores.of(context).textoSuave),
            ),
          ),
          const SizedBox(height: 16),
          if (datos.puedeGestionarCatalogo)
            ElevatedButton(
                onPressed: guardar, child: Text(t.guardarReceta))
          else
            Center(child: Text(t.soloLectura)),
        ],
      ),
    );
  }
}
