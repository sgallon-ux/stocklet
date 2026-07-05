import 'package:cloud_firestore/cloud_firestore.dart';

class Nota {
  String id;
  String asunto;
  String contenido;
  DateTime fecha;
  String autorNombre;
  String autorUid;

  Nota({
    String? id,
    required this.asunto,
    required this.contenido,
    required this.fecha,
    this.autorNombre = '',
    this.autorUid = '',
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  Map<String, dynamic> toMap() {
    return {
      'asunto': asunto,
      'contenido': contenido,
      'fecha': Timestamp.fromDate(fecha),
      'autorNombre': autorNombre,
      'autorUid': autorUid,
    };
  }

  factory Nota.fromMap(String id, Map<String, dynamic> map) {
    return Nota(
      id: id,
      asunto: map['asunto'] as String,
      contenido: (map['contenido'] as String?) ?? '',
      fecha: (map['fecha'] as Timestamp).toDate(),
      autorNombre: (map['autorNombre'] as String?) ?? '',
      autorUid: (map['autorUid'] as String?) ?? '',
    );
  }
}