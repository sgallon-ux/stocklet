import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/cliente.dart';
import '../models/pedido.dart';

class PantallaCrearPedido extends StatefulWidget {
  const PantallaCrearPedido({super.key});

  @override
  State<PantallaCrearPedido> createState() => _PantallaCrearPedidoState();
}

class _PantallaCrearPedidoState extends State<PantallaCrearPedido> {
  final clienteNombreCtrl = TextEditingController();
  final clienteTelefonoCtrl = TextEditingController();
  final descripcionCtrl = TextEditingController();
  final precioCtrl = TextEditingController();
  final costoCtrl = TextEditingController();

  DateTime? fechaEntrega;

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
    final ahora = DateTime.now();
    final seleccionada = await showDatePicker(
      context: context,
      initialDate: ahora,
      firstDate: ahora,
      lastDate: ahora.add(const Duration(days: 365)),
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

    if (nombre.isEmpty || descripcion.isEmpty || precio <= 0 || fechaEntrega == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa cliente, descripción, precio y fecha de entrega')),
      );
      return;
    }

    final cliente = Cliente(nombre: nombre, telefono: telefono);

    context.read<DatosApp>().registrarPedido(Pedido(
      cliente: cliente,
      descripcion: descripcion,
      fechaPedido: DateTime.now(),
      fechaEntrega: fechaEntrega!,
      precio: precio,
      costo: costo,
    ));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo pedido')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: clienteNombreCtrl,
            decoration: const InputDecoration(labelText: 'Nombre del cliente', hintText: 'Ej: María'),
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
            decoration: const InputDecoration(
              labelText: 'Descripción del pedido',
              hintText: 'Ej: Torta de cumpleaños 2 pisos',
            ),
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
              subtitle: Text(
                fechaEntrega == null
                    ? 'Sin elegir'
                    : '${fechaEntrega!.day}/${fechaEntrega!.month}/${fechaEntrega!.year}',
              ),
              trailing: TextButton(onPressed: elegirFecha, child: const Text('Elegir')),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: guardar, child: const Text('Guardar pedido')),
        ],
      ),
    );
  }
}