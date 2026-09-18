# Ficha de Google Play — Stocklet

Guion de capturas y textos de la ficha. Todo se toma del negocio de demo
*Postres Aurora* (ver "Negocio de demo" en el README), nunca del negocio real.

> Última revisión: 2026-09-17, versión 1.1.0+2.

---

## Cómo tomarlas

Lo más limpio es un **emulador de Android con perfil Pixel** (1080×1920): sale
el tamaño que Play prefiere, sin barra de estado sucia ni notificaciones
personales encima.

```
firebase emulators:start --only auth,firestore,storage --project mi-reposteria-app
```

```
cd tool/demo && npm run sembrar
```

```
flutter run --dart-define=STOCKLET_EMULADOR=true
```

Entrar con `demo@stocklet.app` / `demo1234`.

Antes de disparar: modo claro, idioma español, y el emulador en pantalla
completa. Si una captura sale mal, se vuelve a sembrar y queda idéntica.

---

## El guion

Play muestra las capturas en orden y **mucha gente solo ve las dos primeras**.
Por eso el orden no es "recorrer el menú", sino contar una historia: primero el
problema que resuelve, después cómo.

### 1. Inicio — todo el negocio de un vistazo

**Pantalla**: Inicio, recién entrando.
**Qué se ve**: ventas del mes, tendencia de seis meses, avisos de pedido
atrasado e inventario bajo.
**Por qué va primera**: es la única captura que responde "¿qué es esto?" en dos
segundos.
**Texto sugerido**: *Tu negocio completo, en una pantalla*

### 2. Desglose de costeo — lo que nadie más te dice

**Pantalla**: Productos → Cheesecake de maracuyá → desglose de costeo.
**Qué se ve**: materia prima, merma, empaque, mano de obra, energía y gastos
fijos sumando el costo real por unidad, con el precio sugerido al lado y el
producto marcado como mal cobrado.
**Por qué va segunda**: es **el diferenciador**. Cualquier app registra ventas;
esta te dice cuánto te cuesta de verdad y cuánto deberías cobrar. El cheesecake
está mal cobrado a propósito para que el semáforo se vea trabajando.
**Texto sugerido**: *Sabe cuánto te cuesta. Y cuánto deberías cobrar*

### 3. Dinero que dejas de ganar

**Pantalla**: Inicio → panel de oportunidad (o la pantalla de comparador).
**Qué se ve**: el monto mensual que se pierde por productos por debajo de su
precio sugerido.
**Por qué**: convierte el costeo en una cifra que duele. Es la captura que
vende.
**Texto sugerido**: *Cuánto estás dejando sobre la mesa cada mes*

### 4. Inventario que se descuenta solo

**Pantalla**: Inventario, con el Chocolate de cobertura bajo mínimo.
**Qué se ve**: insumos con stock, el que está en rojo, y el buscador.
**Por qué**: el inventario baja solo al vender o entregar pedidos; eso es lo que
ahorra trabajo diario.
**Texto sugerido**: *El inventario baja solo cuando vendes*

### 5. Cotizar y enviar por WhatsApp

**Pantalla**: Cotizar → cotización "Matrimonio Vélez" abierta.
**Qué se ve**: líneas, adiciones, domicilio, total, y los botones de compartir.
**Por qué**: es trabajo que hoy se hace a mano en notas de voz y papel.
**Texto sugerido**: *Cotiza en un minuto y envíala por WhatsApp*

### 6. De cotización aceptada a pedido

**Pantalla**: la cotización "Empresa Nutresa" (aceptada, sin convertir) con el
diálogo de crear pedido abierto.
**Qué se ve**: el resumen con cliente, total, y el aviso de qué descuenta
inventario.
**Por qué**: es la función más nueva y la que mejor muestra que la app entiende
el flujo completo, no pantallas sueltas.
**Texto sugerido**: *El cliente acepta: el pedido se crea solo*

### 7. Pedidos con fecha de entrega

**Pantalla**: Pedidos, con el atrasado visible.
**Qué se ve**: pendientes, entregados y el que va tarde.
**Texto sugerido**: *Nunca más se te pasa una entrega*

### 8. Tu equipo, con permisos

**Pantalla**: Ajustes → Miembros e invitaciones.
**Qué se ve**: invitación por código y los roles.
**Por qué**: diferencia a Stocklet de una libreta personal. Va última porque
solo le importa a quien ya tiene equipo.
**Texto sugerido**: *Invita a tu equipo, sin darles todo el control*

> **Mínimo viable**: si solo vas a tomar cuatro, que sean la 1, 2, 3 y 5. Esas
> cuatro cuentan la historia completa.

---

## Especificaciones que Play exige

| Recurso | Requisito |
|---|---|
| Capturas de teléfono | Entre 2 y 8. JPEG o PNG de 24 bits sin transparencia. Lado corto mínimo 320 px, largo máximo 3840 px. Recomendado 1080×1920 |
| Capturas de tablet 7" y 10" | Opcionales, pero **si no las subes Play puede marcar la app como no optimizada para tablets** |
| Icono | 512×512 PNG de 32 bits con alfa |
| Gráfico destacado | 1024×500 JPEG o PNG de 24 bits, sin transparencia. Obligatorio |
| Descripción corta | Máximo 80 caracteres |
| Descripción completa | Máximo 4000 caracteres |
| Vídeo promocional | Opcional, enlace de YouTube |

El gráfico destacado se ve recortado en muchas superficies: **no pongas texto
cerca de los bordes** y evita meter una captura entera dentro.

---

## Textos de la ficha (español)

### Descripción corta (71 / 80)

```
Controla inventario, costos y precios de tu negocio. Sabe cuánto ganas.
```

### Descripción completa

```
Stocklet es la app de gestión para negocios pequeños que quieren saber, de
verdad, cuánto ganan.

No es otra libreta de ventas. Stocklet calcula cuánto te cuesta producir cada
cosa —incluyendo la merma, el empaque, tu tiempo, la energía y los gastos fijos
del mes— y te dice a qué precio deberías venderla para no trabajar gratis.

QUÉ RESUELVE

• Cuánto te cuesta cada producto, de principio a fin
Materia prima, merma, empaque, mano de obra, energía y gastos fijos prorrateados
por lote. El costo real, no el aproximado.

• A qué precio vender
Stocklet sugiere el precio según el margen que quieras y te marca en rojo los
productos que estás vendiendo por debajo de lo que cuestan.

• Cuánto estás dejando de ganar
Un panel te muestra, en pesos y al mes, lo que pierdes por tener productos mal
cobrados.

• Inventario sin contar a mano
Registra la venta y el inventario baja solo, según la receta de cada producto.
Te avisa cuando un insumo está por acabarse.

• Cotizaciones que se vuelven pedidos
Arma la cotización, envíala por WhatsApp o PDF, y cuando el cliente acepte,
conviértela en pedido sin volver a escribir nada.

• Pedidos con fecha de entrega
Con recordatorio de lo que hay que entregar hoy y aviso de lo que va atrasado.

• Tu equipo, con permisos
Invita socios y empleados por código. Cada rol ve y hace lo que le corresponde.

• Reportes que se entienden
Ventas por mes, por día de semana, productos más vendidos y comparador entre
productos. Además, un simulador para ver qué pasa con tus precios si suben los
insumos.

PARA QUIÉN ES

Reposterías, panaderías, cocinas caseras, talleres y cualquier negocio pequeño
que produzca por lotes y venda por unidad.

Funciona en español, inglés, portugués y francés, con la moneda de tu país.

Empieza gratis. Tus datos quedan sincronizados y puedes trabajar desde el
teléfono y desde el computador.
```

*(1.925 caracteres de 4.000: sobra espacio si quieres añadir casos de uso o
testimonios más adelante.)*

---

## Descripciones cortas en los otros idiomas

La app está en cuatro idiomas, así que conviene localizar al menos la
descripción corta de cada ficha.

| Idioma | Texto | Caracteres |
|---|---|---|
| Inglés | `Track inventory, costs and prices. Know what your business really earns.` | 72 |
| Portugués | `Controle estoque, custos e preços. Saiba quanto seu negócio realmente ganha.` | 76 |
| Francés | `Gérez stock, coûts et prix. Sachez ce que votre activité gagne vraiment.` | 72 |

La descripción completa en esos tres idiomas queda pendiente; para lanzar en
Colombia basta la española, y las otras se añaden cuando se abra cada mercado.

---

## Antes de subir

- [ ] Capturas tomadas del negocio de demo, **nunca del real** (ver
      `docs/data-safety.md`: la app guarda datos de clientes)
- [ ] Ninguna captura muestra el correo o el teléfono de una persona real
- [ ] Gráfico destacado 1024×500 sin texto pegado a los bordes
- [ ] Descripción corta dentro de 80 caracteres
- [ ] URL de política de privacidad puesta en la ficha
- [ ] URL de borrado de cuenta puesta en la ficha
- [ ] Formulario de Data Safety rellenado con `docs/data-safety.md`
