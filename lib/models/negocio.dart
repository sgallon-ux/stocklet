class GastoFijo {
  String nombre;
  double valor;
  GastoFijo({required this.nombre, required this.valor});

  Map<String, dynamic> toMap() => {'nombre': nombre, 'valor': valor};
  factory GastoFijo.fromMap(Map<String, dynamic> m) => GastoFijo(
        nombre: (m['nombre'] as String?) ?? '',
        valor: (m['valor'] as num?)?.toDouble() ?? 0,
      );
}

class Negocio {
  String id;
  String nombre;
  String pais; // "CO", "MX", "AR"...
  String moneda; // "COP", "MXN", "USD"...
  String idioma; // "es", "en"...
  String duenoUid; // quién lo creó
  String nit;
  String correo;
  String tel;
  String ubicacion;
  String logoUrl;

  // --- Ajustes de costeo ---
  double tarifaHora; // valor de una hora de trabajo
  double costoEnergiaHora; // costo de una hora de horno/energía
  List<GastoFijo> gastosFijos; // gastos fijos del mes
  double unidadesMes; // unidades producidas al mes (prorrateo)
  String metodoMargen; // 'venta' | 'markup'
  double margenPct; // margen general (%)
  double margenEspecialPct; // margen para la línea sin azúcar (%)
  bool ivaAplica;
  double ivaTasa;

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
    this.tarifaHora = 0,
    this.costoEnergiaHora = 0,
    List<GastoFijo>? gastosFijos,
    this.unidadesMes = 0,
    this.metodoMargen = 'venta',
    this.margenPct = 40,
    this.margenEspecialPct = 50,
    this.ivaAplica = false,
    this.ivaTasa = 19,
  }) : gastosFijos = gastosFijos ?? [];

  double get gastosFijosMes =>
      gastosFijos.fold(0.0, (a, g) => a + g.valor);

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
      'tarifaHora': tarifaHora,
      'costoEnergiaHora': costoEnergiaHora,
      'gastosFijos': gastosFijos.map((g) => g.toMap()).toList(),
      'unidadesMes': unidadesMes,
      'metodoMargen': metodoMargen,
      'margenPct': margenPct,
      'margenEspecialPct': margenEspecialPct,
      'ivaAplica': ivaAplica,
      'ivaTasa': ivaTasa,
    };
  }

  factory Negocio.fromMap(String id, Map<String, dynamic> map) {
    final gf = <GastoFijo>[];
    if (map['gastosFijos'] is List) {
      for (final x in (map['gastosFijos'] as List)) {
        gf.add(GastoFijo.fromMap(x as Map<String, dynamic>));
      }
    }
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
      tarifaHora: (map['tarifaHora'] as num?)?.toDouble() ?? 0,
      costoEnergiaHora: (map['costoEnergiaHora'] as num?)?.toDouble() ?? 0,
      gastosFijos: gf,
      unidadesMes: (map['unidadesMes'] as num?)?.toDouble() ?? 0,
      metodoMargen: (map['metodoMargen'] as String?) ?? 'venta',
      margenPct: (map['margenPct'] as num?)?.toDouble() ?? 40,
      margenEspecialPct: (map['margenEspecialPct'] as num?)?.toDouble() ?? 50,
      ivaAplica: (map['ivaAplica'] as bool?) ?? false,
      ivaTasa: (map['ivaTasa'] as num?)?.toDouble() ?? 19,
    );
  }
}
