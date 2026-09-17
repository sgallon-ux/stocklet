# Data Safety de Google Play — Stocklet

Inventario de los datos que la app recoge, derivado del código (no de memoria).
Está ordenado como el formulario de Play Console para poder transcribirlo de
corrido: **Play Console → Política → Contenido de la app → Seguridad de los datos**.

> **Mantenerlo vivo.** Si un cambio hace que la app recoja un dato nuevo, esta
> tabla MUST actualizarse en el mismo cambio. Una declaración desactualizada es
> motivo de suspensión, no solo de rechazo.
>
> Última revisión: 2026-09-17, sobre la versión 1.1.0+2.

---

## Resumen para el formulario

| Pregunta de Play | Respuesta |
|---|---|
| ¿La app recoge o comparte alguno de los tipos de datos requeridos? | **Sí** |
| ¿Todos los datos están cifrados en tránsito? | **Sí** (Firebase usa TLS siempre) |
| ¿Se puede pedir la eliminación de los datos? | **Sí**, dentro de la app y por web |
| ¿Recoge el ID de publicidad? | **No** — eliminado del manifest a propósito |

**Eliminación de cuenta.** Play exige las dos vías y ambas existen:

- En la app: Ajustes → Seguridad → Eliminar cuenta (`eliminarCuenta`, Cloud Function).
- Por web: la página de borrado de cuenta en `stocklet.buildlark.com`.

Borra la cuenta de Auth, la ficha de usuario, los archivos en Storage y —si
quien la pide es el dueño— todo el árbol del negocio y a sus miembros.

---

## Datos recogidos

Ninguno se **comparte** en el sentido de Play: todo va a Firebase (Google) y
RevenueCat, que actúan como proveedores de servicio y procesan por cuenta de
BuildLark. Declarar todo como **recogido**, no como compartido.

### Información personal

| Tipo de dato | Recogido | Obligatorio | Propósito | Dónde vive |
|---|---|---|---|---|
| Dirección de correo | Sí | Obligatorio | Gestión de la cuenta, inicio de sesión, recuperar contraseña | Firebase Auth |
| Nombre | Sí | Opcional | Funcionalidad de la app: identificar a cada miembro del equipo | `usuarios/{uid}.nombre` |
| Número de teléfono | Sí | Opcional | Funcionalidad: contacto del perfil, del negocio y **de los clientes del negocio** | `usuarios.celular`, `negocios.tel`, `cliente.telefono` en pedidos y cotizaciones |
| Otra información personal | Sí | Opcional | Datos fiscales y de contacto del negocio: NIT, correo y ubicación (texto, no GPS) | `negocios.nit`, `.correo`, `.ubicacion` |

> **Ojo con el teléfono de los clientes.** La app guarda nombre y teléfono de
> los clientes del negocio (`models/cliente.dart`), que son terceros que no usan
> la app. Hay que declararlo igual, y la política de privacidad debe decir que
> el usuario es responsable de los datos de sus clientes que introduzca.

### Información financiera

| Tipo de dato | Recogido | Obligatorio | Propósito | Dónde vive |
|---|---|---|---|---|
| Historial de compras | Sí | Obligatorio (si se suscribe) | Gestionar la suscripción Pro | RevenueCat + Google Play Billing |
| Otra información financiera | Sí | Obligatorio | Funcionalidad principal: es la contabilidad del negocio — ventas, gastos, costos, precios y márgenes | `negocios/{id}/ventas`, `/gastos`, `/productos`, `/insumos` |

> Es el núcleo del producto. No se puede marcar "opcional": sin estos datos la
> app no hace nada.

### Fotos y vídeos

| Tipo de dato | Recogido | Obligatorio | Propósito | Dónde vive |
|---|---|---|---|---|
| Fotos | Sí | Opcional | Foto de perfil y logo del negocio, elegidas por el usuario | Storage: `usuarios/{uid}/foto_perfil`, `negocios/{id}/logo/imagen` |

Se usa `image_picker` sobre la galería, siempre por acción explícita del usuario.
No hay acceso a cámara ni lectura automática de la galería.

### Archivos y documentos

| Tipo de dato | Recogido | Obligatorio | Propósito | Dónde vive |
|---|---|---|---|---|
| Archivos y documentos | Sí | Opcional | Catálogos en PDF que el negocio sube para consultarlos y compartirlos | Storage: `negocios/{id}/catalogos/` |

### Actividad en la app

| Tipo de dato | Recogido | Obligatorio | Propósito | Dónde vive |
|---|---|---|---|---|
| Interacciones con la app | Sí | Obligatorio | Analítica: pantallas visitadas, registradas automáticamente | Firebase Analytics (`FirebaseAnalyticsObserver`) |
| Otro contenido generado por el usuario | Sí | Obligatorio | Funcionalidad: recetas, productos, insumos, pedidos, cotizaciones y sus notas | Subcolecciones de `negocios/{id}` |

### Información y rendimiento de la app

| Tipo de dato | Recogido | Obligatorio | Propósito | Dónde vive |
|---|---|---|---|---|
| Registros de fallos | Sí | Obligatorio | Diagnóstico de errores | Firebase Crashlytics |
| Diagnósticos | Sí | Obligatorio | Rendimiento y estabilidad | Crashlytics y Analytics |

### Identificadores de dispositivo u otros

| Tipo de dato | Recogido | Obligatorio | Propósito | Dónde vive |
|---|---|---|---|---|
| ID de dispositivo u otros | Sí | Obligatorio | Enviar notificaciones push al dispositivo correcto; identificador de instancia de Analytics | `usuarios/{uid}.fcmTokens`, Firebase Analytics |

**No es el ID de publicidad.** Se eliminó del manifest a propósito
(`com.google.android.gms.permission.AD_ID` con `tools:node="remove"`). Si algún
día se reactiva, hay que volver aquí y declararlo.

---

## Datos que la app NO recoge

Declararlo bien también importa: marcar de más levanta revisiones innecesarias.

| Categoría | Por qué no |
|---|---|
| Ubicación | No hay permisos de ubicación en el manifest. El país se elige a mano de una lista. |
| Contactos | Los clientes se escriben a mano; no se lee la agenda. |
| Mensajes | No hay mensajería. |
| Audio | No se graba. |
| Calendario | Las fechas de pedido se escriben a mano. |
| Salud y forma física | No aplica. |
| Navegación web | No aplica. |
| Datos sensibles (origen étnico, ideas políticas o religiosas, orientación sexual) | No se piden ni se infieren. |

---

## Permisos declarados y su justificación

Del manifest fusionado del `.aab` de release, versión 1.1.0+2:

| Permiso | Lo aporta | Para qué |
|---|---|---|
| `INTERNET` | Firebase | Todo el funcionamiento |
| `ACCESS_NETWORK_STATE` | Firebase | Detectar conectividad |
| `WAKE_LOCK` | Firebase Messaging | Procesar notificaciones |
| `POST_NOTIFICATIONS` | Firebase Messaging | Push en Android 13+ (se pide en runtime) |
| `com.android.vending.BILLING` | RevenueCat | Suscripción Pro |
| `com.google.android.c2dm.permission.RECEIVE` | Firebase Messaging | Recibir push |
| `READ_GSERVICES` | Google Play Services | Servicios de Google |
| `BIND_GET_INSTALL_REFERRER_SERVICE` | Firebase Analytics | Origen de la instalación |

---

## Antes de enviar el formulario

- [ ] La política de privacidad publicada en `stocklet.buildlark.com` cubre
      **todo** lo de este inventario, incluidos los datos de los clientes del
      negocio y la responsabilidad del usuario sobre ellos.
- [ ] La URL de la política está puesta en la ficha de Play.
- [ ] La URL de borrado de cuenta está puesta en la ficha de Play.
- [ ] Si la monetización sigue inactiva (`SuscripcionService.activa = false`) en
      la versión que se sube, revisar si conviene declarar ya el historial de
      compras o esperar a activarla.

> Esto es un inventario técnico derivado del código, no asesoría legal. Quien
> firme la declaración ante Google es BuildLark S.A.S.
