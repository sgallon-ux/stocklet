// Cloud Functions para notificaciones push de Stocklet.
// Envían push cuando: (1) un insumo baja del mínimo, (2) recordatorio diario
// de pedidos por entregar (hoy o atrasados).
// Cada usuario recibe el texto en SU idioma (guardado en usuarios/{uid}.idioma).
//
// Requiere plan Blaze. Despliegue:  firebase deploy --only functions

const {onDocumentUpdated} =
    require('firebase-functions/v2/firestore');
const {onSchedule} = require('firebase-functions/v2/scheduler');
const {onCall, HttpsError} = require('firebase-functions/v2/https');
const admin = require('firebase-admin');

admin.initializeApp();

const IDIOMAS = ['es', 'en', 'pt', 'fr'];
const IDIOMA_DEFECTO = 'es';

// Textos de las notificaciones por idioma. Los parámetros se pasan como función.
const T = {
  es: {
    invTitulo: 'Inventario bajo',
    invBody: (nombre) => nombre + ' está por debajo del mínimo.',
    pedTitulo: 'Pedidos por entregar',
    pedBody: (n) => 'Tienes ' + n + ' pedido(s) para hoy o atrasados.',
  },
  en: {
    invTitulo: 'Low inventory',
    invBody: (nombre) => nombre + ' is below the minimum.',
    pedTitulo: 'Orders to deliver',
    pedBody: (n) => 'You have ' + n + ' order(s) due today or overdue.',
  },
  pt: {
    invTitulo: 'Estoque baixo',
    invBody: (nombre) => nombre + ' está abaixo do mínimo.',
    pedTitulo: 'Pedidos para entregar',
    pedBody: (n) => 'Você tem ' + n + ' pedido(s) para hoje ou atrasados.',
  },
  fr: {
    invTitulo: 'Stock faible',
    invBody: (nombre) => nombre + ' est en dessous du minimum.',
    pedTitulo: 'Commandes à livrer',
    pedBody: (n) => 'Vous avez ' + n + ' commande(s) pour aujourd\'hui ou en retard.',
  },
};

// Devuelve los tokens de los miembros agrupados por idioma:
//   { es: [...], en: [...] }
async function tokensPorIdioma(negocioId, excluyeUid) {
  const snap = await admin.firestore()
      .collection('usuarios')
      .where('negocioId', '==', negocioId)
      .get();
  const grupos = {};
  snap.forEach((doc) => {
    if (excluyeUid && doc.id === excluyeUid) return;
    const arr = doc.get('fcmTokens') || [];
    if (!arr.length) return;
    let lang = doc.get('idioma') || IDIOMA_DEFECTO;
    if (!IDIOMAS.includes(lang)) lang = IDIOMA_DEFECTO;
    grupos[lang] = (grupos[lang] || []).concat(arr);
  });
  Object.keys(grupos).forEach((l) => {
    grupos[l] = [...new Set(grupos[l])];
  });
  return grupos;
}

// Envía a cada grupo de idioma su texto. `construir(t)` devuelve {title, body}.
async function enviarPorIdioma(grupos, construir) {
  for (const lang of Object.keys(grupos)) {
    const {title, body} = construir(T[lang]);
    await admin.messaging().sendEachForMulticast({
      tokens: grupos[lang],
      notification: {title, body},
      data: {tipo: 'notificaciones'},
    });
  }
}

// (1) Insumo que cruza por debajo de su stock mínimo.
exports.inventarioBajo = onDocumentUpdated(
    'negocios/{negocioId}/insumos/{insumoId}', async (event) => {
      const antes = event.data.before.data();
      const despues = event.data.after.data();
      const min = despues.stockMinimo || 0;
      if (min <= 0) return;
      const cruzaAbajo =
          (antes.stockActual >= min) && (despues.stockActual < min);
      if (!cruzaAbajo) return;
      const grupos = await tokensPorIdioma(event.params.negocioId, null);
      const nombre = despues.nombre || '';
      await enviarPorIdioma(grupos, (t) => ({
        title: t.invTitulo,
        body: t.invBody(nombre),
      }));
    });

// (2) Recordatorio diario de pedidos por entregar (hoy o atrasados).
exports.recordatorioPedidos = onSchedule(
    {schedule: 'every day 08:00', timeZone: 'America/Bogota'}, async () => {
      const ahora = new Date();
      const finDia = new Date(
          ahora.getFullYear(), ahora.getMonth(), ahora.getDate(),
          23, 59, 59);
      const snap = await admin.firestore()
          .collectionGroup('pedidos')
          .where('entregado', '==', false)
          .get();
      const porNegocio = {};
      snap.forEach((doc) => {
        const d = doc.data();
        if (d.archivado === true) return;
        const fe = d.fechaEntrega;
        if (!fe) return;
        const fecha = fe.toDate ? fe.toDate() : new Date(fe);
        if (fecha <= finDia) {
          const negocioId = doc.ref.parent.parent.id;
          porNegocio[negocioId] = (porNegocio[negocioId] || 0) + 1;
        }
      });
      for (const negocioId of Object.keys(porNegocio)) {
        const n = porNegocio[negocioId];
        const grupos = await tokensPorIdioma(negocioId, null);
        await enviarPorIdioma(grupos, (t) => ({
          title: t.pedTitulo,
          body: t.pedBody(n),
        }));
      }
    });

// (3) Eliminar cuenta (requisito de las tiendas). El cliente ya reautenticó
// antes de llamar. Si el usuario es DUEÑO, se borra TODO el negocio y se
// desvincula a los demás miembros. Si es socio/empleado, solo se borra su
// propia cuenta. Al final se elimina el usuario de Firebase Auth.
exports.eliminarCuenta = onCall(async (request) => {
  const uid = request.auth && request.auth.uid;
  if (!uid) {
    throw new HttpsError('unauthenticated', 'Debes iniciar sesión.');
  }
  const db = admin.firestore();
  const bucket = admin.storage().bucket();

  const miDoc = await db.collection('usuarios').doc(uid).get();
  const negocioId = miDoc.exists ? miDoc.get('negocioId') : null;
  const rol = miDoc.exists ? miDoc.get('rol') : null;

  if (negocioId && rol === 'dueno') {
    // --- DUEÑO: borrar todo el negocio ---
    // 1) Todos los miembros del negocio (incluido el dueño).
    const miembros = await db.collection('usuarios')
        .where('negocioId', '==', negocioId).get();
    const batch = db.batch();
    miembros.forEach((d) => batch.delete(d.ref));
    // 2) Invitaciones pendientes de ese negocio.
    const invitaciones = await db.collection('invitaciones')
        .where('negocioId', '==', negocioId).get();
    invitaciones.forEach((d) => batch.delete(d.ref));
    await batch.commit();
    // 3) Todo el árbol del negocio (subcolecciones incluidas).
    await db.recursiveDelete(db.collection('negocios').doc(negocioId));
    // 4) Archivos del negocio en Storage.
    try {
      await bucket.deleteFiles({prefix: `negocios/${negocioId}/`});
    } catch (e) {
      console.error('Error borrando storage del negocio', e);
    }
  } else if (miDoc.exists) {
    // --- Socio / empleado: borrar solo su cuenta ---
    await miDoc.ref.delete();
  }

  // Archivos personales del usuario en Storage.
  try {
    await bucket.deleteFiles({prefix: `usuarios/${uid}/`});
  } catch (e) {
    console.error('Error borrando storage del usuario', e);
  }

  // Finalmente, eliminar el usuario de Firebase Auth.
  try {
    await admin.auth().deleteUser(uid);
  } catch (e) {
    console.error('Error borrando el usuario de Auth', e);
    throw new HttpsError('internal', 'No se pudo eliminar la cuenta.');
  }

  return {ok: true};
});
