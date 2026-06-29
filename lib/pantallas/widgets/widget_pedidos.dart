import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../datos_app.dart';
import '../../tema.dart';
import '../pedidos.dart';

class WidgetPedidos extends StatelessWidget {
  const WidgetPedidos({super.key});

  // Días entre hoy y la fecha (solo fecha, sin hora)
  static int _diasHasta(DateTime fecha) {
    final hoy = DateTime.now();
    final a = DateTime(hoy.year, hoy.month, hoy.day);
    final b = DateTime(fecha.year, fecha.month, fecha.day);
    return b.difference(a).inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DatosApp>(
      builder: (context, datos, child) {
        final pendientes = datos.pedidos.where((p) => !p.entregado).toList()
          ..sort((a, b) => a.fechaEntrega.compareTo(b.fechaEntrega));
        final proximos = pendientes.take(3).toList();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.local_shipping_outlined,
                        size: 20, color: AppColores.verde),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('Pedidos próximos',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColores.texto)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PantallaPedidos())),
                      child: const Text('Ver todos'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (pendientes.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text('No tienes pedidos pendientes.',
                          style: TextStyle(color: AppColores.textoSuave)),
                    ),
                  )
                else
                  ...proximos.map((p) {
                    final d = _diasHasta(p.fechaEntrega);
                    String texto;
                    Color color;
                    if (d < 0) {
                      texto = 'Atrasado';
                      color = AppColores.rojo;
                    } else if (d == 0) {
                      texto = 'Hoy';
                      color = const Color(0xFFE08600);
                    } else if (d == 1) {
                      texto = 'Mañana';
                      color = const Color(0xFFE08600);
                    } else {
                      texto = 'En $d días';
                      color = AppColores.textoSuave;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            height: 38,
                            width: 38,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.inventory_2_outlined,
                                size: 18, color: color),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.cliente.nombre,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColores.texto)),
                                Text(p.descripcion,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColores.textoSuave)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(texto,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: color)),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }
}