import 'package:flutter/material.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../tema.dart';
import 'inventario.dart';
import 'productos.dart';
import 'pedidos.dart';
import 'recetas.dart';
import 'catalogo.dart';
import 'cotizar.dart';

class CrearHub extends StatelessWidget {
  const CrearHub({super.key});

  Widget _item(BuildContext context, IconData icono, String titulo,
      String sub, Widget destino) {
    final m = AppColores.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => destino)),
        leading: Container(
          height: 44,
          width: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: m.verde.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icono, color: m.verde),
        ),
        title: Text(titulo,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: m.texto)),
        subtitle: Text(sub),
        trailing: Icon(Icons.chevron_right, color: m.textoSuave),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.crearHubTitulo)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _item(context, Icons.inventory_2_outlined, t.inventario,
              t.inventarioSub, const PantallaInventario()),
          _item(context, Icons.shopping_bag_outlined, t.productos,
              t.productosSub, const PantallaProductos()),
          _item(context, Icons.receipt_long_outlined, t.pedidos,
              t.pedidosSub, const PantallaPedidos()),
          _item(context, Icons.request_quote_outlined, t.cotizarTitulo,
              t.cotizarSub, const PantallaCotizar()),
          _item(context, Icons.menu_book_outlined, t.recetas,
              t.recetasSub, const PantallaRecetas()),
          _item(context, Icons.picture_as_pdf_outlined, t.catalogo,
              t.catalogoSub, const PantallaCatalogo()),
        ],
      ),
    );
  }
}
