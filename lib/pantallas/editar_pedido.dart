import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../models/pedido.dart';
import '../models/item_pedido.dart';
import '../tema.dart';
import '../formato.dart';
import 'selector_producto.dart';

class PantallaEditarPedido extends StatefulWidget {
  final Pedido pedido;
  const PantallaEditarPedido({super.key, required this.pedido});

  @override
  State<PantallaEditarPedido> createState() => _PantallaEditarPedidoState();
}

class _PantallaEditarPedidoState extends State<PantallaEditarPedido> {
  late final TextEditingController clienteNombreCtrl;
  late final TextEditingController clienteTelefonoCtrl;
  late final TextEditingController otroValorCtrl;
  late DateTime fechaEntrega;
  late final List<ItemPedido> items;

  @override
  void initState() {
    super.initState();
    final p = widget.pedido;
    clienteNombreCtrl = TextEditingController(text: p.cliente.nombre);
    clienteTelefonoCtrl = TextEditingController(text: p.cliente.telefono);
    otroValorCtrl = TextEditingController(
        text: p.otroValor > 0 ? cantidadStr(p.otroValor) : '');
    fechaEntrega = p.fechaEntrega;
    items = p.items
        .map((i) => ItemPedido(
            nombre: i.nombre,
            cantidad: i.cantidad,
            precioUnitario: i.precioUnitario,
            costoUnitario: i.costoUnitario,
            receta: i.receta))
        .toList();
  }

  @override
  void dispose() {
    clienteNombreCtrl.dispose();
    clienteTelefonoCtrl.dispose();
    otroValorCtrl.dispose();
    super.dispose();
  }

  Future<void> elegirFecha() async {
    final sel = await showDatePicker(
      context: context,
      initialDate: fechaEntrega,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (sel != null) setState(() => fechaEntrega = sel);
  }

  Future<double?> _pedirCantidad() async {
    final t = AppLocalizations.of(context)!;
    final ctrl = TextEditingController(text: '1');
    final r = await showDialog<double>(
      context: context,
      builder: (dc) => AlertDialog(
        title: Text(t.cantidad),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [Decimal2Formatter()],
          decoration: InputDecoration(labelText: t.cantidad),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc),
              child: Text(t.cancelar)),
          ElevatedButton(
            onPressed: () {
              final n = parseCantidad(ctrl.text);
              Navigator.pop(dc, n > 0 ? n : 1.0);
            },
            child: Text(t.agregar),
          ),
        ],
      ),
    );
    ctrl.dispose();
    return r;
  }

  Future<void> _agregarDelCatalogo() async {
    final t = AppLocalizations.of(context)!;
    final productos = [...context.read<DatosApp>().productos];
    if (productos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.sinProductosCreados)),
      );
      return;
    }
    final prod = await elegirProducto(context, productos);
    if (prod == null || !mounted) return;
    final cant = await _pedirCantidad();
    if (cant == null || !mounted) return;
    setState(() => items.add(ItemPedido(
          nombre: prod.nombre,
          cantidad: cant,
          precioUnitario: prod.precioVenta,
          costoUnitario: prod.costoProduccion(),
          receta: prod.receta
              .map((ing) =>
                  RecetaItem(insumoId: ing.insumo.id, cantidad: ing.cantidad))
              .toList(),
        )));
  }

  Future<void> _agregarManual() async {
    final t = AppLocalizations.of(context)!;
    final nombreCtrl = TextEditingController();
    final precioCtrl = TextEditingController();
    final costoCtrl = TextEditingController();
    final cantCtrl = TextEditingController(text: '1');
    final item = await showDialog<ItemPedido>(
      context: context,
      builder: (dc) => AlertDialog(
        title: Text(t.itemManual),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nombreCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(labelText: t.descripcion)),
              const SizedBox(height: 8),
              TextField(
                  controller: precioCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [Decimal2Formatter()],
                  decoration: InputDecoration(labelText: t.precioUnitario)),
              const SizedBox(height: 8),
              TextField(
                  controller: costoCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [Decimal2Formatter()],
                  decoration:
                      InputDecoration(labelText: t.costoUnitarioOpcional)),
              const SizedBox(height: 8),
              TextField(
                  controller: cantCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [Decimal2Formatter()],
                  decoration: InputDecoration(labelText: t.cantidad)),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc),
              child: Text(t.cancelar)),
          ElevatedButton(
            onPressed: () {
              final nombre = nombreCtrl.text.trim();
              final precio = parseCantidad(precioCtrl.text);
              final costo = parseCantidad(costoCtrl.text);
              final cant = parseCantidad(cantCtrl.text);
              if (nombre.isEmpty || precio <= 0 || cant <= 0) return;
              Navigator.pop(
                  dc,
                  ItemPedido(
                      nombre: nombre,
                      cantidad: cant,
                      precioUnitario: precio,
                      costoUnitario: costo));
            },
            child: Text(t.agregar),
          ),
        ],
      ),
    );
    nombreCtrl.dispose();
    precioCtrl.dispose();
    costoCtrl.dispose();
    cantCtrl.dispose();
    if (item != null && mounted) setState(() => items.add(item));
  }

  void guardar() {
    final t = AppLocalizations.of(context)!;
    final nombre = clienteNombreCtrl.text.trim();
    final telefono = clienteTelefonoCtrl.text.trim();
    final otro = parseCantidad(otroValorCtrl.text);
    final precioItems = items.fold<double>(0, (s, i) => s + i.precioTotal);
    final precioTotal = precioItems + otro;
    final costoTotal = items.fold<double>(0, (s, i) => s + i.costoTotal);

    if (nombre.isEmpty || precioTotal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.faltaClienteItem)),
      );
      return;
    }

    final partes =
        items.map((i) => '${cantidadStr(i.cantidad)}x ${i.nombre}').toList();
    if (otro > 0) partes.add(t.otroValorItem);
    final descripcion = partes.isEmpty ? t.pedidoFallback : partes.join(', ');

    context.read<DatosApp>().editarPedido(
          widget.pedido,
          clienteNombre: nombre,
          clienteTelefono: telefono,
          descripcion: descripcion,
          fechaEntrega: fechaEntrega,
          precio: precioTotal,
          costo: costoTotal,
          items: items,
          otroValor: otro,
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final m = AppColores.of(context);
    final otro = parseCantidad(otroValorCtrl.text);
    final precioItems = items.fold<double>(0, (s, i) => s + i.precioTotal);
    final precioTotal = precioItems + otro;
    final costoTotal = items.fold<double>(0, (s, i) => s + i.costoTotal);
    final ganancia = precioTotal - costoTotal;
    final gColor = ganancia >= 0 ? m.verde : m.rojo;

    return Scaffold(
      appBar: AppBar(title: Text(t.editarPedidoTitulo)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.pedido.entregado)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                t.editarPedidoEntregado,
                style: TextStyle(fontSize: 12, color: m.textoSuave),
              ),
            ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: clienteNombreCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: t.nombreCliente,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: clienteTelefonoCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: t.telefonoOpcional,
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(t.productosDelPedido,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: m.texto)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _agregarDelCatalogo,
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: Text(t.delCatalogo),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _agregarManual,
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(t.manual),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(t.sinItemsEditar,
                  style: TextStyle(color: m.textoSuave)),
            )
          else
            ...items.asMap().entries.map((e) {
              final it = e.value;
              return Card(
                child: ListTile(
                  dense: true,
                  title: Text('${cantidadStr(it.cantidad)}x ${it.nombre}',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(pesos(it.precioTotal)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: m.rojo),
                    onPressed: () => setState(() => items.removeAt(e.key)),
                  ),
                ),
              );
            }),
          const SizedBox(height: 16),
          TextField(
            controller: otroValorCtrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [Decimal2Formatter()],
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: t.otroValorLabel,
              prefixIcon: const Icon(Icons.add_road),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            color: m.verde.withValues(alpha: 0.06),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _tot(t.precio, pesos(precioTotal), m.texto, m),
                  _tot(t.costo, pesos(costoTotal), m.texto, m),
                  _tot(t.ganancia, pesos(ganancia), gColor, m),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Icon(Icons.event, color: m.verde),
              title: Text(t.fechaEntrega),
              subtitle: Text(
                  '${fechaEntrega.day}/${fechaEntrega.month}/${fechaEntrega.year}'),
              trailing: TextButton(
                  onPressed: elegirFecha, child: Text(t.cambiar)),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
              onPressed: guardar, child: Text(t.guardarCambios)),
        ],
      ),
    );
  }

  Widget _tot(String label, String v, Color c, MarcaColores m) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(fontSize: 12, color: m.textoSuave)),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(v,
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold, color: c)),
            ),
          ],
        ),
      );
}
