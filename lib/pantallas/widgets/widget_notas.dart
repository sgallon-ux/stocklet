import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../datos_app.dart';
import '../../tema.dart';
import '../editor_nota.dart';
import '../ver_nota.dart';

class WidgetNotas extends StatelessWidget {
  const WidgetNotas({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatosApp>(
      builder: (context, datos, child) {
        final m = AppColores.of(context);
        final notas = [...datos.notas]
          ..sort((a, b) => b.fecha.compareTo(a.fecha));

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.push_pin_outlined, size: 20, color: m.verde),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('Notas importantes',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: m.texto)),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: m.verde),
                      tooltip: 'Nueva nota',
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PantallaEditorNota())),
                    ),
                  ],
                ),
                if (notas.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text('No tienes notas. Crea una con el +',
                          style: TextStyle(color: m.textoSuave)),
                    ),
                  )
                else
                  ...notas.map((n) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PantallaVerNota(nota: n))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Icon(Icons.sticky_note_2_outlined,
                                size: 18, color: m.textoSuave),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(n.asunto,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: m.texto,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Icon(Icons.chevron_right,
                                size: 18, color: m.textoSuave),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }
}