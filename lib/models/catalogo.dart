import 'package:cloud_firestore/cloud_firestore.dart';

class Catalogo {
  String id;
  String nombre;
  String url;  // enlace de descarga para abrir el PDF
  String path; // ruta en Storage, para poder borrarlo
  DateTime fecha;

  Catalogo({
    required this.id,
    required this.nombre,
    required this.url,
    required this.path,
    required this.fecha,
  });

  Map<String, dynamic> toMap() => {
        'nombre': nombre,
        'url': url,
        'path': path,
        'fecha': Timestamp.fromDate(fecha),
      };

  factory Catalogo.fromMap(String id, Map<String, dynamic> map) => Catalogo(
        id: id,
        nombre: map['nombre'] as String,
        url: map['url'] as String,
        path: (map['path'] as String?) ?? '',
        fecha: (map['fecha'] as Timestamp).toDate(),
      );
}