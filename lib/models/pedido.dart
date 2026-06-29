import 'package:cloud_firestore/cloud_firestore.dart';
import 'cliente.dart';
import 'item_pedido.dart';

class Pedido {
  String id;
  Cliente cliente;
  String descripcion;
  DateTime fechaPedido;
  DateTime fechaEntrega;
  double precio;
  double costo;
  bool entregado;
  bool archivado;
  List<ItemPedido> items;
  double otroValor;

  Pedido({
    String? id,
    required this.cliente,
    required this.descripcion,
    required this.fechaPedido,
    required this.fechaEntrega,
    required this.precio,
    required this.costo,
    this.entregado = false,
    this.archivado = false,
    this.items = const [],
    this.otroValor = 0,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  double get ganancia => precio - costo;

  Map<String, dynamic> toMap() {
    return {
      'cliente': cliente.toMap(),
      'descripcion': descripcion,
      'fechaPedido': fechaPedido,
      'fechaEntrega': fechaEntrega,
      'precio': precio,
      'costo': costo,
      'entregado': entregado,
      'archivado': archivado,
      'items': items.map((i) => i.toMap()).toList(),
      'otroValor': otroValor,
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
      archivado: (map['archivado'] as bool?) ?? false,
      items: ((map['items'] as List?) ?? const [])
          .map((i) => ItemPedido.fromMap(i as Map<String, dynamic>))
          .toList(),
      otroValor: (map['otroValor'] as num?)?.toDouble() ?? 0,
    );
  }
}