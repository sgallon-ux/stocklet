class RecetaItem {
  final String insumoId;
  final double cantidad; // por unidad del producto
  RecetaItem({required this.insumoId, required this.cantidad});

  Map<String, dynamic> toMap() => {'insumoId': insumoId, 'cantidad': cantidad};

  factory RecetaItem.fromMap(Map<String, dynamic> map) => RecetaItem(
        insumoId: map['insumoId'] as String,
        cantidad: (map['cantidad'] as num).toDouble(),
      );
}

class ItemPedido {
  String nombre;
  double cantidad;
  double precioUnitario;
  double costoUnitario;
  List<RecetaItem> receta; // copia de la receta al momento de agregarlo

  ItemPedido({
    required this.nombre,
    required this.cantidad,
    required this.precioUnitario,
    required this.costoUnitario,
    this.receta = const [],
  });

  double get precioTotal => precioUnitario * cantidad;
  double get costoTotal => costoUnitario * cantidad;

  Map<String, dynamic> toMap() => {
        'nombre': nombre,
        'cantidad': cantidad,
        'precioUnitario': precioUnitario,
        'costoUnitario': costoUnitario,
        'receta': receta.map((r) => r.toMap()).toList(),
      };

  factory ItemPedido.fromMap(Map<String, dynamic> map) => ItemPedido(
        nombre: map['nombre'] as String,
        cantidad: (map['cantidad'] as num).toDouble(),
        precioUnitario: (map['precioUnitario'] as num).toDouble(),
        costoUnitario: (map['costoUnitario'] as num).toDouble(),
        receta: ((map['receta'] as List?) ?? [])
            .map((r) => RecetaItem.fromMap(r as Map<String, dynamic>))
            .toList(),
      );
}