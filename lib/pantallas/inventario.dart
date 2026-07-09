import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../models/insumo.dart';
import '../tema.dart';
import '../formato.dart';
import 'agregar_insumo.dart';
import 'editar_insumo.dart';

class PantallaInventario extends StatefulWidget {
  const PantallaInventario({super.key});

  @override
  State<PantallaInventario> createState() => _PantallaInventarioState();
}

class _PantallaInventarioState extends State<PantallaInventario> {
  bool buscando = false;
  final busquedaCtrl = TextEditingController();
  String consulta = '';

  @override
  void dispose() {
    busquedaCtrl.dispose();
    super.dispose();
  }

  void _confirmarEliminar(Insumo insumo) {
    final t = AppLocalizations.of(context)!;
    final datos = context.read<DatosApp>();
    if (datos.insumoEstaEnUso(insumo)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.insumoNoEliminarEnUso(insumo.nombre))),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.eliminarInsumoTitulo),
        content: Text(t.eliminarInsumoConfirmacion(insumo.nombre)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(t.cancelar)),
          TextButton(
            onPressed: () {
              datos.eliminarInsumo(insumo);
              Navigator.pop(dialogContext);
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
    return Scaffold(
      appBar: AppBar(
        title: buscando
            ? TextField(
                controller: busquedaCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: t.buscarInsumoHint,
                  border: InputBorder.none,
                ),
                onChanged: (valor) => setState(() => consulta = valor),
              )
            : Text(t.inventario),
        actions: [
          buscando
              ? IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: t.cerrarBusqueda,
                  onPressed: () {
                    setState(() {
                      buscando = false;
                      consulta = '';
                      busquedaCtrl.clear();
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: t.buscar,
                  onPressed: () => setState(() => buscando = true),
                ),
        ],
      ),
      floatingActionButton: context.watch<DatosApp>().puedeGestionarCatalogo
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PantallaAgregarInsumo())),
              icon: const Icon(Icons.add),
              label: Text(t.insumo),
            )
          : null,
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          final m = AppColores.of(context);
          if (datos.insumos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(t.inventarioVacio,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: m.textoSuave)),
              ),
            );
          }

          final insumos = datos.insumos
              .where((i) =>
                  i.nombre.toLowerCase().contains(consulta.toLowerCase()))
              .toList()
            ..sort((a, b) =>
                a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));

          if (insumos.isEmpty) {
            return Center(
                child: Text(t.inventarioSinCoincidencias));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: insumos.map((insumo) {
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PantallaEditarInsumo(insumo: insumo))),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          height: 44,
                          width: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: m.verde.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.category_outlined,
                              color: m.verde),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(insumo.nombre,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: m.texto)),
                              const SizedBox(height: 3),
                              Text(
                                  t.costoPorUnidadTexto(
                                      pesos(insumo.costoPorUnidad),
                                      insumo.unidad),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: m.textoSuave)),
                              Text(
                                  t.stockTexto(
                                      insumo.stockActual.toStringAsFixed(0),
                                      insumo.unidad),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: m.textoSuave)),
                            ],
                          ),
                        ),
                        if (datos.puedeGestionarCatalogo)
                          PopupMenuButton<String>(
                            onSelected: (opcion) {
                              if (opcion == 'editar') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PantallaEditarInsumo(insumo: insumo)));
                              } else if (opcion == 'eliminar') {
                                _confirmarEliminar(insumo);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  value: 'editar', child: Text(t.editar)),
                              PopupMenuItem(
                                  value: 'eliminar', child: Text(t.eliminar)),
                            ],
                          ),
                      ],
                    ),
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
