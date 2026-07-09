// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get ajustesTitulo => 'Ajustes';

  @override
  String get miNegocio => 'Mi negocio';

  @override
  String get perfil => 'Perfil';

  @override
  String get perfilSubtitulo => 'Tu información personal';

  @override
  String get datosEmpresa => 'Datos de la empresa';

  @override
  String get datosEmpresaSubtitulo => 'Nombre, NIT, contacto y ubicación';

  @override
  String get notificaciones => 'Notificaciones';

  @override
  String get notificacionesSubtitulo => 'Avisos de pedidos, notas e inventario';

  @override
  String get ajustesSeguridad => 'Ajustes y seguridad';

  @override
  String get ajustesSeguridadSubtitulo => 'País, moneda, idioma y contraseña';

  @override
  String get apariencia => 'Apariencia';

  @override
  String get aparienciaSubtitulo => 'Tema y modo oscuro';

  @override
  String get idioma => 'Idioma';

  @override
  String get idiomaSubtitulo => 'Idioma de la aplicación';

  @override
  String get idiomaAutomatico => 'Automático (dispositivo)';

  @override
  String get idiomaTituloDialogo => 'Elige un idioma';

  @override
  String get acercaDe => 'Acerca de';

  @override
  String get acercaDeSubtitulo => 'Versión e información de la app';

  @override
  String get acercaDeDescripcion => 'App de contabilidad para tu negocio.';

  @override
  String get cerrarSesion => 'Cerrar sesión';

  @override
  String get cerrarSesionConfirmacion => '¿Seguro que quieres cerrar sesión?';

  @override
  String get cancelar => 'Cancelar';

  @override
  String get campoCorreo => 'Correo';

  @override
  String get campoContrasena => 'Contraseña';

  @override
  String get crearCuenta => 'Crea tu cuenta';

  @override
  String get iniciarSesion => 'Iniciar sesión';

  @override
  String get iniciaSesion => 'Inicia sesión';

  @override
  String get errorCorreoInvalido => 'El correo no es válido';

  @override
  String get loginBienvenido => 'Bienvenido';

  @override
  String get loginSubtitulo => 'Inicia sesión para gestionar tu negocio';

  @override
  String get loginRecordarCorreo => 'Recordar mi correo';

  @override
  String get loginEresNuevo => '¿Eres nuevo?';

  @override
  String get loginCompletaCampos => 'Escribe tu correo y contraseña';

  @override
  String get loginErrorGeneral => 'No se pudo iniciar sesión';

  @override
  String get loginErrorNoExiste => 'No existe una cuenta con ese correo';

  @override
  String get loginErrorCredenciales => 'Correo o contraseña incorrectos';

  @override
  String get registroSubtitulo => 'Regístrate para empezar con tu negocio';

  @override
  String get registroMinimo => 'Mínimo 6 caracteres';

  @override
  String get registroBoton => 'Crear cuenta';

  @override
  String get registroYaTienes => '¿Ya tienes cuenta?';

  @override
  String get registroCompletaCampos =>
      'Escribe un correo y una contraseña de mínimo 6 caracteres';

  @override
  String get registroErrorGeneral => 'No se pudo crear la cuenta';

  @override
  String get registroErrorEnUso => 'Ese correo ya tiene cuenta';

  @override
  String get registroErrorDebil => 'La contraseña es muy débil';

  @override
  String get crearHubTitulo => 'Crear y gestionar';

  @override
  String get inventario => 'Inventario';

  @override
  String get inventarioSub => 'Insumos, costos y stock';

  @override
  String get productos => 'Productos';

  @override
  String get productosSub => 'Crea y administra tus productos';

  @override
  String get pedidos => 'Pedidos';

  @override
  String get pedidosSub => 'Encargos de clientes';

  @override
  String get recetas => 'Recetas';

  @override
  String get recetasSub => 'Guías de preparación paso a paso';

  @override
  String get catalogo => 'Catálogo';

  @override
  String get catalogoSub => 'Tus catálogos en PDF';

  @override
  String get onboardingBienvenido => '¡Bienvenido!';

  @override
  String get onboardingSubtitulo =>
      'Cuéntanos de tu microempresa para personalizar la app';

  @override
  String get onboardingNombreNegocio => 'Nombre del negocio';

  @override
  String get onboardingNombreVacio => 'Escribe el nombre de tu negocio';

  @override
  String get onboardingCrearBoton => 'Crear mi negocio';

  @override
  String get onboardingBuscarPais => 'Buscar país';

  @override
  String get campoPais => 'País';

  @override
  String get campoMoneda => 'Moneda';

  @override
  String errorGenerico(String detalle) {
    return 'Error: $detalle';
  }

  @override
  String get panelUsuario => 'Panel de usuario';

  @override
  String get buscar => 'Buscar';

  @override
  String get busquedaProximamente => 'Búsqueda próximamente';

  @override
  String get agregarVenta => 'Agregar venta';

  @override
  String get agregarGasto => 'Agregar gasto';

  @override
  String get navInicio => 'Inicio';

  @override
  String get navCrear => 'Crear';

  @override
  String get navReportes => 'Reportes';

  @override
  String get rangoEsteMes => 'Este mes';

  @override
  String get rango3Meses => '3 meses';

  @override
  String get rango6Meses => '6 meses';

  @override
  String get rangoAnio => 'Año';

  @override
  String get resumen => 'Resumen';

  @override
  String get ingresos => 'Ingresos';

  @override
  String get gastos => 'Gastos';

  @override
  String get ganancia => 'Ganancia';

  @override
  String get tendenciaGanancia => 'Tendencia de ganancia';

  @override
  String get graficaSinDatos => 'Aún no hay datos suficientes para mostrar.';

  @override
  String get pedidosProximos => 'Pedidos próximos';

  @override
  String get verTodos => 'Ver todos';

  @override
  String get sinPedidosPendientes => 'No tienes pedidos pendientes.';

  @override
  String get pedidoAtrasado => 'Atrasado';

  @override
  String get hoy => 'Hoy';

  @override
  String get manana => 'Mañana';

  @override
  String enDias(int dias) {
    return 'En $dias días';
  }

  @override
  String get notasImportantes => 'Notas importantes';

  @override
  String get nuevaNota => 'Nueva nota';

  @override
  String get sinNotas => 'No tienes notas. Crea una con el +';

  @override
  String get eliminar => 'Eliminar';

  @override
  String get editar => 'Editar';

  @override
  String get campoNombre => 'Nombre';

  @override
  String get unidadMedida => 'Unidad de medida';

  @override
  String get unidadGramos => 'Gramos (g)';

  @override
  String get unidadMililitros => 'Mililitros (ml)';

  @override
  String get unidadUnidades => 'Unidades';

  @override
  String get stockMinimoOpcional => 'Stock mínimo (opcional)';

  @override
  String get stockMinimoHint => 'Avisar cuando baje de...';

  @override
  String get buscarHint => 'Buscar...';

  @override
  String get insumo => 'Insumo';

  @override
  String get buscarInsumoHint => 'Buscar insumo...';

  @override
  String get cerrarBusqueda => 'Cerrar búsqueda';

  @override
  String get inventarioVacio =>
      'Aún no hay insumos.\nAgrega el primero con el botón +';

  @override
  String get inventarioSinCoincidencias =>
      'Ningún insumo coincide con la búsqueda.';

  @override
  String get eliminarInsumoTitulo => 'Eliminar insumo';

  @override
  String eliminarInsumoConfirmacion(String nombre) {
    return '¿Seguro que quieres eliminar $nombre?';
  }

  @override
  String insumoNoEliminarEnUso(String nombre) {
    return 'No puedes eliminar $nombre: lo usa un producto';
  }

  @override
  String costoPorUnidadTexto(String costo, String unidad) {
    return '$costo por $unidad';
  }

  @override
  String stockTexto(String cantidad, String unidad) {
    return 'Stock: $cantidad $unidad';
  }

  @override
  String get completaCamposValidos =>
      'Completa todos los campos con valores válidos';

  @override
  String get agregarInsumoTitulo => 'Agregar insumo';

  @override
  String get insumoNombreHint => 'Ej: Harina';

  @override
  String get cantidadComprada => 'Cantidad comprada';

  @override
  String get cantidadCompradaHint => 'Ej: 1000';

  @override
  String get precioTotalPagado => 'Precio total pagado';

  @override
  String get agregarInsumoAyuda =>
      'Con la cantidad y el precio, la app calcula sola el costo por unidad.';

  @override
  String get guardarInsumo => 'Guardar insumo';

  @override
  String get revisaCamposNegativos =>
      'Revisa los campos: valores válidos, sin negativos';

  @override
  String get editarInsumoTitulo => 'Editar insumo';

  @override
  String get costoPorUnidadLabel => 'Costo por unidad';

  @override
  String get stockActualLabel => 'Stock actual';

  @override
  String get guardarCambios => 'Guardar cambios';

  @override
  String get elegirInsumoTitulo => 'Elegir insumo';

  @override
  String get ningunInsumoCoincide => 'Ningún insumo coincide.';

  @override
  String get nuevo => 'Nuevo';

  @override
  String get costo => 'Costo';

  @override
  String get margen => 'Margen';

  @override
  String get cantidad => 'Cantidad';

  @override
  String get sinTipo => 'Sin tipo';

  @override
  String get tipoProducto => 'Tipo de producto';

  @override
  String get precioVenta => 'Precio de venta';

  @override
  String get recetaTitulo => 'Receta';

  @override
  String get eliminarProductoTitulo => 'Eliminar producto';

  @override
  String eliminarProductoConfirmacion(String nombre) {
    return '¿Eliminar «$nombre»? Las ventas ya registradas no se modifican.';
  }

  @override
  String get productosVacio =>
      'Aún no tienes productos.\nCrea uno con el botón +';

  @override
  String gananciaTexto(String valor) {
    return 'Ganancia: $valor';
  }

  @override
  String get eligeInsumoCantidad => 'Elige un insumo y una cantidad válida';

  @override
  String get insumoYaEnReceta => 'Ese insumo ya está en la receta';

  @override
  String get faltaNombrePrecioIngrediente =>
      'Falta el nombre, el precio o al menos un ingrediente';

  @override
  String get crearProductoTitulo => 'Crear producto';

  @override
  String get editarProductoTitulo => 'Editar producto';

  @override
  String get nombreProducto => 'Nombre del producto';

  @override
  String get nombreProductoHint => 'Ej: Torta de chocolate';

  @override
  String get recetaAyuda =>
      'Agrega los insumos y cantidades que lleva una unidad';

  @override
  String get recetaSinInsumos =>
      'Primero agrega insumos en la pantalla de Inventario.';

  @override
  String get sinInsumosInventario => 'No hay insumos en el inventario.';

  @override
  String get sinIngredientes => 'Aún no has agregado ingredientes.';

  @override
  String get recetaVacia => 'La receta está vacía.';

  @override
  String ingredienteSubtitulo(String cantidad, String unidad, String costo) {
    return '$cantidad $unidad  ·  $costo';
  }

  @override
  String get guardarProducto => 'Guardar producto';

  @override
  String get elegirProductoTitulo => 'Elegir producto';

  @override
  String get ningunProductoCoincide => 'Ningún producto coincide.';

  @override
  String get crearTipoHint => 'Crear tipo de producto, ej: Bebidas';

  @override
  String get sinTipos => 'Aún no has creado tipos.';

  @override
  String get recetasVacio => 'Aún no tienes recetas.\nCrea una con el botón +';

  @override
  String recetaSubtitulo(int ingredientes, int pasos) {
    return '$ingredientes ingredientes · $pasos pasos';
  }

  @override
  String get eliminarRecetaTitulo => 'Eliminar receta';

  @override
  String eliminarRecetaConfirmacion(String titulo) {
    return '¿Seguro que quieres eliminar «$titulo»?';
  }

  @override
  String get recetaNoExiste => 'Esta receta ya no existe.';

  @override
  String get ingredientesLabel => 'Ingredientes';

  @override
  String get preparacion => 'Preparación';

  @override
  String get recetaFaltaTituloPaso => 'Escribe el título y al menos un paso';

  @override
  String get editarRecetaTitulo => 'Editar receta';

  @override
  String get nuevaRecetaTitulo => 'Nueva receta';

  @override
  String get tituloReceta => 'Título de la receta';

  @override
  String get ingredientesHint => 'Un ingrediente por línea';

  @override
  String get pasosPreparacion => 'Pasos de preparación';

  @override
  String get pasosHint => 'Un paso por línea';

  @override
  String get recetaEditorAyuda =>
      'Escribe cada ingrediente y cada paso en su propia línea (Enter para separar).';

  @override
  String get guardarReceta => 'Guardar receta';

  @override
  String get confirmarVenta => 'Confirmar venta';

  @override
  String confirmarVentaProducto(String nombre, String precio) {
    return '¿Registrar la venta de $nombre por $precio?';
  }

  @override
  String get vender => 'Vender';

  @override
  String ventaProductoRegistrada(String nombre) {
    return 'Venta de $nombre registrada';
  }

  @override
  String get ventaDescripcionValor =>
      'Escribe una descripción y un valor válido';

  @override
  String confirmarVentaManual(String descripcion, String valor) {
    return '¿Registrar la venta «$descripcion» por $valor?';
  }

  @override
  String get registrar => 'Registrar';

  @override
  String get ventaRegistrada => 'Venta registrada';

  @override
  String get ingresarVentaTitulo => 'Ingresar venta';

  @override
  String get ventaRapida => 'Venta rápida';

  @override
  String get ventaRapidaAyuda =>
      'Para ventas que no son de un producto del catálogo';

  @override
  String get descripcion => 'Descripción';

  @override
  String get ventaDescripcionHint => 'Ej: café, domicilio…';

  @override
  String get valor => 'Valor';

  @override
  String get registrarVenta => 'Registrar venta';

  @override
  String get venderProducto => 'Vender un producto';

  @override
  String productosFiltro(String tipo) {
    return 'Productos: $tipo';
  }

  @override
  String get filtrarPorTipo => 'Filtrar por tipo';

  @override
  String get todos => 'Todos';

  @override
  String get sinProductosVenta =>
      'No hay productos. Créalos desde el menú Crear.';

  @override
  String get revisaCamposMayorCero =>
      'Revisa los campos: valores válidos y mayores a cero';

  @override
  String get editarVentaTitulo => 'Editar venta';

  @override
  String get precioUnitario => 'Precio unitario';

  @override
  String get eliminarVentaTitulo => 'Eliminar venta';

  @override
  String get eliminarVentaConfirmacion =>
      'Esto corrige los ingresos, pero no devuelve los insumos al inventario. ¿Quieres continuar?';

  @override
  String get historialVentasTitulo => 'Historial de ventas';

  @override
  String get sinVentas => 'Aún no hay ventas registradas.';

  @override
  String get mesLabel => 'Mes:';

  @override
  String sinVentasEnMes(String mes) {
    return 'No hubo ventas en $mes.';
  }

  @override
  String ventaSubtitulo(String fecha, int cantidad) {
    return '$fecha  ·  Cant: $cantidad';
  }

  @override
  String get analisisVentasTitulo => 'Análisis de ventas';

  @override
  String get sinVentasAnalizar => 'Aún no hay ventas para analizar.';

  @override
  String get resumenGeneral => 'Resumen general';

  @override
  String get ticketPromedio => 'Ticket promedio';

  @override
  String get numVentasLabel => 'Nº de ventas';

  @override
  String get totalVendido => 'Total vendido';

  @override
  String get demandaPorMes => 'Demanda por mes';

  @override
  String demandaFuerteFlojo(String fuerte, String flojo) {
    return 'Más fuerte: $fuerte · Más flojo: $flojo';
  }

  @override
  String get ventasPorDia => 'Ventas por día de la semana';

  @override
  String mejorDia(String dia) {
    return 'Tu mejor día es el $dia';
  }

  @override
  String get sinDatosSuficientes => 'Sin datos suficientes';

  @override
  String get fechasPico => 'Fechas pico';

  @override
  String get fechasPicoAyuda =>
      'Tus días con más ventas (ahí están tus fechas especiales)';

  @override
  String get topProductosTitulo => 'Top de productos';

  @override
  String get sinVentasProductos =>
      'Aún no hay ventas de productos registradas.';

  @override
  String get sinVentasProductosMes =>
      'No hubo ventas de productos en este mes.';

  @override
  String totalTexto(String valor) {
    return 'Total: $valor';
  }

  @override
  String get categoriaInsumos => 'Insumos';

  @override
  String get categoriaServicios => 'Servicios';

  @override
  String get categoriaEmpaques => 'Empaques';

  @override
  String get categoriaOtros => 'Otros';

  @override
  String get gastoDescripcionMonto =>
      'Escribe una descripción y un monto válido';

  @override
  String get confirmarGasto => 'Confirmar gasto';

  @override
  String confirmarGastoTexto(String descripcion, String monto) {
    return '¿Registrar el gasto «$descripcion» por $monto?';
  }

  @override
  String get guardar => 'Guardar';

  @override
  String get primeroCreaInsumos => 'Primero crea insumos en Inventario.';

  @override
  String get insumoYaEnLista => 'Ese insumo ya está en la lista.';

  @override
  String cantidadCompradaUnidad(String unidad) {
    return 'Cantidad comprada ($unidad)';
  }

  @override
  String get totalPagado => 'Total pagado';

  @override
  String get agregar => 'Agregar';

  @override
  String get cantidadTotalMayorCero =>
      'Cantidad y total deben ser mayores a cero.';

  @override
  String get agregaAlMenosInsumo => 'Agrega al menos un insumo.';

  @override
  String get confirmarCompra => 'Confirmar compra';

  @override
  String confirmarCompraTexto(int cantidad, String total) {
    return '¿Registrar la compra de $cantidad insumo(s) por $total? Se sumará el stock y se registrará el gasto.';
  }

  @override
  String get registrarGastoTitulo => 'Registrar gasto';

  @override
  String get gastoNormal => 'Gasto normal';

  @override
  String get compraInsumos => 'Compra de insumos';

  @override
  String get gastoDescripcionHint => 'Ej: pago de arriendo';

  @override
  String get monto => 'Monto';

  @override
  String get categoria => 'Categoría';

  @override
  String get guardarGasto => 'Guardar gasto';

  @override
  String get compraInsumosAyuda =>
      'Agrega los insumos que compraste. Se sumará su stock y el costo por unidad se recalcula (promedio ponderado).';

  @override
  String get agregarInsumoBtn => 'Agregar insumo';

  @override
  String get sinInsumosAgregados => 'Aún no has agregado insumos.';

  @override
  String get descripcionOpcional => 'Descripción (opcional)';

  @override
  String get compraDescHint => 'Ej: compra en la plaza';

  @override
  String get totalGasto => 'Total del gasto';

  @override
  String get guardarCompraReponer => 'Guardar compra y reponer stock';

  @override
  String get eliminarGastoTitulo => 'Eliminar gasto';

  @override
  String eliminarGastoConfirmacion(String descripcion) {
    return '¿Seguro que quieres eliminar «$descripcion»?';
  }

  @override
  String get historialGastosTitulo => 'Historial de gastos';

  @override
  String get sinGastos => 'Aún no hay gastos registrados.';

  @override
  String sinGastosEnMes(String mes) {
    return 'No hubo gastos en $mes.';
  }

  @override
  String gastoSubtitulo(String fecha, String categoria) {
    return '$fecha  ·  $categoria';
  }

  @override
  String get editarGastoTitulo => 'Editar gasto';

  @override
  String get entregarPedido => 'Entregar pedido';

  @override
  String entregarPedidoTexto(String precio) {
    return 'Al marcar este pedido como entregado, su valor de $precio se registrará como un ingreso y aparecerá en tu historial de ventas.';
  }

  @override
  String get pedidoEntregadoOk => 'Pedido entregado y registrado en ingresos';

  @override
  String pedidoEntregadoNegativo(String insumos) {
    return 'Entregado. Stock en negativo: $insumos';
  }

  @override
  String get entregar => 'Entregar';

  @override
  String get eliminarPedidoTitulo => 'Eliminar pedido';

  @override
  String get eliminarPedidoEntregado =>
      'Este pedido ya fue entregado. Su ingreso ya quedó registrado como una venta y NO se modificará al eliminarlo.';

  @override
  String eliminarPedidoConfirmacion(String cliente) {
    return '¿Seguro que quieres eliminar el pedido de $cliente?';
  }

  @override
  String get pedidoArchivado => 'Pedido archivado';

  @override
  String get deshacer => 'Deshacer';

  @override
  String get pedidoFab => 'Pedido';

  @override
  String get pedidosVacio =>
      'Aún no hay pedidos.\nCrea el primero con el botón +';

  @override
  String get pendientes => 'Pendientes';

  @override
  String get entregados => 'Entregados';

  @override
  String get sinEntregados => 'Aún no has entregado pedidos.';

  @override
  String get ocultarArchivados => 'Ocultar archivados';

  @override
  String verArchivadosBtn(int n) {
    return 'Ver archivados ($n)';
  }

  @override
  String get archivar => 'Archivar';

  @override
  String get desarchivar => 'Desarchivar';

  @override
  String get entregadoEstado => 'Entregado';

  @override
  String get archivadoEstado => 'Archivado';

  @override
  String get marcarEntregado => 'Marcar como entregado';

  @override
  String get sinProductosCreados => 'Aún no tienes productos creados';

  @override
  String get itemManual => 'Ítem manual';

  @override
  String get costoUnitarioOpcional => 'Costo unitario (opcional)';

  @override
  String get faltaClienteItemFecha =>
      'Falta el cliente, al menos un ítem (o valor) y la fecha';

  @override
  String get faltaClienteItem =>
      'Falta el cliente o al menos un ítem (o valor)';

  @override
  String get otroValorItem => 'Otro valor';

  @override
  String get pedidoFallback => 'Pedido';

  @override
  String get nuevoPedidoTitulo => 'Nuevo pedido';

  @override
  String get nombreCliente => 'Nombre del cliente';

  @override
  String get telefonoOpcional => 'Teléfono (opcional)';

  @override
  String get productosDelPedido => 'Productos del pedido';

  @override
  String get delCatalogo => 'Del catálogo';

  @override
  String get manual => 'Manual';

  @override
  String get sinItemsCrear => 'Agrega productos del catálogo o ítems manuales.';

  @override
  String get otroValorLabel => 'Otro valor (domicilio, servicios...)';

  @override
  String get precio => 'Precio';

  @override
  String get fechaEntrega => 'Fecha de entrega';

  @override
  String get sinElegir => 'Sin elegir';

  @override
  String get elegir => 'Elegir';

  @override
  String get guardarPedido => 'Guardar pedido';

  @override
  String get editarPedidoTitulo => 'Editar pedido';

  @override
  String get editarPedidoEntregado =>
      'Este pedido ya fue entregado. Editarlo no cambia el ingreso ya registrado.';

  @override
  String get sinItemsEditar => 'Sin ítems. Agrega del catálogo o manuales.';

  @override
  String get cambiar => 'Cambiar';

  @override
  String get analisisYReportes => 'Análisis y reportes';

  @override
  String get reportesVacio =>
      'Aún no hay datos para analizar.\nRegistra ventas y gastos para ver tus reportes.';

  @override
  String gananciaDeMes(String mes) {
    return 'Ganancia de $mes';
  }

  @override
  String get sinComparacion => '— sin comparación';

  @override
  String mesAnterior(String mes, String valor) {
    return 'Mes anterior ($mes): $valor';
  }

  @override
  String get gananciaPorMes => 'Ganancia por mes';

  @override
  String get reportesMensuales => 'Reportes mensuales';

  @override
  String get reportesMensualesSub =>
      'Descarga el extracto en PDF de cada mes cerrado';

  @override
  String get pdfError => 'No se pudo generar el PDF.';

  @override
  String get sinMesesCerrados =>
      'Aún no hay meses cerrados para reportar.\nAl terminar el mes actual, aparecerá aquí.';

  @override
  String ingresosGastos(String ingresos, String gastos) {
    return 'Ingresos: $ingresos  ·  Gastos: $gastos';
  }

  @override
  String get descargarPdf => 'Descargar PDF';

  @override
  String get topProductosMes => 'Top productos del mes';

  @override
  String get topSinVentasMes => 'Aún no hay ventas de productos este mes.';

  @override
  String vendidosAbrev(int cantidad) {
    return '$cantidad vend.';
  }

  @override
  String resumenAnalisisCorto(String ticket, String dia) {
    return 'Ticket promedio $ticket · Mejor día: $dia';
  }

  @override
  String get verMas => 'Ver más';

  @override
  String get nombreCatalogo => 'Nombre del catálogo';

  @override
  String get subir => 'Subir';

  @override
  String get errorLeerArchivo => 'No se pudo leer el archivo.';

  @override
  String get soloPdf => 'Por ahora solo se admiten archivos PDF.';

  @override
  String get archivoSupera15 => 'El archivo supera el límite de 15 MB.';

  @override
  String get errorSubirCatalogo =>
      'No se pudo subir el catálogo. Intenta de nuevo.';

  @override
  String get errorAbrirCatalogo => 'No se pudo abrir el catálogo.';

  @override
  String get eliminarCatalogoTitulo => 'Eliminar catálogo';

  @override
  String eliminarCatalogoConfirmacion(String nombre) {
    return '¿Eliminar «$nombre»? El archivo PDF se borrará.';
  }

  @override
  String get errorEliminar => 'No se pudo eliminar.';

  @override
  String get subiendo => 'Subiendo...';

  @override
  String get subirPdf => 'Subir PDF';

  @override
  String get catalogosVacio =>
      'Aún no tienes catálogos.\nSube un PDF con el botón de abajo.';

  @override
  String get abrir => 'Abrir';

  @override
  String get notaFaltaAsunto => 'Escribe al menos el asunto de la nota';

  @override
  String get editarNotaTitulo => 'Editar nota';

  @override
  String get asunto => 'Asunto';

  @override
  String get contenido => 'Contenido';

  @override
  String get notaContenidoHint => 'Escribe el detalle de la nota...';

  @override
  String get guardarNota => 'Guardar nota';

  @override
  String get eliminarNotaTitulo => 'Eliminar nota';

  @override
  String eliminarNotaConfirmacion(String asunto) {
    return '¿Seguro que quieres eliminar «$asunto»?';
  }

  @override
  String get notaTitulo => 'Nota';

  @override
  String get notaNoExiste => 'Esta nota ya no existe.';

  @override
  String notaPorAutor(String fecha, String autor) {
    return '$fecha  ·  Por $autor';
  }

  @override
  String get sinContenido => '(Sin contenido)';

  @override
  String get entregaHoy => 'Entrega hoy';

  @override
  String get entregaManana => 'Entrega mañana';

  @override
  String get sinAvisos => 'No tienes avisos por ahora. ¡Todo al día!';

  @override
  String avisoPedidoDetalle(String urgencia, String precio) {
    return '$urgencia  ·  $precio';
  }

  @override
  String get inventarioBajo => 'Inventario bajo';

  @override
  String insumoBajoDetalle(String stock, String unidad, String minimo) {
    return 'Quedan $stock $unidad (mínimo $minimo)';
  }

  @override
  String get notasNuevas => 'Notas nuevas';

  @override
  String porAutor(String autor) {
    return 'Por $autor';
  }

  @override
  String get notifConfigAyuda =>
      'Elige qué avisos quieres recibir dentro de la app.';

  @override
  String get notifPedidosSub => 'Entregas de hoy, mañana o atrasadas';

  @override
  String get notifNotasSub => 'Cuando alguien crea una nota';

  @override
  String get notifInsumosSub => 'Insumos por debajo de su stock mínimo';

  @override
  String get modo => 'Modo';

  @override
  String get modoClaro => 'Claro';

  @override
  String get modoOscuro => 'Oscuro';

  @override
  String get modoAuto => 'Automático (según el sistema)';

  @override
  String get colorAcento => 'Color de acento';

  @override
  String get acentoVerde => 'Verde';

  @override
  String get acentoAzul => 'Azul';

  @override
  String get acentoTurquesa => 'Turquesa';

  @override
  String get acentoMorado => 'Morado';

  @override
  String get acentoNaranja => 'Naranja';

  @override
  String get acentoRosa => 'Rosa';

  @override
  String get aparienciaNota =>
      'El tema y el color de acento se aplican a toda la app.';

  @override
  String get completaCampos => 'Completa todos los campos.';

  @override
  String get passwordMin6 =>
      'La nueva contraseña debe tener al menos 6 caracteres.';

  @override
  String get passwordNoCoincide =>
      'La nueva contraseña y su confirmación no coinciden.';

  @override
  String get sinSesionValida => 'No hay una sesión válida.';

  @override
  String get passwordActualizada => 'Contraseña actualizada';

  @override
  String get passwordActualIncorrecta => 'La contraseña actual es incorrecta.';

  @override
  String get passwordDebil => 'La nueva contraseña es muy débil.';

  @override
  String get requiereReloginPassword =>
      'Por seguridad, vuelve a iniciar sesión e intenta de nuevo.';

  @override
  String get demasiadosIntentos =>
      'Demasiados intentos. Espera un momento e inténtalo de nuevo.';

  @override
  String get errorCambiarPassword =>
      'No se pudo cambiar la contraseña. Intenta de nuevo.';

  @override
  String get cambiarContrasena => 'Cambiar contraseña';

  @override
  String get passwordActual => 'Contraseña actual';

  @override
  String get passwordNueva => 'Nueva contraseña';

  @override
  String get passwordConfirmar => 'Confirmar nueva contraseña';

  @override
  String get guardando => 'Guardando...';

  @override
  String get errorLeerImagen => 'No se pudo leer la imagen.';

  @override
  String get imagenSupera5 => 'La imagen supera el límite de 5 MB.';

  @override
  String get fotoActualizada => 'Foto actualizada';

  @override
  String get errorSubirFoto => 'No se pudo subir la foto.';

  @override
  String get logoActualizado => 'Logo actualizado';

  @override
  String get errorSubirLogo => 'No se pudo subir el logo. ¿Eres el dueño?';

  @override
  String get quitar => 'Quitar';

  @override
  String get quitarFoto => 'Quitar foto';

  @override
  String get quitarFotoConfirmacion => '¿Quitar tu foto de perfil?';

  @override
  String get fotoEliminada => 'Foto eliminada';

  @override
  String get errorEliminarFoto => 'No se pudo eliminar la foto.';

  @override
  String get quitarLogo => 'Quitar logo';

  @override
  String get quitarLogoConfirmacion => '¿Quitar el logo de la empresa?';

  @override
  String get logoEliminado => 'Logo eliminado';

  @override
  String get errorEliminarLogo => 'No se pudo eliminar el logo.';

  @override
  String get logoEmpresa => 'Logo de la empresa';

  @override
  String get subirLogo => 'Subir logo';

  @override
  String get cambiarLogo => 'Cambiar logo';

  @override
  String get soloDuenoCambia => 'Solo el dueño puede cambiarlo';

  @override
  String get perfilGuardado => 'Perfil guardado';

  @override
  String get errorGuardarPerfil => 'No se pudo guardar el perfil.';

  @override
  String get nombreEmpresaVacio =>
      'El nombre de la empresa no puede quedar vacío.';

  @override
  String get empresaGuardada => 'Datos de la empresa guardados';

  @override
  String get errorGuardarEmpresa =>
      'No se pudo guardar. ¿Eres el dueño del negocio?';

  @override
  String get tocaCamara => 'Toca la cámara para cambiar tu foto';

  @override
  String get informacionPersonal => 'Información personal';

  @override
  String get correoCuenta => 'Correo (de tu cuenta)';

  @override
  String get celular => 'Celular';

  @override
  String get guardarPerfil => 'Guardar perfil';

  @override
  String get soloLectura => 'Solo lectura';

  @override
  String get soloDuenoEdita =>
      'Solo el dueño del negocio puede editar estos datos.';

  @override
  String get nombreEmpresa => 'Nombre de la empresa';

  @override
  String get nit => 'NIT';

  @override
  String get correoEmpresa => 'Correo de la empresa';

  @override
  String get telefono => 'Teléfono';

  @override
  String get ubicacion => 'Ubicación';

  @override
  String get guardarEmpresa => 'Guardar empresa';

  @override
  String get preferenciasNegocio => 'Preferencias del negocio';

  @override
  String get ajustesSeguridadCaption =>
      'El idioma de la aplicación se puede cambiar aquí y se aplica a toda la app. País y moneda no se pueden cambiar por ahora.';

  @override
  String get seguridad => 'Seguridad';

  @override
  String get notas => 'Notas';

  @override
  String get buscadorHint => 'Buscar en tu negocio...';

  @override
  String get buscadorInicio =>
      'Busca productos, insumos, pedidos, recetas, notas y catálogos.';

  @override
  String buscadorSinResultados(String q) {
    return 'Sin resultados para «$q»';
  }

  @override
  String get miembrosInvitaciones => 'Miembros e invitaciones';

  @override
  String get miembrosInvitacionesSub => 'Invita a tu equipo y gestiona roles';

  @override
  String get invitacionesTitulo => 'Invitaciones';

  @override
  String get generarInvitacion => 'Generar invitación';

  @override
  String get miembrosTitulo => 'Miembros';

  @override
  String get rolDueno => 'Dueño';

  @override
  String get rolSocio => 'Socio';

  @override
  String get rolEmpleado => 'Empleado';

  @override
  String get elegirRolInvitacion => '¿Qué rol tendrá la persona?';

  @override
  String get invitacionCreada => 'Invitación creada';

  @override
  String get codigoInvitacion => 'Código de invitación';

  @override
  String get copiar => 'Copiar';

  @override
  String get copiado => 'Copiado';

  @override
  String get compartirCodigoAyuda =>
      'Comparte este código. La persona lo usa al registrarse para unirse a tu negocio.';

  @override
  String get revocar => 'Revocar';

  @override
  String get invitacionPendiente => 'Pendiente';

  @override
  String get invitacionUsada => 'Usada';

  @override
  String get sinInvitaciones => 'No has generado invitaciones.';

  @override
  String get sinMiembros => 'Aún no hay otros miembros.';

  @override
  String get cambiarRolTitulo => 'Cambiar rol';

  @override
  String get quitarDelNegocio => 'Quitar del negocio';

  @override
  String quitarMiembroConfirmacion(String nombre) {
    return '¿Quitar a $nombre del negocio?';
  }

  @override
  String get unirseCodigo => 'Unirme con un código';

  @override
  String get unirseCodigoTitulo => 'Unirse a un negocio';

  @override
  String get unirseCodigoAyuda =>
      'Escribe el código de invitación que te compartió el dueño del negocio.';

  @override
  String get unirme => 'Unirme';

  @override
  String get codigoVacio => 'Escribe el código.';

  @override
  String get codigoNoExiste => 'El código no existe.';

  @override
  String get codigoUsado => 'Ese código ya fue usado.';

  @override
  String get codigoInvalido => 'El código no es válido.';

  @override
  String get unirseError => 'No se pudo unir. Intenta de nuevo.';

  @override
  String get sinNombre => '(sin nombre)';
}
