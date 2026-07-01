import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../datos_app.dart';
import '../../tema.dart';
import '../top_productos.dart';

class WidgetTopProductos extends StatelessWidget {
  const WidgetTopProductos({super.key});

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<DatosApp>();
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
                const Expanded(
                  child: Text('Top productos del mes',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColores.texto)),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PantallaTopProductos())),
                  child: const Text('Ver todos'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (primeros.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Aún no hay ventas de productos este mes.',
                    style: TextStyle(color: AppColores.textoSuave)),
              )
            else
              ...primeros.asMap().entries.map((e) => _fila(e.key + 1, e.value)),
          ],
        ),
      ),
    );
  }

  Widget _fila(int puesto, ProductoVendido p) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            height: 28,
            width: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColores.verde.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Text('$puesto',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColores.verdeOscuro)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(p.nombre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: AppColores.texto)),
          ),
          Text('${p.cantidad} vend.',
              style: const TextStyle(fontSize: 13, color: AppColores.textoSuave)),
        ],
      ),
    );
  }
}