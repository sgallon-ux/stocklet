import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../datos_app.dart';
import '../tema.dart';
import 'proximamente.dart';
import 'panel_usuario.dart';
import 'ajustes_seguridad.dart';

class PantallaAjustes extends StatelessWidget {
  const PantallaAjustes({super.key});

  void _confirmarCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (dc) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que quieres cerrar sesión?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(dc);
              FirebaseAuth.instance.signOut();
            },
            style: TextButton.styleFrom(foregroundColor: AppColores.rojo),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  void _acercaDe(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Dulce Nota',
      applicationVersion: '1.0.0', // Todo: ajusta a tu versión real
      applicationIcon: Container(
        height: 48,
        width: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColores.verde.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.storefront, color: AppColores.verde),
      ),
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text('App de contabilidad para tu negocio.'),
        ),
      ],
    );
  }

  void _ir(BuildContext context, Widget destino) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => destino));
  }

  Widget _opcion({
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColores.verde.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icono, color: AppColores.verde, size: 20),
      ),
      title: Text(titulo,
          style: const TextStyle(
              fontWeight: FontWeight.w600, color: AppColores.texto)),
      subtitle: Text(subtitulo,
          style: const TextStyle(fontSize: 12, color: AppColores.textoSuave)),
      trailing: const Icon(Icons.chevron_right, color: AppColores.textoSuave),
    );
  }

  @override
  Widget build(BuildContext context) {
    final negocio = context.watch<DatosApp>().negocio;

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          Center(
            child: Column(
              children: [
                Container(
                  height: 72,
                  width: 72,
                  clipBehavior: Clip.antiAlias,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColores.verde.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: (negocio?.logoUrl ?? '').isEmpty
                      ? const Icon(Icons.storefront,
                          color: AppColores.verde, size: 36)
                      : Image.network(
                          negocio!.logoUrl,
                          height: 72,
                          width: 72,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => const Icon(
                              Icons.storefront,
                              color: AppColores.verde,
                              size: 36),
                        ),
                ),
                const SizedBox(height: 12),
                Text(negocio?.nombre ?? 'Mi negocio',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColores.texto)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                _opcion(
                  icono: Icons.person_outline,
                  titulo: 'Perfil',
                  subtitulo: 'Tu información personal',
                  onTap: () => _ir(context, const PantallaPanelUsuario()),
                ),
                const Divider(height: 1),
                _opcion(
                  icono: Icons.business_outlined,
                  titulo: 'Datos de la empresa',
                  subtitulo: 'Nombre, NIT, contacto y ubicación',
                  onTap: () => _ir(context, const PantallaPanelUsuario()),
                ),
                const Divider(height: 1),
                _opcion(
                  icono: Icons.notifications_outlined,
                  titulo: 'Notificaciones',
                  subtitulo: 'Avisos de pedidos, notas e inventario',
                  onTap: () => _ir(
                      context, const PantallaProximamente('Notificaciones')),
                ),
                const Divider(height: 1),
                _opcion(
                  icono: Icons.shield_outlined,
                  titulo: 'Ajustes y seguridad',
                  subtitulo: 'País, moneda, idioma y contraseña',
                  onTap: () => _ir(context, const PantallaAjustesSeguridad()),
                ),
                const Divider(height: 1),
                _opcion(
                  icono: Icons.palette_outlined,
                  titulo: 'Apariencia',
                  subtitulo: 'Tema y modo oscuro',
                  onTap: () =>
                      _ir(context, const PantallaProximamente('Apariencia')),
                ),
                const Divider(height: 1),
                _opcion(
                  icono: Icons.info_outline,
                  titulo: 'Acerca de',
                  subtitulo: 'Versión e información de la app',
                  onTap: () => _acercaDe(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => _confirmarCerrarSesion(context),
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar sesión'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColores.rojo,
              side: const BorderSide(color: AppColores.rojo),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}