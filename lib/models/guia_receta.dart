import 'package:cloud_firestore/cloud_firestore.dart';

class GuiaReceta {
  String id;
  String titulo;
  List<String> ingredientes;
  List<String> pasos;
  DateTime fecha;

  GuiaReceta({
    String? id,
    required this.titulo,
    required this.ingredientes,
    required this.pasos,
    required this.fecha,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  Map<String, dynamic> toMap() => {
        'titulo': titulo,
        'ingredientes': ingredientes,
        'pasos': pasos,
        'fecha': Timestamp.fromDate(fecha),
      };

  factory GuiaReceta.fromMap(String id, Map<String, dynamic> map) => GuiaReceta(
        id: id,
        titulo: map['titulo'] as String,
        ingredientes: ((map['ingredientes'] as List?) ?? const [])
            .map((e) => e.toString())
            .toList(),
        pasos: ((map['pasos'] as List?) ?? const [])
            .map((e) => e.toString())
            .toList(),
        fecha: (map['fecha'] as Timestamp).toDate(),
      );
}