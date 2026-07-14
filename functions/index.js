// Cloud Functions para notificaciones push de Dulce Nota.
// Envían push cuando: (1) un miembro crea una nota, (2) un insumo baja del
// mínimo, (3) recordatorio diario de pedidos por entregar (hoy o atrasados).
// Cada usuario recibe el texto en SU idioma (guardado en usuarios/{uid}.idioma).
//
// Requiere plan Blaze. Despliegue:  firebase deploy --only functions

const {onDocumentCreated, onDocumentUpdated} =
    require('firebase-functions/v2/firestore');
const {onSchedule} = require('firebase-functions/v2/scheduler');
const admin = require('firebase-admin');

admin.initializeApp();

const IDIOMAS = ['es', 'en', 'pt', 'fr'];
const IDIOMA_DEFECTO = 'es';

// Textos de las notificaciones por idioma. Los parámetros se pasan como función.
const T = {
  es: {
    notaTitulo: (asunto) => 'Nueva nota: ' + asunto,
    notaPorAutor: (autor) => 'Por ' + autor,
    invTitulo: 'Inventario bajo',
    invBody: (nombre) => nombre + ' está por debajo del mínimo.',
    pedTitulo: 'Pedidos por entregar',
    pedBody: (n) => 'Tienes ' + n + ' pedido(s) para hoy o atrasados.',
  },
  en: {
    notaTitulo: (asunto) => 'New note: ' + asunto,
    notaPorAutor: (autor) => 'By ' + autor,
    invTitulo: 'Low inventory',
    invBody: (nombre) => nombre + ' is below the minimum.',
    pedTitulo: 'Orders to deliver',
    pedBody: (n) => 'You have ' + n + ' order(s) due today or overdue.',
  },
  pt: {
    notaTitulo: (asunto) => 'Nova nota: ' + asunto,
    notaPorAutor: (autor) => 'Por ' + autor,
    invTitulo: 'Estoque baixo',
    invBody: (nombre) => nombre + ' está abaixo do mínimo.',
    pedTitulo: 'Pedidos para entregar',
    pedBody: (n) => 'Você tem ' + n + ' pedido(s) para hoje ou atrasados.',
  },
  fr: {
    notaTitulo: (asunto) => 'Nouvelle note : ' + asunto,
    notaPorAutor: (autor) => 'Par ' + autor,
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

// (1) Nota nueva -> avisar a los demás miembros.
exports.notaNueva = onDocumentCreated(
    'negocios/{negocioId}/notas/{notaId}', async (event) => {
      const data = event.data && event.data.data();
      if (!data) return;
      const grupos = await tokensPorIdioma(
          event.params.negocioId, data.autorUid);
      await enviarPorIdioma(grupos, (t) => ({
        title: t.notaTitulo(data.asunto || ''),
        body: data.autorNombre ? t.notaPorAutor(data.autorNombre) : '',
      }));
    });

// (2) Insumo que cruza por debajo de su stock mínimo.
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

// (3) Recordatorio diario de pedidos por entregar (hoy o atrasados).
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
