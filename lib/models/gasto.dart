import 'package:cloud_firestore/cloud_firestore.dart';

enum CategoriaGasto { insumos, servicios, empaques, otros }

class Gasto {
  String id;
  DateTime fecha;
  String descripcion;
  CategoriaGasto categoria;
  double monto;

  Gasto({
    String? id,
    required this.fecha,
    required this.descripcion,
    required this.categoria,
    required this.monto,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  Map<String, dynamic> toMap() {
    return {
      'fecha': fecha,
      'descripcion': descripcion,
      'categoria': categoria.name, // el enum se guarda como texto
      'monto': monto,
    };
  }

  factory Gasto.fromMap(String id, Map<String, dynamic> map) {
    return Gasto(
      id: id,
      fecha: (map['fecha'] as Timestamp).toDate(),
      descripcion: map['descripcion'] as String,
      categoria: CategoriaGasto.values.firstWhere(
        (c) => c.name == map['categoria'],
        orElse: () => CategoriaGasto.otros,
      ),
      monto: (map['monto'] as num).toDouble(),
    );
  }
}