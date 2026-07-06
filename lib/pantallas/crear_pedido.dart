import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  Future<int?> _pedirCantidad() async {
    final ctrl = TextEditingController(text: '1');
    final r = await showDialog<int>(
      context: context,
      builder: (dc) => AlertDialog(
        title: const Text('Cantidad'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Cantidad'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final n = int.tryParse(ctrl.text) ?? 0;
              Navigator.pop(dc, n > 0 ? n : 1);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
    ctrl.dispose();
    return r;
  }

  Future<void> _agregarDelCatalogo() async {
    final productos = [...context.read<DatosApp>().productos];
    if (productos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aún no tienes productos creados')),
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
        )));
  }

  Future<void> _agregarManual() async {
    final item = await _dialogoItemManual();
    if (item != null && mounted) setState(() => items.add(item));
  }

  Future<ItemPedido?> _dialogoItemManual() async {
    final nombreCtrl = TextEditingController();
    final precioCtrl = TextEditingController();
    final costoCtrl = TextEditingController();
    final cantCtrl = TextEditingController(text: '1');
    final r = await showDialog<ItemPedido>(
      context: context,
      builder: (dc) => AlertDialog(
        title: const Text('Ítem manual'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nombreCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(labelText: 'Descripción')),
              const SizedBox(height: 8),
              TextField(
                  controller: precioCtrl,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Precio unitario')),
              const SizedBox(height: 8),
              TextField(
                  controller: costoCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Costo unitario (opcional)')),
              const SizedBox(height: 8),
              TextField(
                  controller: cantCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Cantidad')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final nombre = nombreCtrl.text.trim();
              final precio = double.tryParse(precioCtrl.text) ?? 0;
              final costo = double.tryParse(costoCtrl.text) ?? 0;
              final cant = int.tryParse(cantCtrl.text) ?? 0;
              if (nombre.isEmpty || precio <= 0 || cant <= 0) return;
              Navigator.pop(
                  dc,
                  ItemPedido(
                      nombre: nombre,
                      cantidad: cant,
                      precioUnitario: precio,
                      costoUnitario: costo));
            },
            child: const Text('Agregar'),
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
    final nombre = clienteNombreCtrl.text.trim();
    final telefono = clienteTelefonoCtrl.text.trim();
    final otro = double.tryParse(otroValorCtrl.text) ?? 0;
    final precioItems = items.fold<double>(0, (s, i) => s + i.precioTotal);
    final precioTotal = precioItems + otro;
    final costoTotal = items.fold<double>(0, (s, i) => s + i.costoTotal);

    if (nombre.isEmpty || precioTotal <= 0 || fechaEntrega == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Falta el cliente, al menos un ítem (o valor) y la fecha')),
      );
      return;
    }

    final partes = items.map((i) => '${i.cantidad}x ${i.nombre}').toList();
    if (otro > 0) partes.add('Otro valor');
    final descripcion = partes.isEmpty ? 'Pedido' : partes.join(', ');

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
    final m = AppColores.of(context);
    final otro = double.tryParse(otroValorCtrl.text) ?? 0;
    final precioItems = items.fold<double>(0, (s, i) => s + i.precioTotal);
    final precioTotal = precioItems + otro;
    final costoTotal = items.fold<double>(0, (s, i) => s + i.costoTotal);
    final ganancia = precioTotal - costoTotal;
    final gColor = ganancia >= 0 ? m.verde : m.rojo;

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo pedido')),
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
                    decoration: const InputDecoration(
                      labelText: 'Nombre del cliente',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: clienteTelefonoCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono (opcional)',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Productos del pedido',
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
                  label: const Text('Del catálogo'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _agregarManual,
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Manual'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('Agrega productos del catálogo o ítems manuales.',
                  style: TextStyle(color: m.textoSuave)),
            )
          else
            ...items.asMap().entries.map((e) {
              final it = e.value;
              return Card(
                child: ListTile(
                  dense: true,
                  title: Text('${it.cantidad}x ${it.nombre}',
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
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Otro valor (domicilio, servicios...)',
              prefixIcon: Icon(Icons.add_road),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            color: m.verde.withValues(alpha: 0.06),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _tot('Precio', pesos(precioTotal), m.texto, m),
                  _tot('Costo', pesos(costoTotal), m.texto, m),
                  _tot('Ganancia', pesos(ganancia), gColor, m),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Icon(Icons.event, color: m.verde),
              title: const Text('Fecha de entrega'),
              subtitle: Text(
                fechaEntrega == null
                    ? 'Sin elegir'
                    : '${fechaEntrega!.day}/${fechaEntrega!.month}/${fechaEntrega!.year}',
              ),
              trailing: TextButton(
                  onPressed: elegirFecha, child: const Text('Elegir')),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
              onPressed: guardar, child: const Text('Guardar pedido')),
        ],
      ),
    );
  }

  Widget _tot(String t, String v, Color c, MarcaColores m) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t,
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