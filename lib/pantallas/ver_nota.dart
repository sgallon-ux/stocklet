import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../models/nota.dart';
import '../tema.dart';
import 'editor_nota.dart';

class PantallaVerNota extends StatelessWidget {
  final Nota nota;
  const PantallaVerNota({super.key, required this.nota});

  void _confirmarEliminar(BuildContext context, Nota n) {
    final t = AppLocalizations.of(context)!;
    final datos = context.read<DatosApp>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.eliminarNotaTitulo),
        content: Text(t.eliminarNotaConfirmacion(n.asunto)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(t.cancelar),
          ),
          TextButton(
            onPressed: () {
              datos.eliminarNota(n);
              Navigator.pop(dialogContext); // cierra el diálogo
              Navigator.pop(context); // cierra la pantalla de la nota
            },
            child: Text(t.eliminar),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final datos = context.watch<DatosApp>();
    final existentes = datos.notas.where((n) => n.id == nota.id).toList();

    // Si la nota fue eliminada (por mí o por otro miembro), avisamos
    if (existentes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(t.notaTitulo)),
        body: Center(child: Text(t.notaNoExiste)),
      );
    }
    final n = existentes.first;
    final f = n.fecha;
    final m = AppColores.of(context);
    final fechaStr = '${f.day}/${f.month}/${f.year}';

    return Scaffold(
      appBar: AppBar(
        title: Text(t.notaTitulo),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: t.editar,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => PantallaEditorNota(nota: n))),
          ),
          if (datos.puedeEliminar)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: t.eliminar,
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
                  ? fechaStr
                  : t.notaPorAutor(fechaStr, n.autorNombre),
              style: TextStyle(fontSize: 12, color: m.textoSuave)),
          const Divider(height: 28),
          SelectableText(
            n.contenido.isEmpty ? t.sinContenido : n.contenido,
            style: TextStyle(fontSize: 15, height: 1.5, color: m.texto),
          ),
        ],
      ),
    );
  }
}
