import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../models/guia_receta.dart';
import '../tema.dart';
import 'editor_receta.dart';

class PantallaVerReceta extends StatelessWidget {
  final GuiaReceta receta;
  const PantallaVerReceta({super.key, required this.receta});

  void _confirmarEliminar(BuildContext context, GuiaReceta r) {
    final t = AppLocalizations.of(context)!;
    final datos = context.read<DatosApp>();
    showDialog(
      context: context,
      builder: (dc) => AlertDialog(
        title: Text(t.eliminarRecetaTitulo),
        content: Text(t.eliminarRecetaConfirmacion(r.titulo)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc),
              child: Text(t.cancelar)),
          TextButton(
            onPressed: () {
              datos.eliminarReceta(r);
              Navigator.pop(dc);
              Navigator.pop(context);
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
    final m = AppColores.of(context);
    final existentes = datos.recetas.where((r) => r.id == receta.id).toList();
    if (existentes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(t.recetaTitulo)),
        body: Center(child: Text(t.recetaNoExiste)),
      );
    }
    final r = existentes.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.recetaTitulo),
        actions: [
          if (datos.puedeGestionarCatalogo)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: t.editar,
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PantallaEditorReceta(receta: r))),
            ),
          if (datos.puedeEliminar)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: t.eliminar,
              onPressed: () => _confirmarEliminar(context, r),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(r.titulo,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: m.texto)),
          const SizedBox(height: 20),
          if (r.ingredientes.isNotEmpty) ...[
            Text(t.ingredientesLabel,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: m.verdeOscuro)),
            const SizedBox(height: 8),
            ...r.ingredientes.map((ing) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6, right: 8),
                        child: Icon(Icons.circle, size: 7, color: m.verde),
                      ),
                      Expanded(
                        child: Text(ing,
                            style: TextStyle(
                                fontSize: 15,
                                height: 1.4,
                                color: m.texto)),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 20),
          ],
          Text(t.preparacion,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: m.verdeOscuro)),
          const SizedBox(height: 8),
          ...r.pasos.asMap().entries.map((e) {
            final n = e.key + 1;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 26,
                    width: 26,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: m.verde.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Text('$n',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: m.verdeOscuro)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(e.value,
                          style: TextStyle(
                              fontSize: 15, height: 1.5, color: m.texto)),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
