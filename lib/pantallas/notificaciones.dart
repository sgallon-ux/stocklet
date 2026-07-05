import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos_app.dart';
import '../tema.dart';
import '../formato.dart';
import 'pedidos.dart';
import 'inventario.dart';
import 'ver_nota.dart';

class PantallaNotificaciones extends StatefulWidget {
  const PantallaNotificaciones({super.key});

  @override
  State<PantallaNotificaciones> createState() => _PantallaNotificacionesState();
}

class _PantallaNotificacionesState extends State<PantallaNotificaciones> {
  @override
  void initState() {
    super.initState();
    // Al abrir, las notas quedan "vistas" (pedidos e insumos siguen).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DatosApp>().marcarNotasRevisadas();
    });
  }

  static int _diasHasta(DateTime f) {
    final hoy = DateTime.now();
    final a = DateTime(hoy.year, hoy.month, hoy.day);
    final b = DateTime(f.year, f.month, f.day);
    return b.difference(a).inDays;
  }

  static String _urgencia(DateTime f) {
    final d = _diasHasta(f);
    if (d < 0) return 'Atrasado';
    if (d == 0) return 'Entrega hoy';
    if (d == 1) return 'Entrega mañana';
    return 'En $d días';
  }

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<DatosApp>();
    final pedidos = datos.avisosPedidos;
    final insumos = datos.avisosInsumos;
    final notas = datos.avisosNotas;
    final vacio = pedidos.isEmpty && insumos.isEmpty && notas.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: vacio
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('No tienes avisos por ahora. ¡Todo al día!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColores.textoSuave)),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (pedidos.isNotEmpty) ...[
                  _titulo('Pedidos próximos'),
                  ...pedidos.map((p) {
                    final atrasado = _diasHasta(p.fechaEntrega) < 0;
                    return _aviso(
                      icono: Icons.receipt_long_outlined,
                      color: atrasado ? AppColores.rojo : const Color(0xFFE08600),
                      titulo: '${p.cliente.nombre} — ${p.descripcion}',
                      detalle:
                          '${_urgencia(p.fechaEntrega)}  ·  ${pesos(p.precio)}',
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const PantallaPedidos())),
                    );
                  }),
                  const SizedBox(height: 8),
                ],
                if (insumos.isNotEmpty) ...[
                  _titulo('Inventario bajo'),
                  ...insumos.map((i) => _aviso(
                        icono: Icons.inventory_2_outlined,
                        color: AppColores.rojo,
                        titulo: i.nombre,
                        detalle:
                            'Quedan ${i.stockActual.toStringAsFixed(0)} ${i.unidad} (mínimo ${i.stockMinimo.toStringAsFixed(0)})',
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const PantallaInventario())),
                      )),
                  const SizedBox(height: 8),
                ],
                if (notas.isNotEmpty) ...[
                  _titulo('Notas nuevas'),
                  ...notas.map((n) => _aviso(
                        icono: Icons.sticky_note_2_outlined,
                        color: AppColores.verde,
                        titulo: n.asunto,
                        detalle: n.autorNombre.isEmpty
                            ? 'Nueva nota'
                            : 'Por ${n.autorNombre}',
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => PantallaVerNota(nota: n))),
                      )),
                ],
              ],
            ),
    );
  }

  Widget _titulo(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: Text(t,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColores.texto)),
      );

  Widget _aviso({
    required IconData icono,
    required Color color,
    required String titulo,
    required String detalle,
    required VoidCallback onTap,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: Container(
          height: 40,
          width: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icono, color: color, size: 20),
        ),
        title: Text(titulo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: AppColores.texto)),
        subtitle: Text(detalle,
            maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right, color: AppColores.textoSuave),
      ),
    );
  }
}