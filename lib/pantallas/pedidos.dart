import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/pedido.dart';
import '../tema.dart';
import '../formato.dart';
import 'crear_pedido.dart';
import 'editar_pedido.dart';

class PantallaPedidos extends StatefulWidget {
  const PantallaPedidos({super.key});

  @override
  State<PantallaPedidos> createState() => _PantallaPedidosState();
}

class _PantallaPedidosState extends State<PantallaPedidos> {
  bool verArchivados = false;

  static int _diasHasta(DateTime fecha) {
    final hoy = DateTime.now();
    final a = DateTime(hoy.year, hoy.month, hoy.day);
    final b = DateTime(fecha.year, fecha.month, fecha.day);
    return b.difference(a).inDays;
  }

  void _entregar(BuildContext context, Pedido pedido) {
    final datos = context.read<DatosApp>();
    showDialog(
      context: context,
      builder: (dc) => AlertDialog(
        title: const Text('Entregar pedido'),
        content: Text(
          'Al marcar este pedido como entregado, su valor de ${pesos(pedido.precio)} '
          'se registrará como un ingreso y aparecerá en tu historial de ventas.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              datos.marcarPedidoEntregado(pedido);
              Navigator.pop(dc);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Pedido entregado y registrado en ingresos')),
              );
            },
            child: const Text('Entregar'),
          ),
        ],
      ),
    );
  }

  void _eliminar(BuildContext context, Pedido pedido) {
    final datos = context.read<DatosApp>();
    final entregado = pedido.entregado;
    showDialog(
      context: context,
      builder: (dc) => AlertDialog(
        title: const Text('Eliminar pedido'),
        content: Text(
          entregado
              ? 'Este pedido ya fue entregado. Su ingreso ya quedó registrado '
                  'como una venta y NO se modificará al eliminarlo.'
              : '¿Seguro que quieres eliminar el pedido de ${pedido.cliente.nombre}?',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              datos.eliminarPedido(pedido);
              Navigator.pop(dc);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _archivar(BuildContext context, Pedido pedido) {
    final datos = context.read<DatosApp>();
    datos.archivarPedido(pedido);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pedido archivado'),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () => datos.desarchivarPedido(pedido),
        ),
      ),
    );
  }

  void _editar(BuildContext context, Pedido pedido) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => PantallaEditarPedido(pedido: pedido)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const PantallaCrearPedido())),
        icon: const Icon(Icons.add),
        label: const Text('Pedido'),
      ),
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          final m = AppColores.of(context);
          if (datos.pedidos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text('Aún no hay pedidos.\nCrea el primero con el botón +',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: m.textoSuave)),
              ),
            );
          }

          final pendientes = datos.pedidos
              .where((p) => !p.entregado && !p.archivado)
              .toList()
            ..sort((a, b) => a.fechaEntrega.compareTo(b.fechaEntrega));
          final entregados = datos.pedidos
              .where((p) => p.entregado && !p.archivado)
              .toList()
            ..sort((a, b) => b.fechaEntrega.compareTo(a.fechaEntrega));
          final archivados = datos.pedidos.where((p) => p.archivado).toList()
            ..sort((a, b) => b.fechaEntrega.compareTo(a.fechaEntrega));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _encabezado(m, 'Pendientes', pendientes.length),
              if (pendientes.isEmpty)
                _vacio(m, 'No tienes pedidos pendientes.')
              else
                ...pendientes.map((p) => _tarjeta(context, p, 'pendiente')),
              const SizedBox(height: 16),
              _encabezado(m, 'Entregados', entregados.length),
              if (entregados.isEmpty)
                _vacio(m, 'Aún no has entregado pedidos.')
              else
                ...entregados.map((p) => _tarjeta(context, p, 'entregado')),
              if (archivados.isNotEmpty) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () =>
                      setState(() => verArchivados = !verArchivados),
                  icon: Icon(
                      verArchivados ? Icons.expand_less : Icons.expand_more),
                  label: Text(verArchivados
                      ? 'Ocultar archivados'
                      : 'Ver archivados (${archivados.length})'),
                ),
                if (verArchivados)
                  ...archivados.map((p) => _tarjeta(context, p, 'archivado')),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _encabezado(MarcaColores m, String texto, int n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text('$texto ($n)',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: m.texto)),
    );
  }

  Widget _vacio(MarcaColores m, String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(texto, style: TextStyle(color: m.textoSuave)),
    );
  }

  Widget _tarjeta(BuildContext context, Pedido pedido, String tipo) {
    final m = AppColores.of(context);
    String urg = '';
    Color urgColor = m.textoSuave;
    if (tipo == 'pendiente') {
      final d = _diasHasta(pedido.fechaEntrega);
      if (d < 0) {
        urg = 'Atrasado';
        urgColor = m.rojo;
      } else if (d == 0) {
        urg = 'Hoy';
        urgColor = const Color(0xFFE08600);
      } else if (d == 1) {
        urg = 'Mañana';
        urgColor = const Color(0xFFE08600);
      } else {
        urg = 'En $d días';
        urgColor = m.textoSuave;
      }
    }

    final iconColor = tipo == 'pendiente' ? urgColor : m.verde;
    final icono = tipo == 'pendiente' ? Icons.schedule : Icons.check_circle;

    final menu = <PopupMenuEntry<String>>[
      const PopupMenuItem(value: 'editar', child: Text('Editar')),
      if (tipo == 'entregado')
        const PopupMenuItem(value: 'archivar', child: Text('Archivar')),
      if (tipo == 'archivado')
        const PopupMenuItem(value: 'desarchivar', child: Text('Desarchivar')),
      const PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icono, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pedido.cliente.nombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: m.texto)),
                      Text(pedido.descripcion,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12, color: m.textoSuave)),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (op) {
                    if (op == 'editar') {
                      _editar(context, pedido);
                    } else if (op == 'archivar') {
                      _archivar(context, pedido);
                    } else if (op == 'desarchivar') {
                      context.read<DatosApp>().desarchivarPedido(pedido);
                    } else if (op == 'eliminar') {
                      _eliminar(context, pedido);
                    }
                  },
                  itemBuilder: (_) => menu,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.event, size: 15, color: m.textoSuave),
                const SizedBox(width: 4),
                Text(
                  '${pedido.fechaEntrega.day}/${pedido.fechaEntrega.month}/${pedido.fechaEntrega.year}',
                  style: TextStyle(fontSize: 12, color: m.textoSuave),
                ),
                const SizedBox(width: 10),
                Text(pesos(pedido.precio),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: m.texto)),
                const Spacer(),
                if (tipo == 'pendiente')
                  Text(urg,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: urgColor))
                else if (tipo == 'entregado')
                  Text('Entregado',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: m.verde))
                else
                  Text('Archivado',
                      style: TextStyle(fontSize: 12, color: m.textoSuave)),
              ],
            ),
            if (tipo == 'pendiente') ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _entregar(context, pedido),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Marcar como entregado'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}