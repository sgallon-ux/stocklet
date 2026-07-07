import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../../datos_app.dart';
import '../../tema.dart';
import '../top_productos.dart';

class WidgetTopProductos extends StatelessWidget {
  const WidgetTopProductos({super.key});

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<DatosApp>();
    final m = AppColores.of(context);
    final t = AppLocalizations.of(context)!;
    final ahora = DateTime.now();
    final top = datos.topProductos(ahora.year, ahora.month);
    final primeros = top.take(3).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(t.topProductosMes,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: m.texto)),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PantallaTopProductos())),
                  child: Text(t.verTodos),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (primeros.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(t.topSinVentasMes,
                    style: TextStyle(color: m.textoSuave)),
              )
            else
              ...primeros
                  .asMap()
                  .entries
                  .map((e) => _fila(m, t, e.key + 1, e.value)),
          ],
        ),
      ),
    );
  }

  Widget _fila(MarcaColores m, AppLocalizations t, int puesto,
      ProductoVendido p) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            height: 28,
            width: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: m.verde.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Text('$puesto',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: m.verdeOscuro)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(p.nombre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: m.texto)),
          ),
          Text(t.vendidosAbrev(p.cantidad),
              style: TextStyle(fontSize: 13, color: m.textoSuave)),
        ],
      ),
    );
  }
}
