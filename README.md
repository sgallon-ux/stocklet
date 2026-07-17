# Stocklet

App de gestión para microempresas (ventas, inventario, gastos, pedidos, notas y equipo con roles), hecha en **Flutter + Firebase**. Multiempresa y multi-idioma (es/en/pt/fr).

Publicada por **BuildLark S.A.S.** · Package: `com.buildlark.stocklet`

> Nota: el nombre interno del paquete Dart sigue siendo `reposteria_app` (histórico, no afecta a los usuarios).

## Stack

- **Flutter / Dart** (Android, iOS, web/PWA).
- **Firebase**: Auth, Firestore, Storage, Cloud Functions, Cloud Messaging, Analytics, Crashlytics.
- **RevenueCat** (`purchases_flutter`) para suscripciones (freemium; inactivo hasta configurar la cuenta de Play).
- i18n con ARB + `gen-l10n`.

## Puesta en marcha

```
flutter pub get
flutter gen-l10n
flutter run
```

Requiere los archivos de configuración de Firebase (no versionados): `android/app/google-services.json`, `lib/firebase_options.dart`, y para iOS `ios/Runner/GoogleService-Info.plist`.

## Comandos frecuentes

```
flutter analyze
flutter build appbundle              # .aab para Google Play
firebase deploy --only functions     # Cloud Functions
firebase deploy --only hosting       # web/ (tras flutter build web)
```

## Documentación

El estado del proyecto, el plan de monetización y el checklist para publicar están en
`Creador Apps/Stocklet - Estado del proyecto.md`.
