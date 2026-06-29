import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/guia_receta.dart';
import '../tema.dart';
import 'editor_receta.dart';

class PantallaVerReceta extends StatelessWidget {
  final GuiaReceta receta;
  const PantallaVerReceta({super.key, required this.receta});

  void _confirmarEliminar(BuildContext context, GuiaReceta r) {
    final datos = context.read<DatosApp>();
    showDialog(
      context: context,
      builder: (dc) => AlertDialog(
        title: const Text('Eliminar receta'),
        content: Text('¿Seguro que quieres eliminar "${r.titulo}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              datos.eliminarReceta(r);
              Navigator.pop(dc);
              Navigator.pop(context);
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
    final existentes = datos.recetas.where((r) => r.id == receta.id).toList();
    if (existentes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Receta')),
        body: const Center(child: Text('Esta receta ya no existe.')),
      );
    }
    final r = existentes.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar',
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PantallaEditorReceta(receta: r))),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Eliminar',
            onPressed: () => _confirmarEliminar(context, r),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(r.titulo,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColores.texto)),
          const SizedBox(height: 20),
          if (r.ingredientes.isNotEmpty) ...[
            const Text('Ingredientes',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColores.verdeOscuro)),
            const SizedBox(height: 8),
            ...r.ingredientes.map((ing) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 6, right: 8),
                        child: Icon(Icons.circle,
                            size: 7, color: AppColores.verde),
                      ),
                      Expanded(
                        child: Text(ing,
                            style: const TextStyle(
                                fontSize: 15,
                                height: 1.4,
                                color: AppColores.texto)),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 20),
          ],
          const Text('Preparación',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColores.verdeOscuro)),
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
                      color: AppColores.verde.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Text('$n',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColores.verdeOscuro)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(e.value,
                          style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: AppColores.texto)),
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