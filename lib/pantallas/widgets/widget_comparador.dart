import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../../datos_app.dart';
import '../../models/producto.dart';
import '../../costeo.dart';
import '../../tema.dart';
import '../../formato.dart';
import '../comparador_productos.dart';
import 'desglose_costeo.dart';

class WidgetComparador extends StatelessWidget {
  const WidgetComparador({super.key});

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
    return Consumer<DatosApp>(
      builder: (context, datos, child) {
        final m = AppColores.of(context);
        final t = AppLocalizations.of(context)!;
        final cfg = datos.configCosteo;
        final productos = [...datos.productos]
          ..sort((a, b) {
            final sa = _sev(costear(a, cfg).estado);
            final sb = _sev(costear(b, cfg).estado);
            if (sa != sb) return sa.compareTo(sb);
            return a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase());
          });
        final dinero = dineroMesOportunidad(productos, cfg);
        final nBajo = productosPorDebajo(productos, cfg);
        final top = productos.take(3).toList();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.insights_outlined, size: 20, color: m.verde),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(t.comparadorTitulo,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: m.texto)),
                    ),
                    if (productos.isNotEmpty)
                      TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const PantallaComparadorProductos())),
                        child: Text(t.verTodos),
                      ),
                  ],
                ),
                if (productos.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(t.comparadorVacio,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: m.textoSuave)),
                    ),
                  )
                else ...[
                  if (nBajo > 0 && dinero > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Text(t.oportunidadResumen(pesos(dinero)),
                          style: TextStyle(fontSize: 12, color: m.rojo)),
                    )
                  else if (nBajo == 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Text(t.oportunidadBien,
                          style: TextStyle(fontSize: 12, color: m.verde)),
                    ),
                  ...top.map((p) => _fila(m, t, cfg, p)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _fila(
      MarcaColores m, AppLocalizations t, ConfigCosteo cfg, Producto p) {
    final r = costear(p, cfg);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(p.nombre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w600, color: m.texto)),
          ),
          const SizedBox(width: 8),
          Text(pesos(p.precioVenta),
              style: TextStyle(fontSize: 12, color: m.textoSuave)),
          const SizedBox(width: 8),
          if (r.estado == EstadoPrecio.perdida || r.estado == EstadoPrecio.bajo)
            ChipEstadoPrecio(estado: r.estado)
          else
            Text(pesos(r.precioSugerido),
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: m.verde)),
        ],
      ),
    );
  }
}
