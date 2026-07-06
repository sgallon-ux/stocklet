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
import 'package:shared_preferences/shared_preferences.dart';

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

class ProductoVendido {
  final String nombre;
  final int cantidad;
  final double total;
  ProductoVendido(this.nombre, this.cantidad, this.total);
}

class AnalisisVentas {
  final int numVentas;
  final double totalVendido;
  final double ticketPromedio;
  final List<MapEntry<String, double>> porMes;      // 'Mmm aaaa' -> total
  final List<MapEntry<int, double>> porDiaSemana;   // 1=Lun..7=Dom -> total
  final List<MapEntry<DateTime, double>> fechasPico; // día -> total
  AnalisisVentas({
    required this.numVentas,
    required this.totalVendido,
    required this.ticketPromedio,
    required this.porMes,
    required this.porDiaSemana,
    required this.fechasPico,
  });
}

class DatosApp extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  String? _negocioId; // a qué negocio pertenece el usuario actual
  EstadoApp estado = EstadoApp.cargando;
  Negocio? negocio;
  String perfilNombre = '';
  String perfilCelular = '';
  String perfilFotoUrl = '';
  bool notifPedidos = true;
  bool notifNotas = true;
  bool notifInsumos = true;
  String acentoId = 'verde';
  String modoTemaId = 'claro'; // 'claro' | 'oscuro' | 'auto'

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
    _cargarPrefsNotif();
    FirebaseAuth.instance.authStateChanges().listen((usuario) async {
      if (usuario != null) {
        estado = EstadoApp.cargando;
        notifyListeners();
        await _cargarNegocioId(usuario.uid);
        if (_negocioId != null) {
          _escucharTodo();
          await _cargarUltimaRevision();
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
      perfilNombre = (doc.data()?['nombre'] as String?) ?? '';
      perfilCelular = (doc.data()?['celular'] as String?) ?? '';
      perfilFotoUrl = (doc.data()?['fotoUrl'] as String?) ?? '';
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

  // Guarda los datos personales del usuario (en usuarios/{uid})
  Future<void> guardarPerfil(
      {required String nombre, required String celular}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await _db.collection('usuarios').doc(uid).set(
      {'nombre': nombre, 'celular': celular},
      SetOptions(merge: true),
    );
    perfilNombre = nombre;
    perfilCelular = celular;
    notifyListeners();
  }

  Future<void> _cargarPrefsNotif() async {
    final prefs = await SharedPreferences.getInstance();
    notifPedidos = prefs.getBool('notifPedidos') ?? true;
    notifNotas = prefs.getBool('notifNotas') ?? true;
    notifInsumos = prefs.getBool('notifInsumos') ?? true;
    acentoId = prefs.getString('acentoId') ?? 'verde';
    modoTemaId = prefs.getString('modoTemaId') ?? 'claro';
    notifyListeners();
  }

  Future<void> setNotif({bool? pedidos, bool? notas, bool? insumos}) async {
    final prefs = await SharedPreferences.getInstance();
    if (pedidos != null) {
      notifPedidos = pedidos;
      await prefs.setBool('notifPedidos', pedidos);
    }
    if (notas != null) {
      notifNotas = notas;
      await prefs.setBool('notifNotas', notas);
    }
    if (insumos != null) {
      notifInsumos = insumos;
      await prefs.setBool('notifInsumos', insumos);
    }
    notifyListeners();
  }

  Future<void> setAcento(String id) async {
    acentoId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('acentoId', id);
    notifyListeners();
  }

  Future<void> setModoTema(String id) async {
    modoTemaId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('modoTemaId', id);
    notifyListeners();
  }

  // --- Avisos en-app (respetan los interruptores) ---
  List<Pedido> get avisosPedidos {
    if (!notifPedidos) return [];
    return pedidos.where((p) {
      if (p.entregado || p.archivado) return false;
      final hoy = DateTime.now();
      final a = DateTime(hoy.year, hoy.month, hoy.day);
      final b = DateTime(
          p.fechaEntrega.year, p.fechaEntrega.month, p.fechaEntrega.day);
      return b.difference(a).inDays <= 1; // atrasados, hoy y mañana
    }).toList()
      ..sort((x, y) => x.fechaEntrega.compareTo(y.fechaEntrega));
  }

  List<Insumo> get avisosInsumos {
    if (!notifInsumos) return [];
    return insumos.where((i) => i.bajoMinimo).toList()
      ..sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
  }

  List<Nota> get avisosNotas {
    if (!notifNotas) return [];
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return notas.where((n) {
      if (n.autorUid == uid) return false; // no aviso de mis propias notas
      return n.fecha.isAfter(_notasUltimaRevision);
    }).toList()
      ..sort((a, b) => b.fecha.compareTo(a.fecha));
  }

  int get totalAvisos =>
      avisosPedidos.length + avisosInsumos.length + avisosNotas.length;

  DateTime _notasUltimaRevision = DateTime.fromMillisecondsSinceEpoch(0);

  Future<void> _cargarUltimaRevision() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (uid.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt('notasUltimaRevision_$uid') ?? 0;
    _notasUltimaRevision = DateTime.fromMillisecondsSinceEpoch(ms);
    notifyListeners();
  }

  Future<void> marcarNotasRevisadas() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (uid.isEmpty) return;
    final ahora = DateTime.now();
    _notasUltimaRevision = ahora;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'notasUltimaRevision_$uid', ahora.millisecondsSinceEpoch);
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
    required double stockMinimo,
  }) {
    insumo.nombre = nombre;
    insumo.unidad = unidad;
    insumo.costoPorUnidad = costoPorUnidad;
    insumo.stockActual = stockActual;
    insumo.stockMinimo = stockMinimo;
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
    // Autor: nombre de Perfil (o correo como respaldo) + uid
    final user = FirebaseAuth.instance.currentUser;
    nota.autorUid = user?.uid ?? '';
    nota.autorNombre =
        perfilNombre.isNotEmpty ? perfilNombre : (user?.email ?? '');
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
  
  // --- Top de productos (solo nombres que existen en el catálogo) ---
  List<ProductoVendido> topProductos(int anio, int mes) {
    final nombres = productos.map((p) => p.nombre).toSet();
    final cant = <String, int>{};
    final tot = <String, double>{};
    for (final v in ventas) {
      if (v.fecha.year != anio || v.fecha.month != mes) continue;
      if (!nombres.contains(v.descripcion)) continue;
      cant[v.descripcion] = (cant[v.descripcion] ?? 0) + v.cantidad;
      tot[v.descripcion] = (tot[v.descripcion] ?? 0) + v.total;
    }
    final lista = cant.keys
        .map((n) => ProductoVendido(n, cant[n]!, tot[n]!))
        .toList()
      ..sort((a, b) => b.cantidad.compareTo(a.cantidad));
    return lista;
  }

  // Meses (día 1) que tienen al menos una venta de un producto del catálogo.
  List<DateTime> mesesConVentasDeProductos() {
    final nombres = productos.map((p) => p.nombre).toSet();
    final vistos = <String>{};
    final lista = <DateTime>[];
    for (final v in ventas) {
      if (!nombres.contains(v.descripcion)) continue;
      final clave = '${v.fecha.year}-${v.fecha.month}';
      if (vistos.add(clave)) lista.add(DateTime(v.fecha.year, v.fecha.month, 1));
    }
    lista.sort((a, b) => b.compareTo(a)); // más reciente primero
    return lista;
  }

  // --- Análisis de todas las ventas (productos, manuales y pedidos) ---
  AnalisisVentas analisisVentas() {
    if (ventas.isEmpty) {
      return AnalisisVentas(
        numVentas: 0,
        totalVendido: 0,
        ticketPromedio: 0,
        porMes: const [],
        porDiaSemana: const [],
        fechasPico: const [],
      );
    }

    double total = 0;
    final porMesMapa = <String, double>{};
    final ordenMes = <String, DateTime>{};
    final porDia = <int, double>{};
    final porFecha = <DateTime, double>{};

    for (final v in ventas) {
      total += v.total;

      final claveMes =
          '${_mesesCorto[v.fecha.month - 1]} ${v.fecha.year}';
      porMesMapa[claveMes] = (porMesMapa[claveMes] ?? 0) + v.total;
      ordenMes[claveMes] = DateTime(v.fecha.year, v.fecha.month, 1);

      porDia[v.fecha.weekday] = (porDia[v.fecha.weekday] ?? 0) + v.total;

      final dia = DateTime(v.fecha.year, v.fecha.month, v.fecha.day);
      porFecha[dia] = (porFecha[dia] ?? 0) + v.total;
    }

    // Meses ordenados cronológicamente
    final porMes = porMesMapa.entries.toList()
      ..sort((a, b) => ordenMes[a.key]!.compareTo(ordenMes[b.key]!));

    // Día de la semana ordenado Lun..Dom
    final porDiaSemana = [
      for (int d = 1; d <= 7; d++) MapEntry(d, porDia[d] ?? 0.0)
    ];

    // Fechas pico: top 5 días por total
    final fechasPico = porFecha.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return AnalisisVentas(
      numVentas: ventas.length,
      totalVendido: total,
      ticketPromedio: total / ventas.length,
      porMes: porMes,
      porDiaSemana: porDiaSemana,
      fechasPico: fechasPico.take(5).toList(),
    );
  }

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
    perfilNombre = '';
    perfilCelular = '';
    perfilFotoUrl = '';
    _productosRaw = [];
    notifyListeners();
  }

  // Sube/reemplaza el logo del negocio (solo el dueño, según las reglas)
  Future<void> guardarLogo(Uint8List bytes, String contentType) async {
    if (_negocioId == null || negocio == null) return;
    final ref = _storage.ref('negocios/$_negocioId/logo/imagen');
    await ref.putData(bytes, SettableMetadata(contentType: contentType));
    final url = await ref.getDownloadURL();
    await _db.collection('negocios').doc(_negocioId).set(
      {'logoUrl': url},
      SetOptions(merge: true),
    );
    negocio!.logoUrl = url;
    notifyListeners();
  }

  // Quitar la foto de perfil (borra el archivo y limpia la URL)
  Future<void> eliminarFotoPerfil() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      await _storage.ref('usuarios/$uid/foto_perfil').delete();
    } catch (_) {
      // Si el archivo ya no existe, igual limpiamos la URL.
    }
    await _db.collection('usuarios').doc(uid).set(
      {'fotoUrl': ''},
      SetOptions(merge: true),
    );
    perfilFotoUrl = '';
    notifyListeners();
  }

  // Quitar el logo de la empresa (solo el dueño, según las reglas)
  Future<void> eliminarLogo() async {
    if (_negocioId == null || negocio == null) return;
    try {
      await _storage.ref('negocios/$_negocioId/logo/imagen').delete();
    } catch (_) {
      // Si el archivo ya no existe, igual limpiamos la URL.
    }
    await _db.collection('negocios').doc(_negocioId).set(
      {'logoUrl': ''},
      SetOptions(merge: true),
    );
    negocio!.logoUrl = '';
    notifyListeners();
  }

  // Actualiza los datos de la empresa (solo el dueño, según las reglas)
  Future<void> editarNegocioDatos({
    required String nombre,
    required String nit,
    required String correo,
    required String tel,
    required String ubicacion,
  }) async {
    if (_negocioId == null || negocio == null) return;
    await _db.collection('negocios').doc(_negocioId).set(
      {
        'nombre': nombre,
        'nit': nit,
        'correo': correo,
        'tel': tel,
        'ubicacion': ubicacion,
      },
      SetOptions(merge: true),
    );
    negocio!.nombre = nombre;
    negocio!.nit = nit;
    negocio!.correo = correo;
    negocio!.tel = tel;
    negocio!.ubicacion = ubicacion;
    notifyListeners();
  }

  // Sube/reemplaza la foto de perfil (privada) y guarda su URL
  Future<void> guardarFotoPerfil(Uint8List bytes, String contentType) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final ref = _storage.ref('usuarios/$uid/foto_perfil');
    await ref.putData(bytes, SettableMetadata(contentType: contentType));
    final url = await ref.getDownloadURL();
    await _db.collection('usuarios').doc(uid).set(
      {'fotoUrl': url},
      SetOptions(merge: true),
    );
    perfilFotoUrl = url;
    notifyListeners();
  }

  void _reconstruirProductos() {
    productos = _productosRaw
        .map((d) => Producto.fromMap(d.id, d.data(), insumos))
        .toList();
  }
}