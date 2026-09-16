# Stocklet Constitution

## Core Principles

### I. Dominio en español, interfaz siempre traducida

El vocabulario del dominio (insumo, producto, receta, costeo, venta, gasto, pedido,
cotización, negocio) es la fuente de verdad y se escribe en español: nombres de clases,
campos, archivos, carpetas y claves de Firestore MUST mantener ese idioma, aunque el
código Flutter que los rodea esté en inglés.

Ningún texto visible por la persona usuaria puede escribirse literal en el código: MUST
obtenerse vía `AppLocalizations` y declararse en los cuatro ARB (`app_es`, `app_en`,
`app_pt`, `app_fr`). Una clave nueva MUST añadirse a los cuatro archivos en el mismo
cambio; dejar una traducción sin poner rompe el idioma en producción, no solo el build.
Tras tocar cualquier ARB MUST ejecutarse `flutter gen-l10n`.

Razón: el producto se vende en cuatro idiomas pero se piensa y se mantiene en español;
mezclar ambos planos es lo que produce cadenas sueltas sin traducir y modelos con
nombres inconsistentes.

### II. Aislamiento por negocio y roles (NO NEGOCIABLE)

Stocklet es multiempresa. Toda lectura y escritura de datos de negocio MUST estar
acotada a `negocios/{negocioId}` del negocio activo; queda prohibido consultar
colecciones de negocio a nivel raíz o derivar el `negocioId` de algo que no sea la
sesión vigente en `DatosApp`.

Los roles `dueno`, `socio` y `empleado` definen qué se puede hacer. Ocultar un botón en
la UI NO es control de acceso: toda acción restringida MUST validarse también del lado
servidor (reglas de Firestore o Cloud Function). Un cambio que amplíe lo que puede hacer
un rol MUST revisar ambos lados en el mismo cambio.

El acceso a funciones Pro MUST pasar por `exigirPro(context)`
(`lib/servicios/gate_pro.dart`); no se permiten comprobaciones ad-hoc de `esPro`
dispersas por las pantallas.

Razón: una fuga entre negocios o una escalada de rol expone datos contables de terceros.
Es el único fallo de esta app que no admite parche posterior.

### III. Estado y persistencia centralizados en DatosApp

Las pantallas (`lib/pantallas/`) MUST leer y mutar el estado a través de `DatosApp`
(Provider) o de un servicio de `lib/servicios/`. Está prohibido que una pantalla
instancie `FirebaseFirestore`, `FirebaseStorage`, `FirebaseAuth` o `FirebaseFunctions`
directamente.

Los modelos de `lib/models/` MUST conservar su propia serialización (`fromMap`/`toMap`)
y ser el único lugar donde se conoce la forma del documento en Firestore. La lógica
derivada (costeo, márgenes, resúmenes, tendencias) vive en `lib/costeo.dart` y en
`DatosApp`, no dentro de los `build()`.

Las pantallas SHOULD limitarse a presentación; cuando una pantalla necesita lógica nueva
no trivial, esa lógica MUST ubicarse en el modelo, el servicio o `DatosApp` que le
corresponda.

Razón: con 91 archivos Dart y sin capa de repositorio, `DatosApp` es la única frontera
que impide que cada pantalla invente su propio contrato con Firestore.

### IV. Dinero, cantidades y costeo pasan por los helpers

Todo importe mostrado MUST formatearse con los helpers de `lib/formato.dart`, respetando
la moneda y el locale configurados por el negocio; queda prohibido `toStringAsFixed`,
concatenar símbolos de moneda a mano o asumir separadores decimales.

Las conversiones entre unidades MUST usar `lib/unidades.dart`, y los cálculos de costo,
margen y precio sugerido MUST usar `lib/costeo.dart`. Las cantidades de insumos y recetas
admiten decimales y MUST tratarse como `double`, nunca como enteros.

Cualquier regla de cálculo nueva MUST añadirse a estos módulos y reutilizarse, en lugar
de duplicarse en la pantalla que la necesitó primero.

Razón: la app es una herramienta contable multi-moneda; un redondeo inconsistente entre
dos pantallas destruye la confianza en todos los números que muestra.

### V. Verificación manual antes de entregar (NO NEGOCIABLE)

Este proyecto no tiene CI ni suite de pruebas automatizada, así que la puerta de calidad
es explícita y manual. Antes de dar por terminado cualquier cambio:

- `flutter analyze` MUST terminar sin errores ni advertencias nuevas.
- Si se tocaron archivos ARB, `flutter gen-l10n` MUST ejecutarse y el resultado compilar.
- El flujo afectado MUST ejecutarse al menos una vez en la app real (`flutter run`);
  "compila" no cuenta como verificado.
- Un cambio que toque permisos, roles, cobros o datos de negocio MUST probarse además con
  un rol distinto de `dueno`.

Lo que quede sin verificar MUST reportarse en lugar de declarar el trabajo terminado.
Cuando se añadan pruebas automatizadas, estas SHOULD cubrir primero `costeo.dart`,
`unidades.dart` y `formato.dart`, que son lógica pura y de alto impacto.

Razón: sin red automatizada, la única protección real es que nadie entregue algo que no
ejecutó.

## Restricciones de Stack y Plataforma

- **Stack fijo**: Flutter/Dart (SDK `^3.12.2`) sobre Firebase (Auth, Firestore, Storage,
  Functions, Messaging, Analytics, Crashlytics). Estado con `provider`. Suscripciones con
  RevenueCat (`purchases_flutter`). Introducir una dependencia de peso equivalente a
  cualquiera de estas requiere enmienda de esta constitución.
- **Objetivos de despliegue**: Android (Google Play, `com.buildlark.stocklet`), iOS y
  web/PWA vía Firebase Hosting. Un cambio MUST seguir compilando para los tres; si rompe
  alguno, MUST declararse explícitamente.
- **Secretos y configuración**: `android/app/google-services.json`,
  `lib/firebase_options.dart` y `ios/Runner/GoogleService-Info.plist` no se versionan y
  MUST NOT commitearse. Ninguna clave de API va en el código fuente.
- **Cloud Functions**: `functions/` es JavaScript y se despliega aparte
  (`firebase deploy --only functions`). Un cambio que dependa de una función nueva MUST
  indicar que ese despliegue es parte de la entrega.
- **Monetización**: el modelo es freemium y puede estar inactivo (`esPro` = true). El
  código MUST funcionar correctamente con la monetización activa e inactiva.
- **Observabilidad**: los errores no controlados MUST llegar a Crashlytics. No se
  registran en logs datos personales ni contables de los negocios.

## Flujo de Desarrollo y Puertas de Calidad

- **Spec Kit**: el trabajo de funcionalidad sigue `/speckit-specify` → `/speckit-plan` →
  `/speckit-tasks` → `/speckit-implement`. Los bugs usan la extensión `bug`
  (`assess` → `fix` → `test`).
- **Rama**: el desarrollo ocurre sobre `main`. No hay proceso de pull request ni revisión
  por pares; quien mantiene el proyecto es responsable único de aplicar estas reglas
  antes de commitear.
- **Commits**: mensaje en español, describiendo el cambio funcional. Un commit MUST NOT
  mezclar una funcionalidad nueva con una refactorización amplia no relacionada.
- **Puerta previa al commit**: Principio V completo (analyze limpio, l10n regenerada si
  aplica, flujo ejecutado en la app).
- **Puerta previa a publicar**: `flutter build appbundle` para Play, y `flutter build web`
  + `firebase deploy --only hosting` para web; verificar que la versión de `pubspec.yaml`
  se incrementó.
- **Complejidad**: toda estructura nueva (servicio, capa, abstracción) MUST justificarse
  frente a la alternativa de extender `DatosApp`, los modelos o los helpers existentes.

## Governance

Esta constitución tiene precedencia sobre cualquier otra práctica, costumbre o
preferencia de estilo del proyecto. Cuando un plan, una tarea o una sugerencia de
herramienta la contradiga, prevalece la constitución.

**Enmiendas**: cualquier cambio a este documento MUST hacerse mediante
`/speckit-constitution`, MUST incluir el Sync Impact Report con el cambio de versión y
los principios afectados, y MUST registrar la nueva fecha de última enmienda. Un
principio no puede eliminarse ni debilitarse sin dejar escrito en el reporte por qué dejó
de aplicar.

**Versionado semántico de este documento**:

- MAJOR: se elimina o redefine un principio de forma incompatible con el anterior.
- MINOR: se añade un principio o una sección, o se amplía materialmente una guía.
- PATCH: aclaraciones, redacción o correcciones que no cambian el significado.

**Cumplimiento**: cada entrega MUST verificarse contra los cinco principios antes de
darse por terminada; el Principio V es la puerta explícita. Las excepciones se permiten
solo si quedan escritas en el plan de la funcionalidad, con su razón y su alcance
acotado. Una excepción repetida es señal de que la constitución debe enmendarse, no de
que la regla puede ignorarse.

Las guías operativas del día a día (comandos, puesta en marcha, stack) viven en
`README.md`; si el README y esta constitución discrepan, manda esta constitución y el
README MUST corregirse.

**Version**: 1.0.0 | **Ratified**: 2026-09-15 | **Last Amended**: 2026-09-15
