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

## Reglas de seguridad

Las reglas viven en el repositorio y son la única barrera real entre un negocio
y los datos de otro (la UI solo oculta botones):

- `firestore.rules` — aislamiento por negocio y permisos por rol (`dueno`,
  `socio`, `empleado`).
- `storage.rules` — fotos de perfil, logo del negocio y catálogos en PDF.

Tienen una suite que las ejerce contra el emulador. Requiere Java y una vez
`npm install` dentro de `test/rules`:

```
cd test/rules
npm test
```

Para desplegarlas (sobrescribe lo que haya en la consola de Firebase):

```
firebase deploy --only firestore:rules,storage
```

Ojo con el nombre del objetivo: `firestore:rules` existe, pero `storage:rules`
no. En Storage lo que va después de los dos puntos es un *deploy target* de
bucket, así que las reglas van con `storage` a secas.

## Documentación

El estado del proyecto, el plan de monetización y el checklist para publicar están en
`Creador Apps/Stocklet - Estado del proyecto.md`.
