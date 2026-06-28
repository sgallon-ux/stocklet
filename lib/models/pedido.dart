import 'package:cloud_firestore/cloud_firestore.dart';
import 'cliente.dart';

class Pedido {
  String id;
  Cliente cliente;
  String descripcion;
  DateTime fechaPedido;
  DateTime fechaEntrega;
  double precio;
  double costo;
  bool entregado;

  Pedido({
    String? id,
    required this.cliente,
    required this.descripcion,
    required this.fechaPedido,
    required this.fechaEntrega,
    required this.precio,
    required this.costo,
    this.entregado = false,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  double get ganancia => precio - costo;

  Map<String, dynamic> toMap() {
    return {
      'cliente': cliente.toMap(), // un mapa dentro del mapa
      'descripcion': descripcion,
      'fechaPedido': fechaPedido,
      'fechaEntrega': fechaEntrega,
      'precio': precio,
      'costo': costo,
      'entregado': entregado,
    };
  }

  factory Pedido.fromMap(String id, Map<String, dynamic> map) {
    return Pedido(
      id: id,
      cliente: Cliente.fromMap(map['cliente'] as Map<String, dynamic>),
      descripcion: map['descripcion'] as String,
      fechaPedido: (map['fechaPedido'] as Timestamp).toDate(),
      fechaEntrega: (map['fechaEntrega'] as Timestamp).toDate(),
      precio: (map['precio'] as num).toDouble(),
      costo: (map['costo'] as num).toDouble(),
      entregado: map['entregado'] as bool,
    );
  }
}