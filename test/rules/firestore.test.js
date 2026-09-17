// Pruebas de las reglas de seguridad de Firestore (../../firestore.rules).
//
// Se ejecutan contra el emulador:
//   cd test/rules && npm test
//
// Lo que se busca demostrar, en orden de gravedad:
//   1. Un negocio no ve ni toca los datos de otro.
//   2. Nadie se sube el rol ni se cambia de negocio por su cuenta.
//   3. El empleado puede trabajar (vender descuenta inventario) sin poder
//      editar el catálogo ni borrar historial.

import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, resolve } from 'node:path';
import test, { before, after, beforeEach } from 'node:test';
import {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} from '@firebase/rules-unit-testing';
import { doc, getDoc, setDoc, deleteDoc, collection, getDocs, query, where } from 'firebase/firestore';

const aqui = dirname(fileURLToPath(import.meta.url));
const [host, puerto] = (process.env.FIRESTORE_EMULATOR_HOST ?? '127.0.0.1:8080').split(':');

let env;

// --- Datos de partida -------------------------------------------------------
// Dos negocios independientes, con su gente. negB existe para probar que negA
// no lo alcanza.

const HARINA = {
  nombre: 'Harina',
  categoria: 'Secos',
  unidad: 'g',
  costoPorUnidad: 5,
  stockActual: 1000,
  stockMinimo: 100,
  unidadCompra: 'kg',
  cantidadCompra: 1,
  precioPresentacion: 5000,
  proveedor: 'Proveedor X',
  especial: false,
};

async function sembrar() {
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, 'negocios/negA'), {
      nombre: 'Dulce Nota', pais: 'CO', moneda: 'COP', idioma: 'es', duenoUid: 'duenoA',
    });
    await setDoc(doc(db, 'negocios/negB'), {
      nombre: 'Otro Negocio', pais: 'CO', moneda: 'COP', idioma: 'es', duenoUid: 'duenoB',
    });

    await setDoc(doc(db, 'usuarios/duenoA'), { negocioId: 'negA', rol: 'dueno', nombre: 'Ana' });
    await setDoc(doc(db, 'usuarios/socioA'), { negocioId: 'negA', rol: 'socio', nombre: 'Sara' });
    await setDoc(doc(db, 'usuarios/empleadoA'), { negocioId: 'negA', rol: 'empleado', nombre: 'Eli' });
    await setDoc(doc(db, 'usuarios/duenoB'), { negocioId: 'negB', rol: 'dueno', nombre: 'Beto' });

    await setDoc(doc(db, 'negocios/negA/insumos/harina'), HARINA);
    await setDoc(doc(db, 'negocios/negA/productos/torta'), { nombre: 'Torta', precio: 50000 });
    await setDoc(doc(db, 'negocios/negA/ventas/v1'), { descripcion: 'Torta', cantidad: 1 });
    await setDoc(doc(db, 'negocios/negB/insumos/azucar'), { ...HARINA, nombre: 'Azúcar' });

    await setDoc(doc(db, 'invitaciones/ABC123'), {
      negocioId: 'negA', rol: 'empleado', estado: 'pendiente',
      creadoPor: 'duenoA', usadaPor: '',
    });
  });
}

const como = (uid) => env.authenticatedContext(uid).firestore();
const sinSesion = () => env.unauthenticatedContext().firestore();

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-stocklet',
    firestore: {
      // STOCKLET_RULES permite correr la misma suite contra otro archivo de
      // reglas (por ejemplo, las que hay desplegadas hoy) para compararlas.
      rules: readFileSync(
        process.env.STOCKLET_RULES ?? resolve(aqui, '../../firestore.rules'), 'utf8'),
      host,
      port: Number(puerto),
    },
  });
});

after(async () => { await env?.cleanup(); });

beforeEach(async () => {
  await env.clearFirestore();
  await sembrar();
});

// --- 1. Aislamiento entre negocios -----------------------------------------

test('sin sesión no se lee nada', async () => {
  await assertFails(getDoc(doc(sinSesion(), 'negocios/negA')));
  await assertFails(getDoc(doc(sinSesion(), 'negocios/negA/insumos/harina')));
});

test('el dueño de otro negocio no lee el negocio ajeno', async () => {
  await assertFails(getDoc(doc(como('duenoB'), 'negocios/negA')));
});

test('el dueño de otro negocio no lee los insumos ajenos', async () => {
  await assertFails(getDoc(doc(como('duenoB'), 'negocios/negA/insumos/harina')));
});

test('el dueño de otro negocio no lee las ventas ajenas', async () => {
  await assertFails(getDocs(collection(como('duenoB'), 'negocios/negA/ventas')));
});

test('el dueño de otro negocio no escribe en el negocio ajeno', async () => {
  await assertFails(setDoc(doc(como('duenoB'), 'negocios/negA/insumos/harina'), HARINA));
});

test('un usuario sin ficha no alcanza nada', async () => {
  await assertFails(getDoc(doc(como('fantasma'), 'negocios/negA')));
  await assertFails(getDoc(doc(como('fantasma'), 'negocios/negA/insumos/harina')));
});

test('un usuario con ficha pero sin negocio no alcanza nada', async () => {
  // El caso límite: negocioId ausente se lee como '' y no debe emparejar con
  // ningún documento, ni siquiera con otro que tenga el campo vacío.
  await env.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), 'usuarios/huerfano'), { nombre: 'Sin negocio' });
  });
  await assertFails(getDoc(doc(como('huerfano'), 'negocios/negA')));
  await assertFails(getDoc(doc(como('huerfano'), 'negocios/negA/insumos/harina')));
  await assertFails(getDoc(doc(como('huerfano'), 'usuarios/empleadoA')));
});

test('un miembro sí lee lo suyo', async () => {
  await assertSucceeds(getDoc(doc(como('empleadoA'), 'negocios/negA')));
  await assertSucceeds(getDoc(doc(como('empleadoA'), 'negocios/negA/insumos/harina')));
});

// --- 2. Nadie se asciende solo ---------------------------------------------

test('un empleado no puede subirse el rol a dueño', async () => {
  await assertFails(setDoc(doc(como('empleadoA'), 'usuarios/empleadoA'),
    { negocioId: 'negA', rol: 'dueno', nombre: 'Eli' }));
});

test('un empleado no puede subirse el rol a socio', async () => {
  await assertFails(setDoc(doc(como('empleadoA'), 'usuarios/empleadoA'),
    { negocioId: 'negA', rol: 'socio', nombre: 'Eli' }));
});

test('un empleado no puede mudarse a otro negocio por su cuenta', async () => {
  await assertFails(setDoc(doc(como('empleadoA'), 'usuarios/empleadoA'),
    { negocioId: 'negB', rol: 'empleado', nombre: 'Eli' }));
});

test('un empleado sí puede editar sus datos personales', async () => {
  await assertSucceeds(setDoc(doc(como('empleadoA'), 'usuarios/empleadoA'),
    { negocioId: 'negA', rol: 'empleado', nombre: 'Eli Nuevo', celular: '3110000000' }));
});

test('nadie edita la ficha de un miembro de otro negocio', async () => {
  await assertFails(setDoc(doc(como('duenoB'), 'usuarios/empleadoA'),
    { negocioId: 'negA', rol: 'empleado', nombre: 'Hackeado' }, { merge: true }));
});

// --- 3. El dueño gestiona su gente, con límites ------------------------------

test('el dueño cambia el rol de un miembro', async () => {
  await assertSucceeds(setDoc(doc(como('duenoA'), 'usuarios/empleadoA'),
    { rol: 'socio' }, { merge: true }));
});

test('el dueño no puede fabricar otro dueño', async () => {
  await assertFails(setDoc(doc(como('duenoA'), 'usuarios/empleadoA'),
    { rol: 'dueno' }, { merge: true }));
});

test('el dueño no puede mover a un miembro a otro negocio', async () => {
  await assertFails(setDoc(doc(como('duenoA'), 'usuarios/empleadoA'),
    { negocioId: 'negB' }, { merge: true }));
});

test('el dueño saca a un miembro de su negocio', async () => {
  await assertSucceeds(deleteDoc(doc(como('duenoA'), 'usuarios/empleadoA')));
});

test('un empleado no saca a otro miembro', async () => {
  await assertFails(deleteDoc(doc(como('empleadoA'), 'usuarios/socioA')));
});

// --- 4. El empleado trabaja, pero no manda -----------------------------------

test('el empleado descuenta inventario al vender', async () => {
  // La app guarda el insumo completo; lo único que cambia es el stock.
  await assertSucceeds(setDoc(doc(como('empleadoA'), 'negocios/negA/insumos/harina'),
    { ...HARINA, stockActual: 750 }));
});

test('el empleado no puede cambiarle el precio a un insumo', async () => {
  await assertFails(setDoc(doc(como('empleadoA'), 'negocios/negA/insumos/harina'),
    { ...HARINA, costoPorUnidad: 1 }));
});

test('el empleado no puede renombrar un insumo mientras descuenta stock', async () => {
  await assertFails(setDoc(doc(como('empleadoA'), 'negocios/negA/insumos/harina'),
    { ...HARINA, nombre: 'Otra cosa', stockActual: 750 }));
});

test('el empleado no crea ni borra insumos', async () => {
  await assertFails(setDoc(doc(como('empleadoA'), 'negocios/negA/insumos/nuevo'), HARINA));
  await assertFails(deleteDoc(doc(como('empleadoA'), 'negocios/negA/insumos/harina')));
});

test('el socio sí gestiona el catálogo', async () => {
  await assertSucceeds(setDoc(doc(como('socioA'), 'negocios/negA/insumos/harina'),
    { ...HARINA, costoPorUnidad: 7 }));
  await assertSucceeds(setDoc(doc(como('socioA'), 'negocios/negA/productos/torta'),
    { nombre: 'Torta grande', precio: 70000 }));
});

test('el empleado no toca los productos', async () => {
  await assertFails(setDoc(doc(como('empleadoA'), 'negocios/negA/productos/torta'),
    { nombre: 'Torta', precio: 1 }));
});

test('el empleado registra una venta pero no la borra', async () => {
  await assertSucceeds(setDoc(doc(como('empleadoA'), 'negocios/negA/ventas/v2'),
    { descripcion: 'Torta', cantidad: 1 }));
  await assertFails(deleteDoc(doc(como('empleadoA'), 'negocios/negA/ventas/v1')));
});

test('el socio sí corrige el historial', async () => {
  await assertSucceeds(deleteDoc(doc(como('socioA'), 'negocios/negA/ventas/v1')));
});

// --- 5. Negocio y ajustes ----------------------------------------------------

test('cualquiera crea su propio negocio, pero no a nombre de otro', async () => {
  const base = { nombre: 'Nuevo', pais: 'CO', moneda: 'COP', idioma: 'es' };
  await assertSucceeds(setDoc(doc(como('nuevo'), 'negocios/negC'), { ...base, duenoUid: 'nuevo' }));
  await assertFails(setDoc(doc(como('nuevo'), 'negocios/negD'), { ...base, duenoUid: 'duenoA' }));
});

test('el empleado no cambia los ajustes del negocio', async () => {
  await assertFails(setDoc(doc(como('empleadoA'), 'negocios/negA'),
    { moneda: 'USD' }, { merge: true }));
});

test('el dueño no puede regalarle el negocio a otro desde el cliente', async () => {
  await assertFails(setDoc(doc(como('duenoA'), 'negocios/negA'),
    { duenoUid: 'duenoB' }, { merge: true }));
});

test('nadie borra el negocio desde el cliente', async () => {
  await assertFails(deleteDoc(doc(como('duenoA'), 'negocios/negA')));
});

// --- 6. Invitaciones ---------------------------------------------------------

test('el dueño lista las invitaciones de su negocio', async () => {
  const q = query(collection(como('duenoA'), 'invitaciones'), where('negocioId', '==', 'negA'));
  await assertSucceeds(getDocs(q));
});

test('nadie lista las invitaciones de otro negocio', async () => {
  const q = query(collection(como('duenoB'), 'invitaciones'), where('negocioId', '==', 'negA'));
  await assertFails(getDocs(q));
});

test('el empleado no lista las invitaciones de su propio negocio', async () => {
  const q = query(collection(como('empleadoA'), 'invitaciones'), where('negocioId', '==', 'negA'));
  await assertFails(getDocs(q));
});

test('el dueño no puede invitar a otro negocio', async () => {
  await assertFails(setDoc(doc(como('duenoA'), 'invitaciones/XXX999'), {
    negocioId: 'negB', rol: 'empleado', estado: 'pendiente',
    creadoPor: 'duenoA', usadaPor: '',
  }));
});

test('el dueño no puede invitar a alguien como dueño', async () => {
  await assertFails(setDoc(doc(como('duenoA'), 'invitaciones/XXX998'), {
    negocioId: 'negA', rol: 'dueno', estado: 'pendiente',
    creadoPor: 'duenoA', usadaPor: '',
  }));
});

test('canjear una invitación y entrar al negocio', async () => {
  const db = como('recienLlegado');
  // 1) Reclamar el código.
  await assertSucceeds(setDoc(doc(db, 'invitaciones/ABC123'), {
    negocioId: 'negA', rol: 'empleado', estado: 'usada',
    creadoPor: 'duenoA', usadaPor: 'recienLlegado',
  }));
  // 2) Crear la ficha con lo que dice la invitación.
  await assertSucceeds(setDoc(doc(db, 'usuarios/recienLlegado'), {
    negocioId: 'negA', rol: 'empleado', invitacionCodigo: 'ABC123',
  }));
});

test('no se puede entrar con una invitación reclamada por otro', async () => {
  await env.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), 'invitaciones/ABC123'), {
      negocioId: 'negA', rol: 'empleado', estado: 'usada',
      creadoPor: 'duenoA', usadaPor: 'otraPersona',
    });
  });
  await assertFails(setDoc(doc(como('colado'), 'usuarios/colado'), {
    negocioId: 'negA', rol: 'empleado', invitacionCodigo: 'ABC123',
  }));
});

test('canjear una invitación no permite elegirse el rol', async () => {
  const db = como('ambicioso');
  await setDoc(doc(db, 'invitaciones/ABC123'), {
    negocioId: 'negA', rol: 'empleado', estado: 'usada',
    creadoPor: 'duenoA', usadaPor: 'ambicioso',
  });
  await assertFails(setDoc(doc(db, 'usuarios/ambicioso'), {
    negocioId: 'negA', rol: 'socio', invitacionCodigo: 'ABC123',
  }));
});

test('sin invitación no se entra a un negocio ajeno', async () => {
  await assertFails(setDoc(doc(como('colado'), 'usuarios/colado'), {
    negocioId: 'negA', rol: 'empleado',
  }));
});

test('una invitación ya usada no se vuelve a canjear', async () => {
  await env.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), 'invitaciones/ABC123'), {
      negocioId: 'negA', rol: 'empleado', estado: 'usada',
      creadoPor: 'duenoA', usadaPor: 'alguien',
    });
  });
  await assertFails(setDoc(doc(como('tardio'), 'invitaciones/ABC123'), {
    negocioId: 'negA', rol: 'empleado', estado: 'usada',
    creadoPor: 'duenoA', usadaPor: 'tardio',
  }));
});
