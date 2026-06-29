import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final datos = context.read<DatosApp>();
    if (datos.insumoEstaEnUso(insumo)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'No puedes eliminar ${insumo.nombre}: lo usa un producto')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar insumo'),
        content: Text('¿Seguro que quieres eliminar ${insumo.nombre}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              datos.eliminarInsumo(insumo);
              Navigator.pop(dialogContext);
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
      appBar: AppBar(
        title: buscando
            ? TextField(
                controller: busquedaCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Buscar insumo...',
                  border: InputBorder.none,
                ),
                onChanged: (valor) => setState(() => consulta = valor),
              )
            : const Text('Inventario'),
        actions: [
          buscando
              ? IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Cerrar búsqueda',
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
                  tooltip: 'Buscar',
                  onPressed: () => setState(() => buscando = true),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PantallaAgregarInsumo())),
        icon: const Icon(Icons.add),
        label: const Text('Insumo'),
      ),
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          if (datos.insumos.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('Aún no hay insumos.\nAgrega el primero con el botón +',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColores.textoSuave)),
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
            return const Center(
                child: Text('Ningún insumo coincide con la búsqueda.'));
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
                            color: AppColores.verde.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.category_outlined,
                              color: AppColores.verde),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(insumo.nombre,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColores.texto)),
                              const SizedBox(height: 3),
                              Text(
                                  '${pesos(insumo.costoPorUnidad)} por ${insumo.unidad}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColores.textoSuave)),
                              Text(
                                  'Stock: ${insumo.stockActual.toStringAsFixed(0)} ${insumo.unidad}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColores.textoSuave)),
                            ],
                          ),
                        ),
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
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'editar', child: Text('Editar')),
                            PopupMenuItem(
                                value: 'eliminar', child: Text('Eliminar')),
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