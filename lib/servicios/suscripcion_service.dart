import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Capa de suscripción sobre RevenueCat.
///
/// Interruptor maestro [activa]:
///  - `false` (por ahora): NO se inicializa RevenueCat y [esPro] queda en `true`
///    → todo desbloqueado; la app funciona igual que hoy. Úsalo hasta tener la
///    cuenta de Google Play + los productos + la clave de RevenueCat.
///  - `true`: se configura RevenueCat y [esPro] refleja el permiso "pro" real.
class SuscripcionService {
  SuscripcionService._();
  static final SuscripcionService instance = SuscripcionService._();

  /// Cámbialo a `true` cuando RevenueCat y los productos de Play estén listos.
  static const bool activa = false;

  /// Claves PÚBLICAS de RevenueCat (Project settings → API keys). Reemplázalas.
  static const String _apiKeyAndroid = 'REEMPLAZAR_REVENUECAT_ANDROID_KEY';
  static const String _apiKeyIos = 'REEMPLAZAR_REVENUECAT_IOS_KEY';

  /// Identificador del "entitlement" (permiso Pro) configurado en RevenueCat.
  static const String entitlementPro = 'pro';

  /// `true` = el usuario tiene Pro (o la monetización está inactiva).
  final ValueNotifier<bool> esPro = ValueNotifier<bool>(true);

  Future<void> init() async {
    if (!activa) {
      esPro.value = true; // sin monetización, todo desbloqueado
      return;
    }
    try {
      final apiKey = defaultTargetPlatform == TargetPlatform.iOS
          ? _apiKeyIos
          : _apiKeyAndroid;
      await Purchases.configure(PurchasesConfiguration(apiKey));
      await _refrescar();
      Purchases.addCustomerInfoUpdateListener((info) {
        esPro.value = info.entitlements.active.containsKey(entitlementPro);
      });
    } catch (_) {
      esPro.value = false;
    }
  }

  /// Vincula la suscripción al usuario de Firebase.
  ///
  /// Sin esto RevenueCat asigna un ID anónimo por instalación, y quien
  /// reinstale o entre desde otro dispositivo no recupera su Pro salvo que use
  /// "Restaurar compras" a mano. Al identificar, RevenueCat conserva las
  /// compras hechas antes de iniciar sesión (las asocia al uid).
  Future<void> identificar(String uid) async {
    if (!activa || uid.isEmpty) return;
    try {
      final res = await Purchases.logIn(uid);
      esPro.value =
          res.customerInfo.entitlements.active.containsKey(entitlementPro);
    } catch (_) {
      // Si falla, se queda con lo que hubiera; restaurar() sigue disponible.
    }
  }

  /// Desvincula al cerrar sesión, para que quien entre después en este mismo
  /// dispositivo no herede el estado Pro del anterior.
  Future<void> cerrarSesion() async {
    if (!activa) return;
    try {
      final info = await Purchases.logOut();
      esPro.value = info.entitlements.active.containsKey(entitlementPro);
    } catch (_) {
      // logOut lanza si el usuario ya era anónimo. Sea ese caso o un fallo de
      // red, lo prudente es no dejar Pro activo para el siguiente usuario.
      esPro.value = false;
    }
  }

  Future<void> _refrescar() async {
    try {
      final info = await Purchases.getCustomerInfo();
      esPro.value = info.entitlements.active.containsKey(entitlementPro);
    } catch (_) {}
  }

  /// Paquetes disponibles (mensual, anual...) para mostrar en el paywall.
  Future<List<Package>> paquetes() async {
    if (!activa) return [];
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current?.availablePackages ?? [];
    } catch (_) {
      return [];
    }
  }

  /// Compra un paquete. Devuelve `null` si todo bien, o 'cancelado' | 'error'.
  Future<String?> comprar(Package paquete) async {
    if (!activa) return 'inactiva';
    try {
      // ignore: deprecated_member_use
      final result = await Purchases.purchasePackage(paquete);
      esPro.value =
          result.customerInfo.entitlements.active.containsKey(entitlementPro);
      return null;
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) return 'cancelado';
      return 'error';
    } catch (_) {
      return 'error';
    }
  }

  /// Restaura compras previas (obligatorio ofrecerlo en las tiendas).
  Future<void> restaurar() async {
    if (!activa) return;
    try {
      final info = await Purchases.restorePurchases();
      esPro.value = info.entitlements.active.containsKey(entitlementPro);
    } catch (_) {}
  }
}
