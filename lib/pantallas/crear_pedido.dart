import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../models/cliente.dart';
import '../models/pedido.dart';
import '../models/item_pedido.dart';
import '../tema.dart';
import '../formato.dart';
import 'selector_producto.dart';

class PantallaCrearPedido extends StatefulWidget {
  const PantallaCrearPedido({super.key});

  @override
  State<PantallaCrearPedido> createState() => _PantallaCrearPedidoState();
}

class _PantallaCrearPedidoState extends State<PantallaCrearPedido> {
  final clienteNombreCtrl = TextEditingController();
  final clienteTelefonoCtrl = TextEditingController();
  final otroValorCtrl = TextEditingController();
  DateTime? fechaEntrega;
  final List<ItemPedido> items = [];

  @override
  void dispose() {
    clienteNombreCtrl.dispose();
    clienteTelefonoCtrl.dispose();
    otroValorCtrl.dispose();
    super.dispose();
  }

  Future<void> elegirFecha() async {
    final ahora = DateTime.now();
    final sel = await showDatePicker(
      context: context,
      initialDate: ahora,
      firstDate: ahora,
      lastDate: ahora.add(const Duration(days: 365)),
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
          receta: prod.consumoPorUnidad(),
        )));
  }

  Future<void> _agregarManual() async {
    final item = await _dialogoItemManual();
    if (item != null && mounted) setState(() => items.add(item));
  }

  Future<ItemPedido?> _dialogoItemManual() async {
    final t = AppLocalizations.of(context)!;
    final nombreCtrl = TextEditingController();
    final precioCtrl = TextEditingController();
    final costoCtrl = TextEditingController();
    final cantCtrl = TextEditingController(text: '1');
    final r = await showDialog<ItemPedido>(
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
    return r;
  }

  void guardar() {
    final t = AppLocalizations.of(context)!;
    final nombre = clienteNombreCtrl.text.trim();
    final telefono = clienteTelefonoCtrl.text.trim();
    final otro = parseCantidad(otroValorCtrl.text);
    final precioItems = items.fold<double>(0, (s, i) => s + i.precioTotal);
    final precioTotal = precioItems + otro;
    final costoTotal = items.fold<double>(0, (s, i) => s + i.costoTotal);

    if (nombre.isEmpty || precioTotal <= 0 || fechaEntrega == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.faltaClienteItemFecha)),
      );
      return;
    }

    final partes =
        items.map((i) => '${cantidadStr(i.cantidad)}x ${i.nombre}').toList();
    if (otro > 0) partes.add(t.otroValorItem);
    final descripcion = partes.isEmpty ? t.pedidoFallback : partes.join(', ');

    context.read<DatosApp>().registrarPedido(Pedido(
          cliente: Cliente(nombre: nombre, telefono: telefono),
          descripcion: descripcion,
          fechaPedido: DateTime.now(),
          fechaEntrega: fechaEntrega!,
          precio: precioTotal,
          costo: costoTotal,
          items: items,
          otroValor: otro,
        ));

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
      appBar: AppBar(title: Text(t.nuevoPedidoTitulo)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
              child: Text(t.sinItemsCrear,
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
                fechaEntrega == null
                    ? t.sinElegir
                    : '${fechaEntrega!.day}/${fechaEntrega!.month}/${fechaEntrega!.year}',
              ),
              trailing: TextButton(
                  onPressed: elegirFecha, child: Text(t.elegir)),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
              onPressed: guardar, child: Text(t.guardarPedido)),
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
