import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'datos_app.dart';
import 'pantallas/login.dart';
import 'pantallas/inicio.dart';
import 'pantallas/crear_negocio.dart';

class Compuerta extends StatelessWidget {
  const Compuerta({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<DatosApp>().estado;
    switch (estado) {
      case EstadoApp.cargando:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case EstadoApp.sinSesion:
        return const PantallaLogin();
      case EstadoApp.sinNegocio:
        return const PantallaCrearNegocio();
      case EstadoApp.listo:
        return const PantallaInicio();
    }
  }
}