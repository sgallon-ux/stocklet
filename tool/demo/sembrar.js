// Siembra un negocio de demo en los EMULADORES de Firebase.
//
// Para qué: las capturas de la ficha de Google Play no pueden salir del negocio
// real. Las pantallas de Stocklet muestran nombres y teléfonos de clientes,
// ventas, costos y márgenes; una captura en Play es pública y permanente.
// Con este script las capturas salen de datos inventados y, además, son
// repetibles: si Play pide rehacerlas, se vuelve a sembrar y queda idéntico.
//
// Nunca toca producción: si no detecta los emuladores, se niega a correr.
//
// Uso:
//   1. firebase emulators:start --only auth,firestore,storage --project demo-stocklet
//   2. cd tool/demo && npm install && npm run sembrar
//   3. flutter run --dart-define=STOCKLET_EMULADOR=true
//   4. Entrar con las credenciales que imprime al final.

import { initializeApp } from 'firebase-admin/app';
import { getFirestore, Timestamp } from 'firebase-admin/firestore';
import { getAuth } from 'firebase-admin/auth';

// --- Guardia: solo emuladores ------------------------------------------------
if (!process.env.FIRESTORE_EMULATOR_HOST) {
  process.env.FIRESTORE_EMULATOR_HOST = '127.0.0.1:8080';
}
if (!process.env.FIREBASE_AUTH_EMULATOR_HOST) {
  process.env.FIREBASE_AUTH_EMULATOR_HOST = '127.0.0.1:9099';
}
const PROYECTO = process.env.GCLOUD_PROJECT || 'demo-stocklet';
if (!PROYECTO.startsWith('demo-')) {
  console.error(
    `Negándome a sembrar en el proyecto "${PROYECTO}".\n` +
    'Este script es solo para emuladores: usa un projectId que empiece por "demo-".');
  process.exit(1);
}

initializeApp({ projectId: PROYECTO });
const db = getFirestore();
const auth = getAuth();

// Credenciales del emulador. No sirven fuera de él: el emulador de Auth no
// comparte usuarios con el proyecto real.
const CORREO = 'demo@stocklet.app';
const CLAVE = 'demo1234';

const NEGOCIO = 'negocio-demo';
const ts = (d) => Timestamp.fromDate(d);
const diasAtras = (n) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d;
};
const enDias = (n) => {
  const d = new Date();
  d.setDate(d.getDate() + n);
  return d;
};

// --- Insumos -----------------------------------------------------------------
// costoPorUnidad va en unidad BASE (g / ml / unidad), como hace la app al
// convertir la presentación de compra.
const insumos = [
  ['harina', 'Harina de trigo', 'Harinas y almidones', 'g', 4.2, 12000, 3000, 'kg', 1, 4200, 'Distribuidora El Molino'],
  ['azucar', 'Azúcar', 'Azúcares y sustitutos', 'g', 3.8, 9000, 2000, 'kg', 1, 3800, 'Distribuidora El Molino'],
  ['mantequilla', 'Mantequilla', 'Grasas', 'g', 18, 2800, 1000, 'kg', 1, 18000, 'Lácteos del Valle'],
  ['huevos', 'Huevos', 'Lácteos y huevos', 'unidad', 800, 48, 24, 'doc', 1, 9600, 'Granja La Esperanza'],
  ['chocolate', 'Chocolate de cobertura', 'Chocolates y cacao', 'g', 32, 1800, 2000, 'kg', 1, 32000, 'Cacao Andino'],
  ['leche', 'Leche entera', 'Lácteos y huevos', 'ml', 3.5, 6000, 2000, 'l', 1, 3500, 'Lácteos del Valle'],
  ['polvo', 'Polvo de hornear', 'Leudantes', 'g', 25, 700, 200, 'g', 1, 25, 'Distribuidora El Molino'],
  ['vainilla', 'Esencia de vainilla', 'Saborizantes y aditivos', 'ml', 90, 220, 100, 'ml', 1, 90, 'Cacao Andino'],
  ['queso', 'Queso crema', 'Lácteos y huevos', 'g', 24, 3000, 1000, 'kg', 1, 24000, 'Lácteos del Valle'],
  ['caja', 'Caja para torta', 'Empaques', 'unidad', 1200, 35, 15, 'unidad', 1, 1200, 'Empaques Rionegro'],
  ['base', 'Base para brownie', 'Empaques', 'unidad', 350, 120, 50, 'unidad', 1, 350, 'Empaques Rionegro'],
  ['bolsa', 'Bolsa de galletas', 'Empaques', 'unidad', 250, 200, 60, 'unidad', 1, 250, 'Empaques Rionegro'],
];

// --- Productos ---------------------------------------------------------------
const r = (insumoId, cantidad) => ({ insumoId, cantidad });

const productos = [
  {
    id: 'torta-chocolate',
    nombre: 'Torta de chocolate',
    tipo: 'Tortas',
    precioVenta: 95000,
    rendimiento: 1,
    mermaPct: 5,
    minutosPrep: 55,
    minutosHorno: 45,
    unidadesMesEstimadas: 14,
    receta: [r('harina', 350), r('azucar', 300), r('mantequilla', 220),
             r('huevos', 4), r('chocolate', 260), r('leche', 200), r('polvo', 15)],
    empaque: [r('caja', 1)],
  },
  {
    id: 'brownies',
    nombre: 'Brownies',
    tipo: 'Brownies',
    precioVenta: 5000,
    rendimiento: 24,
    mermaPct: 8,
    minutosPrep: 40,
    minutosHorno: 35,
    unidadesMesEstimadas: 220,
    receta: [r('harina', 400), r('azucar', 600), r('mantequilla', 350),
             r('huevos', 6), r('chocolate', 500), r('vainilla', 10)],
    empaque: [r('base', 1)],
  },
  {
    id: 'galletas-vainilla',
    nombre: 'Galletas de vainilla',
    tipo: 'New York Cookies',
    precioVenta: 2800,
    rendimiento: 50,
    mermaPct: 6,
    minutosPrep: 35,
    minutosHorno: 25,
    unidadesMesEstimadas: 380,
    receta: [r('harina', 900), r('azucar', 500), r('mantequilla', 400),
             r('huevos', 4), r('vainilla', 20), r('polvo', 20)],
    empaque: [r('bolsa', 1)],
  },
  {
    // A propósito por debajo de su precio sugerido: así el panel de
    // oportunidad y el semáforo de precios tienen algo que mostrar.
    id: 'cheesecake',
    nombre: 'Cheesecake de maracuyá',
    tipo: 'Tortas',
    precioVenta: 62000,
    rendimiento: 12,
    mermaPct: 5,
    minutosPrep: 50,
    minutosHorno: 40,
    unidadesMesEstimadas: 60,
    receta: [r('queso', 900), r('azucar', 350), r('huevos', 5),
             r('mantequilla', 150), r('harina', 200), r('vainilla', 8)],
    empaque: [r('caja', 1)],
  },
];

// --- Ventas: seis meses de historia, para que las gráficas tengan forma ------
const catalogoVentas = [
  ['Torta de chocolate', 95000, 41000],
  ['Brownies', 5000, 2100],
  ['Galletas de vainilla', 2800, 1150],
  ['Cheesecake de maracuyá', 62000, 28000],
];

function generarVentas() {
  const ventas = [];
  let semilla = 7;
  const aleatorio = () => {
    semilla = (semilla * 9301 + 49297) % 233280;
    return semilla / 233280;
  };
  for (let dia = 175; dia >= 0; dia -= 1) {
    const fecha = diasAtras(dia);
    const finDeSemana = fecha.getDay() === 0 || fecha.getDay() === 6;
    const cuantas = finDeSemana ? Math.floor(aleatorio() * 4) + 2
                                : Math.floor(aleatorio() * 3);
    for (let i = 0; i < cuantas; i += 1) {
      const [nombre, precio, costo] = catalogoVentas[
        Math.floor(aleatorio() * catalogoVentas.length)];
      const cantidad = precio > 50000 ? 1 : Math.floor(aleatorio() * 6) + 1;
      ventas.push({
        fecha: ts(fecha),
        descripcion: nombre,
        cantidad,
        precioUnitario: precio,
        costoUnitario: costo,
      });
    }
  }
  return ventas;
}

const gastos = [
  [2, 'Compra de insumos del mes', 'insumos', 640000],
  [5, 'Arriendo del local', 'servicios', 800000],
  [6, 'Energía y agua', 'servicios', 245000],
  [9, 'Cajas y bolsas', 'empaques', 180000],
  [14, 'Internet', 'servicios', 92000],
  [21, 'Mantenimiento del horno', 'otros', 150000],
  [33, 'Compra de insumos del mes', 'insumos', 580000],
  [35, 'Arriendo del local', 'servicios', 800000],
  [48, 'Publicidad en redes', 'otros', 120000],
];

// --- Pedidos -----------------------------------------------------------------
const item = (nombre, cantidad, precio, costo, receta) => ({
  nombre, cantidad, precioUnitario: precio, costoUnitario: costo, receta,
});

const pedidos = [
  {
    id: 'pedido-hoy',
    cliente: { nombre: 'Laura Restrepo', telefono: '3115558842' },
    descripcion: '1x Torta de chocolate, 24x Brownies',
    fechaPedido: ts(diasAtras(4)),
    fechaEntrega: ts(new Date()),
    precio: 215000,
    costo: 91400,
    entregado: false,
    archivado: false,
    otroValor: 0,
    items: [
      item('Torta de chocolate', 1, 95000, 41000,
           [r('harina', 350), r('azucar', 300), r('chocolate', 260), r('caja', 1)]),
      item('Brownies', 24, 5000, 2100, [r('base', 1), r('chocolate', 21)]),
    ],
  },
  {
    // Atrasado: dispara el aviso de pedidos pendientes en Inicio.
    id: 'pedido-atrasado',
    cliente: { nombre: 'Andrés Gómez', telefono: '3004471290' },
    descripcion: '50x Galletas de vainilla',
    fechaPedido: ts(diasAtras(9)),
    fechaEntrega: ts(diasAtras(2)),
    precio: 140000,
    costo: 57500,
    entregado: false,
    archivado: false,
    otroValor: 0,
    items: [item('Galletas de vainilla', 50, 2800, 1150,
                 [r('harina', 18), r('bolsa', 1)])],
  },
  {
    id: 'pedido-entregado',
    cliente: { nombre: 'Cafetería La Plaza', telefono: '3201118834' },
    descripcion: '2x Cheesecake de maracuyá',
    fechaPedido: ts(diasAtras(18)),
    fechaEntrega: ts(diasAtras(12)),
    precio: 124000,
    costo: 56000,
    entregado: true,
    archivado: false,
    otroValor: 0,
    items: [item('Cheesecake de maracuyá', 2, 62000, 28000, [r('queso', 75)])],
  },
];

// --- Cotizaciones ------------------------------------------------------------
const linea = (nombre, precio, cantidad, productoId) =>
  ({ nombre, precioUnitario: precio, cantidad, productoId: productoId ?? null });

const cotizaciones = [
  {
    id: 'cotiza-enviada',
    cliente: 'Matrimonio Vélez',
    fecha: ts(diasAtras(3)),
    estado: 'enviada',
    lineas: [
      linea('Torta de chocolate', 95000, 2, 'torta-chocolate'),
      linea('Brownies', 5000, 60, 'brownies'),
    ],
    adiciones: [{ nombre: 'Decoración personalizada', valor: 45000 }],
    domicilio: 15000,
    descuento: 0,
    aplicaIva: false,
    tasaIva: 19,
    notas: 'Entrega en el salón, montaje incluido.',
    pedidoId: '',
  },
  {
    // Aceptada y sin convertir: así se ve el botón de "crear pedido".
    id: 'cotiza-aceptada',
    cliente: 'Empresa Nutresa',
    fecha: ts(diasAtras(1)),
    estado: 'aceptada',
    lineas: [
      linea('Galletas de vainilla', 2800, 120, 'galletas-vainilla'),
      linea('Brownies', 5000, 80, 'brownies'),
    ],
    adiciones: [],
    domicilio: 20000,
    descuento: 30000,
    aplicaIva: false,
    tasaIva: 19,
    notas: 'Pedido corporativo, fin de mes.',
    pedidoId: '',
  },
];

// --- Siembra -----------------------------------------------------------------
async function limpiar() {
  await db.recursiveDelete(db.collection('negocios').doc(NEGOCIO));
  const us = await db.collection('usuarios').get();
  await Promise.all(us.docs.map((d) => d.ref.delete()));
}

async function crearUsuario() {
  try {
    await auth.deleteUser('demo-uid');
  } catch { /* no existía */ }
  await auth.createUser({
    uid: 'demo-uid',
    email: CORREO,
    password: CLAVE,
    displayName: 'Camila Ríos',
  });
  return 'demo-uid';
}

async function sembrar() {
  console.log(`Sembrando en el proyecto "${PROYECTO}" (emuladores)...`);
  await limpiar();
  const uid = await crearUsuario();

  await db.collection('usuarios').doc(uid).set({
    negocioId: NEGOCIO,
    rol: 'dueno',
    nombre: 'Camila Ríos',
    celular: '3123456789',
    fotoUrl: '',
    idioma: 'es',
  });

  await db.collection('negocios').doc(NEGOCIO).set({
    nombre: 'Postres Aurora',
    pais: 'CO',
    moneda: 'COP',
    idioma: 'es',
    duenoUid: uid,
    nit: '901.234.567-8',
    correo: 'hola@postresaurora.com',
    tel: '3123456789',
    ubicacion: 'Rionegro, Antioquia',
    logoUrl: '',
    tarifaHora: 12000,
    costoEnergiaHora: 2500,
    gastosFijos: [
      { nombre: 'Arriendo', valor: 800000 },
      { nombre: 'Servicios', valor: 245000 },
      { nombre: 'Internet', valor: 92000 },
    ],
    lotesMes: 45,
    metodoMargen: 'venta',
    margenPct: 40,
    margenEspecialPct: 55,
    ivaAplica: false,
    ivaTasa: 19,
  });

  const col = (n) => db.collection('negocios').doc(NEGOCIO).collection(n);

  for (const [id, nombre, categoria, unidad, costoPorUnidad, stockActual,
               stockMinimo, unidadCompra, cantidadCompra, precioPresentacion,
               proveedor] of insumos) {
    await col('insumos').doc(id).set({
      nombre, categoria, unidad, costoPorUnidad, stockActual, stockMinimo,
      unidadCompra, cantidadCompra, precioPresentacion, proveedor,
      especial: false,
    });
  }

  for (const p of productos) {
    const { id, ...datos } = p;
    await col('productos').doc(id).set({
      ...datos,
      metodoMargen: '',
      margenPct: null,
      sinAzucar: false,
    });
  }

  const ventas = generarVentas();
  let lote = db.batch();
  let n = 0;
  for (const v of ventas) {
    lote.set(col('ventas').doc(), v);
    n += 1;
    if (n % 400 === 0) { await lote.commit(); lote = db.batch(); }
  }
  await lote.commit();

  for (const [dias, descripcion, categoria, monto] of gastos) {
    await col('gastos').doc().set({
      fecha: ts(diasAtras(dias)), descripcion, categoria, monto,
    });
  }

  for (const p of pedidos) {
    const { id, ...datos } = p;
    await col('pedidos').doc(id).set(datos);
  }

  for (const c of cotizaciones) {
    const { id, ...datos } = c;
    await col('cotizaciones').doc(id).set(datos);
  }

  console.log(`
Listo. Negocio de demo "Postres Aurora":
  ${insumos.length} insumos (chocolate por debajo del mínimo, a propósito)
  ${productos.length} productos con receta (el cheesecake, mal cobrado a propósito)
  ${ventas.length} ventas en seis meses
  ${gastos.length} gastos, ${pedidos.length} pedidos, ${cotizaciones.length} cotizaciones

Entra en la app con:
  correo: ${CORREO}
  clave:  ${CLAVE}

  flutter run --dart-define=STOCKLET_EMULADOR=true
`);
}

sembrar().catch((e) => {
  console.error(e);
  process.exit(1);
});
