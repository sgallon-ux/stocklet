import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../models/producto.dart';
import '../costeo.dart';
import '../tema.dart';
import '../formato.dart';
import 'widgets/desglose_costeo.dart';
import 'editar_producto.dart';
import 'simulador_alza.dart';

class PantallaComparadorProductos extends StatelessWidget {
  const PantallaComparadorProductos({super.key});

  int _sev(EstadoPrecio e) {
    switch (e) {
      case EstadoPrecio.perdida:
        return 0;
      case EstadoPrecio.bajo:
        return 1;
      case EstadoPrecio.sinPrecio:
        return 2;
      case EstadoPrecio.bien:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final m = AppColores.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.comparadorTitulo),
        actions: [
          IconButton(
            icon: const Icon(Icons.trending_up),
            tooltip: t.simuladorTitulo,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PantallaSimuladorAlza())),
          ),
        ],
      ),
      body: Consumer<DatosApp>(
        builder: (context, datos, _) {
          final cfg = datos.configCosteo;
          final productos = [...datos.productos];
          if (productos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(t.comparadorVacio,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: m.textoSuave)),
              ),
            );
          }
          productos.sort((a, b) {
            final sa = _sev(costear(a, cfg).estado);
            final sb = _sev(costear(b, cfg).estado);
            if (sa != sb) return sa.compareTo(sb);
            return a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase());
          });
          final dinero = dineroMesOportunidad(productos, cfg);
          final nBajo = productosPorDebajo(productos, cfg);

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _panelOportunidad(m, t, dinero, nBajo),
              const SizedBox(height: 8),
              ...productos.map((p) => _fila(context, m, t, cfg, p)),
            ],
          );
        },
      ),
    );
  }

  Widget _panelOportunidad(
      MarcaColores m, AppLocalizations t, double dinero, int nBajo) {
    final bien = nBajo == 0;
    return Card(
      color: (bien ? m.verde : m.rojo).withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(bien ? t.oportunidadBien : t.oportunidadTitulo,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: bien ? m.verde : m.rojo)),
            if (!bien) ...[
              const SizedBox(height: 6),
              if (dinero > 0)
                Text(pesos(dinero),
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: m.texto)),
              Text(
                  dinero > 0
                      ? t.oportunidadDetalle(nBajo)
                      : t.oportunidadSinEstimado(nBajo),
                  style: TextStyle(fontSize: 12, color: m.textoSuave)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _fila(BuildContext context, MarcaColores m, AppLocalizations t,
      ConfigCosteo cfg, Producto p) {
    final r = costear(p, cfg);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => PantallaEditarProducto(producto: p))),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(p.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: m.texto)),
                  ),
                  ChipEstadoPrecio(estado: r.estado),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  _celda(m, t.costeoCostoUnidad, pesos(r.costoUnidad)),
                  _celda(m, t.cotizaPrecioUnitario, pesos(p.precioVenta)),
                  _celda(m, t.costeoPrecioSugerido, pesos(r.precioSugerido),
                      color: m.verde),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _celda(MarcaColores m, String etq, String val, {Color? color}) =>
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(etq, style: TextStyle(fontSize: 11, color: m.textoSuave)),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(val,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color ?? m.texto)),
            ),
          ],
        ),
      );
}
