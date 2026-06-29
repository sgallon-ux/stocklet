import 'package:flutter/material.dart';
import '../tema.dart';

class PantallaProximamente extends StatelessWidget {
  final String titulo;
  const PantallaProximamente(this.titulo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 72,
              width: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColores.verde.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.construction,
                  color: AppColores.verde, size: 36),
            ),
            const SizedBox(height: 16),
            Text('$titulo\npróximamente',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16, color: AppColores.textoSuave)),
          ],
        ),
      ),
    );
  }
}