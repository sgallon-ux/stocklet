import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import 'ingresar_venta.dart';
import 'registrar_gasto.dart';
import 'ajustes.dart';
import 'widgets/panel_resumen.dart';
import 'widgets/widget_pedidos.dart';
import 'widgets/widget_notas.dart';

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.account_circle_outlined),
          tooltip: 'Panel de usuario',
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const PantallaAjustes())),
        ),
        title: Builder(
          builder: (context) {
            final negocio = context.watch<DatosApp>().negocio;
            final logo = negocio?.logoUrl ?? '';
            return logo.isEmpty
                ? Text(negocio?.nombre ?? 'Mi negocio')
                : Image.network(
                    logo,
                    height: 36,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) =>
                        Text(negocio?.nombre ?? 'Mi negocio'),
                  );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Buscar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Búsqueda próximamente')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PanelResumen(),
          const SizedBox(height: 16),

          // --- Fila de acciones ---
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PantallaIngresarVenta())),
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar venta'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PantallaRegistrarGasto())),
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar gasto'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const WidgetPedidos(),
          const SizedBox(height: 20),
          const WidgetNotas(),
        ],
      ),
    );
  }
}