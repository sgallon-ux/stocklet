import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final titulo = tituloCtrl.text.trim();
    final ingredientes = _lineas(ingredientesCtrl.text);
    final pasos = _lineas(pasosCtrl.text);
    if (titulo.isEmpty || pasos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe el título y al menos un paso')),
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
    return Scaffold(
      appBar: AppBar(title: Text(esEdicion ? 'Editar receta' : 'Nueva receta')),
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
                    decoration: const InputDecoration(
                      labelText: 'Título de la receta',
                      hintText: 'Ej: Torta de chocolate',
                      prefixIcon: Icon(Icons.menu_book_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ingredientesCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 3,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Ingredientes',
                      hintText: 'Un ingrediente por línea',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: pasosCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 4,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Pasos de preparación',
                      hintText: 'Un paso por línea',
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
              'Escribe cada ingrediente y cada paso en su propia línea (Enter para separar).',
              style:
                  TextStyle(fontSize: 12, color: AppColores.of(context).textoSuave),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: guardar, child: const Text('Guardar receta')),
        ],
      ),
    );
  }
}