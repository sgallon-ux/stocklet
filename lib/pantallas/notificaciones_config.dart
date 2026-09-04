import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../tema.dart';

class PantallaNotificacionesConfig extends StatelessWidget {
  const PantallaNotificacionesConfig({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final datos = context.watch<DatosApp>();
    final m = AppColores.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.notificaciones)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(t.notifConfigAyuda,
              style: TextStyle(color: m.textoSuave)),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: datos.notifPedidos,
                  onChanged: (v) => datos.setNotif(pedidos: v),
                  secondary:
                      Icon(Icons.receipt_long_outlined, color: m.verde),
                  title: Text(t.pedidosProximos),
                  subtitle: Text(t.notifPedidosSub),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: datos.notifInsumos,
                  onChanged: (v) => datos.setNotif(insumos: v),
                  secondary:
                      Icon(Icons.inventory_2_outlined, color: m.verde),
                  title: Text(t.inventarioBajo),
                  subtitle: Text(t.notifInsumosSub),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
