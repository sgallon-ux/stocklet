import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../tema.dart';
import '../formato.dart';
import 'ingresar_venta.dart';
import 'registrar_gasto.dart';
import 'historial_ventas.dart';
import 'historial_gastos.dart';
import 'ajustes.dart';
import 'widgets/tarjeta_resumen.dart';
import 'widgets/grafica_tendencia.dart';

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
        title: Text(context.watch<DatosApp>().negocio?.nombre ?? 'Mi negocio'),
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
      body: Consumer<DatosApp>(
        builder: (context, datos, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Resumen de tu negocio',
                  style: TextStyle(fontSize: 14, color: AppColores.textoSuave)),
              const SizedBox(height: 12),

              // --- Resumen en una fila (Ingresos y Gastos son botones) ---
              Row(
                children: [
                  Expanded(
                    child: TarjetaResumen(
                      titulo: 'Ingresos',
                      valor: pesos(datos.ingresosTotales),
                      icono: Icons.trending_up,
                      color: AppColores.verde,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PantallaHistorialVentas())),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TarjetaResumen(
                      titulo: 'Gastos',
                      valor: pesos(datos.gastosTotales),
                      icono: Icons.trending_down,
                      color: AppColores.rojo,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PantallaHistorialGastos())),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TarjetaResumen(
                      titulo: 'Ganancia',
                      valor: pesos(datos.ganancia),
                      icono: Icons.account_balance_wallet,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

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
              const GraficaTendencia(),
            ],
          );
        },
      ),
    );
  }
}