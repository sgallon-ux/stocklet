import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../tema.dart';
import 'editor_receta.dart';
import 'ver_receta.dart';

class PantallaRecetas extends StatelessWidget {
  const PantallaRecetas({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.recetas)),
      floatingActionButton: context.watch<DatosApp>().puedeGestionarCatalogo
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PantallaEditorReceta())),
              icon: const Icon(Icons.add),
              label: Text(t.recetaTitulo),
            )
          : null,
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          final m = AppColores.of(context);
          final recetas = [...datos.recetas]
            ..sort((a, b) =>
                a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase()));

          if (recetas.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(t.recetasVacio,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: m.textoSuave)),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: recetas.map((r) {
              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PantallaVerReceta(receta: r))),
                  leading: Container(
                    height: 44,
                    width: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: m.verde.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.menu_book_outlined, color: m.verde),
                  ),
                  title: Text(r.titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: m.texto)),
                  subtitle: Text(
                      t.recetaSubtitulo(r.ingredientes.length, r.pasos.length)),
                  trailing:
                      Icon(Icons.chevron_right, color: m.textoSuave),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
