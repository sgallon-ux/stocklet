import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../pantallas/notificaciones.dart';

// Claves globales para navegar y mostrar avisos desde fuera del árbol de widgets
// (por ejemplo, cuando llega una notificación push).
final navigatorKey = GlobalKey<NavigatorState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

// Servicio de notificaciones push (FCM). La campana en el inicio sigue igual;
// esto solo recibe las push y, al tocarlas, abre la pantalla de notificaciones.
class PushService {
  PushService._();
  static final PushService instance = PushService._();

  final _fm = FirebaseMessaging.instance;

  Future<void> init() async {
    try {
      await _fm.requestPermission();
      await _fm.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true);

      // App abierta al tocar una push estando en segundo plano.
      FirebaseMessaging.onMessageOpenedApp
          .listen((_) => _abrirNotificaciones());

      // App abierta desde cerrada al tocar una push.
      final inicial = await _fm.getInitialMessage();
      if (inicial != null) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _abrirNotificaciones());
      }

      // Push en primer plano: mostramos un aviso con acción "Ver".
      FirebaseMessaging.onMessage.listen(_enPrimerPlano);

      // Si el token cambia, lo volvemos a guardar.
      _fm.onTokenRefresh.listen((token) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) _guardar(uid, token);
      });
    } catch (_) {
      // En web sin configuración de push, o si el usuario niega permisos,
      // no queremos que la app falle al arrancar.
    }
  }

  void _enPrimerPlano(RemoteMessage m) {
    final n = m.notification;
    if (n == null) return;
    final ctx = navigatorKey.currentContext;
    final etiquetaVer =
        ctx != null ? (AppLocalizations.of(ctx)?.ver ?? 'Ver') : 'Ver';
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(n.title ?? n.body ?? ''),
        action: SnackBarAction(
          label: etiquetaVer,
          onPressed: _abrirNotificaciones,
        ),
      ),
    );
  }

  void _abrirNotificaciones() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => const PantallaNotificaciones()),
    );
  }

  // Guarda el token del dispositivo en usuarios/{uid}.fcmTokens (arrayUnion).
  // Se llama cuando el usuario ya tiene negocio (su doc usuarios existe).
  Future<void> guardarToken(String uid) async {
    try {
      final token = await _fm.getToken();
      if (token != null) await _guardar(uid, token);
    } catch (_) {}
  }

  Future<void> _guardar(String uid, String token) async {
    try {
      await FirebaseFirestore.instance.collection('usuarios').doc(uid).update({
        'fcmTokens': FieldValue.arrayUnion([token]),
      });
    } catch (_) {
      // El doc puede no existir todavía; se guardará al entrar a un negocio.
    }
  }
}
