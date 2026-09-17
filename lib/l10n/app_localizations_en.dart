// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get ajustesTitulo => 'Settings';

  @override
  String get miNegocio => 'My business';

  @override
  String get perfil => 'Profile';

  @override
  String get perfilSubtitulo => 'Your personal information';

  @override
  String get datosEmpresa => 'Business details';

  @override
  String get datosEmpresaSubtitulo => 'Name, tax ID, contact and location';

  @override
  String get notificaciones => 'Notifications';

  @override
  String get notificacionesSubtitulo => 'Order and inventory alerts';

  @override
  String get ajustesSeguridad => 'Settings and security';

  @override
  String get ajustesSeguridadSubtitulo =>
      'Country, currency, language and password';

  @override
  String get apariencia => 'Appearance';

  @override
  String get aparienciaSubtitulo => 'Theme and dark mode';

  @override
  String get idioma => 'Language';

  @override
  String get idiomaSubtitulo => 'App language';

  @override
  String get idiomaAutomatico => 'Automatic (device)';

  @override
  String get idiomaTituloDialogo => 'Choose a language';

  @override
  String get acercaDe => 'About';

  @override
  String get acercaDeSubtitulo => 'App version and information';

  @override
  String get acercaDeDescripcion => 'Accounting app for your business.';

  @override
  String get cerrarSesion => 'Sign out';

  @override
  String get cerrarSesionConfirmacion => 'Are you sure you want to sign out?';

  @override
  String get cancelar => 'Cancel';

  @override
  String get campoCorreo => 'Email';

  @override
  String get campoContrasena => 'Password';

  @override
  String get crearCuenta => 'Create your account';

  @override
  String get iniciarSesion => 'Sign in';

  @override
  String get iniciaSesion => 'Sign in';

  @override
  String get errorCorreoInvalido => 'The email is not valid';

  @override
  String get loginBienvenido => 'Welcome';

  @override
  String get loginSubtitulo => 'Sign in to manage your business';

  @override
  String get loginRecordarCorreo => 'Remember my email';

  @override
  String get loginEresNuevo => 'New here?';

  @override
  String get loginCompletaCampos => 'Enter your email and password';

  @override
  String get loginErrorGeneral => 'Could not sign in';

  @override
  String get loginErrorNoExiste => 'No account exists with that email';

  @override
  String get loginErrorCredenciales => 'Incorrect email or password';

  @override
  String get registroSubtitulo => 'Sign up to get started with your business';

  @override
  String get registroMinimo => 'At least 6 characters';

  @override
  String get registroBoton => 'Create account';

  @override
  String get registroYaTienes => 'Already have an account?';

  @override
  String get registroCompletaCampos =>
      'Enter an email and a password of at least 6 characters';

  @override
  String get registroErrorGeneral => 'Could not create the account';

  @override
  String get registroErrorEnUso => 'That email already has an account';

  @override
  String get registroErrorDebil => 'The password is too weak';

  @override
  String get crearHubTitulo => 'Create and manage';

  @override
  String get inventario => 'Inventory';

  @override
  String get inventarioSub => 'Supplies, costs and stock';

  @override
  String get productos => 'Products';

  @override
  String get productosSub => 'Create and manage your products';

  @override
  String get pedidos => 'Orders';

  @override
  String get pedidosSub => 'Customer orders';

  @override
  String get recetas => 'Recipes';

  @override
  String get recetasSub => 'Step-by-step preparation guides';

  @override
  String get catalogo => 'Catalog';

  @override
  String get catalogoSub => 'Your PDF catalogs';

  @override
  String get onboardingBienvenido => 'Welcome!';

  @override
  String get onboardingSubtitulo =>
      'Tell us about your business to personalize the app';

  @override
  String get onboardingNombreNegocio => 'Business name';

  @override
  String get onboardingNombreVacio => 'Enter your business name';

  @override
  String get onboardingCrearBoton => 'Create my business';

  @override
  String get onboardingBuscarPais => 'Search country';

  @override
  String get campoPais => 'Country';

  @override
  String get campoMoneda => 'Currency';

  @override
  String errorGenerico(String detalle) {
    return 'Error: $detalle';
  }

  @override
  String get panelUsuario => 'User panel';

  @override
  String get buscar => 'Search';

  @override
  String get busquedaProximamente => 'Search coming soon';

  @override
  String get agregarVenta => 'Add sale';

  @override
  String get agregarGasto => 'Add expense';

  @override
  String get navInicio => 'Home';

  @override
  String get navCrear => 'Create';

  @override
  String get navReportes => 'Reports';

  @override
  String get rangoEsteMes => 'This month';

  @override
  String get rango3Meses => '3 months';

  @override
  String get rango6Meses => '6 months';

  @override
  String get rangoAnio => 'Year';

  @override
  String get resumen => 'Summary';

  @override
  String get ingresos => 'Income';

  @override
  String get gastos => 'Expenses';

  @override
  String get ganancia => 'Profit';

  @override
  String get tendenciaGanancia => 'Profit trend';

  @override
  String get graficaSinDatos => 'Not enough data to show yet.';

  @override
  String get pedidosProximos => 'Upcoming orders';

  @override
  String get verTodos => 'See all';

  @override
  String get sinPedidosPendientes => 'You have no pending orders.';

  @override
  String get pedidoAtrasado => 'Overdue';

  @override
  String get hoy => 'Today';

  @override
  String get manana => 'Tomorrow';

  @override
  String enDias(int dias) {
    return 'In $dias days';
  }

  @override
  String get eliminar => 'Delete';

  @override
  String get editar => 'Edit';

  @override
  String get campoNombre => 'Name';

  @override
  String get unidadMedida => 'Unit of measure';

  @override
  String get unidadGramos => 'Grams (g)';

  @override
  String get unidadMililitros => 'Milliliters (ml)';

  @override
  String get unidadUnidades => 'Units';

  @override
  String get stockMinimoOpcional => 'Minimum stock (optional)';

  @override
  String get stockMinimoHint => 'Alert when it drops below...';

  @override
  String get buscarHint => 'Search...';

  @override
  String get insumo => 'Supply';

  @override
  String get buscarInsumoHint => 'Search supply...';

  @override
  String get cerrarBusqueda => 'Close search';

  @override
  String get inventarioVacio =>
      'No supplies yet.\nAdd the first one with the + button';

  @override
  String get inventarioSinCoincidencias => 'No supply matches the search.';

  @override
  String get eliminarInsumoTitulo => 'Delete supply';

  @override
  String eliminarInsumoConfirmacion(String nombre) {
    return 'Are you sure you want to delete $nombre?';
  }

  @override
  String insumoNoEliminarEnUso(String nombre) {
    return 'You can\'t delete $nombre: a product uses it';
  }

  @override
  String costoPorUnidadTexto(String costo, String unidad) {
    return '$costo per $unidad';
  }

  @override
  String stockTexto(String cantidad, String unidad) {
    return 'Stock: $cantidad $unidad';
  }

  @override
  String get completaCamposValidos => 'Fill in all fields with valid values';

  @override
  String get agregarInsumoTitulo => 'Add supply';

  @override
  String get insumoNombreHint => 'e.g. Flour';

  @override
  String get cantidadComprada => 'Quantity purchased';

  @override
  String get cantidadCompradaHint => 'e.g. 1000';

  @override
  String get precioTotalPagado => 'Total price paid';

  @override
  String get agregarInsumoAyuda =>
      'With the quantity and price, the app calculates the unit cost for you.';

  @override
  String get guardarInsumo => 'Save supply';

  @override
  String get revisaCamposNegativos =>
      'Check the fields: valid values, no negatives';

  @override
  String get editarInsumoTitulo => 'Edit supply';

  @override
  String get costoPorUnidadLabel => 'Cost per unit';

  @override
  String get stockActualLabel => 'Current stock';

  @override
  String get guardarCambios => 'Save changes';

  @override
  String get categoriaLabel => 'Category';

  @override
  String get cantidadQueCompras => 'Amount you buy';

  @override
  String get unidadDeCompra => 'Unit';

  @override
  String get precioPresentacionLabel => 'Price of that pack';

  @override
  String get proveedorOpcional => 'Supplier (optional)';

  @override
  String get insumoEspecialLabel => 'Special supply (sugar-free line)';

  @override
  String get insumoEspecialAyuda =>
      'Mark sugar substitutes and diabetic-friendly products.';

  @override
  String costoPorUnidadCalculado(String costo, String unidad) {
    return 'Cost: $costo per $unidad';
  }

  @override
  String get especialEtiqueta => 'sugar-free';

  @override
  String get traerDelCatalogo => 'Add from catalog';

  @override
  String get catalogoRefTitulo => 'Reference catalog';

  @override
  String get catalogoRefAyuda =>
      'These are common purchase packs. Price starts at zero: you set what you pay. Pick the ones you use.';

  @override
  String get buscarEnCatalogo => 'Search the catalog';

  @override
  String get marcarTodoVisible => 'Select all visible';

  @override
  String get catalogoTodoAgregado =>
      'You\'ve already added every catalog supply.';

  @override
  String insumosAgregadosN(int n) {
    return '$n supplies added';
  }

  @override
  String agregarSeleccionadosN(int n) {
    return 'Add $n';
  }

  @override
  String get prodBasico => 'Basics';

  @override
  String get prodRendimiento => 'How many units come out?';

  @override
  String get prodSinAzucar => 'It\'s from the sugar-free line';

  @override
  String get prodIngredientesLote => 'Ingredients (per batch)';

  @override
  String get prodEmpaque => 'Packaging (per unit)';

  @override
  String get prodTiemposMerma => 'Time and waste';

  @override
  String get prodMinutosPrep => 'Minutes of work';

  @override
  String get prodMinutosHorno => 'Oven minutes';

  @override
  String get prodMerma => 'Waste (%)';

  @override
  String get prodMermaAyuda =>
      'What gets damaged or tasted. Losing 10% raises cost 11.1%.';

  @override
  String get prodPrecioSeccion => 'Price';

  @override
  String get prodMetodoMargen => 'Margin method';

  @override
  String get prodMetodoDefault => 'From Settings';

  @override
  String get prodMetodoVenta => 'On sale price';

  @override
  String get prodMetodoMarkup => 'On cost (markup)';

  @override
  String get prodMargenReceta => 'Margin for this product (%)';

  @override
  String get prodMargenHint => 'From Settings';

  @override
  String get prodPrecioCobras => 'Price you charge';

  @override
  String prodSugeridoCorto(String precio) {
    return 'Suggested $precio';
  }

  @override
  String get costeoMateriaPrima => 'Raw materials';

  @override
  String get costeoEmpaque => 'Packaging';

  @override
  String get costeoManoObra => 'Labor';

  @override
  String get costeoEnergia => 'Energy';

  @override
  String get costeoGastosFijos => 'Fixed costs';

  @override
  String get costeoCostoUnidad => 'Cost per unit';

  @override
  String get costeoPrecioSugerido => 'Suggested price';

  @override
  String get costeoUsarSugerido => 'Use this price';

  @override
  String get costeoFijosIncompletos =>
      'Add your fixed costs and batches/month for the full cost.';

  @override
  String get costeoCompletar => 'Complete';

  @override
  String get estadoPerdida => 'Loss';

  @override
  String get estadoBajo => 'Underpriced';

  @override
  String get estadoBien => 'OK';

  @override
  String get ajustesCosteoTitulo => 'Costing settings';

  @override
  String get ajustesCosteoSub => 'Rate, fixed costs and margins';

  @override
  String get costeoNegocioTiempo => 'Your time and your oven';

  @override
  String get costeoTarifaHora => 'How much your work hour is worth';

  @override
  String get costeoEnergiaHoraLabel => 'Cost of one oven hour';

  @override
  String get costeoGastosMes => 'Monthly fixed costs';

  @override
  String get costeoConcepto => 'Item';

  @override
  String get costeoValorMensual => 'Monthly value';

  @override
  String get costeoAgregarConcepto => 'Add item';

  @override
  String get costeoLotesMes => 'Recipes or batches you make per month';

  @override
  String costeoTotalMensual(String total, String unidad) {
    return 'Monthly total: $total · per batch: $unidad';
  }

  @override
  String get costeoMargenSeccion => 'Margin and price';

  @override
  String get costeoMargenGeneral => 'General margin (%)';

  @override
  String get costeoMargenEspecial => 'Sugar-free margin (%)';

  @override
  String get costeoIva => 'VAT';

  @override
  String get costeoIvaAplica => 'Charge VAT';

  @override
  String get costeoIvaTasa => 'VAT rate (%)';

  @override
  String get costeoGuardado => 'Settings saved';

  @override
  String get cotizarTitulo => 'Quote';

  @override
  String get cotizarSub => 'Create quotes for your customers';

  @override
  String get nuevaCotizacion => 'New quote';

  @override
  String get cotizarVacio =>
      'Your quotes will appear here. Build the order and get it ready for WhatsApp and printing.';

  @override
  String get cotizarSinProductos => 'To quote you need products with a price.';

  @override
  String get cotizaSinCliente => 'No customer';

  @override
  String cotizaNumProductos(int n) {
    return '$n products';
  }

  @override
  String get cotizaEliminarTitulo => 'Delete quote';

  @override
  String get cotizaEliminarConfirm => 'Delete this quote?';

  @override
  String get cotizaCliente => 'Customer';

  @override
  String get cotizaFecha => 'Date';

  @override
  String get cotizaEstado => 'Status';

  @override
  String get cotizaProductosTitulo => 'Products';

  @override
  String get cotizaSinLineas => 'Add the first product to the order.';

  @override
  String get cotizaCantidad => 'Quantity';

  @override
  String get cotizaPrecioUnitario => 'Unit price';

  @override
  String get cotizaAgregarProducto => 'Add product';

  @override
  String get cotizaAdicionesTitulo => 'Add-ons and customizations';

  @override
  String get cotizaSinAdiciones =>
      'Toppers, figures, special decoration… anything charged separately.';

  @override
  String get cotizaAdicion => 'Add-on';

  @override
  String get cotizaValor => 'Value';

  @override
  String get cotizaAgregarAdicion => 'Add add-on';

  @override
  String get cotizaCierre => 'Closing';

  @override
  String get cotizaDomicilio => 'Delivery';

  @override
  String get cotizaDescuento => 'Discount';

  @override
  String get cotizaCobrarIva => 'Charge VAT on this quote';

  @override
  String get cotizaNota => 'Note for the customer';

  @override
  String get cotizaSubtotal => 'Subtotal';

  @override
  String get cotizaTotal => 'Total';

  @override
  String get cotizaGuardada => 'Quote saved.';

  @override
  String get cotizaCopiado => 'Text copied.';

  @override
  String get cotizaCopiar => 'Copy text';

  @override
  String get cotizaWhatsapp => 'WhatsApp';

  @override
  String get cotizaImprimir => 'Print';

  @override
  String get cotizacionTitulo => 'Quote';

  @override
  String get cotizaPara => 'For:';

  @override
  String get cotizaProducto => 'Product';

  @override
  String get cotizaValorUnitario => 'Unit value';

  @override
  String get cotizaPieValidez => 'Quote valid for 8 days.';

  @override
  String get estCotBorrador => 'Draft';

  @override
  String get estCotEnviada => 'Sent';

  @override
  String get estCotAceptada => 'Accepted';

  @override
  String get estCotEntregada => 'Delivered';

  @override
  String get estCotRechazada => 'Rejected';

  @override
  String get comparadorTitulo => 'Product comparison';

  @override
  String get comparadorVacio => 'You have no products to compare yet.';

  @override
  String get simuladorTitulo => 'Price-rise simulator';

  @override
  String get simuladorAyuda =>
      'See how your costs and prices change if supplies go up.';

  @override
  String get simuladorSinProductos => 'You have no products to simulate.';

  @override
  String get oportunidadTitulo => 'Money you leave on the table each month';

  @override
  String get oportunidadBien =>
      'No product is sold below its suggested price. Nice!';

  @override
  String oportunidadDetalle(int n) {
    return 'Adding up $n product(s) priced too low, based on your units/month.';
  }

  @override
  String oportunidadSinEstimado(int n) {
    return '$n product(s) priced too low. Add \"units per month\" to estimate the money.';
  }

  @override
  String oportunidadResumen(String monto) {
    return 'You\'re leaving ~$monto on the table monthly';
  }

  @override
  String get prodUnidadesMes => 'Units you sell per month (optional)';

  @override
  String get prodUnidadesMesAyuda =>
      'We use this to estimate how much money you leave on the table each month.';

  @override
  String get elegirInsumoTitulo => 'Choose supply';

  @override
  String get ningunInsumoCoincide => 'No supply matches.';

  @override
  String get nuevo => 'New';

  @override
  String get costo => 'Cost';

  @override
  String get margen => 'Margin';

  @override
  String get cantidad => 'Quantity';

  @override
  String get sinTipo => 'No type';

  @override
  String get tipoProducto => 'Product type';

  @override
  String get precioVenta => 'Sale price';

  @override
  String get recetaTitulo => 'Recipe';

  @override
  String get eliminarProductoTitulo => 'Delete product';

  @override
  String eliminarProductoConfirmacion(String nombre) {
    return 'Delete «$nombre»? Sales already recorded are not affected.';
  }

  @override
  String get productosVacio =>
      'You have no products yet.\nCreate one with the + button';

  @override
  String gananciaTexto(String valor) {
    return 'Profit: $valor';
  }

  @override
  String get eligeInsumoCantidad => 'Choose a supply and a valid quantity';

  @override
  String get insumoYaEnReceta => 'That supply is already in the recipe';

  @override
  String get faltaNombrePrecioIngrediente =>
      'Missing the name, price or at least one ingredient';

  @override
  String get crearProductoTitulo => 'Create product';

  @override
  String get editarProductoTitulo => 'Edit product';

  @override
  String get nombreProducto => 'Product name';

  @override
  String get nombreProductoHint => 'e.g. Chocolate cake';

  @override
  String get recetaAyuda =>
      'Add the supplies and quantities that go into one unit';

  @override
  String get recetaSinInsumos => 'First add supplies in the Inventory screen.';

  @override
  String get sinInsumosInventario => 'There are no supplies in the inventory.';

  @override
  String get sinIngredientes => 'You haven\'t added any ingredients yet.';

  @override
  String get recetaVacia => 'The recipe is empty.';

  @override
  String ingredienteSubtitulo(String cantidad, String unidad, String costo) {
    return '$cantidad $unidad  ·  $costo';
  }

  @override
  String get guardarProducto => 'Save product';

  @override
  String get elegirProductoTitulo => 'Choose product';

  @override
  String get ningunProductoCoincide => 'No product matches.';

  @override
  String get crearTipoHint => 'Create product type, e.g. Drinks';

  @override
  String get sinTipos => 'You haven\'t created any types yet.';

  @override
  String get recetasVacio =>
      'You have no recipes yet.\nCreate one with the + button';

  @override
  String recetaSubtitulo(int ingredientes, int pasos) {
    return '$ingredientes ingredients · $pasos steps';
  }

  @override
  String get eliminarRecetaTitulo => 'Delete recipe';

  @override
  String eliminarRecetaConfirmacion(String titulo) {
    return 'Are you sure you want to delete «$titulo»?';
  }

  @override
  String get recetaNoExiste => 'This recipe no longer exists.';

  @override
  String get ingredientesLabel => 'Ingredients';

  @override
  String get preparacion => 'Preparation';

  @override
  String get recetaFaltaTituloPaso => 'Write the title and at least one step';

  @override
  String get editarRecetaTitulo => 'Edit recipe';

  @override
  String get nuevaRecetaTitulo => 'New recipe';

  @override
  String get tituloReceta => 'Recipe title';

  @override
  String get ingredientesHint => 'One ingredient per line';

  @override
  String get pasosPreparacion => 'Preparation steps';

  @override
  String get pasosHint => 'One step per line';

  @override
  String get recetaEditorAyuda =>
      'Write each ingredient and each step on its own line (Enter to separate).';

  @override
  String get guardarReceta => 'Save recipe';

  @override
  String get confirmarVenta => 'Confirm sale';

  @override
  String confirmarVentaProducto(String nombre, String precio) {
    return 'Record the sale of $nombre for $precio?';
  }

  @override
  String get vender => 'Sell';

  @override
  String ventaProductoRegistrada(String nombre) {
    return 'Sale of $nombre recorded';
  }

  @override
  String get ventaDescripcionValor => 'Enter a description and a valid amount';

  @override
  String confirmarVentaManual(String descripcion, String valor) {
    return 'Record the sale «$descripcion» for $valor?';
  }

  @override
  String get registrar => 'Record';

  @override
  String get ventaRegistrada => 'Sale recorded';

  @override
  String get ingresarVentaTitulo => 'Record sale';

  @override
  String get ventaRapida => 'Quick sale';

  @override
  String get ventaRapidaAyuda =>
      'For sales that aren\'t a product from the catalog';

  @override
  String get descripcion => 'Description';

  @override
  String get ventaDescripcionHint => 'e.g. coffee, delivery…';

  @override
  String get valor => 'Amount';

  @override
  String get registrarVenta => 'Record sale';

  @override
  String get venderProducto => 'Sell a product';

  @override
  String productosFiltro(String tipo) {
    return 'Products: $tipo';
  }

  @override
  String get filtrarPorTipo => 'Filter by type';

  @override
  String get todos => 'All';

  @override
  String get sinProductosVenta =>
      'No products. Create them from the Create menu.';

  @override
  String get revisaCamposMayorCero =>
      'Check the fields: valid values greater than zero';

  @override
  String get editarVentaTitulo => 'Edit sale';

  @override
  String get precioUnitario => 'Unit price';

  @override
  String get eliminarVentaTitulo => 'Delete sale';

  @override
  String get eliminarVentaConfirmacion =>
      'This corrects the income, but doesn\'t return the supplies to inventory. Continue?';

  @override
  String get historialVentasTitulo => 'Sales history';

  @override
  String get sinVentas => 'No sales recorded yet.';

  @override
  String get mesLabel => 'Month:';

  @override
  String sinVentasEnMes(String mes) {
    return 'No sales in $mes.';
  }

  @override
  String ventaSubtitulo(String fecha, String cantidad) {
    return '$fecha  ·  Qty: $cantidad';
  }

  @override
  String get analisisVentasTitulo => 'Sales analysis';

  @override
  String get sinVentasAnalizar => 'No sales to analyze yet.';

  @override
  String get resumenGeneral => 'Overview';

  @override
  String get ticketPromedio => 'Average ticket';

  @override
  String get numVentasLabel => 'No. of sales';

  @override
  String get totalVendido => 'Total sold';

  @override
  String get demandaPorMes => 'Demand by month';

  @override
  String demandaFuerteFlojo(String fuerte, String flojo) {
    return 'Strongest: $fuerte · Weakest: $flojo';
  }

  @override
  String get ventasPorDia => 'Sales by day of the week';

  @override
  String mejorDia(String dia) {
    return 'Your best day is $dia';
  }

  @override
  String get sinDatosSuficientes => 'Not enough data';

  @override
  String get fechasPico => 'Peak dates';

  @override
  String get fechasPicoAyuda =>
      'Your days with the most sales (those are your special dates)';

  @override
  String get topProductosTitulo => 'Top products';

  @override
  String get sinVentasProductos => 'No product sales recorded yet.';

  @override
  String get sinVentasProductosMes => 'No product sales this month.';

  @override
  String totalTexto(String valor) {
    return 'Total: $valor';
  }

  @override
  String get categoriaInsumos => 'Supplies';

  @override
  String get categoriaServicios => 'Services';

  @override
  String get categoriaEmpaques => 'Packaging';

  @override
  String get categoriaOtros => 'Other';

  @override
  String get gastoDescripcionMonto => 'Enter a description and a valid amount';

  @override
  String get confirmarGasto => 'Confirm expense';

  @override
  String confirmarGastoTexto(String descripcion, String monto) {
    return 'Record the expense «$descripcion» for $monto?';
  }

  @override
  String get guardar => 'Save';

  @override
  String get primeroCreaInsumos => 'First create supplies in Inventory.';

  @override
  String get insumoYaEnLista => 'That supply is already in the list.';

  @override
  String cantidadCompradaUnidad(String unidad) {
    return 'Quantity purchased ($unidad)';
  }

  @override
  String get totalPagado => 'Total paid';

  @override
  String get agregar => 'Add';

  @override
  String get cantidadTotalMayorCero =>
      'Quantity and total must be greater than zero.';

  @override
  String get agregaAlMenosInsumo => 'Add at least one supply.';

  @override
  String get confirmarCompra => 'Confirm purchase';

  @override
  String confirmarCompraTexto(int cantidad, String total) {
    return 'Record the purchase of $cantidad supply(ies) for $total? Stock will be added and the expense recorded.';
  }

  @override
  String get registrarGastoTitulo => 'Record expense';

  @override
  String get gastoNormal => 'Regular expense';

  @override
  String get compraInsumos => 'Supply purchase';

  @override
  String get gastoDescripcionHint => 'e.g. rent payment';

  @override
  String get monto => 'Amount';

  @override
  String get categoria => 'Category';

  @override
  String get guardarGasto => 'Save expense';

  @override
  String get compraInsumosAyuda =>
      'Add the supplies you bought. Their stock is added and the unit cost is recalculated (weighted average).';

  @override
  String get agregarInsumoBtn => 'Add supply';

  @override
  String get sinInsumosAgregados => 'You haven\'t added any supplies yet.';

  @override
  String get descripcionOpcional => 'Description (optional)';

  @override
  String get compraDescHint => 'e.g. purchase at the market';

  @override
  String get totalGasto => 'Total expense';

  @override
  String get guardarCompraReponer => 'Save purchase and restock';

  @override
  String get eliminarGastoTitulo => 'Delete expense';

  @override
  String eliminarGastoConfirmacion(String descripcion) {
    return 'Are you sure you want to delete «$descripcion»?';
  }

  @override
  String get historialGastosTitulo => 'Expense history';

  @override
  String get sinGastos => 'No expenses recorded yet.';

  @override
  String sinGastosEnMes(String mes) {
    return 'No expenses in $mes.';
  }

  @override
  String gastoSubtitulo(String fecha, String categoria) {
    return '$fecha  ·  $categoria';
  }

  @override
  String get editarGastoTitulo => 'Edit expense';

  @override
  String get entregarPedido => 'Deliver order';

  @override
  String entregarPedidoTexto(String precio) {
    return 'By marking this order as delivered, its value of $precio will be recorded as income and appear in your sales history.';
  }

  @override
  String get pedidoEntregadoOk => 'Order delivered and recorded as income';

  @override
  String pedidoEntregadoNegativo(String insumos) {
    return 'Delivered. Negative stock: $insumos';
  }

  @override
  String get entregar => 'Deliver';

  @override
  String get eliminarPedidoTitulo => 'Delete order';

  @override
  String get eliminarPedidoEntregado =>
      'This order has already been delivered. Its income is already recorded as a sale and will NOT change when you delete it.';

  @override
  String eliminarPedidoConfirmacion(String cliente) {
    return 'Are you sure you want to delete $cliente\'s order?';
  }

  @override
  String get pedidoArchivado => 'Order archived';

  @override
  String get deshacer => 'Undo';

  @override
  String get pedidoFab => 'Order';

  @override
  String get pedidosVacio =>
      'No orders yet.\nCreate the first one with the + button';

  @override
  String get pendientes => 'Pending';

  @override
  String get entregados => 'Delivered';

  @override
  String get sinEntregados => 'You haven\'t delivered any orders yet.';

  @override
  String get ocultarArchivados => 'Hide archived';

  @override
  String verArchivadosBtn(int n) {
    return 'View archived ($n)';
  }

  @override
  String get archivar => 'Archive';

  @override
  String get desarchivar => 'Unarchive';

  @override
  String get entregadoEstado => 'Delivered';

  @override
  String get archivadoEstado => 'Archived';

  @override
  String get marcarEntregado => 'Mark as delivered';

  @override
  String get sinProductosCreados => 'You have no products created yet';

  @override
  String get itemManual => 'Manual item';

  @override
  String get costoUnitarioOpcional => 'Unit cost (optional)';

  @override
  String get faltaClienteItemFecha =>
      'Missing the customer, at least one item (or amount) and the date';

  @override
  String get faltaClienteItem =>
      'Missing the customer or at least one item (or amount)';

  @override
  String get otroValorItem => 'Other amount';

  @override
  String get pedidoFallback => 'Order';

  @override
  String get nuevoPedidoTitulo => 'New order';

  @override
  String get nombreCliente => 'Customer name';

  @override
  String get telefonoOpcional => 'Phone (optional)';

  @override
  String get productosDelPedido => 'Order products';

  @override
  String get delCatalogo => 'From catalog';

  @override
  String get manual => 'Manual';

  @override
  String get sinItemsCrear => 'Add products from the catalog or manual items.';

  @override
  String get otroValorLabel => 'Other amount (delivery, services...)';

  @override
  String get precio => 'Price';

  @override
  String get fechaEntrega => 'Delivery date';

  @override
  String get sinElegir => 'Not selected';

  @override
  String get elegir => 'Select';

  @override
  String get guardarPedido => 'Save order';

  @override
  String get editarPedidoTitulo => 'Edit order';

  @override
  String get editarPedidoEntregado =>
      'This order has already been delivered. Editing it doesn\'t change the income already recorded.';

  @override
  String get sinItemsEditar => 'No items. Add from the catalog or manual ones.';

  @override
  String get cambiar => 'Change';

  @override
  String get analisisYReportes => 'Analysis and reports';

  @override
  String get reportesVacio =>
      'No data to analyze yet.\nRecord sales and expenses to see your reports.';

  @override
  String gananciaDeMes(String mes) {
    return '$mes profit';
  }

  @override
  String get sinComparacion => '— no comparison';

  @override
  String mesAnterior(String mes, String valor) {
    return 'Previous month ($mes): $valor';
  }

  @override
  String get gananciaPorMes => 'Profit by month';

  @override
  String get reportesMensuales => 'Monthly reports';

  @override
  String get reportesMensualesSub =>
      'Download the PDF statement for each closed month';

  @override
  String get pdfError => 'Could not generate the PDF.';

  @override
  String get sinMesesCerrados =>
      'No closed months to report yet.\nWhen the current month ends, it will appear here.';

  @override
  String ingresosGastos(String ingresos, String gastos) {
    return 'Income: $ingresos  ·  Expenses: $gastos';
  }

  @override
  String get descargarPdf => 'Download PDF';

  @override
  String get topProductosMes => 'Top products of the month';

  @override
  String get topSinVentasMes => 'No product sales this month yet.';

  @override
  String vendidosAbrev(String cantidad) {
    return '$cantidad sold';
  }

  @override
  String resumenAnalisisCorto(String ticket, String dia) {
    return 'Average ticket $ticket · Best day: $dia';
  }

  @override
  String get verMas => 'See more';

  @override
  String get nombreCatalogo => 'Catalog name';

  @override
  String get subir => 'Upload';

  @override
  String get errorLeerArchivo => 'Could not read the file.';

  @override
  String get soloPdf => 'Only PDF files are supported for now.';

  @override
  String get archivoSupera15 => 'The file exceeds the 15 MB limit.';

  @override
  String get errorSubirCatalogo => 'Could not upload the catalog. Try again.';

  @override
  String get errorAbrirCatalogo => 'Could not open the catalog.';

  @override
  String get eliminarCatalogoTitulo => 'Delete catalog';

  @override
  String eliminarCatalogoConfirmacion(String nombre) {
    return 'Delete «$nombre»? The PDF file will be removed.';
  }

  @override
  String get errorEliminar => 'Could not delete.';

  @override
  String get subiendo => 'Uploading...';

  @override
  String get subirPdf => 'Upload PDF';

  @override
  String get catalogosVacio =>
      'You have no catalogs yet.\nUpload a PDF with the button below.';

  @override
  String get abrir => 'Open';

  @override
  String get asunto => 'Subject';

  @override
  String get contenido => 'Content';

  @override
  String get sinContenido => '(No content)';

  @override
  String get entregaHoy => 'Delivery today';

  @override
  String get entregaManana => 'Delivery tomorrow';

  @override
  String get sinAvisos => 'No alerts for now. All caught up!';

  @override
  String avisoPedidoDetalle(String urgencia, String precio) {
    return '$urgencia  ·  $precio';
  }

  @override
  String get inventarioBajo => 'Low inventory';

  @override
  String insumoBajoDetalle(String stock, String unidad, String minimo) {
    return '$stock $unidad left (minimum $minimo)';
  }

  @override
  String porAutor(String autor) {
    return 'By $autor';
  }

  @override
  String get notifConfigAyuda =>
      'Choose which alerts you want to receive in the app.';

  @override
  String get notifPedidosSub => 'Deliveries today, tomorrow or overdue';

  @override
  String get notifInsumosSub => 'Supplies below their minimum stock';

  @override
  String get modo => 'Mode';

  @override
  String get modoClaro => 'Light';

  @override
  String get modoOscuro => 'Dark';

  @override
  String get modoAuto => 'Automatic (system)';

  @override
  String get colorAcento => 'Accent color';

  @override
  String get acentoVerde => 'Green';

  @override
  String get acentoAzul => 'Blue';

  @override
  String get acentoTurquesa => 'Teal';

  @override
  String get acentoMorado => 'Purple';

  @override
  String get acentoNaranja => 'Orange';

  @override
  String get acentoRosa => 'Pink';

  @override
  String get aparienciaNota =>
      'The theme and accent color apply to the whole app.';

  @override
  String get completaCampos => 'Fill in all fields.';

  @override
  String get passwordMin6 => 'The new password must be at least 6 characters.';

  @override
  String get passwordNoCoincide =>
      'The new password and its confirmation don\'t match.';

  @override
  String get sinSesionValida => 'There is no valid session.';

  @override
  String get passwordActualizada => 'Password updated';

  @override
  String get passwordActualIncorrecta => 'The current password is incorrect.';

  @override
  String get passwordDebil => 'The new password is too weak.';

  @override
  String get requiereReloginPassword =>
      'For security, sign in again and try again.';

  @override
  String get demasiadosIntentos =>
      'Too many attempts. Wait a moment and try again.';

  @override
  String get errorCambiarPassword =>
      'Could not change the password. Try again.';

  @override
  String get cambiarContrasena => 'Change password';

  @override
  String get passwordActual => 'Current password';

  @override
  String get passwordNueva => 'New password';

  @override
  String get passwordConfirmar => 'Confirm new password';

  @override
  String get guardando => 'Saving...';

  @override
  String get errorLeerImagen => 'Could not read the image.';

  @override
  String get imagenSupera5 => 'The image exceeds the 5 MB limit.';

  @override
  String get fotoActualizada => 'Photo updated';

  @override
  String get errorSubirFoto => 'Could not upload the photo.';

  @override
  String get logoActualizado => 'Logo updated';

  @override
  String get errorSubirLogo => 'Could not upload the logo. Are you the owner?';

  @override
  String get quitar => 'Remove';

  @override
  String get quitarFoto => 'Remove photo';

  @override
  String get quitarFotoConfirmacion => 'Remove your profile photo?';

  @override
  String get fotoEliminada => 'Photo removed';

  @override
  String get errorEliminarFoto => 'Could not remove the photo.';

  @override
  String get quitarLogo => 'Remove logo';

  @override
  String get quitarLogoConfirmacion => 'Remove the business logo?';

  @override
  String get logoEliminado => 'Logo removed';

  @override
  String get errorEliminarLogo => 'Could not remove the logo.';

  @override
  String get logoEmpresa => 'Business logo';

  @override
  String get subirLogo => 'Upload logo';

  @override
  String get cambiarLogo => 'Change logo';

  @override
  String get soloDuenoCambia => 'Only the owner can change it';

  @override
  String get perfilGuardado => 'Profile saved';

  @override
  String get errorGuardarPerfil => 'Could not save the profile.';

  @override
  String get nombreEmpresaVacio => 'The business name can\'t be empty.';

  @override
  String get empresaGuardada => 'Business details saved';

  @override
  String get errorGuardarEmpresa =>
      'Could not save. Are you the business owner?';

  @override
  String get tocaCamara => 'Tap the camera to change your photo';

  @override
  String get informacionPersonal => 'Personal information';

  @override
  String get correoCuenta => 'Email (of your account)';

  @override
  String get celular => 'Mobile';

  @override
  String get guardarPerfil => 'Save profile';

  @override
  String get soloLectura => 'Read only';

  @override
  String get soloDuenoEdita =>
      'Only the business owner can edit these details.';

  @override
  String get nombreEmpresa => 'Business name';

  @override
  String get nit => 'Tax ID';

  @override
  String get correoEmpresa => 'Business email';

  @override
  String get telefono => 'Phone';

  @override
  String get ubicacion => 'Location';

  @override
  String get guardarEmpresa => 'Save business';

  @override
  String get preferenciasNegocio => 'Business preferences';

  @override
  String get ajustesSeguridadCaption =>
      'The app language can be changed here and applies to the whole app. Country and currency can\'t be changed for now.';

  @override
  String get seguridad => 'Security';

  @override
  String get buscadorHint => 'Search your business...';

  @override
  String get buscadorInicio =>
      'Search products, supplies, orders, recipes and catalogs.';

  @override
  String buscadorSinResultados(String q) {
    return 'No results for «$q»';
  }

  @override
  String get miembrosInvitaciones => 'Members and invitations';

  @override
  String get miembrosInvitacionesSub => 'Invite your team and manage roles';

  @override
  String get invitacionesTitulo => 'Invitations';

  @override
  String get generarInvitacion => 'Generate invitation';

  @override
  String get miembrosTitulo => 'Members';

  @override
  String get rolDueno => 'Owner';

  @override
  String get rolSocio => 'Partner';

  @override
  String get rolEmpleado => 'Employee';

  @override
  String get elegirRolInvitacion => 'What role will the person have?';

  @override
  String get invitacionCreada => 'Invitation created';

  @override
  String get codigoInvitacion => 'Invitation code';

  @override
  String get copiar => 'Copy';

  @override
  String get copiado => 'Copied';

  @override
  String get compartirCodigoAyuda =>
      'Share this code. The person uses it when signing up to join your business.';

  @override
  String get revocar => 'Revoke';

  @override
  String get invitacionPendiente => 'Pending';

  @override
  String get invitacionUsada => 'Used';

  @override
  String get sinInvitaciones => 'You haven\'t generated any invitations.';

  @override
  String get sinMiembros => 'There are no other members yet.';

  @override
  String get cambiarRolTitulo => 'Change role';

  @override
  String get quitarDelNegocio => 'Remove from business';

  @override
  String quitarMiembroConfirmacion(String nombre) {
    return 'Remove $nombre from the business?';
  }

  @override
  String get unirseCodigo => 'Join with a code';

  @override
  String get unirseCodigoTitulo => 'Join a business';

  @override
  String get unirseCodigoAyuda =>
      'Enter the invitation code the business owner shared with you.';

  @override
  String get unirme => 'Join';

  @override
  String get codigoVacio => 'Enter the code.';

  @override
  String get codigoNoExiste => 'The code doesn\'t exist.';

  @override
  String get codigoUsado => 'That code has already been used.';

  @override
  String get codigoInvalido => 'The code is not valid.';

  @override
  String get unirseError => 'Could not join. Try again.';

  @override
  String get sinNombre => '(no name)';

  @override
  String get ver => 'View';

  @override
  String get olvidasteContrasena => 'Forgot your password?';

  @override
  String get recuperarContrasenaTitulo => 'Reset password';

  @override
  String get recuperarContrasenaAyuda =>
      'We\'ll send you an email to reset your password.';

  @override
  String get enviar => 'Send';

  @override
  String get correoVacio => 'Enter your email.';

  @override
  String get correoRecuperacionEnviado =>
      'If an account exists for that email, we sent a link to reset it.';

  @override
  String get eliminarCuenta => 'Delete account';

  @override
  String get eliminarCuentaAdvertencia =>
      'This will delete your account and your access to this business. It can\'t be undone.';

  @override
  String get eliminarCuentaAdvertenciaDueno =>
      'As the owner, this will delete the ENTIRE business and its data (products, sales, expenses, orders...) and unlink the other members. This action CANNOT be undone.';

  @override
  String get continuar => 'Continue';

  @override
  String get eliminarCuentaConfirmar => 'Yes, delete';

  @override
  String get ingresaContrasenaEliminar => 'Enter your password to confirm.';

  @override
  String get errorEliminarCuenta => 'Could not delete the account. Try again.';

  @override
  String get cargandoNegocio => 'Loading your business';

  @override
  String get historialCompletoPro => 'See full history with Pro';

  @override
  String get paywallTitulo => 'Unlock all of Stocklet';

  @override
  String get paywallSubtitulo => 'Grow with your team and the full toolkit';

  @override
  String get proEquipo => 'Team with roles';

  @override
  String get proEquipoDesc => 'Invite partners and employees';

  @override
  String get proHistorial => 'Full history';

  @override
  String get proHistorialDesc => 'No date limit';

  @override
  String get proReportes => 'Reports and analytics';

  @override
  String get proReportesDesc => 'Best day, top products, PDF';

  @override
  String get proCatalogos => 'Unlimited PDF catalogs';

  @override
  String get proNegocios => 'Multiple businesses';

  @override
  String get proExportar => 'Export your data';

  @override
  String get planMensual => 'Monthly plan';

  @override
  String get planAnual => 'Annual plan';

  @override
  String get dosMesesGratis => '~2 months free';

  @override
  String get porMes => 'per month';

  @override
  String get porAnioDescuento => 'per year · ~2 months free';

  @override
  String get restaurarCompras => 'Restore purchases';

  @override
  String get pagosPronto =>
      'Payments will be enabled when the app is published.';

  @override
  String get yaEresPro => 'You\'re Pro now! Thank you.';

  @override
  String get errorCompra => 'The purchase could not be completed.';

  @override
  String get productosEligeFiltro => 'Choose a type or search for a product.';
}
