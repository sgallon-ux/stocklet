import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../models/cotizacion.dart';
import '../tema.dart';
import '../formato.dart';
import 'editar_cotizacion.dart';
import 'cotizacion_util.dart';
import 'widgets/dialogo_convertir_pedido.dart';

class PantallaCotizar extends StatelessWidget {
  const PantallaCotizar({super.key});

  void _nueva(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => EditarCotizacion(cotizacion: Cotizacion())));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final m = AppColores.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.cotizarTitulo)),
      // Cotizar es parte del trabajo del día: cualquier miembro puede hacerlo.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _nueva(context),
        icon: const Icon(Icons.add),
        label: Text(t.nuevaCotizacion),
      ),
      body: Consumer<DatosApp>(
        builder: (context, datos, _) {
          final lista = [...datos.cotizaciones]
            ..sort((a, b) => b.fecha.compareTo(a.fecha));
          if (lista.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.request_quote_outlined,
                        size: 48, color: m.textoSuave),
                    const SizedBox(height: 12),
                    Text(
                        datos.productos.isEmpty
                            ? t.cotizarSinProductos
                            : t.cotizarVacio,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: m.textoSuave)),
                  ],
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(12),
            children: lista.map((c) => _tarjeta(context, datos, m, t, c)).toList(),
          );
        },
      ),
    );
  }

  Widget _tarjeta(BuildContext context, DatosApp datos, MarcaColores m,
      AppLocalizations t, Cotizacion c) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => EditarCotizacion(cotizacion: c))),
        title: Row(
          children: [
            Flexible(
              child: Text(c.cliente.isEmpty ? t.cotizaSinCliente : c.cliente,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: m.verde.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(estadoCotizacionTexto(t, c.estado),
                  style: TextStyle(fontSize: 10, color: m.verdeOscuro)),
            ),
          ],
        ),
        subtitle: Text(
            '${t.cotizaNumProductos(c.lineas.length)}  ·  ${pesos(c.total)}'
            '${c.convertida ? '  ·  ${t.cotizaYaTienePedido}' : ''}',
            style: TextStyle(color: m.textoSuave)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Solo para las aceptadas que aún no generaron pedido: el resto no
            // tiene nada que convertir, o ya lo hizo.
            if (c.estado == 'aceptada' && !c.convertida)
              IconButton(
                icon: Icon(Icons.assignment_turned_in_outlined, color: m.verdeOscuro),
                tooltip: t.convertirAccion,
                onPressed: () => _convertir(context, datos, t, c),
              ),
            if (datos.puedeEliminar)
              IconButton(
                icon: Icon(Icons.delete_outline, color: m.rojo),
                onPressed: () => _confirmarEliminar(context, datos, t, c),
              ),
          ],
        ),
      ),
    );
  }

  /// Convertir desde la lista, para las cotizaciones que se aceptaron hace
  /// días y aún no tienen pedido.
  Future<void> _convertir(BuildContext context, DatosApp datos,
      AppLocalizations t, Cotizacion c) async {
    final messenger = ScaffoldMessenger.of(context);
    if (c.lineas.isEmpty && c.total <= 0) {
      messenger.showSnackBar(SnackBar(content: Text(t.convertirSinLineas)));
      return;
    }
    final r = await mostrarDialogoConvertirPedido(context, c);
    if (r == null) return;
    final pedido = datos.convertirCotizacionEnPedido(
      c,
      telefono: r.telefono,
      fechaEntrega: r.fechaEntrega,
      descripcionFallback: t.pedidoFallback,
    );
    if (pedido != null) {
      messenger.showSnackBar(SnackBar(content: Text(t.convertirCreado)));
    }
  }

  void _confirmarEliminar(BuildContext context, DatosApp datos,
      AppLocalizations t, Cotizacion c) {
    showDialog(
      context: context,
      builder: (dc) => AlertDialog(
        title: Text(t.cotizaEliminarTitulo),
        content: Text(t.cotizaEliminarConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc), child: Text(t.cancelar)),
          TextButton(
            onPressed: () {
              datos.eliminarCotizacion(c);
              Navigator.pop(dc);
            },
            child: Text(t.eliminar),
          ),
        ],
      ),
    );
  }
}
