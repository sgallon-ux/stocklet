import 'package:cloud_firestore/cloud_firestore.dart';
import '../formato.dart';
import 'cliente.dart';
import 'cotizacion.dart';
import 'insumo.dart';
import 'item_pedido.dart';
import 'producto.dart';

class Pedido {
  String id;
  Cliente cliente;
  String descripcion;
  DateTime fechaPedido;
  DateTime fechaEntrega;
  double precio;
  double costo;
  bool entregado;
  bool archivado;
  List<ItemPedido> items;
  double otroValor;

  Pedido({
    String? id,
    required this.cliente,
    required this.descripcion,
    required this.fechaPedido,
    required this.fechaEntrega,
    required this.precio,
    required this.costo,
    this.entregado = false,
    this.archivado = false,
    this.items = const [],
    this.otroValor = 0,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  /// Construye el pedido que corresponde a una cotización aceptada.
  ///
  /// Puro: no toca Firestore ni `DatosApp`, para poder probarlo sin emulador.
  ///
  /// Conviven aquí dos verdades distintas. El **precio** de cada línea es el
  /// cotizado y se congela, porque es lo que se le prometió al cliente. El
  /// **costo y la receta** se toman del producto tal como está hoy, porque es
  /// lo que la cocina va a consumir de verdad.
  ///
  /// Una línea sin producto del catálogo —escrita a mano, o de un producto ya
  /// borrado— entra sin costo ni receta: al entregar no descontará inventario.
  ///
  /// Garantiza que `precio == cotizacion.total`.
  factory Pedido.desdeCotizacion(
    Cotizacion cotizacion, {
    required List<Producto> productos,
    required String telefono,
    required DateTime fechaEntrega,
    required String descripcionFallback,
  }) {
    final items = <ItemPedido>[];
    for (final linea in cotizacion.lineas) {
      final pid = linea.productoId;
      Producto? prod;
      if (pid != null && pid.isNotEmpty) {
        for (final p in productos) {
          if (p.id == pid) {
            prod = p;
            break;
          }
        }
      }
      items.add(ItemPedido(
        nombre: linea.nombre,
        cantidad: linea.cantidad,
        precioUnitario: linea.precioUnitario,
        costoUnitario: prod?.costoProduccion() ?? 0,
        receta: prod?.consumoPorUnidad() ?? const [],
      ));
    }

    final precioItems = items.fold<double>(0, (s, i) => s + i.precioTotal);
    final costoTotal = items.fold<double>(0, (s, i) => s + i.costoTotal);
    final partes =
        items.map((i) => '${cantidadStr(i.cantidad)}x ${i.nombre}').toList();

    return Pedido(
      cliente: Cliente(nombre: cotizacion.cliente, telefono: telefono),
      descripcion: partes.isEmpty ? descripcionFallback : partes.join(', '),
      fechaPedido: DateTime.now(),
      fechaEntrega: fechaEntrega,
      precio: cotizacion.total,
      costo: costoTotal,
      items: items,
      // Adiciones + domicilio − descuento + IVA, resumidos en un solo número
      // para que el total del pedido sea exactamente el cotizado. Queda
      // negativo si el descuento pesa más que los extras.
      otroValor: cotizacion.total - precioItems,
    );
  }

  double get ganancia => precio - costo;

  Map<String, dynamic> toMap() {
    return {
      'cliente': cliente.toMap(),
      'descripcion': descripcion,
      'fechaPedido': fechaPedido,
      'fechaEntrega': fechaEntrega,
      'precio': precio,
      'costo': costo,
      'entregado': entregado,
      'archivado': archivado,
      'items': items.map((i) => i.toMap()).toList(),
      'otroValor': otroValor,
    };
  }

  factory Pedido.fromMap(String id, Map<String, dynamic> map) {
    return Pedido(
      id: id,
      cliente: Cliente.fromMap(map['cliente'] as Map<String, dynamic>),
      descripcion: map['descripcion'] as String,
      fechaPedido: (map['fechaPedido'] as Timestamp).toDate(),
      fechaEntrega: (map['fechaEntrega'] as Timestamp).toDate(),
      precio: (map['precio'] as num).toDouble(),
      costo: (map['costo'] as num).toDouble(),
      entregado: map['entregado'] as bool,
      archivado: (map['archivado'] as bool?) ?? false,
      items: ((map['items'] as List?) ?? const [])
          .map((i) => ItemPedido.fromMap(i as Map<String, dynamic>))
          .toList(),
      otroValor: (map['otroValor'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// Cuánto consume el pedido de cada insumo, según la copia de receta que cada
/// ítem guardó al agregarse. Pura.
///
/// La usan dos sitios: el aviso previo de inventario insuficiente al convertir
/// una cotización, y el descuento real en `DatosApp.marcarPedidoEntregado`. Que
/// sea una sola función es lo que impide que el aviso y el descuento discrepen.
Map<String, double> consumoDeInsumos(Pedido pedido) {
  final consumo = <String, double>{};
  for (final item in pedido.items) {
    for (final r in item.receta) {
      consumo[r.insumoId] = (consumo[r.insumoId] ?? 0) + r.cantidad * item.cantidad;
    }
  }
  return consumo;
}

/// Nombres de los insumos cuyo stock actual no cubre lo que el pedido
/// consumiría. Lista vacía = alcanza para todo. Pura.
///
/// Un insumo que ya no está en el catálogo no se reporta: tampoco se descuenta
/// al entregar, así que avisar de él confundiría.
List<String> faltantesDeInventario(Pedido pedido, List<Insumo> insumos) {
  final faltantes = <String>[];
  consumoDeInsumos(pedido).forEach((insumoId, cantidad) {
    final idx = insumos.indexWhere((i) => i.id == insumoId);
    if (idx == -1) return;
    if (insumos[idx].stockActual < cantidad) faltantes.add(insumos[idx].nombre);
  });
  return faltantes;
}
