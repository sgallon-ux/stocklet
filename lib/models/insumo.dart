class Insumo {
  String id;
  String nombre;
  String unidad;
  double costoPorUnidad;
  double stockActual;
  double stockMinimo;

  Insumo({
    String? id,
    required this.nombre,
    required this.unidad,
    required this.costoPorUnidad,
    required this.stockActual,
    this.stockMinimo = 0,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  // ¿Está por debajo de su mínimo? (0 = sin mínimo, no avisa)
  bool get bajoMinimo => stockMinimo > 0 && stockActual < stockMinimo;

  // objeto -> Map (para GUARDAR en Firestore)
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'unidad': unidad,
      'costoPorUnidad': costoPorUnidad,
      'stockActual': stockActual,
      'stockMinimo': stockMinimo,
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
      stockMinimo: (map['stockMinimo'] as num?)?.toDouble() ?? 0,
    );
  }
}