import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../models/producto.dart';
import '../tema.dart';
import '../formato.dart';
import 'crear_producto.dart';
import 'editar_producto.dart';

class PantallaProductos extends StatefulWidget {
  const PantallaProductos({super.key});

  @override
  State<PantallaProductos> createState() => _PantallaProductosState();
}

class _PantallaProductosState extends State<PantallaProductos> {
  final busquedaCtrl = TextEditingController();
  String busqueda = '';
  String? tipoSel; // null = ninguno (pantalla limpia); 'Todos' = mostrar todos

  @override
  void dispose() {
    busquedaCtrl.dispose();
    super.dispose();
  }

  void _confirmarEliminar(BuildContext context, Producto p) {
    final t = AppLocalizations.of(context)!;
    final datos = context.read<DatosApp>();
    showDialog(
      context: context,
      builder: (dc) => AlertDialog(
        title: Text(t.eliminarProductoTitulo),
        content: Text(t.eliminarProductoConfirmacion(p.nombre)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc), child: Text(t.cancelar)),
          TextButton(
            onPressed: () {
              datos.eliminarProducto(p);
              Navigator.pop(dc);
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
      appBar: AppBar(title: Text(t.productos)),
      floatingActionButton: context.watch<DatosApp>().puedeGestionarCatalogo
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const PantallaCrearProducto())),
              icon: const Icon(Icons.add),
              label: Text(t.nuevo),
            )
          : null,
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          final m = AppColores.of(context);
          final todos = [...datos.productos]
            ..sort((a, b) =>
                a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
          final tipos = (<String>{
            for (final p in todos)
              if (p.tipo.trim().isNotEmpty) p.tipo
          }.toList()
            ..sort());

          final q = sinTildes(busqueda.trim());
          List<Producto> mostrados;
          if (q.isNotEmpty) {
            mostrados =
                todos.where((p) => sinTildes(p.nombre).contains(q)).toList();
          } else if (tipoSel == 'Todos') {
            mostrados = todos;
          } else if (tipoSel != null) {
            mostrados = todos.where((p) => p.tipo == tipoSel).toList();
          } else {
            mostrados = const [];
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  children: [
                    TextField(
                      controller: busquedaCtrl,
                      decoration: InputDecoration(
                        hintText: t.buscarHint,
                        prefixIcon: const Icon(Icons.search),
                        isDense: true,
                      ),
                      onChanged: (v) => setState(() => busqueda = v),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.filter_list, size: 18, color: m.textoSuave),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            tipoSel == null
                                ? t.filtrarPorTipo
                                : (tipoSel == 'Todos'
                                    ? t.todos
                                    : t.productosFiltro(tipoSel!)),
                            style: TextStyle(color: m.textoSuave),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.arrow_drop_down),
                          tooltip: t.filtrarPorTipo,
                          onSelected: (v) => setState(() => tipoSel = v),
                          itemBuilder: (_) => ['Todos', ...tipos].map((tf) {
                            return PopupMenuItem(
                                value: tf,
                                child: Text(tf == 'Todos' ? t.todos : tf));
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: todos.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(t.productosVacio,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: m.textoSuave)),
                        ),
                      )
                    : mostrados.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text(
                                q.isEmpty && tipoSel == null
                                    ? t.productosEligeFiltro
                                    : t.ningunProductoCoincide,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: m.textoSuave),
                              ),
                            ),
                          )
                        : ListView(
                            padding: const EdgeInsets.all(16),
                            children: mostrados
                                .map((p) => _tarjeta(context, datos, m, t, p))
                                .toList(),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tarjeta(BuildContext context, DatosApp datos, MarcaColores m,
      AppLocalizations t, Producto p) {
    final gananciaColor = p.ganancia >= 0 ? m.verde : m.rojo;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => PantallaEditarProducto(producto: p))),
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
                child: Icon(Icons.shopping_bag_outlined, color: m.verde),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: m.texto)),
                    const SizedBox(height: 2),
                    Text(
                        p.tipo.trim().isEmpty
                            ? pesos(p.precioVenta)
                            : '${p.tipo}  ·  ${pesos(p.precioVenta)}',
                        style:
                            TextStyle(fontSize: 12, color: m.textoSuave)),
                    Text(t.gananciaTexto(pesos(p.ganancia)),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: gananciaColor)),
                  ],
                ),
              ),
              if (datos.puedeGestionarCatalogo)
                PopupMenuButton<String>(
                  onSelected: (op) {
                    if (op == 'editar') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  PantallaEditarProducto(producto: p)));
                    } else if (op == 'eliminar') {
                      _confirmarEliminar(context, p);
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'editar', child: Text(t.editar)),
                    PopupMenuItem(value: 'eliminar', child: Text(t.eliminar)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
