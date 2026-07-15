import 'dart:ui' show PlatformDispatcher;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';
import 'datos_app.dart';
import 'compuerta.dart';
import 'tema.dart';
import 'servicios/push_service.dart';
import 'servicios/suscripcion_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:country_picker/country_picker.dart';
import 'package:reposteria_app/l10n/app_localizations.dart'; // NUEVO

// Manejador de push en segundo plano (obligatorio, debe ser de nivel superior).
@pragma('vm:entry-point')
Future<void> _fcmBackgroundHandler(RemoteMessage message) async {}

// Instancia global de Analytics (usada por el observador de navegación).
final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Crashlytics: captura errores de Flutter y errores asíncronos no atrapados.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
  await PushService.instance.init();
  await SuscripcionService.instance.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => DatosApp(),
      child: const MiApp(),
    ),
  );
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final acentoId = context.select<DatosApp, String>((d) => d.acentoId);
    final modoTemaId = context.select<DatosApp, String>((d) => d.modoTemaId);
    // NUEVO: idioma elegido por el usuario (null = seguir el del dispositivo)
    final idiomaId = context.select<DatosApp, String?>((d) => d.idiomaId);
    final acento = colorDeAcento(acentoId);
    final modo = switch (modoTemaId) {
      'oscuro' => ThemeMode.dark,
      'auto' => ThemeMode.system,
      _ => ThemeMode.light,
    };

    return MaterialApp(
      title: 'Stocklet',
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      // Analytics: registra automáticamente las pantallas visitadas.
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      theme: temaApp(acento: acento),
      darkTheme: temaOscuro(acento: acento),
      themeMode: modo,
      // NUEVO: si idiomaId es null, Flutter usa el idioma del dispositivo.
      locale: idiomaId == null ? null : Locale(idiomaId),
      localizationsDelegates: const [
        AppLocalizations.delegate, // NUEVO
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // NUEVO: idiomas soportados. Para agregar otro en el futuro solo
      // creas su .arb (ej. app_de.arb) y añades aquí su Locale.
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('pt'),
        Locale('fr'),
      ],
      home: const Compuerta(),
    );
  }
}
