import 'package:flutter/material.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../tema.dart';
import 'inicio.dart';
import 'crear_hub.dart';
import 'reportes.dart';
import 'ajustes.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _indice = 0;

  final _pantallas = const [
    PantallaInicio(),
    CrearHub(),
    PantallaReportes(),
    PantallaAjustes(),
  ];

  @override
  Widget build(BuildContext context) {
    final m = AppColores.of(context);
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: IndexedStack(index: _indice, children: _pantallas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        backgroundColor: m.superficie,
        indicatorColor: m.verde.withValues(alpha: 0.14),
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: t.navInicio),
          NavigationDestination(
              icon: const Icon(Icons.add_box_outlined),
              selectedIcon: const Icon(Icons.add_box),
              label: t.navCrear),
          NavigationDestination(
              icon: const Icon(Icons.bar_chart_outlined),
              selectedIcon: const Icon(Icons.bar_chart),
              label: t.navReportes),
          NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: t.ajustesTitulo),
        ],
      ),
    );
  }
}
