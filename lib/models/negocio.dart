class Negocio {
  String id;
  String nombre;
  String pais;       // "CO", "MX", "AR"...
  String moneda;     // "COP", "MXN", "USD"...
  String idioma;     // "es", "en"...
  String duenoUid;   // quién lo creó
  String nit;
  String correo;
  String tel;
  String ubicacion;
  String logoUrl;

  Negocio({
    required this.id,
    required this.nombre,
    required this.pais,
    required this.moneda,
    required this.idioma,
    required this.duenoUid,
    this.nit = '',
    this.correo = '',
    this.tel = '',
    this.ubicacion = '',
    this.logoUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'pais': pais,
      'moneda': moneda,
      'idioma': idioma,
      'duenoUid': duenoUid,
      'nit': nit,
      'correo': correo,
      'tel': tel,
      'ubicacion': ubicacion,
      'logoUrl': logoUrl,
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
      nit: (map['nit'] as String?) ?? '',
      correo: (map['correo'] as String?) ?? '',
      tel: (map['tel'] as String?) ?? '',
      ubicacion: (map['ubicacion'] as String?) ?? '',
      logoUrl: (map['logoUrl'] as String?) ?? '',
    );
  }
}