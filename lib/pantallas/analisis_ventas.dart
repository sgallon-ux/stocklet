import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../tema.dart';
import '../formato.dart';

class PantallaAnalisisVentas extends StatelessWidget {
  const PantallaAnalisisVentas({super.key});

  static const _dias = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
  ];
  static const _nombresMes = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<DatosApp>();
    final a = datos.analisisVentas();

    return Scaffold(
      appBar: AppBar(title: const Text('Análisis de ventas')),
      body: a.numVentas == 0
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('Aún no hay ventas para analizar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColores.textoSuave)),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _ticket(a),
                const SizedBox(height: 16),
                _demanda(a),
                const SizedBox(height: 16),
                _diaSemana(a),
                const SizedBox(height: 16),
                _fechasPico(a),
              ],
            ),
    );
  }

  // --- Ticket promedio y nº de ventas ---
  Widget _ticket(AnalisisVentas a) {
    Widget bloque(String t, String v) => Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t,
                  style: const TextStyle(
                      fontSize: 12, color: AppColores.textoSuave)),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(v,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColores.texto)),
              ),
            ],
          ),
        );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resumen general',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColores.texto)),
            const SizedBox(height: 12),
            Row(
              children: [
                bloque('Ticket promedio', pesos(a.ticketPromedio)),
                bloque('Nº de ventas', '${a.numVentas}'),
                bloque('Total vendido', pesos(a.totalVendido)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Meses de mayor y menor demanda ---
  Widget _demanda(AnalisisVentas a) {
    final ordenados = [...a.porMes]..sort((x, y) => y.value.compareTo(x.value));
    final mejor = ordenados.first;
    final peor = ordenados.last;
    final maxV = mejor.value <= 0 ? 1 : mejor.value;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Demanda por mes',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColores.texto)),
            const SizedBox(height: 4),
            Text(
                'Más fuerte: ${mejor.key} · Más flojo: ${peor.key}',
                style: const TextStyle(
                    fontSize: 12, color: AppColores.textoSuave)),
            const SizedBox(height: 12),
            ...a.porMes.map((e) {
              final frac = (e.value / maxV).clamp(0.0, 1.0);
              final esMejor = e.key == mejor.key;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                        width: 70,
                        child: Text(e.key,
                            style: const TextStyle(
                                fontSize: 12, color: AppColores.textoSuave))),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: frac,
                          minHeight: 10,
                          backgroundColor:
                              AppColores.borde.withValues(alpha: 0.5),
                          color: esMejor
                              ? AppColores.verde
                              : AppColores.verde.withValues(alpha: 0.45),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(pesos(e.value),
                        style: const TextStyle(
                            fontSize: 11, color: AppColores.textoSuave)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // --- Mejor día de la semana ---
  Widget _diaSemana(AnalisisVentas a) {
    final maxV = a.porDiaSemana
        .map((e) => e.value)
        .fold<double>(0, (m, v) => v > m ? v : m);
    final mejor = [...a.porDiaSemana]..sort((x, y) => y.value.compareTo(x.value));
    final base = maxV <= 0 ? 1 : maxV;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ventas por día de la semana',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColores.texto)),
            const SizedBox(height: 4),
            Text(
                mejor.first.value > 0
                    ? 'Tu mejor día es el ${_dias[mejor.first.key - 1].toLowerCase()}'
                    : 'Sin datos suficientes',
                style: const TextStyle(
                    fontSize: 12, color: AppColores.textoSuave)),
            const SizedBox(height: 12),
            ...a.porDiaSemana.map((e) {
              final frac = (e.value / base).clamp(0.0, 1.0);
              final esMejor = e.key == mejor.first.key && e.value > 0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                        width: 70,
                        child: Text(_dias[e.key - 1],
                            style: const TextStyle(
                                fontSize: 12, color: AppColores.textoSuave))),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: frac,
                          minHeight: 10,
                          backgroundColor:
                              AppColores.borde.withValues(alpha: 0.5),
                          color: esMejor
                              ? AppColores.verde
                              : AppColores.verde.withValues(alpha: 0.45),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(pesos(e.value),
                        style: const TextStyle(
                            fontSize: 11, color: AppColores.textoSuave)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // --- Fechas pico ---
  Widget _fechasPico(AnalisisVentas a) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fechas pico',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColores.texto)),
            const SizedBox(height: 4),
            const Text('Tus días con más ventas (ahí están tus fechas especiales)',
                style: TextStyle(fontSize: 12, color: AppColores.textoSuave)),
            const SizedBox(height: 12),
            ...a.fechasPico.asMap().entries.map((e) {
              final puesto = e.key + 1;
              final fecha = e.value.key;
              final valor = e.value.value;
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
                      child: Text(
                          '${fecha.day} de ${_nombresMes[fecha.month - 1]} ${fecha.year}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColores.texto)),
                    ),
                    Text(pesos(valor),
                        style: const TextStyle(
                            fontSize: 13, color: AppColores.textoSuave)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}