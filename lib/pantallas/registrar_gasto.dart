import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../models/gasto.dart';
import '../tema.dart';
import '../formato.dart';
import 'selector_insumo.dart';

enum _ModoGasto { normal, insumos }

class PantallaRegistrarGasto extends StatefulWidget {
  const PantallaRegistrarGasto({super.key});

  @override
  State<PantallaRegistrarGasto> createState() => _PantallaRegistrarGastoState();
}

class _PantallaRegistrarGastoState extends State<PantallaRegistrarGasto> {
  _ModoGasto modo = _ModoGasto.normal;

  // Gasto normal
  final descripcionCtrl = TextEditingController();
  final montoCtrl = TextEditingController();
  CategoriaGasto categoria = CategoriaGasto.insumos;

  // Compra de insumos
  final compraDescCtrl = TextEditingController();
  final List<LineaCompraInsumo> lineas = [];

  @override
  void dispose() {
    descripcionCtrl.dispose();
    montoCtrl.dispose();
    compraDescCtrl.dispose();
    super.dispose();
  }

  void _aviso(String t) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));
  }

  void _guardarNormal() {
    final descripcion = descripcionCtrl.text.trim();
    final monto = double.tryParse(montoCtrl.text) ?? 0;
    if (descripcion.isEmpty || monto <= 0) {
      _aviso('Escribe una descripción y un monto válido');
      return;
    }
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar gasto'),
        content:
            Text('¿Registrar el gasto "$descripcion" por ${pesos(monto)}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              context.read<DatosApp>().registrarGasto(Gasto(
                    fecha: DateTime.now(),
                    descripcion: descripcion,
                    categoria: categoria,
                    monto: monto,
                  ));
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _agregarLinea() async {
    final insumos = [...context.read<DatosApp>().insumos]
      ..sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
    if (insumos.isEmpty) {
      _aviso('Primero crea insumos en Inventario.');
      return;
    }
    final insumo = await elegirInsumo(context, insumos);
    if (insumo == null || !mounted) return;
    if (lineas.any((l) => l.insumo.id == insumo.id)) {
      _aviso('Ese insumo ya está en la lista.');
      return;
    }
    final cantidadCtrl = TextEditingController();
    final totalCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (dc) => AlertDialog(
        title: Text(insumo.nombre),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: cantidadCtrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: 'Cantidad comprada (${insumo.unidad})'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: totalCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Total pagado', prefixText: '\$ '),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc, false),
              child: const Text('Cancelar')),
          ElevatedButton(
              onPressed: () => Navigator.pop(dc, true),
              child: const Text('Agregar')),
        ],
      ),
    );
    final cantidad = double.tryParse(cantidadCtrl.text) ?? 0;
    final total = double.tryParse(totalCtrl.text) ?? 0;
    cantidadCtrl.dispose();
    totalCtrl.dispose();
    if (ok != true || !mounted) return;
    if (cantidad <= 0 || total <= 0) {
      _aviso('Cantidad y total deben ser mayores a cero.');
      return;
    }
    setState(() => lineas.add(LineaCompraInsumo(insumo, cantidad, total)));
  }

  void _guardarCompra() {
    if (lineas.isEmpty) {
      _aviso('Agrega al menos un insumo.');
      return;
    }
    final total = lineas.fold<double>(0, (s, l) => s + l.total);
    showDialog(
      context: context,
      builder: (dc) => AlertDialog(
        title: const Text('Confirmar compra'),
        content: Text(
            '¿Registrar la compra de ${lineas.length} insumo(s) por ${pesos(total)}? '
            'Se sumará el stock y se registrará el gasto.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              context.read<DatosApp>().comprarInsumos(
                    lineas: lineas,
                    descripcion: compraDescCtrl.text,
                  );
              Navigator.pop(dc);
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = AppColores.of(context);
    final totalCompra = lineas.fold<double>(0, (s, l) => s + l.total);

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar gasto')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<_ModoGasto>(
            segments: const [
              ButtonSegment(
                  value: _ModoGasto.normal,
                  label: Text('Gasto normal'),
                  icon: Icon(Icons.receipt_long_outlined)),
              ButtonSegment(
                  value: _ModoGasto.insumos,
                  label: Text('Compra de insumos'),
                  icon: Icon(Icons.inventory_2_outlined)),
            ],
            selected: {modo},
            onSelectionChanged: (s) => setState(() => modo = s.first),
          ),
          const SizedBox(height: 20),
          if (modo == _ModoGasto.normal)
            ..._camposNormal()
          else
            ..._camposCompra(m, totalCompra),
        ],
      ),
    );
  }

  List<Widget> _camposNormal() {
    return [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: descripcionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Ej: pago de arriendo',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: montoCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Monto', prefixText: '\$ '),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CategoriaGasto>(
                initialValue: categoria,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: CategoriaGasto.values.map((c) {
                  return DropdownMenuItem(value: c, child: Text(c.name));
                }).toList(),
                onChanged: (nueva) => setState(() => categoria = nueva!),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
      ElevatedButton(
          onPressed: _guardarNormal, child: const Text('Guardar gasto')),
    ];
  }

  List<Widget> _camposCompra(MarcaColores m, double total) {
    return [
      Text(
          'Agrega los insumos que compraste. Se sumará su stock y el costo por unidad se recalcula (promedio ponderado).',
          style: TextStyle(fontSize: 12, color: m.textoSuave)),
      const SizedBox(height: 12),
      OutlinedButton.icon(
        onPressed: _agregarLinea,
        icon: const Icon(Icons.add),
        label: const Text('Agregar insumo'),
      ),
      const SizedBox(height: 12),
      if (lineas.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text('Aún no has agregado insumos.',
              style: TextStyle(color: m.textoSuave)),
        )
      else
        ...lineas.asMap().entries.map((e) {
          final l = e.value;
          return Card(
            child: ListTile(
              dense: true,
              title: Text(l.insumo.nombre,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                  '${l.cantidad.toStringAsFixed(0)} ${l.insumo.unidad}  ·  ${pesos(l.total)}'),
              trailing: IconButton(
                icon: Icon(Icons.delete_outline, color: m.rojo),
                onPressed: () => setState(() => lineas.removeAt(e.key)),
              ),
            ),
          );
        }),
      const SizedBox(height: 12),
      TextField(
        controller: compraDescCtrl,
        decoration: const InputDecoration(
          labelText: 'Descripción (opcional)',
          hintText: 'Ej: compra en la plaza',
        ),
      ),
      const SizedBox(height: 16),
      Card(
        color: m.verde.withValues(alpha: 0.06),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total del gasto', style: TextStyle(color: m.textoSuave)),
              Text(pesos(total),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: m.texto)),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      ElevatedButton(
          onPressed: _guardarCompra,
          child: const Text('Guardar compra y reponer stock')),
    ];
  }
}