import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/insumo.dart';
import 'models/producto.dart';
import 'models/venta.dart';
import 'models/gasto.dart';
import 'models/cliente.dart';
import 'models/pedido.dart';
import 'models/ingrediente_de_receta.dart';
import 'models/resumen_mensual.dart';
import 'models/negocio.dart';
import 'formato.dart';
import 'models/nota.dart';
import 'models/guia_receta.dart';
import 'models/item_pedido.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'models/catalogo.dart';

enum EstadoApp { cargando, sinSesion, sinNegocio, listo }

const _mesesCorto = [
  'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
  'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
];

class PuntoTendencia {
  final String etiqueta;
  final double valor;
  PuntoTendencia(this.etiqueta, this.valor);
}

enum RangoTendencia { mes, tres, seis, anio }

class DatosApp extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  String? _negocioId; // a qué negocio pertenece el usuario actual
  EstadoApp estado = EstadoApp.cargando;
  Negocio? negocio;

  List<Insumo> insumos = [];
  List<Producto> productos = [];
  List<Cliente> clientes = [];
  List<Venta> ventas = [];
  List<Gasto> gastos = [];
  List<Pedido> pedidos = [];
  List<Nota> notas = [];
  List<GuiaReceta> recetas = [];
  List<Catalogo> catalogos = [];

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _productosRaw = [];
  final List<StreamSubscription> _suscripciones = [];

  DatosApp() {
    FirebaseAuth.instance.authStateChanges().listen((usuario) async {
      if (usuario != null) {
        estado = EstadoApp.cargando;
        notifyListeners();
        await _cargarNegocioId(usuario.uid);
        if (_negocioId != null) {
          _escucharTodo();
          estado = EstadoApp.listo;
        } else {
          estado = EstadoApp.sinNegocio;
        }
        notifyListeners();
      } else {
        estado = EstadoApp.sinSesion;
        _negocioId = null;
        negocio = null;        // limpia el negocio anterior
        reiniciarMoneda();     // vuelve la moneda a la de por defecto
        _detenerYLimpiar();
      }
    });
  }

Future<void> _cargarNegocioId(String uid) async {
    // 1) ¿A qué negocio pertenezco? Esto define si entras o no.
    try {
      final doc = await _db.collection('usuarios').doc(uid).get();
      _negocioId = doc.exists ? (doc.data()?['negocioId'] as String?) : null;
    } catch (e) {
      _negocioId = null;
      return;
    }

    // 2) Traer los datos del negocio (moneda, nombre). Si falla,
    //    NO perdemos el negocioId: entras igual, con la moneda por defecto.
    if (_negocioId != null) {
      try {
        final negDoc = await _db.collection('negocios').doc(_negocioId).get();
        if (negDoc.exists) {
          negocio = Negocio.fromMap(negDoc.id, negDoc.data()!);
          configurarMoneda(
            moneda: negocio!.moneda,
            idioma: negocio!.idioma,
            pais: negocio!.pais,
          );
        }
      } catch (e) {
        // Moneda por defecto; lo importante es que entres a tu negocio.
      }
    }
  }

  // Crea un negocio nuevo y enlaza al usuario actual
  Future<void> crearNegocio({
    required String nombre,
    required String pais,
    required String moneda,
    required String idioma,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = _db.collection('negocios').doc();
    await ref.set({
      'nombre': nombre,
      'pais': pais,
      'moneda': moneda,
      'idioma': idioma,
      'duenoUid': uid,
    });
    await _db.collection('usuarios').doc(uid).set({
      'negocioId': ref.id,
      'rol': 'dueno',
    });
    _negocioId = ref.id;
    negocio = Negocio(
      id: ref.id,
      nombre: nombre,
      pais: pais,
      moneda: moneda,
      idioma: idioma,
      duenoUid: uid,
    );
    configurarMoneda(moneda: moneda, idioma: idioma, pais: pais);
    _escucharTodo();
    estado = EstadoApp.listo;
    notifyListeners();
  }

  // Atajo: la colección X DENTRO de mi negocio
  CollectionReference<Map<String, dynamic>> _col(String nombre) =>
      _db.collection('negocios').doc(_negocioId).collection(nombre);

  // --- Agregar al catálogo ---
  void agregarInsumo(Insumo insumo) {
    insumos.add(insumo);
    _col('insumos').doc(insumo.id).set(insumo.toMap());
    notifyListeners();
  }

  void agregarProducto(Producto producto) {
    productos.add(producto);
    _col('productos').doc(producto.id).set(producto.toMap());
    notifyListeners();
  }

  void agregarCliente(Cliente cliente) {
    clientes.add(cliente);
    notifyListeners();
  }

  // --- Registrar movimientos ---
  void registrarVenta(Producto producto, int cantidad) {
    final venta = Venta(
      fecha: DateTime.now(),
      descripcion: producto.nombre,
      cantidad: cantidad,
      precioUnitario: producto.precioVenta,
      costoUnitario: producto.costoProduccion(),
    );
    ventas.add(venta);
    producto.descontarStock(cantidad);

    _col('ventas').doc(venta.id).set(venta.toMap());
    for (final ing in producto.receta) {
      _col('insumos').doc(ing.insumo.id).set(ing.insumo.toMap());
    }
    notifyListeners();
  }

  void registrarVentaManual(String descripcion, double valor) {
    final venta = Venta(
      fecha: DateTime.now(),
      descripcion: descripcion,
      cantidad: 1,
      precioUnitario: valor,
      costoUnitario: 0,
    );
    ventas.add(venta);
    _col('ventas').doc(venta.id).set(venta.toMap());
    notifyListeners();
  }

  void registrarGasto(Gasto gasto) {
    gastos.add(gasto);
    _col('gastos').doc(gasto.id).set(gasto.toMap());
    notifyListeners();
  }

  void registrarPedido(Pedido pedido) {
    pedidos.add(pedido);
    _col('pedidos').doc(pedido.id).set(pedido.toMap());
    notifyListeners();
  }

  void marcarPedidoEntregado(Pedido pedido) {
    pedido.entregado = true;
    _col('pedidos').doc(pedido.id).set(pedido.toMap());

    // El ingreso del pedido se registra como una venta propia: así aparece
    // en el historial y queda independiente del pedido (archivar/eliminar
    // el pedido ya no afecta los ingresos).
    final venta = Venta(
      fecha: DateTime.now(),
      descripcion: 'Pedido: ${pedido.cliente.nombre} — ${pedido.descripcion}',
      cantidad: 1,
      precioUnitario: pedido.precio,
      costoUnitario: pedido.costo,
    );
    ventas.add(venta);
    _col('ventas').doc(venta.id).set(venta.toMap());

    notifyListeners();
  }

  void archivarPedido(Pedido pedido) {
    pedido.archivado = true;
    _col('pedidos').doc(pedido.id).set(pedido.toMap());
    notifyListeners();
  }

  void desarchivarPedido(Pedido pedido) {
    pedido.archivado = false;
    _col('pedidos').doc(pedido.id).set(pedido.toMap());
    notifyListeners();
  }

  // --- Editar y eliminar insumos ---
  void editarInsumo(
    Insumo insumo, {
    required String nombre,
    required String unidad,
    required double costoPorUnidad,
    required double stockActual,
  }) {
    insumo.nombre = nombre;
    insumo.unidad = unidad;
    insumo.costoPorUnidad = costoPorUnidad;
    insumo.stockActual = stockActual;
    _col('insumos').doc(insumo.id).set(insumo.toMap());
    notifyListeners();
  }

  bool insumoEstaEnUso(Insumo insumo) {
    for (var producto in productos) {
      for (var ing in producto.receta) {
        if (ing.insumo == insumo) return true;
      }
    }
    return false;
  }

  void eliminarInsumo(Insumo insumo) {
    insumos.remove(insumo);
    _col('insumos').doc(insumo.id).delete();
    notifyListeners();
  }

  // --- Editar y eliminar gastos ---
  void editarGasto(
    Gasto gasto, {
    required String descripcion,
    required CategoriaGasto categoria,
    required double monto,
  }) {
    gasto.descripcion = descripcion;
    gasto.categoria = categoria;
    gasto.monto = monto;
    _col('gastos').doc(gasto.id).set(gasto.toMap());
    notifyListeners();
  }

  void eliminarGasto(Gasto gasto) {
    gastos.remove(gasto);
    _col('gastos').doc(gasto.id).delete();
    notifyListeners();
  }

  // --- Editar y eliminar ventas ---
  void editarVenta(
    Venta venta, {
    required String descripcion,
    required int cantidad,
    required double precioUnitario,
  }) {
    venta.descripcion = descripcion;
    venta.cantidad = cantidad;
    venta.precioUnitario = precioUnitario;
    _col('ventas').doc(venta.id).set(venta.toMap());
    notifyListeners();
  }

  void eliminarVenta(Venta venta) {
    ventas.remove(venta);
    _col('ventas').doc(venta.id).delete();
    notifyListeners();
  }

  // --- Editar y eliminar productos ---
  void editarProducto(
    Producto producto, {
    required String nombre,
    required String tipo,
    required double precioVenta,
    required List<IngredienteDeReceta> receta,
  }) {
    producto.nombre = nombre;
    producto.tipo = tipo;
    producto.precioVenta = precioVenta;
    producto.receta = receta;
    _col('productos').doc(producto.id).set(producto.toMap());
    notifyListeners();
  }

  void eliminarProducto(Producto producto) {
    productos.remove(producto);
    _col('productos').doc(producto.id).delete();
    notifyListeners();
  }

  // --- Editar y eliminar pedidos ---
  void editarPedido(
    Pedido pedido, {
    required String clienteNombre,
    required String clienteTelefono,
    required String descripcion,
    required DateTime fechaEntrega,
    required double precio,
    required double costo,
    required List<ItemPedido> items,
    required double otroValor,
  }) {
    pedido.cliente.nombre = clienteNombre;
    pedido.cliente.telefono = clienteTelefono;
    pedido.descripcion = descripcion;
    pedido.fechaEntrega = fechaEntrega;
    pedido.precio = precio;
    pedido.costo = costo;
    pedido.items = items;
    pedido.otroValor = otroValor;
    _col('pedidos').doc(pedido.id).set(pedido.toMap());
    notifyListeners();
  }

  void eliminarPedido(Pedido pedido) {
    pedidos.remove(pedido);
    _col('pedidos').doc(pedido.id).delete();
    notifyListeners();
  }

  void agregarNota(Nota nota) {
    notas.add(nota);
    _col('notas').doc(nota.id).set(nota.toMap());
    notifyListeners();
  }

  void editarNota(Nota nota,
      {required String asunto, required String contenido}) {
    nota.asunto = asunto;
    nota.contenido = contenido;
    nota.fecha = DateTime.now();
    _col('notas').doc(nota.id).set(nota.toMap());
    notifyListeners();
  }

  void eliminarNota(Nota nota) {
    notas.remove(nota);
    _col('notas').doc(nota.id).delete();
    notifyListeners();
  }

  void agregarReceta(GuiaReceta r) {
    recetas.add(r);
    _col('recetas').doc(r.id).set(r.toMap());
    notifyListeners();
  }

  void editarReceta(GuiaReceta r,
      {required String titulo,
      required List<String> ingredientes,
      required List<String> pasos}) {
    r.titulo = titulo;
    r.ingredientes = ingredientes;
    r.pasos = pasos;
    r.fecha = DateTime.now();
    _col('recetas').doc(r.id).set(r.toMap());
    notifyListeners();
  }

  void eliminarReceta(GuiaReceta r) {
    recetas.remove(r);
    _col('recetas').doc(r.id).delete();
    notifyListeners();
  }

  Future<void> agregarCatalogo({
    required String nombre,
    required Uint8List bytes,
    required String nombreArchivo,
  }) async {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final path = 'negocios/$_negocioId/catalogos/${id}_$nombreArchivo';
    final ref = _storage.ref(path);
    await ref.putData(bytes, SettableMetadata(contentType: 'application/pdf'));
    final url = await ref.getDownloadURL();
    final cat = Catalogo(
        id: id, nombre: nombre, url: url, path: path, fecha: DateTime.now());
    await _col('catalogos').doc(id).set(cat.toMap());
    notifyListeners();
  }

  Future<void> eliminarCatalogo(Catalogo c) async {
    try {
      await _storage.ref(c.path).delete();
    } catch (_) {
      // Si el archivo ya no existe, igual borramos el registro.
    }
    await _col('catalogos').doc(c.id).delete();
    catalogos.removeWhere((x) => x.id == c.id);
    notifyListeners();
  }

  // --- Reportes ---
  double get ingresosTotales {
    double total = 0;
    for (Venta v in ventas) {
      total += v.total;
    }
    return total;
  }

  double get gastosTotales {
    double total = 0;
    for (Gasto g in gastos) {
      total += g.monto;
    }
    return total;
  }

  double get ganancia => ingresosTotales - gastosTotales;

  // --- Totales dentro de un rango (para el panel del inicio) ---
  (DateTime, DateTime) _limitesRango(RangoTendencia rango) {
    final ahora = DateTime.now();
    final fin = DateTime(ahora.year, ahora.month + 1, 1);
    if (rango == RangoTendencia.mes) {
      return (DateTime(ahora.year, ahora.month, 1), fin);
    }
    final n = rango == RangoTendencia.tres
        ? 3
        : (rango == RangoTendencia.seis ? 6 : 12);
    return (DateTime(ahora.year, ahora.month - (n - 1), 1), fin);
  }

  double ingresosEnRango(RangoTendencia rango) {
    final (ini, fin) = _limitesRango(rango);
    double total = 0;
    for (final v in ventas) {
      if (!v.fecha.isBefore(ini) && v.fecha.isBefore(fin)) total += v.total;
    }
    return total;
  }

  double gastosEnRango(RangoTendencia rango) {
    final (ini, fin) = _limitesRango(rango);
    double total = 0;
    for (final g in gastos) {
      if (!g.fecha.isBefore(ini) && g.fecha.isBefore(fin)) total += g.monto;
    }
    return total;
  }

  double gananciaEnRango(RangoTendencia rango) =>
      ingresosEnRango(rango) - gastosEnRango(rango);

  List<ResumenMensual> get resumenPorMes {
    final mapa = <String, ResumenMensual>{};
    ResumenMensual delMes(int anio, int mes) {
      return mapa.putIfAbsent('$anio-$mes', () => ResumenMensual(anio, mes));
    }
    for (final v in ventas) {
      delMes(v.fecha.year, v.fecha.month).ingresos += v.total;
    }
    for (final g in gastos) {
      delMes(g.fecha.year, g.fecha.month).gastos += g.monto;
    }
    final lista = mapa.values.toList();
    lista.sort((a, b) {
      if (a.anio != b.anio) return a.anio.compareTo(b.anio);
      return a.mes.compareTo(b.mes);
    });
    return lista;
  }

  List<PuntoTendencia> tendenciaGanancia(RangoTendencia rango) {
    final ahora = DateTime.now();

    // Ganancia en el intervalo [ini, fin)  (fin es exclusivo)
    double gananciaEntre(DateTime ini, DateTime fin) {
      double ing = 0, gas = 0;
      for (final v in ventas) {
        if (!v.fecha.isBefore(ini) && v.fecha.isBefore(fin)) ing += v.total;
      }
      for (final g in gastos) {
        if (!g.fecha.isBefore(ini) && g.fecha.isBefore(fin)) gas += g.monto;
      }
      return ing - gas;
    }

    final puntos = <PuntoTendencia>[];

    if (rango == RangoTendencia.mes) {
      // Día por día, del 1 hasta hoy
      for (int d = 1; d <= ahora.day; d++) {
        final ini = DateTime(ahora.year, ahora.month, d);
        final fin = DateTime(ahora.year, ahora.month, d + 1);
        puntos.add(PuntoTendencia('$d', gananciaEntre(ini, fin)));
      }
    } else {
      final n = rango == RangoTendencia.tres
          ? 3
          : (rango == RangoTendencia.seis ? 6 : 12);
      for (int i = n - 1; i >= 0; i--) {
        final ini = DateTime(ahora.year, ahora.month - i, 1);
        final fin = DateTime(ahora.year, ahora.month - i + 1, 1);
        puntos.add(PuntoTendencia(_mesesCorto[ini.month - 1], gananciaEntre(ini, fin)));
      }
    }
    return puntos;
  }

  // --- Escuchar la nube en vivo, dentro del negocio ---
  void _escucharTodo() {
    if (_negocioId == null) return;       // sin negocio, no hay qué escuchar
    if (_suscripciones.isNotEmpty) return;

    _suscripciones.add(
      _col('insumos').snapshots().listen((snap) {
        insumos = snap.docs.map((d) => Insumo.fromMap(d.id, d.data())).toList();
        _reconstruirProductos();
        notifyListeners();
      }),
    );
    _suscripciones.add(
      _col('productos').snapshots().listen((snap) {
        _productosRaw = snap.docs;
        _reconstruirProductos();
        notifyListeners();
      }),
    );
    _suscripciones.add(
      _col('gastos').snapshots().listen((snap) {
        gastos = snap.docs.map((d) => Gasto.fromMap(d.id, d.data())).toList();
        notifyListeners();
      }),
    );
    _suscripciones.add(
      _col('ventas').snapshots().listen((snap) {
        ventas = snap.docs.map((d) => Venta.fromMap(d.id, d.data())).toList();
        notifyListeners();
      }),
    );
    _suscripciones.add(
      _col('pedidos').snapshots().listen((snap) {
        pedidos = snap.docs.map((d) => Pedido.fromMap(d.id, d.data())).toList();
        notifyListeners();
      }),
    );
    _suscripciones.add(
      _col('notas').snapshots().listen((snap) {
        notas = snap.docs.map((d) => Nota.fromMap(d.id, d.data())).toList();
        notifyListeners();
      }),
    );
    _suscripciones.add(
      _col('recetas').snapshots().listen((snap) {
        recetas =
            snap.docs.map((d) => GuiaReceta.fromMap(d.id, d.data())).toList();
        notifyListeners();
      }),
    );
    _suscripciones.add(
      _col('catalogos').snapshots().listen((snap) {
        catalogos =
            snap.docs.map((d) => Catalogo.fromMap(d.id, d.data())).toList();
        notifyListeners();
      }),
    );
  }

  void _detenerYLimpiar() {
    for (final s in _suscripciones) {
      s.cancel();
    }
    _suscripciones.clear();
    insumos = [];
    productos = [];
    clientes = [];
    ventas = [];
    gastos = [];
    pedidos = [];
    notas = [];
    recetas = [];
    catalogos = [];
    _productosRaw = [];
    notifyListeners();
  }

  void _reconstruirProductos() {
    productos = _productosRaw
        .map((d) => Producto.fromMap(d.id, d.data(), insumos))
        .toList();
  }
}