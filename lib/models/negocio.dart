class Negocio {
  String id;
  String nombre;
  String pais;       // "CO", "MX", "AR"...
  String moneda;     // "COP", "MXN", "USD"...
  String idioma;     // "es", "en"...
  String duenoUid;   // quién lo creó

  Negocio({
    required this.id,
    required this.nombre,
    required this.pais,
    required this.moneda,
    required this.idioma,
    required this.duenoUid,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'pais': pais,
      'moneda': moneda,
      'idioma': idioma,
      'duenoUid': duenoUid,
    };
  }

  factory Negocio.fromMap(String id, Map<String, dynamic> map) {
    return Negocio(
      id: id,
      nombre: map['nombre'] as String,
      pais: map['pais'] as String,
      moneda: map['moneda'] as String,
      idioma: map['idioma'] as String,
      duenoUid: map['duenoUid'] as String,
    );
  }
}