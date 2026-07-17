import 'package:cloud_firestore/cloud_firestore.dart';

class Venta {
  String id;
  DateTime fecha;
  String descripcion;
  double cantidad;
  double precioUnitario;
  double costoUnitario;

  Venta({
    String? id,
    required this.fecha,
    required this.descripcion,
    required this.cantidad,
    required this.precioUnitario,
    required this.costoUnitario,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  double get total => precioUnitario * cantidad;
  double get ganancia => (precioUnitario - costoUnitario) * cantidad;

  Map<String, dynamic> toMap() {
    return {
      'fecha': fecha,
      'descripcion': descripcion,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'costoUnitario': costoUnitario,
    };
  }

  factory Venta.fromMap(String id, Map<String, dynamic> map) {
    return Venta(
      id: id,
      fecha: (map['fecha'] as Timestamp).toDate(),
      descripcion: map['descripcion'] as String,
      cantidad: (map['cantidad'] as num).toDouble(),
      precioUnitario: (map['precioUnitario'] as num).toDouble(),
      costoUnitario: (map['costoUnitario'] as num).toDouble(),
    );
  }
}