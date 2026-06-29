import 'package:cloud_firestore/cloud_firestore.dart';

class Nota {
  String id;
  String asunto;
  String contenido;
  DateTime fecha;

  Nota({
    String? id,
    required this.asunto,
    required this.contenido,
    required this.fecha,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  Map<String, dynamic> toMap() {
    return {
      'asunto': asunto,
      'contenido': contenido,
      'fecha': Timestamp.fromDate(fecha),
    };
  }

  factory Nota.fromMap(String id, Map<String, dynamic> map) {
    return Nota(
      id: id,
      asunto: map['asunto'] as String,
      contenido: (map['contenido'] as String?) ?? '',
      fecha: (map['fecha'] as Timestamp).toDate(),
    );
  }
}