import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/pedido.dart';

class PantallaEditarPedido extends StatefulWidget {
  final Pedido pedido;
  const PantallaEditarPedido({super.key, required this.pedido});

  @override
  State<PantallaEditarPedido> createState() => _PantallaEditarPedidoState();
}

class _PantallaEditarPedidoState extends State<PantallaEditarPedido> {
  late final TextEditingController clienteNombreCtrl;
  late final TextEditingController clienteTelefonoCtrl;
  late final TextEditingController descripcionCtrl;
  late final TextEditingController precioCtrl;
  late final TextEditingController costoCtrl;
  late DateTime fechaEntrega;

  @override
  void initState() {
    super.initState();
    final p = widget.pedido;
    clienteNombreCtrl = TextEditingController(text: p.cliente.nombre);
    clienteTelefonoCtrl = TextEditingController(text: p.cliente.telefono);
    descripcionCtrl = TextEditingController(text: p.descripcion);
    precioCtrl = TextEditingController(text: p.precio.toStringAsFixed(0));
    costoCtrl = TextEditingController(text: p.costo.toStringAsFixed(0));
    fechaEntrega = p.fechaEntrega;
  }

  @override
  void dispose() {
    clienteNombreCtrl.dispose();
    clienteTelefonoCtrl.dispose();
    descripcionCtrl.dispose();
    precioCtrl.dispose();
    costoCtrl.dispose();
    super.dispose();
  }

  Future<void> elegirFecha() async {
    final seleccionada = await showDatePicker(
      context: context,
      initialDate: fechaEntrega,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (seleccionada != null) {
      setState(() => fechaEntrega = seleccionada);
    }
  }

  void guardar() {
    final nombre = clienteNombreCtrl.text.trim();
    final telefono = clienteTelefonoCtrl.text.trim();
    final descripcion = descripcionCtrl.text.trim();
    final precio = double.tryParse(precioCtrl.text) ?? 0;
    final costo = double.tryParse(costoCtrl.text) ?? 0;

    if (nombre.isEmpty || descripcion.isEmpty || precio <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa cliente, descripción y precio')),
      );
      return;
    }

    context.read<DatosApp>().editarPedido(
      widget.pedido,
      clienteNombre: nombre,
      clienteTelefono: telefono,
      descripcion: descripcion,
      fechaEntrega: fechaEntrega,
      precio: precio,
      costo: costo,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar pedido')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: clienteNombreCtrl,
            decoration: const InputDecoration(labelText: 'Nombre del cliente'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: clienteTelefonoCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Teléfono (opcional)'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descripcionCtrl,
            decoration: const InputDecoration(labelText: 'Descripción del pedido'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: precioCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Precio', prefixText: '\$ '),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: costoCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Costo aprox.', prefixText: '\$ '),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Fecha de entrega'),
              subtitle: Text('${fechaEntrega.day}/${fechaEntrega.month}/${fechaEntrega.year}'),
              trailing: TextButton(onPressed: elegirFecha, child: const Text('Cambiar')),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: guardar, child: const Text('Guardar cambios')),
        ],
      ),
    );
  }
}