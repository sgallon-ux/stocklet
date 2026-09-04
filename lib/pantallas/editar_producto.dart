import 'package:flutter/material.dart';
import '../models/producto.dart';
import 'widgets/formulario_producto.dart';

class PantallaEditarProducto extends StatelessWidget {
  final Producto producto;
  const PantallaEditarProducto({super.key, required this.producto});

  @override
  Widget build(BuildContext context) => FormularioProducto(producto: producto);
}
