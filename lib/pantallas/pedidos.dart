import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
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
    final t = AppLocalizations.of(context)!;
    final datos = context.read<DatosApp>();
    showDialog(
      context: context,
      builder: (dc) => AlertDialog(
        title: Text(t.entregarPedido),
        content: Text(t.entregarPedidoTexto(pesos(pedido.precio))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc),
              child: Text(t.cancelar)),
          ElevatedButton(
            onPressed: () {
              final negativos = datos.marcarPedidoEntregado(pedido);
              Navigator.pop(dc);
              final msg = negativos.isEmpty
                  ? t.pedidoEntregadoOk
                  : t.pedidoEntregadoNegativo(negativos.join(', '));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg)),
              );
            },
            child: Text(t.entregar),
          ),
        ],
      ),
    );
  }

  void _eliminar(BuildContext context, Pedido pedido) {
    final t = AppLocalizations.of(context)!;
    final datos = context.read<DatosApp>();
    final entregado = pedido.entregado;
    showDialog(
      context: context,
      builder: (dc) => AlertDialog(
        title: Text(t.eliminarPedidoTitulo),
        content: Text(
          entregado
              ? t.eliminarPedidoEntregado
              : t.eliminarPedidoConfirmacion(pedido.cliente.nombre),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc),
              child: Text(t.cancelar)),
          TextButton(
            onPressed: () {
              datos.eliminarPedido(pedido);
              Navigator.pop(dc);
            },
            child: Text(t.eliminar),
          ),
        ],
      ),
    );
  }

  void _archivar(BuildContext context, Pedido pedido) {
    final t = AppLocalizations.of(context)!;
    final datos = context.read<DatosApp>();
    datos.archivarPedido(pedido);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.pedidoArchivado),
        action: SnackBarAction(
          label: t.deshacer,
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
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.pedidos)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const PantallaCrearPedido())),
        icon: const Icon(Icons.add),
        label: Text(t.pedidoFab),
      ),
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          final m = AppColores.of(context);
          if (datos.pedidos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(t.pedidosVacio,
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
              _encabezado(m, t.pendientes, pendientes.length),
              if (pendientes.isEmpty)
                _vacio(m, t.sinPedidosPendientes)
              else
                ...pendientes.map((p) => _tarjeta(context, p, 'pendiente')),
              const SizedBox(height: 16),
              _encabezado(m, t.entregados, entregados.length),
              if (entregados.isEmpty)
                _vacio(m, t.sinEntregados)
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
                      ? t.ocultarArchivados
                      : t.verArchivadosBtn(archivados.length)),
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
    final t = AppLocalizations.of(context)!;
    String urg = '';
    Color urgColor = m.textoSuave;
    if (tipo == 'pendiente') {
      final d = _diasHasta(pedido.fechaEntrega);
      if (d < 0) {
        urg = t.pedidoAtrasado;
        urgColor = m.rojo;
      } else if (d == 0) {
        urg = t.hoy;
        urgColor = const Color(0xFFE08600);
      } else if (d == 1) {
        urg = t.manana;
        urgColor = const Color(0xFFE08600);
      } else {
        urg = t.enDias(d);
        urgColor = m.textoSuave;
      }
    }

    final iconColor = tipo == 'pendiente' ? urgColor : m.verde;
    final icono = tipo == 'pendiente' ? Icons.schedule : Icons.check_circle;

    final menu = <PopupMenuEntry<String>>[
      PopupMenuItem(value: 'editar', child: Text(t.editar)),
      if (tipo == 'entregado')
        PopupMenuItem(value: 'archivar', child: Text(t.archivar)),
      if (tipo == 'archivado')
        PopupMenuItem(value: 'desarchivar', child: Text(t.desarchivar)),
      PopupMenuItem(value: 'eliminar', child: Text(t.eliminar)),
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
                  Text(t.entregadoEstado,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: m.verde))
                else
                  Text(t.archivadoEstado,
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
                  label: Text(t.marcarEntregado),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
