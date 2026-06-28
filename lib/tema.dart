import 'package:flutter/material.dart';

// --- Tokens de diseño: los colores de la marca, en un solo lugar ---
class AppColores {
  static const Color verde = Color(0xFF0E9F6E);       // verde esmeralda principal
  static const Color verdeOscuro = Color(0xFF0A7D55);
  static const Color fondo = Color(0xFFF5F7F8);        // fondo claro de las pantallas
  static const Color superficie = Colors.white;        // tarjetas y barras
  static const Color texto = Color(0xFF1B2733);        // azul muy oscuro (títulos)
  static const Color textoSuave = Color(0xFF6B7785);   // gris (subtítulos)
  static const Color rojo = Color(0xFFE2483D);
  static const Color borde = Color(0x14000000);        // negro al 8% (bordes sutiles)
}

ThemeData temaApp() {
  final esquema = ColorScheme.fromSeed(
    seedColor: AppColores.verde,
    primary: AppColores.verde,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: esquema,
    scaffoldBackgroundColor: AppColores.fondo,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColores.superficie,
      foregroundColor: AppColores.texto,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColores.texto,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColores.superficie,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColores.borde),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColores.superficie,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColores.borde),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColores.borde),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColores.verde, width: 2),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColores.verde,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColores.verde,
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: AppColores.verde),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColores.verde),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColores.verde,
      foregroundColor: Colors.white,
    ),
  );
}