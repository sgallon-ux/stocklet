# Gráfico destacado de Google Play

El gráfico destacado (1024×500) es **obligatorio** en la ficha y no sale de una
captura: es diseño. Se genera desde `grafico-destacado.html` con Chrome en modo
headless, así que el tamaño es exacto y rehacerlo es un comando.

## Regenerar

```
"C:\Program Files\Google\Chrome\Application\chrome.exe" --headless --disable-gpu --hide-scrollbars --force-device-scale-factor=1 --screenshot="..\..\capturas\grafico-destacado.png" --window-size=1024,500 "file:///C:/Users/PC/Documents/reposteria_app/reposteria_app/tool/grafico/grafico-destacado.html"
```

El PNG sale en `capturas/`, que está fuera de git porque se regenera.

## Lo que condiciona el diseño

- **Play lo recorta** en varias superficies, así que nada importante va cerca de
  los bordes: todo el contenido queda dentro de un margen de 80 px. Los círculos
  del fondo sí los cruzan, a propósito.
- **No admite transparencia**: el fondo es opaco de lado a lado.
- Los colores salen de `lib/tema.dart`: verde `#0E9F6E` sobre `#0A7D55`.
- `stocklet_icon.png` es una copia de `assets/icon/stocklet_icon.png`. Si el
  icono de la app cambia, hay que volver a copiarlo.

## Las cifras de la tarjeta

Son las del negocio de demo (`tool/demo/sembrar.js`) para la **Torta de
chocolate**: costo 59.515, cobrado 76.000, sugerido 99.192.

**Si cambias los precios del sembrador, hay que actualizar estas cifras**, o el
gráfico contradirá a la captura del comparador de productos. Es la única
dependencia entre los dos, y no la detecta nada automáticamente.
