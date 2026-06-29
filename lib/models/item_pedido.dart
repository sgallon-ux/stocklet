class ItemPedido {
  String nombre;
  int cantidad;
  double precioUnitario;
  double costoUnitario;

  ItemPedido({
    required this.nombre,
    required this.cantidad,
    required this.precioUnitario,
    required this.costoUnitario,
  });

  double get precioTotal => precioUnitario * cantidad;
  double get costoTotal => costoUnitario * cantidad;

  Map<String, dynamic> toMap() => {
        'nombre': nombre,
        'cantidad': cantidad,
        'precioUnitario': precioUnitario,
        'costoUnitario': costoUnitario,
      };

  factory ItemPedido.fromMap(Map<String, dynamic> map) => ItemPedido(
        nombre: map['nombre'] as String,
        cantidad: (map['cantidad'] as num).toInt(),
        precioUnitario: (map['precioUnitario'] as num).toDouble(),
        costoUnitario: (map['costoUnitario'] as num).toDouble(),
      );
}