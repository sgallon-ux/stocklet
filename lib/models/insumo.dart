class Insumo {
  String id;
  String nombre;
  String unidad;
  double costoPorUnidad;
  double stockActual;

  Insumo({
    String? id,
    required this.nombre,
    required this.unidad,
    required this.costoPorUnidad,
    required this.stockActual,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  // objeto -> Map (para GUARDAR en Firestore)
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'unidad': unidad,
      'costoPorUnidad': costoPorUnidad,
      'stockActual': stockActual,
    };
  }

  // Map -> objeto (para LEER de Firestore; lo usaremos al cargar)
  factory Insumo.fromMap(String id, Map<String, dynamic> map) {
    return Insumo(
      id: id,
      nombre: map['nombre'] as String,
      unidad: map['unidad'] as String,
      costoPorUnidad: (map['costoPorUnidad'] as num).toDouble(),
      stockActual: (map['stockActual'] as num).toDouble(),
    );
  }
}