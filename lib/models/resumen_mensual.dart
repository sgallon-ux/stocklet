class ResumenMensual {
  final int anio;
  final int mes;
  double ingresos;
  double gastos;

  ResumenMensual(this.anio, this.mes, {this.ingresos = 0, this.gastos = 0});

  double get ganancia => ingresos - gastos;

  static const _nombres = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
  ];

  String get etiquetaCorta => '${_nombres[mes - 1]} ${anio % 100}'; // "Jun 26"
  String get etiqueta => '${_nombres[mes - 1]} $anio';              // "Jun 2026"
}