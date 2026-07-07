import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../models/producto.dart';
import '../tema.dart';
import '../formato.dart';

class PantallaIngresarVenta extends StatefulWidget {
  const PantallaIngresarVenta({super.key});

  @override
  State<PantallaIngresarVenta> createState() => _PantallaIngresarVentaState();
}

class _PantallaIngresarVentaState extends State<PantallaIngresarVenta> {
  final descripcionCtrl = TextEditingController();
  final valorCtrl = TextEditingController();
  String tipoFiltro = 'Todos'; // 'Todos' = centinela interno (no traducir)

  @override
  void dispose() {
    descripcionCtrl.dispose();
    valorCtrl.dispose();
    super.dispose();
  }

  void _venderProducto(Producto producto) {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.confirmarVenta),
        content: Text(
          t.confirmarVentaProducto(
              producto.nombre, pesos(producto.precioVenta)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(t.cancelar),
          ),
          TextButton(
            onPressed: () {
              context.read<DatosApp>().registrarVenta(producto, 1);
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text(t.ventaProductoRegistrada(producto.nombre))),
              );
            },
            child: Text(t.vender),
          ),
        ],
      ),
    );
  }

  void _venderManual() {
    final t = AppLocalizations.of(context)!;
    final descripcion = descripcionCtrl.text.trim();
    final valor = double.tryParse(valorCtrl.text) ?? 0;
    if (descripcion.isEmpty || valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.ventaDescripcionValor)),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.confirmarVenta),
        content: Text(t.confirmarVentaManual(descripcion, pesos(valor))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(t.cancelar),
          ),
          TextButton(
            onPressed: () {
              context.read<DatosApp>().registrarVentaManual(descripcion, valor);
              Navigator.pop(dialogContext);
              descripcionCtrl.clear();
              valorCtrl.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t.ventaRegistrada)),
              );
            },
            child: Text(t.registrar),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.ingresarVentaTitulo)),
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          final m = AppColores.of(context);
          final productos = (tipoFiltro == 'Todos'
              ? [...datos.productos]
              : datos.productos.where((p) => p.tipo == tipoFiltro).toList())
            ..sort((a, b) =>
                a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
          final tipos = (<String>{
            for (final p in datos.productos)
              if (p.tipo.trim().isNotEmpty) p.tipo
          }.toList()
            ..sort());

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(t.ventaRapida,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: m.texto)),
              const SizedBox(height: 4),
              Text(t.ventaRapidaAyuda,
                  style: TextStyle(fontSize: 12, color: m.textoSuave)),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: descripcionCtrl,
                        decoration: InputDecoration(
                          labelText: t.descripcion,
                          hintText: t.ventaDescripcionHint,
                          prefixIcon: const Icon(Icons.edit_note),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: valorCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: t.valor,
                          prefixIcon: const Icon(Icons.attach_money),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _venderManual,
                          child: Text(t.registrarVenta),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            tipoFiltro == 'Todos'
                                ? t.venderProducto
                                : t.productosFiltro(tipoFiltro),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: m.texto),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.arrow_drop_down),
                          tooltip: t.filtrarPorTipo,
                          onSelected: (valor) =>
                              setState(() => tipoFiltro = valor),
                          itemBuilder: (context) =>
                              ['Todos', ...tipos].map((tf) {
                            return PopupMenuItem(
                                value: tf,
                                child: Text(tf == 'Todos' ? t.todos : tf));
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              if (productos.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text(t.sinProductosVenta)),
                )
              else
                ...productos.map((producto) {
                  return Card(
                    child: ListTile(
                      onTap: () => _venderProducto(producto),
                      leading: Container(
                        height: 44,
                        width: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: m.verde.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.shopping_bag_outlined,
                            color: m.verde),
                      ),
                      title: Text(producto.nombre,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(pesos(producto.precioVenta)),
                      trailing: Icon(Icons.add_shopping_cart_outlined,
                          color: m.verde),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}
