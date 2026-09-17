# Implementation Plan: Convertir una cotización aceptada en pedido

**Branch**: `001-cotizacion-a-pedido` | **Date**: 2026-09-17 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/001-cotizacion-a-pedido/spec.md`

## Summary

Una cotización aceptada genera su pedido sin volver a capturar nada: solo se
piden teléfono y fecha de entrega, que es lo único que el pedido exige y la
cotización no guarda.

El enfoque técnico es deliberadamente pequeño. La regla de conversión vive en
un constructor puro `Pedido.desdeCotizacion`, probable sin emulador ni
Firebase. `DatosApp` se limita a orquestar —construir, registrar el pedido,
enlazar la cotización— reutilizando `registrarPedido` y `guardarCotizacion`,
que ya existen. Las pantallas solo presentan. No hay servicios nuevos, ni
archivos nuevos en `lib/`, ni cambios en las reglas de seguridad.

El punto delicado es el inventario, y se resuelve por omisión: convertir **no
descuenta nada**. El descuento sigue ocurriendo en `marcarPedidoEntregado`,
que además pasa a compartir con el aviso previo una única función de cálculo,
para que el aviso no pueda discrepar de lo que realmente se descontará.

## Technical Context

**Language/Version**: Dart / Flutter 3.44.2 (SDK `^3.12.2`)

**Primary Dependencies**: `provider` (estado), `cloud_firestore` (persistencia),
`intl` (formato). Ninguna dependencia nueva.

**Storage**: Firestore, bajo `negocios/{negocioId}/cotizaciones`, `/pedidos` e
`/insumos`. Un campo nuevo (`pedidoId` en la cotización), sin migración.

**Testing**: `flutter test` para la lógica pura. La suite de `test/rules` no
aplica: no se tocan reglas ni roles.

**Target Platform**: Android, iOS y web/PWA. La funcionalidad es de UI y
lógica local; no introduce nada específico de plataforma.

**Project Type**: aplicación móvil multiplataforma en Flutter, con backend
gestionado (Firebase).

**Performance Goals**: la conversión opera sobre datos ya en memoria
(`DatosApp.productos`, `.insumos`); es instantánea. Dos escrituras a Firestore,
el mismo coste que crear un pedido a mano.

**Constraints**:
- El total del pedido MUST ser exactamente el de la cotización.
- La conversión MUST NOT alterar el inventario.
- Una cotización MUST NOT generar dos pedidos.

**Scale/Scope**: decenas de cotizaciones por negocio. Dos pantallas tocadas
(`editar_cotizacion`, `cotizar`), un diálogo nuevo, dos modelos y `DatosApp`.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Contra la constitución v1.1.0:

| Principio | Cómo se cumple | Estado |
|---|---|---|
| **I. Dominio en español, interfaz traducida** | Nombres en español (`desdeCotizacion`, `consumoDeInsumos`, `faltantesDeInventario`, `pedidoId`). Todas las cadenas nuevas entran en los cuatro ARB en el mismo cambio, con `gen-l10n`. El modelo recibe el texto de respaldo como parámetro para no conocer `AppLocalizations`. | PASA |
| **II. Aislamiento por negocio y roles** | Ambas escrituras van por `_col(...)`, acotado al negocio activo. No se amplía lo que puede hacer ningún rol: convertir = crear pedido + actualizar cotización, que las reglas ya permiten a cualquier miembro. Sin cambios en reglas (D6). | PASA |
| **III. Estado y persistencia en DatosApp** | La regla vive en el modelo; la persistencia en `DatosApp`; las pantallas solo presentan. Ninguna pantalla instancia Firestore. No se crea estructura nueva: se extiende `Pedido`, `Cotizacion` y `DatosApp` (D1). | PASA |
| **IV. Dinero por los helpers** | El total se toma de la aritmética que `Cotizacion` ya expone (`subtotal`, `base`, `iva`, `total`); no se recalcula a mano. El formateo en pantalla usa `pesos()`. Las cantidades siguen siendo `double`. | PASA |
| **V. Verificación antes de entregar** | La conversión es lógica pura y **entra con prueba**, como exige el principio. Puerta completa: `analyze` limpio, `flutter test` en verde, `gen-l10n` tras tocar ARB, y el flujo ejecutado en la app, incluido con rol empleado por tocar datos de negocio. | PASA |

**Post-diseño (Fase 1)**: se vuelve a evaluar sin cambios. El diseño no
introdujo servicios, capas ni dependencias; al contrario, eliminó una
duplicación al extraer `consumoDeInsumos` de `marcarPedidoEntregado`.

Sin violaciones. **Complexity Tracking** queda vacío a propósito.

## Project Structure

### Documentation (this feature)

```text
specs/001-cotizacion-a-pedido/
├── spec.md              # Qué y por qué (/speckit-specify)
├── plan.md              # Este archivo (/speckit-plan)
├── research.md          # Fase 0: decisiones D1–D7
├── data-model.md        # Fase 1: campos, reglas e invariantes
├── quickstart.md        # Fase 1: cómo validar que funciona
├── contracts/
│   └── api-interna.md   # Fase 1: superficies que consumen las pantallas
├── checklists/
│   └── requirements.md  # Calidad del spec
└── tasks.md             # Fase 2 (/speckit-tasks — aún no existe)
```

### Source Code (repository root)

```text
lib/
├── models/
│   ├── cotizacion.dart        # + pedidoId, + convertida
│   ├── pedido.dart            # + Pedido.desdeCotizacion
│   │                          # + consumoDeInsumos, + faltantesDeInventario
│   ├── item_pedido.dart       # sin cambios (origen de la copia de receta)
│   └── producto.dart          # sin cambios (costoProduccion, consumoPorUnidad)
├── datos_app.dart             # + convertirCotizacionEnPedido
│                              # marcarPedidoEntregado usa consumoDeInsumos
├── pantallas/
│   ├── editar_cotizacion.dart # ofrece convertir al guardar como aceptada
│   ├── cotizar.dart           # acción por fila + marca de ya convertida
│   └── widgets/
│       └── dialogo_convertir_pedido.dart   # ÚNICO archivo nuevo
└── l10n/
    ├── app_es.arb / app_en.arb / app_pt.arb / app_fr.arb   # cadenas nuevas

test/
└── conversion_pedido_test.dart   # pruebas de la lógica pura
```

**Structure Decision**: se mantiene la estructura del proyecto tal cual. El
único archivo nuevo en `lib/` es el diálogo, y va en
`lib/pantallas/widgets/`, donde ya viven los widgets compartidos
(`desglose_costeo.dart`, `formulario_producto.dart`, `widget_pedidos.dart`).
Toda la lógica se añade a archivos existentes, que es lo que pide el Flujo de
Desarrollo antes de justificar estructura nueva.

## Complexity Tracking

Sin violaciones de la constitución. Nada que justificar.
