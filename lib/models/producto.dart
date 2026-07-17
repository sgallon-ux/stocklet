import 'ingrediente_de_receta.dart';
import 'insumo.dart';

// La lista de tipos. Para agregar uno nuevo, solo añádelo aquí.
const List<String> tiposDeProducto = [
  'Tortas',
  'Alfajores',
  'Brownies',
  'New York Cookies',
  'Otro',
];

class Producto {
  String id;
  String nombre;
  String tipo;
  List<IngredienteDeReceta> receta;
  double precioVenta;

  Producto({
    String? id,
    required this.nombre,
    this.tipo = 'Otro',
    required this.receta,
    required this.precioVenta,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  double costoProduccion() {
    double total = 0;
    for (IngredienteDeReceta ing in receta) {
      total += ing.costo;
    }
    return total;
  }

  double get ganancia => precioVenta - costoProduccion();
  double get margen => ganancia / precioVenta;

  void descontarStock(double cantidad) {
    for (IngredienteDeReceta ing in receta) {
      ing.insumo.stockActual -= ing.cantidad * cantidad;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'tipo': tipo,
      'precioVenta': precioVenta,
      'receta': receta.map((ing) => ing.toMap()).toList(),
    };
  }

  factory Producto.fromMap(
    String id,
    Map<String, dynamic> map,
    List<Insumo> insumosDisponibles,
  ) {
    final listaReceta = <IngredienteDeReceta>[];
    for (final item in (map['receta'] as List)) {
      final ingMap = item as Map<String, dynamic>;
      Insumo? insumo;
      for (final ins in insumosDisponibles) {
        if (ins.id == ingMap['insumoId']) {
          insumo = ins;
          break;
        }
      }
      if (insumo == null) continue;
      listaReceta.add(IngredienteDeReceta(
        insumo: insumo,
        cantidad: (ingMap['cantidad'] as num).toDouble(),
      ));
    }

    return Producto(
      id: id,
      nombre: map['nombre'] as String,
      tipo: map['tipo'] as String? ?? 'Otro', // productos viejos no traen tipo
      precioVenta: (map['precioVenta'] as num).toDouble(),
      receta: listaReceta,
    );
  }
}