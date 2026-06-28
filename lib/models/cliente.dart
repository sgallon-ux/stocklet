class Cliente {
  String nombre;
  String telefono;

  Cliente({required this.nombre, required this.telefono});

  Map<String, dynamic> toMap() {
    return {'nombre': nombre, 'telefono': telefono};
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      nombre: map['nombre'] as String,
      telefono: map['telefono'] as String,
    );
  }
}