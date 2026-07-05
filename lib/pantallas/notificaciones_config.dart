import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../tema.dart';

class PantallaNotificacionesConfig extends StatelessWidget {
  const PantallaNotificacionesConfig({super.key});

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<DatosApp>();
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Elige qué avisos quieres recibir dentro de la app.',
              style: TextStyle(color: AppColores.textoSuave)),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: datos.notifPedidos,
                  onChanged: (v) => datos.setNotif(pedidos: v),
                  secondary: const Icon(Icons.receipt_long_outlined,
                      color: AppColores.verde),
                  title: const Text('Pedidos próximos'),
                  subtitle: const Text('Entregas de hoy, mañana o atrasadas'),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: datos.notifNotas,
                  onChanged: (v) => datos.setNotif(notas: v),
                  secondary: const Icon(Icons.sticky_note_2_outlined,
                      color: AppColores.verde),
                  title: const Text('Notas nuevas'),
                  subtitle: const Text('Cuando alguien crea una nota'),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: datos.notifInsumos,
                  onChanged: (v) => datos.setNotif(insumos: v),
                  secondary: const Icon(Icons.inventory_2_outlined,
                      color: AppColores.verde),
                  title: const Text('Inventario bajo'),
                  subtitle:
                      const Text('Insumos por debajo de su stock mínimo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}