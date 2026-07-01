import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../tema.dart';
import '../formato.dart';

class PantallaTopProductos extends StatefulWidget {
  const PantallaTopProductos({super.key});

  @override
  State<PantallaTopProductos> createState() => _PantallaTopProductosState();
}

class _PantallaTopProductosState extends State<PantallaTopProductos> {
  DateTime? _mes; // primer día del mes seleccionado

  static const _nombresMes = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  String _label(DateTime m) => '${_nombresMes[m.month - 1]} ${m.year}';

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<DatosApp>();
    final meses = datos.mesesConVentasDeProductos();

    // Por defecto: mes actual si tiene ventas; si no, el más reciente.
    DateTime? sel = _mes;
    if (sel == null && meses.isNotEmpty) {
      final ahora = DateTime.now();
      final actual = DateTime(ahora.year, ahora.month, 1);
      sel = meses.contains(actual) ? actual : meses.first;
    }

    final top = sel == null
        ? <ProductoVendido>[]
        : datos.topProductos(sel.year, sel.month);

    return Scaffold(
      appBar: AppBar(title: const Text('Top de productos')),
      body: meses.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('Aún no hay ventas de productos registradas.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColores.textoSuave)),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    const Text('Mes:',
                        style: TextStyle(color: AppColores.textoSuave)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButton<DateTime>(
                        value: sel,
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(12),
                        items: meses
                            .map((m) => DropdownMenuItem(
                                value: m, child: Text(_label(m))))
                            .toList(),
                        onChanged: (v) => setState(() => _mes = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (top.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('No hubo ventas de productos en este mes.',
                        style: TextStyle(color: AppColores.textoSuave)),
                  )
                else
                  ...top.asMap().entries.map((e) {
                    final puesto = e.key + 1;
                    final p = e.value;
                    return Card(
                      child: ListTile(
                        leading: Container(
                          height: 36,
                          width: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColores.verde.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Text('$puesto',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColores.verdeOscuro)),
                        ),
                        title: Text(p.nombre,
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('Total: ${pesos(p.total)}'),
                        trailing: Text('${p.cantidad}',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColores.texto)),
                      ),
                    );
                  }),
              ],
            ),
    );
  }
}