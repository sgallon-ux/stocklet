import 'package:flutter/material.dart';
import '../../tema.dart';

class TarjetaResumen extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;
  final Color color;
  final VoidCallback? onTap; // si se pasa, la tarjeta funciona como botón

  const TarjetaResumen({
    super.key,
    required this.titulo,
    required this.valor,
    required this.icono,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final contenido = Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icono, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(titulo,
              style: const TextStyle(fontSize: 12, color: AppColores.textoSuave)),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              valor,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ],
      ),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? contenido
          : InkWell(onTap: onTap, child: contenido),
    );
  }
}