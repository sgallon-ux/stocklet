import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../tema.dart';
import 'editor_receta.dart';
import 'ver_receta.dart';

class PantallaRecetas extends StatelessWidget {
  const PantallaRecetas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recetas')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const PantallaEditorReceta())),
        icon: const Icon(Icons.add),
        label: const Text('Receta'),
      ),
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          final recetas = [...datos.recetas]
            ..sort((a, b) =>
                a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase()));

          if (recetas.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('Aún no tienes recetas.\nCrea una con el botón +',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColores.textoSuave)),
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
                      color: AppColores.verde.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.menu_book_outlined,
                        color: AppColores.verde),
                  ),
                  title: Text(r.titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColores.texto)),
                  subtitle: Text(
                      '${r.ingredientes.length} ingredientes · ${r.pasos.length} pasos'),
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColores.textoSuave),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}