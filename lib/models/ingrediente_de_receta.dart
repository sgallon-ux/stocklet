import 'insumo.dart';

class IngredienteDeReceta {
  Insumo insumo;
  double cantidad;

  IngredienteDeReceta({required this.insumo, required this.cantidad});

  double get costo => insumo.costoPorUnidad * cantidad;

  // guarda solo el id del insumo, no el insumo entero
  Map<String, dynamic> toMap() {
    return {'insumoId': insumo.id, 'cantidad': cantidad};
  }
}