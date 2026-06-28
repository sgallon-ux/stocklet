import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/insumo.dart';
import 'agregar_insumo.dart';
import 'editar_insumo.dart';
import '../formato.dart';

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
        SnackBar(content: Text('No puedes eliminar ${insumo.nombre}: lo usa un producto')),
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
            child: const Text('Cancelar'),
          ),
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
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Agregar insumo',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PantallaAgregarInsumo()),
              );
            },
          ),
        ],
      ),
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          if (datos.insumos.isEmpty) {
            return const Center(
              child: Text('Aún no hay insumos. Agrega el primero con el botón +'),
            );
          }

          // Filtra por la búsqueda y ordena A-Z
          final insumos = datos.insumos
              .where((i) => i.nombre.toLowerCase().contains(consulta.toLowerCase()))
              .toList()
            ..sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));

          if (insumos.isEmpty) {
            return const Center(child: Text('Ningún insumo coincide con la búsqueda.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: insumos.map((insumo) {
              return Card(
                child: ListTile(
                  title: Text(insumo.nombre),
                  subtitle: Text(
                    'Costo: ${pesos(insumo.costoPorUnidad)} por ${insumo.unidad}'
                    '  ·  Stock: ${insumo.stockActual.toStringAsFixed(0)} ${insumo.unidad}',
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (opcion) {
                      if (opcion == 'editar') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PantallaEditarInsumo(insumo: insumo),
                          ),
                        );
                      } else if (opcion == 'eliminar') {
                        _confirmarEliminar(insumo);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'editar', child: Text('Editar')),
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