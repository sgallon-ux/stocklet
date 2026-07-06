import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/nota.dart';
import '../tema.dart';
import 'editor_nota.dart';

class PantallaVerNota extends StatelessWidget {
  final Nota nota;
  const PantallaVerNota({super.key, required this.nota});

  void _confirmarEliminar(BuildContext context, Nota n) {
    final datos = context.read<DatosApp>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: Text('¿Seguro que quieres eliminar "${n.asunto}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              datos.eliminarNota(n);
              Navigator.pop(dialogContext); // cierra el diálogo
              Navigator.pop(context); // cierra la pantalla de la nota
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<DatosApp>();
    final existentes = datos.notas.where((n) => n.id == nota.id).toList();

    // Si la nota fue eliminada (por mí o por otro miembro), avisamos
    if (existentes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nota')),
        body: const Center(child: Text('Esta nota ya no existe.')),
      );
    }
    final n = existentes.first;
    final f = n.fecha;
    final m = AppColores.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nota'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => PantallaEditorNota(nota: n))),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Eliminar',
            onPressed: () => _confirmarEliminar(context, n),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(n.asunto,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: m.texto)),
          const SizedBox(height: 6),
          Text(
              n.autorNombre.isEmpty
                  ? '${f.day}/${f.month}/${f.year}'
                  : '${f.day}/${f.month}/${f.year}  ·  Por ${n.autorNombre}',
              style: TextStyle(fontSize: 12, color: m.textoSuave)),
          const Divider(height: 28),
          SelectableText(
            n.contenido.isEmpty ? '(Sin contenido)' : n.contenido,
            style: TextStyle(fontSize: 15, height: 1.5, color: m.texto),
          ),
        ],
      ),
    );
  }
}