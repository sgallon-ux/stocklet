// Puente CommonJS -> ESM.
//
// `firebase emulators:exec` corre el script con el Node empaquetado del CLI,
// que hace require() del archivo de entrada y por tanto no acepta ni ESM ni el
// flag --test. Este archivo es el entry CommonJS que importa la suite ESM; el
// runner de node:test se encarga solo de ejecutar y de fijar el código de
// salida si algo falla.

import('./firestore.test.js').catch((err) => {
  console.error(err);
  process.exit(1);
});
