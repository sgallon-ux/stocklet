import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../models/cotizacion.dart';
import '../tema.dart';
import '../formato.dart';
import 'editar_cotizacion.dart';
import 'cotizacion_util.dart';

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
      floatingActionButton: context.watch<DatosApp>().puedeGestionarCatalogo
          ? FloatingActionButton.extended(
              onPressed: () => _nueva(context),
              icon: const Icon(Icons.add),
              label: Text(t.nuevaCotizacion),
            )
          : null,
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
            '${t.cotizaNumProductos(c.lineas.length)}  ·  ${pesos(c.total)}',
            style: TextStyle(color: m.textoSuave)),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: m.rojo),
          onPressed: () => _confirmarEliminar(context, datos, t, c),
        ),
      ),
    );
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
