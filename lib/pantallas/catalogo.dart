import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../datos_app.dart';
import '../models/catalogo.dart';
import '../tema.dart';

class PantallaCatalogo extends StatefulWidget {
  const PantallaCatalogo({super.key});

  @override
  State<PantallaCatalogo> createState() => _PantallaCatalogoState();
}

class _PantallaCatalogoState extends State<PantallaCatalogo> {
  bool subiendo = false;

  void _aviso(String t) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));
  }

  Future<String?> _pedirNombre(String sugerido) async {
    final ctrl = TextEditingController(text: sugerido);
    final r = await showDialog<String>(
      context: context,
      builder: (dc) => AlertDialog(
        title: const Text('Nombre del catálogo'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final n = ctrl.text.trim();
              if (n.isNotEmpty) Navigator.pop(dc, n);
            },
            child: const Text('Subir'),
          ),
        ],
      ),
    );
    ctrl.dispose();
    return r;
  }

  Future<void> _subir() async {
    final result = await FilePicker.pickFiles(
      type: FileType.any, // iPhone a veces no deja elegir si se filtra a 'pdf'
      withData: true,
    );
    if (result == null || !mounted) return;
    final archivo = result.files.first;
    final bytes = archivo.bytes;
    if (bytes == null) {
      _aviso('No se pudo leer el archivo.');
      return;
    }
    if (!archivo.name.toLowerCase().endsWith('.pdf')) {
      _aviso('Por ahora solo se admiten archivos PDF.');
      return;
    }
    if (archivo.size > 15 * 1024 * 1024) {
      _aviso('El archivo supera el límite de 15 MB.');
      return;
    }
    final sugerido =
        archivo.name.replaceAll('.pdf', '').replaceAll('.PDF', '');
    final nombre = await _pedirNombre(sugerido);
    if (nombre == null || !mounted) return;

    setState(() => subiendo = true);
    try {
      await context.read<DatosApp>().agregarCatalogo(
            nombre: nombre,
            bytes: bytes,
            nombreArchivo: archivo.name,
          );
    } catch (e) {
      _aviso('No se pudo subir el catálogo. Intenta de nuevo.');
    } finally {
      if (mounted) setState(() => subiendo = false);
    }
  }

  Future<void> _abrir(Catalogo c) async {
    final uri = Uri.parse(c.url);
    // En PWA instalada: intentar pestaña nueva ('_blank'); si el móvil
    // la bloquea, abrir en la misma ventana ('_self').
    var ok = await launchUrl(uri, webOnlyWindowName: '_blank');
    if (!ok) {
      ok = await launchUrl(uri, webOnlyWindowName: '_self');
    }
    if (!ok) _aviso('No se pudo abrir el catálogo.');
  }

  void _confirmarEliminar(Catalogo c) {
    showDialog(
      context: context,
      builder: (dc) => AlertDialog(
        title: const Text('Eliminar catálogo'),
        content: Text('¿Eliminar "${c.nombre}"? El archivo PDF se borrará.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              Navigator.pop(dc);
              try {
                await context.read<DatosApp>().eliminarCatalogo(c);
              } catch (e) {
                _aviso('No se pudo eliminar.');
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: subiendo ? null : _subir,
        icon: subiendo
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.upload_file),
        label: Text(subiendo ? 'Subiendo...' : 'Subir PDF'),
      ),
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          final m = AppColores.of(context);
          final catalogos = [...datos.catalogos]
            ..sort((a, b) => b.fecha.compareTo(a.fecha));

          if (catalogos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                    'Aún no tienes catálogos.\nSube un PDF con el botón de abajo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: m.textoSuave)),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: catalogos.map((c) {
              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  onTap: () => _abrir(c),
                  leading: Container(
                    height: 44,
                    width: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: m.rojo.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.picture_as_pdf, color: m.rojo),
                  ),
                  title: Text(c.nombre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: m.texto)),
                  subtitle: Text('${c.fecha.day}/${c.fecha.month}/${c.fecha.year}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (op) {
                      if (op == 'abrir') {
                        _abrir(c);
                      } else if (op == 'eliminar') {
                        _confirmarEliminar(c);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'abrir', child: Text('Abrir')),
                      PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}