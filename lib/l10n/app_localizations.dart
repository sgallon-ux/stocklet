import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
  ];

  /// Titulo del AppBar de la pantalla de ajustes
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get ajustesTitulo;

  /// Nombre por defecto cuando el negocio no tiene nombre
  ///
  /// In es, this message translates to:
  /// **'Mi negocio'**
  String get miNegocio;

  /// No description provided for @perfil.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get perfil;

  /// No description provided for @perfilSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Tu información personal'**
  String get perfilSubtitulo;

  /// No description provided for @datosEmpresa.
  ///
  /// In es, this message translates to:
  /// **'Datos de la empresa'**
  String get datosEmpresa;

  /// No description provided for @datosEmpresaSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Nombre, NIT, contacto y ubicación'**
  String get datosEmpresaSubtitulo;

  /// No description provided for @notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notificaciones;

  /// No description provided for @notificacionesSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Avisos de pedidos, notas e inventario'**
  String get notificacionesSubtitulo;

  /// No description provided for @ajustesSeguridad.
  ///
  /// In es, this message translates to:
  /// **'Ajustes y seguridad'**
  String get ajustesSeguridad;

  /// No description provided for @ajustesSeguridadSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'País, moneda, idioma y contraseña'**
  String get ajustesSeguridadSubtitulo;

  /// No description provided for @apariencia.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get apariencia;

  /// No description provided for @aparienciaSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Tema y modo oscuro'**
  String get aparienciaSubtitulo;

  /// No description provided for @idioma.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get idioma;

  /// No description provided for @idiomaSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Idioma de la aplicación'**
  String get idiomaSubtitulo;

  /// No description provided for @idiomaAutomatico.
  ///
  /// In es, this message translates to:
  /// **'Automático (dispositivo)'**
  String get idiomaAutomatico;

  /// No description provided for @idiomaTituloDialogo.
  ///
  /// In es, this message translates to:
  /// **'Elige un idioma'**
  String get idiomaTituloDialogo;

  /// No description provided for @acercaDe.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get acercaDe;

  /// No description provided for @acercaDeSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Versión e información de la app'**
  String get acercaDeSubtitulo;

  /// No description provided for @acercaDeDescripcion.
  ///
  /// In es, this message translates to:
  /// **'App de contabilidad para tu negocio.'**
  String get acercaDeDescripcion;

  /// No description provided for @cerrarSesion.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get cerrarSesion;

  /// No description provided for @cerrarSesionConfirmacion.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres cerrar sesión?'**
  String get cerrarSesionConfirmacion;

  /// No description provided for @cancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancelar;

  /// No description provided for @campoCorreo.
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get campoCorreo;

  /// No description provided for @campoContrasena.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get campoContrasena;

  /// No description provided for @crearCuenta.
  ///
  /// In es, this message translates to:
  /// **'Crea tu cuenta'**
  String get crearCuenta;

  /// No description provided for @iniciarSesion.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get iniciarSesion;

  /// No description provided for @iniciaSesion.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión'**
  String get iniciaSesion;

  /// No description provided for @errorCorreoInvalido.
  ///
  /// In es, this message translates to:
  /// **'El correo no es válido'**
  String get errorCorreoInvalido;

  /// No description provided for @loginBienvenido.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido'**
  String get loginBienvenido;

  /// No description provided for @loginSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión para gestionar tu negocio'**
  String get loginSubtitulo;

  /// No description provided for @loginRecordarCorreo.
  ///
  /// In es, this message translates to:
  /// **'Recordar mi correo'**
  String get loginRecordarCorreo;

  /// No description provided for @loginEresNuevo.
  ///
  /// In es, this message translates to:
  /// **'¿Eres nuevo?'**
  String get loginEresNuevo;

  /// No description provided for @loginCompletaCampos.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu correo y contraseña'**
  String get loginCompletaCampos;

  /// No description provided for @loginErrorGeneral.
  ///
  /// In es, this message translates to:
  /// **'No se pudo iniciar sesión'**
  String get loginErrorGeneral;

  /// No description provided for @loginErrorNoExiste.
  ///
  /// In es, this message translates to:
  /// **'No existe una cuenta con ese correo'**
  String get loginErrorNoExiste;

  /// No description provided for @loginErrorCredenciales.
  ///
  /// In es, this message translates to:
  /// **'Correo o contraseña incorrectos'**
  String get loginErrorCredenciales;

  /// No description provided for @registroSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Regístrate para empezar con tu negocio'**
  String get registroSubtitulo;

  /// No description provided for @registroMinimo.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 6 caracteres'**
  String get registroMinimo;

  /// No description provided for @registroBoton.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get registroBoton;

  /// No description provided for @registroYaTienes.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta?'**
  String get registroYaTienes;

  /// No description provided for @registroCompletaCampos.
  ///
  /// In es, this message translates to:
  /// **'Escribe un correo y una contraseña de mínimo 6 caracteres'**
  String get registroCompletaCampos;

  /// No description provided for @registroErrorGeneral.
  ///
  /// In es, this message translates to:
  /// **'No se pudo crear la cuenta'**
  String get registroErrorGeneral;

  /// No description provided for @registroErrorEnUso.
  ///
  /// In es, this message translates to:
  /// **'Ese correo ya tiene cuenta'**
  String get registroErrorEnUso;

  /// No description provided for @registroErrorDebil.
  ///
  /// In es, this message translates to:
  /// **'La contraseña es muy débil'**
  String get registroErrorDebil;

  /// No description provided for @crearHubTitulo.
  ///
  /// In es, this message translates to:
  /// **'Crear y gestionar'**
  String get crearHubTitulo;

  /// No description provided for @inventario.
  ///
  /// In es, this message translates to:
  /// **'Inventario'**
  String get inventario;

  /// No description provided for @inventarioSub.
  ///
  /// In es, this message translates to:
  /// **'Insumos, costos y stock'**
  String get inventarioSub;

  /// No description provided for @productos.
  ///
  /// In es, this message translates to:
  /// **'Productos'**
  String get productos;

  /// No description provided for @productosSub.
  ///
  /// In es, this message translates to:
  /// **'Crea y administra tus productos'**
  String get productosSub;

  /// No description provided for @pedidos.
  ///
  /// In es, this message translates to:
  /// **'Pedidos'**
  String get pedidos;

  /// No description provided for @pedidosSub.
  ///
  /// In es, this message translates to:
  /// **'Encargos de clientes'**
  String get pedidosSub;

  /// No description provided for @recetas.
  ///
  /// In es, this message translates to:
  /// **'Recetas'**
  String get recetas;

  /// No description provided for @recetasSub.
  ///
  /// In es, this message translates to:
  /// **'Guías de preparación paso a paso'**
  String get recetasSub;

  /// No description provided for @catalogo.
  ///
  /// In es, this message translates to:
  /// **'Catálogo'**
  String get catalogo;

  /// No description provided for @catalogoSub.
  ///
  /// In es, this message translates to:
  /// **'Tus catálogos en PDF'**
  String get catalogoSub;

  /// No description provided for @onboardingBienvenido.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido!'**
  String get onboardingBienvenido;

  /// No description provided for @onboardingSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Cuéntanos de tu microempresa para personalizar la app'**
  String get onboardingSubtitulo;

  /// No description provided for @onboardingNombreNegocio.
  ///
  /// In es, this message translates to:
  /// **'Nombre del negocio'**
  String get onboardingNombreNegocio;

  /// No description provided for @onboardingNombreVacio.
  ///
  /// In es, this message translates to:
  /// **'Escribe el nombre de tu negocio'**
  String get onboardingNombreVacio;

  /// No description provided for @onboardingCrearBoton.
  ///
  /// In es, this message translates to:
  /// **'Crear mi negocio'**
  String get onboardingCrearBoton;

  /// No description provided for @onboardingBuscarPais.
  ///
  /// In es, this message translates to:
  /// **'Buscar país'**
  String get onboardingBuscarPais;

  /// No description provided for @campoPais.
  ///
  /// In es, this message translates to:
  /// **'País'**
  String get campoPais;

  /// No description provided for @campoMoneda.
  ///
  /// In es, this message translates to:
  /// **'Moneda'**
  String get campoMoneda;

  /// No description provided for @errorGenerico.
  ///
  /// In es, this message translates to:
  /// **'Error: {detalle}'**
  String errorGenerico(String detalle);

  /// No description provided for @panelUsuario.
  ///
  /// In es, this message translates to:
  /// **'Panel de usuario'**
  String get panelUsuario;

  /// No description provided for @buscar.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get buscar;

  /// No description provided for @busquedaProximamente.
  ///
  /// In es, this message translates to:
  /// **'Búsqueda próximamente'**
  String get busquedaProximamente;

  /// No description provided for @agregarVenta.
  ///
  /// In es, this message translates to:
  /// **'Agregar venta'**
  String get agregarVenta;

  /// No description provided for @agregarGasto.
  ///
  /// In es, this message translates to:
  /// **'Agregar gasto'**
  String get agregarGasto;

  /// No description provided for @navInicio.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navInicio;

  /// No description provided for @navCrear.
  ///
  /// In es, this message translates to:
  /// **'Crear'**
  String get navCrear;

  /// No description provided for @navReportes.
  ///
  /// In es, this message translates to:
  /// **'Reportes'**
  String get navReportes;

  /// No description provided for @rangoEsteMes.
  ///
  /// In es, this message translates to:
  /// **'Este mes'**
  String get rangoEsteMes;

  /// No description provided for @rango3Meses.
  ///
  /// In es, this message translates to:
  /// **'3 meses'**
  String get rango3Meses;

  /// No description provided for @rango6Meses.
  ///
  /// In es, this message translates to:
  /// **'6 meses'**
  String get rango6Meses;

  /// No description provided for @rangoAnio.
  ///
  /// In es, this message translates to:
  /// **'Año'**
  String get rangoAnio;

  /// No description provided for @resumen.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get resumen;

  /// No description provided for @ingresos.
  ///
  /// In es, this message translates to:
  /// **'Ingresos'**
  String get ingresos;

  /// No description provided for @gastos.
  ///
  /// In es, this message translates to:
  /// **'Gastos'**
  String get gastos;

  /// No description provided for @ganancia.
  ///
  /// In es, this message translates to:
  /// **'Ganancia'**
  String get ganancia;

  /// No description provided for @tendenciaGanancia.
  ///
  /// In es, this message translates to:
  /// **'Tendencia de ganancia'**
  String get tendenciaGanancia;

  /// No description provided for @graficaSinDatos.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay datos suficientes para mostrar.'**
  String get graficaSinDatos;

  /// No description provided for @pedidosProximos.
  ///
  /// In es, this message translates to:
  /// **'Pedidos próximos'**
  String get pedidosProximos;

  /// No description provided for @verTodos.
  ///
  /// In es, this message translates to:
  /// **'Ver todos'**
  String get verTodos;

  /// No description provided for @sinPedidosPendientes.
  ///
  /// In es, this message translates to:
  /// **'No tienes pedidos pendientes.'**
  String get sinPedidosPendientes;

  /// No description provided for @pedidoAtrasado.
  ///
  /// In es, this message translates to:
  /// **'Atrasado'**
  String get pedidoAtrasado;

  /// No description provided for @hoy.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get hoy;

  /// No description provided for @manana.
  ///
  /// In es, this message translates to:
  /// **'Mañana'**
  String get manana;

  /// No description provided for @enDias.
  ///
  /// In es, this message translates to:
  /// **'En {dias} días'**
  String enDias(int dias);

  /// No description provided for @notasImportantes.
  ///
  /// In es, this message translates to:
  /// **'Notas importantes'**
  String get notasImportantes;

  /// No description provided for @nuevaNota.
  ///
  /// In es, this message translates to:
  /// **'Nueva nota'**
  String get nuevaNota;

  /// No description provided for @sinNotas.
  ///
  /// In es, this message translates to:
  /// **'No tienes notas. Crea una con el +'**
  String get sinNotas;

  /// No description provided for @eliminar.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get eliminar;

  /// No description provided for @editar.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get editar;

  /// No description provided for @campoNombre.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get campoNombre;

  /// No description provided for @unidadMedida.
  ///
  /// In es, this message translates to:
  /// **'Unidad de medida'**
  String get unidadMedida;

  /// No description provided for @unidadGramos.
  ///
  /// In es, this message translates to:
  /// **'Gramos (g)'**
  String get unidadGramos;

  /// No description provided for @unidadMililitros.
  ///
  /// In es, this message translates to:
  /// **'Mililitros (ml)'**
  String get unidadMililitros;

  /// No description provided for @unidadUnidades.
  ///
  /// In es, this message translates to:
  /// **'Unidades'**
  String get unidadUnidades;

  /// No description provided for @stockMinimoOpcional.
  ///
  /// In es, this message translates to:
  /// **'Stock mínimo (opcional)'**
  String get stockMinimoOpcional;

  /// No description provided for @stockMinimoHint.
  ///
  /// In es, this message translates to:
  /// **'Avisar cuando baje de...'**
  String get stockMinimoHint;

  /// No description provided for @buscarHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar...'**
  String get buscarHint;

  /// No description provided for @insumo.
  ///
  /// In es, this message translates to:
  /// **'Insumo'**
  String get insumo;

  /// No description provided for @buscarInsumoHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar insumo...'**
  String get buscarInsumoHint;

  /// No description provided for @cerrarBusqueda.
  ///
  /// In es, this message translates to:
  /// **'Cerrar búsqueda'**
  String get cerrarBusqueda;

  /// No description provided for @inventarioVacio.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay insumos.\nAgrega el primero con el botón +'**
  String get inventarioVacio;

  /// No description provided for @inventarioSinCoincidencias.
  ///
  /// In es, this message translates to:
  /// **'Ningún insumo coincide con la búsqueda.'**
  String get inventarioSinCoincidencias;

  /// No description provided for @eliminarInsumoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Eliminar insumo'**
  String get eliminarInsumoTitulo;

  /// No description provided for @eliminarInsumoConfirmacion.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar {nombre}?'**
  String eliminarInsumoConfirmacion(String nombre);

  /// No description provided for @insumoNoEliminarEnUso.
  ///
  /// In es, this message translates to:
  /// **'No puedes eliminar {nombre}: lo usa un producto'**
  String insumoNoEliminarEnUso(String nombre);

  /// No description provided for @costoPorUnidadTexto.
  ///
  /// In es, this message translates to:
  /// **'{costo} por {unidad}'**
  String costoPorUnidadTexto(String costo, String unidad);

  /// No description provided for @stockTexto.
  ///
  /// In es, this message translates to:
  /// **'Stock: {cantidad} {unidad}'**
  String stockTexto(String cantidad, String unidad);

  /// No description provided for @completaCamposValidos.
  ///
  /// In es, this message translates to:
  /// **'Completa todos los campos con valores válidos'**
  String get completaCamposValidos;

  /// No description provided for @agregarInsumoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Agregar insumo'**
  String get agregarInsumoTitulo;

  /// No description provided for @insumoNombreHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Harina'**
  String get insumoNombreHint;

  /// No description provided for @cantidadComprada.
  ///
  /// In es, this message translates to:
  /// **'Cantidad comprada'**
  String get cantidadComprada;

  /// No description provided for @cantidadCompradaHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 1000'**
  String get cantidadCompradaHint;

  /// No description provided for @precioTotalPagado.
  ///
  /// In es, this message translates to:
  /// **'Precio total pagado'**
  String get precioTotalPagado;

  /// No description provided for @agregarInsumoAyuda.
  ///
  /// In es, this message translates to:
  /// **'Con la cantidad y el precio, la app calcula sola el costo por unidad.'**
  String get agregarInsumoAyuda;

  /// No description provided for @guardarInsumo.
  ///
  /// In es, this message translates to:
  /// **'Guardar insumo'**
  String get guardarInsumo;

  /// No description provided for @revisaCamposNegativos.
  ///
  /// In es, this message translates to:
  /// **'Revisa los campos: valores válidos, sin negativos'**
  String get revisaCamposNegativos;

  /// No description provided for @editarInsumoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Editar insumo'**
  String get editarInsumoTitulo;

  /// No description provided for @costoPorUnidadLabel.
  ///
  /// In es, this message translates to:
  /// **'Costo por unidad'**
  String get costoPorUnidadLabel;

  /// No description provided for @stockActualLabel.
  ///
  /// In es, this message translates to:
  /// **'Stock actual'**
  String get stockActualLabel;

  /// No description provided for @guardarCambios.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get guardarCambios;

  /// No description provided for @elegirInsumoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Elegir insumo'**
  String get elegirInsumoTitulo;

  /// No description provided for @ningunInsumoCoincide.
  ///
  /// In es, this message translates to:
  /// **'Ningún insumo coincide.'**
  String get ningunInsumoCoincide;

  /// No description provided for @nuevo.
  ///
  /// In es, this message translates to:
  /// **'Nuevo'**
  String get nuevo;

  /// No description provided for @costo.
  ///
  /// In es, this message translates to:
  /// **'Costo'**
  String get costo;

  /// No description provided for @margen.
  ///
  /// In es, this message translates to:
  /// **'Margen'**
  String get margen;

  /// No description provided for @cantidad.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get cantidad;

  /// No description provided for @sinTipo.
  ///
  /// In es, this message translates to:
  /// **'Sin tipo'**
  String get sinTipo;

  /// No description provided for @tipoProducto.
  ///
  /// In es, this message translates to:
  /// **'Tipo de producto'**
  String get tipoProducto;

  /// No description provided for @precioVenta.
  ///
  /// In es, this message translates to:
  /// **'Precio de venta'**
  String get precioVenta;

  /// No description provided for @recetaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Receta'**
  String get recetaTitulo;

  /// No description provided for @eliminarProductoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Eliminar producto'**
  String get eliminarProductoTitulo;

  /// No description provided for @eliminarProductoConfirmacion.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar «{nombre}»? Las ventas ya registradas no se modifican.'**
  String eliminarProductoConfirmacion(String nombre);

  /// No description provided for @productosVacio.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes productos.\nCrea uno con el botón +'**
  String get productosVacio;

  /// No description provided for @gananciaTexto.
  ///
  /// In es, this message translates to:
  /// **'Ganancia: {valor}'**
  String gananciaTexto(String valor);

  /// No description provided for @eligeInsumoCantidad.
  ///
  /// In es, this message translates to:
  /// **'Elige un insumo y una cantidad válida'**
  String get eligeInsumoCantidad;

  /// No description provided for @insumoYaEnReceta.
  ///
  /// In es, this message translates to:
  /// **'Ese insumo ya está en la receta'**
  String get insumoYaEnReceta;

  /// No description provided for @faltaNombrePrecioIngrediente.
  ///
  /// In es, this message translates to:
  /// **'Falta el nombre, el precio o al menos un ingrediente'**
  String get faltaNombrePrecioIngrediente;

  /// No description provided for @crearProductoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Crear producto'**
  String get crearProductoTitulo;

  /// No description provided for @editarProductoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Editar producto'**
  String get editarProductoTitulo;

  /// No description provided for @nombreProducto.
  ///
  /// In es, this message translates to:
  /// **'Nombre del producto'**
  String get nombreProducto;

  /// No description provided for @nombreProductoHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Torta de chocolate'**
  String get nombreProductoHint;

  /// No description provided for @recetaAyuda.
  ///
  /// In es, this message translates to:
  /// **'Agrega los insumos y cantidades que lleva una unidad'**
  String get recetaAyuda;

  /// No description provided for @recetaSinInsumos.
  ///
  /// In es, this message translates to:
  /// **'Primero agrega insumos en la pantalla de Inventario.'**
  String get recetaSinInsumos;

  /// No description provided for @sinInsumosInventario.
  ///
  /// In es, this message translates to:
  /// **'No hay insumos en el inventario.'**
  String get sinInsumosInventario;

  /// No description provided for @sinIngredientes.
  ///
  /// In es, this message translates to:
  /// **'Aún no has agregado ingredientes.'**
  String get sinIngredientes;

  /// No description provided for @recetaVacia.
  ///
  /// In es, this message translates to:
  /// **'La receta está vacía.'**
  String get recetaVacia;

  /// No description provided for @ingredienteSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'{cantidad} {unidad}  ·  {costo}'**
  String ingredienteSubtitulo(String cantidad, String unidad, String costo);

  /// No description provided for @guardarProducto.
  ///
  /// In es, this message translates to:
  /// **'Guardar producto'**
  String get guardarProducto;

  /// No description provided for @elegirProductoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Elegir producto'**
  String get elegirProductoTitulo;

  /// No description provided for @ningunProductoCoincide.
  ///
  /// In es, this message translates to:
  /// **'Ningún producto coincide.'**
  String get ningunProductoCoincide;

  /// No description provided for @crearTipoHint.
  ///
  /// In es, this message translates to:
  /// **'Crear tipo de producto, ej: Bebidas'**
  String get crearTipoHint;

  /// No description provided for @sinTipos.
  ///
  /// In es, this message translates to:
  /// **'Aún no has creado tipos.'**
  String get sinTipos;

  /// No description provided for @recetasVacio.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes recetas.\nCrea una con el botón +'**
  String get recetasVacio;

  /// No description provided for @recetaSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'{ingredientes} ingredientes · {pasos} pasos'**
  String recetaSubtitulo(int ingredientes, int pasos);

  /// No description provided for @eliminarRecetaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Eliminar receta'**
  String get eliminarRecetaTitulo;

  /// No description provided for @eliminarRecetaConfirmacion.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar «{titulo}»?'**
  String eliminarRecetaConfirmacion(String titulo);

  /// No description provided for @recetaNoExiste.
  ///
  /// In es, this message translates to:
  /// **'Esta receta ya no existe.'**
  String get recetaNoExiste;

  /// No description provided for @ingredientesLabel.
  ///
  /// In es, this message translates to:
  /// **'Ingredientes'**
  String get ingredientesLabel;

  /// No description provided for @preparacion.
  ///
  /// In es, this message translates to:
  /// **'Preparación'**
  String get preparacion;

  /// No description provided for @recetaFaltaTituloPaso.
  ///
  /// In es, this message translates to:
  /// **'Escribe el título y al menos un paso'**
  String get recetaFaltaTituloPaso;

  /// No description provided for @editarRecetaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Editar receta'**
  String get editarRecetaTitulo;

  /// No description provided for @nuevaRecetaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Nueva receta'**
  String get nuevaRecetaTitulo;

  /// No description provided for @tituloReceta.
  ///
  /// In es, this message translates to:
  /// **'Título de la receta'**
  String get tituloReceta;

  /// No description provided for @ingredientesHint.
  ///
  /// In es, this message translates to:
  /// **'Un ingrediente por línea'**
  String get ingredientesHint;

  /// No description provided for @pasosPreparacion.
  ///
  /// In es, this message translates to:
  /// **'Pasos de preparación'**
  String get pasosPreparacion;

  /// No description provided for @pasosHint.
  ///
  /// In es, this message translates to:
  /// **'Un paso por línea'**
  String get pasosHint;

  /// No description provided for @recetaEditorAyuda.
  ///
  /// In es, this message translates to:
  /// **'Escribe cada ingrediente y cada paso en su propia línea (Enter para separar).'**
  String get recetaEditorAyuda;

  /// No description provided for @guardarReceta.
  ///
  /// In es, this message translates to:
  /// **'Guardar receta'**
  String get guardarReceta;

  /// No description provided for @confirmarVenta.
  ///
  /// In es, this message translates to:
  /// **'Confirmar venta'**
  String get confirmarVenta;

  /// No description provided for @confirmarVentaProducto.
  ///
  /// In es, this message translates to:
  /// **'¿Registrar la venta de {nombre} por {precio}?'**
  String confirmarVentaProducto(String nombre, String precio);

  /// No description provided for @vender.
  ///
  /// In es, this message translates to:
  /// **'Vender'**
  String get vender;

  /// No description provided for @ventaProductoRegistrada.
  ///
  /// In es, this message translates to:
  /// **'Venta de {nombre} registrada'**
  String ventaProductoRegistrada(String nombre);

  /// No description provided for @ventaDescripcionValor.
  ///
  /// In es, this message translates to:
  /// **'Escribe una descripción y un valor válido'**
  String get ventaDescripcionValor;

  /// No description provided for @confirmarVentaManual.
  ///
  /// In es, this message translates to:
  /// **'¿Registrar la venta «{descripcion}» por {valor}?'**
  String confirmarVentaManual(String descripcion, String valor);

  /// No description provided for @registrar.
  ///
  /// In es, this message translates to:
  /// **'Registrar'**
  String get registrar;

  /// No description provided for @ventaRegistrada.
  ///
  /// In es, this message translates to:
  /// **'Venta registrada'**
  String get ventaRegistrada;

  /// No description provided for @ingresarVentaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Ingresar venta'**
  String get ingresarVentaTitulo;

  /// No description provided for @ventaRapida.
  ///
  /// In es, this message translates to:
  /// **'Venta rápida'**
  String get ventaRapida;

  /// No description provided for @ventaRapidaAyuda.
  ///
  /// In es, this message translates to:
  /// **'Para ventas que no son de un producto del catálogo'**
  String get ventaRapidaAyuda;

  /// No description provided for @descripcion.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get descripcion;

  /// No description provided for @ventaDescripcionHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: café, domicilio…'**
  String get ventaDescripcionHint;

  /// No description provided for @valor.
  ///
  /// In es, this message translates to:
  /// **'Valor'**
  String get valor;

  /// No description provided for @registrarVenta.
  ///
  /// In es, this message translates to:
  /// **'Registrar venta'**
  String get registrarVenta;

  /// No description provided for @venderProducto.
  ///
  /// In es, this message translates to:
  /// **'Vender un producto'**
  String get venderProducto;

  /// No description provided for @productosFiltro.
  ///
  /// In es, this message translates to:
  /// **'Productos: {tipo}'**
  String productosFiltro(String tipo);

  /// No description provided for @filtrarPorTipo.
  ///
  /// In es, this message translates to:
  /// **'Filtrar por tipo'**
  String get filtrarPorTipo;

  /// No description provided for @todos.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get todos;

  /// No description provided for @sinProductosVenta.
  ///
  /// In es, this message translates to:
  /// **'No hay productos. Créalos desde el menú Crear.'**
  String get sinProductosVenta;

  /// No description provided for @revisaCamposMayorCero.
  ///
  /// In es, this message translates to:
  /// **'Revisa los campos: valores válidos y mayores a cero'**
  String get revisaCamposMayorCero;

  /// No description provided for @editarVentaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Editar venta'**
  String get editarVentaTitulo;

  /// No description provided for @precioUnitario.
  ///
  /// In es, this message translates to:
  /// **'Precio unitario'**
  String get precioUnitario;

  /// No description provided for @eliminarVentaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Eliminar venta'**
  String get eliminarVentaTitulo;

  /// No description provided for @eliminarVentaConfirmacion.
  ///
  /// In es, this message translates to:
  /// **'Esto corrige los ingresos, pero no devuelve los insumos al inventario. ¿Quieres continuar?'**
  String get eliminarVentaConfirmacion;

  /// No description provided for @historialVentasTitulo.
  ///
  /// In es, this message translates to:
  /// **'Historial de ventas'**
  String get historialVentasTitulo;

  /// No description provided for @sinVentas.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay ventas registradas.'**
  String get sinVentas;

  /// No description provided for @mesLabel.
  ///
  /// In es, this message translates to:
  /// **'Mes:'**
  String get mesLabel;

  /// No description provided for @sinVentasEnMes.
  ///
  /// In es, this message translates to:
  /// **'No hubo ventas en {mes}.'**
  String sinVentasEnMes(String mes);

  /// No description provided for @ventaSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'{fecha}  ·  Cant: {cantidad}'**
  String ventaSubtitulo(String fecha, int cantidad);

  /// No description provided for @analisisVentasTitulo.
  ///
  /// In es, this message translates to:
  /// **'Análisis de ventas'**
  String get analisisVentasTitulo;

  /// No description provided for @sinVentasAnalizar.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay ventas para analizar.'**
  String get sinVentasAnalizar;

  /// No description provided for @resumenGeneral.
  ///
  /// In es, this message translates to:
  /// **'Resumen general'**
  String get resumenGeneral;

  /// No description provided for @ticketPromedio.
  ///
  /// In es, this message translates to:
  /// **'Ticket promedio'**
  String get ticketPromedio;

  /// No description provided for @numVentasLabel.
  ///
  /// In es, this message translates to:
  /// **'Nº de ventas'**
  String get numVentasLabel;

  /// No description provided for @totalVendido.
  ///
  /// In es, this message translates to:
  /// **'Total vendido'**
  String get totalVendido;

  /// No description provided for @demandaPorMes.
  ///
  /// In es, this message translates to:
  /// **'Demanda por mes'**
  String get demandaPorMes;

  /// No description provided for @demandaFuerteFlojo.
  ///
  /// In es, this message translates to:
  /// **'Más fuerte: {fuerte} · Más flojo: {flojo}'**
  String demandaFuerteFlojo(String fuerte, String flojo);

  /// No description provided for @ventasPorDia.
  ///
  /// In es, this message translates to:
  /// **'Ventas por día de la semana'**
  String get ventasPorDia;

  /// No description provided for @mejorDia.
  ///
  /// In es, this message translates to:
  /// **'Tu mejor día es el {dia}'**
  String mejorDia(String dia);

  /// No description provided for @sinDatosSuficientes.
  ///
  /// In es, this message translates to:
  /// **'Sin datos suficientes'**
  String get sinDatosSuficientes;

  /// No description provided for @fechasPico.
  ///
  /// In es, this message translates to:
  /// **'Fechas pico'**
  String get fechasPico;

  /// No description provided for @fechasPicoAyuda.
  ///
  /// In es, this message translates to:
  /// **'Tus días con más ventas (ahí están tus fechas especiales)'**
  String get fechasPicoAyuda;

  /// No description provided for @topProductosTitulo.
  ///
  /// In es, this message translates to:
  /// **'Top de productos'**
  String get topProductosTitulo;

  /// No description provided for @sinVentasProductos.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay ventas de productos registradas.'**
  String get sinVentasProductos;

  /// No description provided for @sinVentasProductosMes.
  ///
  /// In es, this message translates to:
  /// **'No hubo ventas de productos en este mes.'**
  String get sinVentasProductosMes;

  /// No description provided for @totalTexto.
  ///
  /// In es, this message translates to:
  /// **'Total: {valor}'**
  String totalTexto(String valor);

  /// No description provided for @categoriaInsumos.
  ///
  /// In es, this message translates to:
  /// **'Insumos'**
  String get categoriaInsumos;

  /// No description provided for @categoriaServicios.
  ///
  /// In es, this message translates to:
  /// **'Servicios'**
  String get categoriaServicios;

  /// No description provided for @categoriaEmpaques.
  ///
  /// In es, this message translates to:
  /// **'Empaques'**
  String get categoriaEmpaques;

  /// No description provided for @categoriaOtros.
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get categoriaOtros;

  /// No description provided for @gastoDescripcionMonto.
  ///
  /// In es, this message translates to:
  /// **'Escribe una descripción y un monto válido'**
  String get gastoDescripcionMonto;

  /// No description provided for @confirmarGasto.
  ///
  /// In es, this message translates to:
  /// **'Confirmar gasto'**
  String get confirmarGasto;

  /// No description provided for @confirmarGastoTexto.
  ///
  /// In es, this message translates to:
  /// **'¿Registrar el gasto «{descripcion}» por {monto}?'**
  String confirmarGastoTexto(String descripcion, String monto);

  /// No description provided for @guardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get guardar;

  /// No description provided for @primeroCreaInsumos.
  ///
  /// In es, this message translates to:
  /// **'Primero crea insumos en Inventario.'**
  String get primeroCreaInsumos;

  /// No description provided for @insumoYaEnLista.
  ///
  /// In es, this message translates to:
  /// **'Ese insumo ya está en la lista.'**
  String get insumoYaEnLista;

  /// No description provided for @cantidadCompradaUnidad.
  ///
  /// In es, this message translates to:
  /// **'Cantidad comprada ({unidad})'**
  String cantidadCompradaUnidad(String unidad);

  /// No description provided for @totalPagado.
  ///
  /// In es, this message translates to:
  /// **'Total pagado'**
  String get totalPagado;

  /// No description provided for @agregar.
  ///
  /// In es, this message translates to:
  /// **'Agregar'**
  String get agregar;

  /// No description provided for @cantidadTotalMayorCero.
  ///
  /// In es, this message translates to:
  /// **'Cantidad y total deben ser mayores a cero.'**
  String get cantidadTotalMayorCero;

  /// No description provided for @agregaAlMenosInsumo.
  ///
  /// In es, this message translates to:
  /// **'Agrega al menos un insumo.'**
  String get agregaAlMenosInsumo;

  /// No description provided for @confirmarCompra.
  ///
  /// In es, this message translates to:
  /// **'Confirmar compra'**
  String get confirmarCompra;

  /// No description provided for @confirmarCompraTexto.
  ///
  /// In es, this message translates to:
  /// **'¿Registrar la compra de {cantidad} insumo(s) por {total}? Se sumará el stock y se registrará el gasto.'**
  String confirmarCompraTexto(int cantidad, String total);

  /// No description provided for @registrarGastoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Registrar gasto'**
  String get registrarGastoTitulo;

  /// No description provided for @gastoNormal.
  ///
  /// In es, this message translates to:
  /// **'Gasto normal'**
  String get gastoNormal;

  /// No description provided for @compraInsumos.
  ///
  /// In es, this message translates to:
  /// **'Compra de insumos'**
  String get compraInsumos;

  /// No description provided for @gastoDescripcionHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: pago de arriendo'**
  String get gastoDescripcionHint;

  /// No description provided for @monto.
  ///
  /// In es, this message translates to:
  /// **'Monto'**
  String get monto;

  /// No description provided for @categoria.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get categoria;

  /// No description provided for @guardarGasto.
  ///
  /// In es, this message translates to:
  /// **'Guardar gasto'**
  String get guardarGasto;

  /// No description provided for @compraInsumosAyuda.
  ///
  /// In es, this message translates to:
  /// **'Agrega los insumos que compraste. Se sumará su stock y el costo por unidad se recalcula (promedio ponderado).'**
  String get compraInsumosAyuda;

  /// No description provided for @agregarInsumoBtn.
  ///
  /// In es, this message translates to:
  /// **'Agregar insumo'**
  String get agregarInsumoBtn;

  /// No description provided for @sinInsumosAgregados.
  ///
  /// In es, this message translates to:
  /// **'Aún no has agregado insumos.'**
  String get sinInsumosAgregados;

  /// No description provided for @descripcionOpcional.
  ///
  /// In es, this message translates to:
  /// **'Descripción (opcional)'**
  String get descripcionOpcional;

  /// No description provided for @compraDescHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: compra en la plaza'**
  String get compraDescHint;

  /// No description provided for @totalGasto.
  ///
  /// In es, this message translates to:
  /// **'Total del gasto'**
  String get totalGasto;

  /// No description provided for @guardarCompraReponer.
  ///
  /// In es, this message translates to:
  /// **'Guardar compra y reponer stock'**
  String get guardarCompraReponer;

  /// No description provided for @eliminarGastoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Eliminar gasto'**
  String get eliminarGastoTitulo;

  /// No description provided for @eliminarGastoConfirmacion.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar «{descripcion}»?'**
  String eliminarGastoConfirmacion(String descripcion);

  /// No description provided for @historialGastosTitulo.
  ///
  /// In es, this message translates to:
  /// **'Historial de gastos'**
  String get historialGastosTitulo;

  /// No description provided for @sinGastos.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay gastos registrados.'**
  String get sinGastos;

  /// No description provided for @sinGastosEnMes.
  ///
  /// In es, this message translates to:
  /// **'No hubo gastos en {mes}.'**
  String sinGastosEnMes(String mes);

  /// No description provided for @gastoSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'{fecha}  ·  {categoria}'**
  String gastoSubtitulo(String fecha, String categoria);

  /// No description provided for @editarGastoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Editar gasto'**
  String get editarGastoTitulo;

  /// No description provided for @entregarPedido.
  ///
  /// In es, this message translates to:
  /// **'Entregar pedido'**
  String get entregarPedido;

  /// No description provided for @entregarPedidoTexto.
  ///
  /// In es, this message translates to:
  /// **'Al marcar este pedido como entregado, su valor de {precio} se registrará como un ingreso y aparecerá en tu historial de ventas.'**
  String entregarPedidoTexto(String precio);

  /// No description provided for @pedidoEntregadoOk.
  ///
  /// In es, this message translates to:
  /// **'Pedido entregado y registrado en ingresos'**
  String get pedidoEntregadoOk;

  /// No description provided for @pedidoEntregadoNegativo.
  ///
  /// In es, this message translates to:
  /// **'Entregado. Stock en negativo: {insumos}'**
  String pedidoEntregadoNegativo(String insumos);

  /// No description provided for @entregar.
  ///
  /// In es, this message translates to:
  /// **'Entregar'**
  String get entregar;

  /// No description provided for @eliminarPedidoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Eliminar pedido'**
  String get eliminarPedidoTitulo;

  /// No description provided for @eliminarPedidoEntregado.
  ///
  /// In es, this message translates to:
  /// **'Este pedido ya fue entregado. Su ingreso ya quedó registrado como una venta y NO se modificará al eliminarlo.'**
  String get eliminarPedidoEntregado;

  /// No description provided for @eliminarPedidoConfirmacion.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar el pedido de {cliente}?'**
  String eliminarPedidoConfirmacion(String cliente);

  /// No description provided for @pedidoArchivado.
  ///
  /// In es, this message translates to:
  /// **'Pedido archivado'**
  String get pedidoArchivado;

  /// No description provided for @deshacer.
  ///
  /// In es, this message translates to:
  /// **'Deshacer'**
  String get deshacer;

  /// No description provided for @pedidoFab.
  ///
  /// In es, this message translates to:
  /// **'Pedido'**
  String get pedidoFab;

  /// No description provided for @pedidosVacio.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay pedidos.\nCrea el primero con el botón +'**
  String get pedidosVacio;

  /// No description provided for @pendientes.
  ///
  /// In es, this message translates to:
  /// **'Pendientes'**
  String get pendientes;

  /// No description provided for @entregados.
  ///
  /// In es, this message translates to:
  /// **'Entregados'**
  String get entregados;

  /// No description provided for @sinEntregados.
  ///
  /// In es, this message translates to:
  /// **'Aún no has entregado pedidos.'**
  String get sinEntregados;

  /// No description provided for @ocultarArchivados.
  ///
  /// In es, this message translates to:
  /// **'Ocultar archivados'**
  String get ocultarArchivados;

  /// No description provided for @verArchivadosBtn.
  ///
  /// In es, this message translates to:
  /// **'Ver archivados ({n})'**
  String verArchivadosBtn(int n);

  /// No description provided for @archivar.
  ///
  /// In es, this message translates to:
  /// **'Archivar'**
  String get archivar;

  /// No description provided for @desarchivar.
  ///
  /// In es, this message translates to:
  /// **'Desarchivar'**
  String get desarchivar;

  /// No description provided for @entregadoEstado.
  ///
  /// In es, this message translates to:
  /// **'Entregado'**
  String get entregadoEstado;

  /// No description provided for @archivadoEstado.
  ///
  /// In es, this message translates to:
  /// **'Archivado'**
  String get archivadoEstado;

  /// No description provided for @marcarEntregado.
  ///
  /// In es, this message translates to:
  /// **'Marcar como entregado'**
  String get marcarEntregado;

  /// No description provided for @sinProductosCreados.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes productos creados'**
  String get sinProductosCreados;

  /// No description provided for @itemManual.
  ///
  /// In es, this message translates to:
  /// **'Ítem manual'**
  String get itemManual;

  /// No description provided for @costoUnitarioOpcional.
  ///
  /// In es, this message translates to:
  /// **'Costo unitario (opcional)'**
  String get costoUnitarioOpcional;

  /// No description provided for @faltaClienteItemFecha.
  ///
  /// In es, this message translates to:
  /// **'Falta el cliente, al menos un ítem (o valor) y la fecha'**
  String get faltaClienteItemFecha;

  /// No description provided for @faltaClienteItem.
  ///
  /// In es, this message translates to:
  /// **'Falta el cliente o al menos un ítem (o valor)'**
  String get faltaClienteItem;

  /// No description provided for @otroValorItem.
  ///
  /// In es, this message translates to:
  /// **'Otro valor'**
  String get otroValorItem;

  /// No description provided for @pedidoFallback.
  ///
  /// In es, this message translates to:
  /// **'Pedido'**
  String get pedidoFallback;

  /// No description provided for @nuevoPedidoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Nuevo pedido'**
  String get nuevoPedidoTitulo;

  /// No description provided for @nombreCliente.
  ///
  /// In es, this message translates to:
  /// **'Nombre del cliente'**
  String get nombreCliente;

  /// No description provided for @telefonoOpcional.
  ///
  /// In es, this message translates to:
  /// **'Teléfono (opcional)'**
  String get telefonoOpcional;

  /// No description provided for @productosDelPedido.
  ///
  /// In es, this message translates to:
  /// **'Productos del pedido'**
  String get productosDelPedido;

  /// No description provided for @delCatalogo.
  ///
  /// In es, this message translates to:
  /// **'Del catálogo'**
  String get delCatalogo;

  /// No description provided for @manual.
  ///
  /// In es, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @sinItemsCrear.
  ///
  /// In es, this message translates to:
  /// **'Agrega productos del catálogo o ítems manuales.'**
  String get sinItemsCrear;

  /// No description provided for @otroValorLabel.
  ///
  /// In es, this message translates to:
  /// **'Otro valor (domicilio, servicios...)'**
  String get otroValorLabel;

  /// No description provided for @precio.
  ///
  /// In es, this message translates to:
  /// **'Precio'**
  String get precio;

  /// No description provided for @fechaEntrega.
  ///
  /// In es, this message translates to:
  /// **'Fecha de entrega'**
  String get fechaEntrega;

  /// No description provided for @sinElegir.
  ///
  /// In es, this message translates to:
  /// **'Sin elegir'**
  String get sinElegir;

  /// No description provided for @elegir.
  ///
  /// In es, this message translates to:
  /// **'Elegir'**
  String get elegir;

  /// No description provided for @guardarPedido.
  ///
  /// In es, this message translates to:
  /// **'Guardar pedido'**
  String get guardarPedido;

  /// No description provided for @editarPedidoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Editar pedido'**
  String get editarPedidoTitulo;

  /// No description provided for @editarPedidoEntregado.
  ///
  /// In es, this message translates to:
  /// **'Este pedido ya fue entregado. Editarlo no cambia el ingreso ya registrado.'**
  String get editarPedidoEntregado;

  /// No description provided for @sinItemsEditar.
  ///
  /// In es, this message translates to:
  /// **'Sin ítems. Agrega del catálogo o manuales.'**
  String get sinItemsEditar;

  /// No description provided for @cambiar.
  ///
  /// In es, this message translates to:
  /// **'Cambiar'**
  String get cambiar;

  /// No description provided for @analisisYReportes.
  ///
  /// In es, this message translates to:
  /// **'Análisis y reportes'**
  String get analisisYReportes;

  /// No description provided for @reportesVacio.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay datos para analizar.\nRegistra ventas y gastos para ver tus reportes.'**
  String get reportesVacio;

  /// No description provided for @gananciaDeMes.
  ///
  /// In es, this message translates to:
  /// **'Ganancia de {mes}'**
  String gananciaDeMes(String mes);

  /// No description provided for @sinComparacion.
  ///
  /// In es, this message translates to:
  /// **'— sin comparación'**
  String get sinComparacion;

  /// No description provided for @mesAnterior.
  ///
  /// In es, this message translates to:
  /// **'Mes anterior ({mes}): {valor}'**
  String mesAnterior(String mes, String valor);

  /// No description provided for @gananciaPorMes.
  ///
  /// In es, this message translates to:
  /// **'Ganancia por mes'**
  String get gananciaPorMes;

  /// No description provided for @reportesMensuales.
  ///
  /// In es, this message translates to:
  /// **'Reportes mensuales'**
  String get reportesMensuales;

  /// No description provided for @reportesMensualesSub.
  ///
  /// In es, this message translates to:
  /// **'Descarga el extracto en PDF de cada mes cerrado'**
  String get reportesMensualesSub;

  /// No description provided for @pdfError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo generar el PDF.'**
  String get pdfError;

  /// No description provided for @sinMesesCerrados.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay meses cerrados para reportar.\nAl terminar el mes actual, aparecerá aquí.'**
  String get sinMesesCerrados;

  /// No description provided for @ingresosGastos.
  ///
  /// In es, this message translates to:
  /// **'Ingresos: {ingresos}  ·  Gastos: {gastos}'**
  String ingresosGastos(String ingresos, String gastos);

  /// No description provided for @descargarPdf.
  ///
  /// In es, this message translates to:
  /// **'Descargar PDF'**
  String get descargarPdf;

  /// No description provided for @topProductosMes.
  ///
  /// In es, this message translates to:
  /// **'Top productos del mes'**
  String get topProductosMes;

  /// No description provided for @topSinVentasMes.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay ventas de productos este mes.'**
  String get topSinVentasMes;

  /// No description provided for @vendidosAbrev.
  ///
  /// In es, this message translates to:
  /// **'{cantidad} vend.'**
  String vendidosAbrev(int cantidad);

  /// No description provided for @resumenAnalisisCorto.
  ///
  /// In es, this message translates to:
  /// **'Ticket promedio {ticket} · Mejor día: {dia}'**
  String resumenAnalisisCorto(String ticket, String dia);

  /// No description provided for @verMas.
  ///
  /// In es, this message translates to:
  /// **'Ver más'**
  String get verMas;

  /// No description provided for @nombreCatalogo.
  ///
  /// In es, this message translates to:
  /// **'Nombre del catálogo'**
  String get nombreCatalogo;

  /// No description provided for @subir.
  ///
  /// In es, this message translates to:
  /// **'Subir'**
  String get subir;

  /// No description provided for @errorLeerArchivo.
  ///
  /// In es, this message translates to:
  /// **'No se pudo leer el archivo.'**
  String get errorLeerArchivo;

  /// No description provided for @soloPdf.
  ///
  /// In es, this message translates to:
  /// **'Por ahora solo se admiten archivos PDF.'**
  String get soloPdf;

  /// No description provided for @archivoSupera15.
  ///
  /// In es, this message translates to:
  /// **'El archivo supera el límite de 15 MB.'**
  String get archivoSupera15;

  /// No description provided for @errorSubirCatalogo.
  ///
  /// In es, this message translates to:
  /// **'No se pudo subir el catálogo. Intenta de nuevo.'**
  String get errorSubirCatalogo;

  /// No description provided for @errorAbrirCatalogo.
  ///
  /// In es, this message translates to:
  /// **'No se pudo abrir el catálogo.'**
  String get errorAbrirCatalogo;

  /// No description provided for @eliminarCatalogoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Eliminar catálogo'**
  String get eliminarCatalogoTitulo;

  /// No description provided for @eliminarCatalogoConfirmacion.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar «{nombre}»? El archivo PDF se borrará.'**
  String eliminarCatalogoConfirmacion(String nombre);

  /// No description provided for @errorEliminar.
  ///
  /// In es, this message translates to:
  /// **'No se pudo eliminar.'**
  String get errorEliminar;

  /// No description provided for @subiendo.
  ///
  /// In es, this message translates to:
  /// **'Subiendo...'**
  String get subiendo;

  /// No description provided for @subirPdf.
  ///
  /// In es, this message translates to:
  /// **'Subir PDF'**
  String get subirPdf;

  /// No description provided for @catalogosVacio.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes catálogos.\nSube un PDF con el botón de abajo.'**
  String get catalogosVacio;

  /// No description provided for @abrir.
  ///
  /// In es, this message translates to:
  /// **'Abrir'**
  String get abrir;

  /// No description provided for @notaFaltaAsunto.
  ///
  /// In es, this message translates to:
  /// **'Escribe al menos el asunto de la nota'**
  String get notaFaltaAsunto;

  /// No description provided for @editarNotaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Editar nota'**
  String get editarNotaTitulo;

  /// No description provided for @asunto.
  ///
  /// In es, this message translates to:
  /// **'Asunto'**
  String get asunto;

  /// No description provided for @contenido.
  ///
  /// In es, this message translates to:
  /// **'Contenido'**
  String get contenido;

  /// No description provided for @notaContenidoHint.
  ///
  /// In es, this message translates to:
  /// **'Escribe el detalle de la nota...'**
  String get notaContenidoHint;

  /// No description provided for @guardarNota.
  ///
  /// In es, this message translates to:
  /// **'Guardar nota'**
  String get guardarNota;

  /// No description provided for @eliminarNotaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Eliminar nota'**
  String get eliminarNotaTitulo;

  /// No description provided for @eliminarNotaConfirmacion.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar «{asunto}»?'**
  String eliminarNotaConfirmacion(String asunto);

  /// No description provided for @notaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Nota'**
  String get notaTitulo;

  /// No description provided for @notaNoExiste.
  ///
  /// In es, this message translates to:
  /// **'Esta nota ya no existe.'**
  String get notaNoExiste;

  /// No description provided for @notaPorAutor.
  ///
  /// In es, this message translates to:
  /// **'{fecha}  ·  Por {autor}'**
  String notaPorAutor(String fecha, String autor);

  /// No description provided for @sinContenido.
  ///
  /// In es, this message translates to:
  /// **'(Sin contenido)'**
  String get sinContenido;

  /// No description provided for @entregaHoy.
  ///
  /// In es, this message translates to:
  /// **'Entrega hoy'**
  String get entregaHoy;

  /// No description provided for @entregaManana.
  ///
  /// In es, this message translates to:
  /// **'Entrega mañana'**
  String get entregaManana;

  /// No description provided for @sinAvisos.
  ///
  /// In es, this message translates to:
  /// **'No tienes avisos por ahora. ¡Todo al día!'**
  String get sinAvisos;

  /// No description provided for @avisoPedidoDetalle.
  ///
  /// In es, this message translates to:
  /// **'{urgencia}  ·  {precio}'**
  String avisoPedidoDetalle(String urgencia, String precio);

  /// No description provided for @inventarioBajo.
  ///
  /// In es, this message translates to:
  /// **'Inventario bajo'**
  String get inventarioBajo;

  /// No description provided for @insumoBajoDetalle.
  ///
  /// In es, this message translates to:
  /// **'Quedan {stock} {unidad} (mínimo {minimo})'**
  String insumoBajoDetalle(String stock, String unidad, String minimo);

  /// No description provided for @notasNuevas.
  ///
  /// In es, this message translates to:
  /// **'Notas nuevas'**
  String get notasNuevas;

  /// No description provided for @porAutor.
  ///
  /// In es, this message translates to:
  /// **'Por {autor}'**
  String porAutor(String autor);

  /// No description provided for @notifConfigAyuda.
  ///
  /// In es, this message translates to:
  /// **'Elige qué avisos quieres recibir dentro de la app.'**
  String get notifConfigAyuda;

  /// No description provided for @notifPedidosSub.
  ///
  /// In es, this message translates to:
  /// **'Entregas de hoy, mañana o atrasadas'**
  String get notifPedidosSub;

  /// No description provided for @notifNotasSub.
  ///
  /// In es, this message translates to:
  /// **'Cuando alguien crea una nota'**
  String get notifNotasSub;

  /// No description provided for @notifInsumosSub.
  ///
  /// In es, this message translates to:
  /// **'Insumos por debajo de su stock mínimo'**
  String get notifInsumosSub;

  /// No description provided for @modo.
  ///
  /// In es, this message translates to:
  /// **'Modo'**
  String get modo;

  /// No description provided for @modoClaro.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get modoClaro;

  /// No description provided for @modoOscuro.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get modoOscuro;

  /// No description provided for @modoAuto.
  ///
  /// In es, this message translates to:
  /// **'Automático (según el sistema)'**
  String get modoAuto;

  /// No description provided for @colorAcento.
  ///
  /// In es, this message translates to:
  /// **'Color de acento'**
  String get colorAcento;

  /// No description provided for @acentoVerde.
  ///
  /// In es, this message translates to:
  /// **'Verde'**
  String get acentoVerde;

  /// No description provided for @acentoAzul.
  ///
  /// In es, this message translates to:
  /// **'Azul'**
  String get acentoAzul;

  /// No description provided for @acentoTurquesa.
  ///
  /// In es, this message translates to:
  /// **'Turquesa'**
  String get acentoTurquesa;

  /// No description provided for @acentoMorado.
  ///
  /// In es, this message translates to:
  /// **'Morado'**
  String get acentoMorado;

  /// No description provided for @acentoNaranja.
  ///
  /// In es, this message translates to:
  /// **'Naranja'**
  String get acentoNaranja;

  /// No description provided for @acentoRosa.
  ///
  /// In es, this message translates to:
  /// **'Rosa'**
  String get acentoRosa;

  /// No description provided for @aparienciaNota.
  ///
  /// In es, this message translates to:
  /// **'El tema y el color de acento se aplican a toda la app.'**
  String get aparienciaNota;

  /// No description provided for @completaCampos.
  ///
  /// In es, this message translates to:
  /// **'Completa todos los campos.'**
  String get completaCampos;

  /// No description provided for @passwordMin6.
  ///
  /// In es, this message translates to:
  /// **'La nueva contraseña debe tener al menos 6 caracteres.'**
  String get passwordMin6;

  /// No description provided for @passwordNoCoincide.
  ///
  /// In es, this message translates to:
  /// **'La nueva contraseña y su confirmación no coinciden.'**
  String get passwordNoCoincide;

  /// No description provided for @sinSesionValida.
  ///
  /// In es, this message translates to:
  /// **'No hay una sesión válida.'**
  String get sinSesionValida;

  /// No description provided for @passwordActualizada.
  ///
  /// In es, this message translates to:
  /// **'Contraseña actualizada'**
  String get passwordActualizada;

  /// No description provided for @passwordActualIncorrecta.
  ///
  /// In es, this message translates to:
  /// **'La contraseña actual es incorrecta.'**
  String get passwordActualIncorrecta;

  /// No description provided for @passwordDebil.
  ///
  /// In es, this message translates to:
  /// **'La nueva contraseña es muy débil.'**
  String get passwordDebil;

  /// No description provided for @requiereReloginPassword.
  ///
  /// In es, this message translates to:
  /// **'Por seguridad, vuelve a iniciar sesión e intenta de nuevo.'**
  String get requiereReloginPassword;

  /// No description provided for @demasiadosIntentos.
  ///
  /// In es, this message translates to:
  /// **'Demasiados intentos. Espera un momento e inténtalo de nuevo.'**
  String get demasiadosIntentos;

  /// No description provided for @errorCambiarPassword.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cambiar la contraseña. Intenta de nuevo.'**
  String get errorCambiarPassword;

  /// No description provided for @cambiarContrasena.
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña'**
  String get cambiarContrasena;

  /// No description provided for @passwordActual.
  ///
  /// In es, this message translates to:
  /// **'Contraseña actual'**
  String get passwordActual;

  /// No description provided for @passwordNueva.
  ///
  /// In es, this message translates to:
  /// **'Nueva contraseña'**
  String get passwordNueva;

  /// No description provided for @passwordConfirmar.
  ///
  /// In es, this message translates to:
  /// **'Confirmar nueva contraseña'**
  String get passwordConfirmar;

  /// No description provided for @guardando.
  ///
  /// In es, this message translates to:
  /// **'Guardando...'**
  String get guardando;

  /// No description provided for @errorLeerImagen.
  ///
  /// In es, this message translates to:
  /// **'No se pudo leer la imagen.'**
  String get errorLeerImagen;

  /// No description provided for @imagenSupera5.
  ///
  /// In es, this message translates to:
  /// **'La imagen supera el límite de 5 MB.'**
  String get imagenSupera5;

  /// No description provided for @fotoActualizada.
  ///
  /// In es, this message translates to:
  /// **'Foto actualizada'**
  String get fotoActualizada;

  /// No description provided for @errorSubirFoto.
  ///
  /// In es, this message translates to:
  /// **'No se pudo subir la foto.'**
  String get errorSubirFoto;

  /// No description provided for @logoActualizado.
  ///
  /// In es, this message translates to:
  /// **'Logo actualizado'**
  String get logoActualizado;

  /// No description provided for @errorSubirLogo.
  ///
  /// In es, this message translates to:
  /// **'No se pudo subir el logo. ¿Eres el dueño?'**
  String get errorSubirLogo;

  /// No description provided for @quitar.
  ///
  /// In es, this message translates to:
  /// **'Quitar'**
  String get quitar;

  /// No description provided for @quitarFoto.
  ///
  /// In es, this message translates to:
  /// **'Quitar foto'**
  String get quitarFoto;

  /// No description provided for @quitarFotoConfirmacion.
  ///
  /// In es, this message translates to:
  /// **'¿Quitar tu foto de perfil?'**
  String get quitarFotoConfirmacion;

  /// No description provided for @fotoEliminada.
  ///
  /// In es, this message translates to:
  /// **'Foto eliminada'**
  String get fotoEliminada;

  /// No description provided for @errorEliminarFoto.
  ///
  /// In es, this message translates to:
  /// **'No se pudo eliminar la foto.'**
  String get errorEliminarFoto;

  /// No description provided for @quitarLogo.
  ///
  /// In es, this message translates to:
  /// **'Quitar logo'**
  String get quitarLogo;

  /// No description provided for @quitarLogoConfirmacion.
  ///
  /// In es, this message translates to:
  /// **'¿Quitar el logo de la empresa?'**
  String get quitarLogoConfirmacion;

  /// No description provided for @logoEliminado.
  ///
  /// In es, this message translates to:
  /// **'Logo eliminado'**
  String get logoEliminado;

  /// No description provided for @errorEliminarLogo.
  ///
  /// In es, this message translates to:
  /// **'No se pudo eliminar el logo.'**
  String get errorEliminarLogo;

  /// No description provided for @logoEmpresa.
  ///
  /// In es, this message translates to:
  /// **'Logo de la empresa'**
  String get logoEmpresa;

  /// No description provided for @subirLogo.
  ///
  /// In es, this message translates to:
  /// **'Subir logo'**
  String get subirLogo;

  /// No description provided for @cambiarLogo.
  ///
  /// In es, this message translates to:
  /// **'Cambiar logo'**
  String get cambiarLogo;

  /// No description provided for @soloDuenoCambia.
  ///
  /// In es, this message translates to:
  /// **'Solo el dueño puede cambiarlo'**
  String get soloDuenoCambia;

  /// No description provided for @perfilGuardado.
  ///
  /// In es, this message translates to:
  /// **'Perfil guardado'**
  String get perfilGuardado;

  /// No description provided for @errorGuardarPerfil.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar el perfil.'**
  String get errorGuardarPerfil;

  /// No description provided for @nombreEmpresaVacio.
  ///
  /// In es, this message translates to:
  /// **'El nombre de la empresa no puede quedar vacío.'**
  String get nombreEmpresaVacio;

  /// No description provided for @empresaGuardada.
  ///
  /// In es, this message translates to:
  /// **'Datos de la empresa guardados'**
  String get empresaGuardada;

  /// No description provided for @errorGuardarEmpresa.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar. ¿Eres el dueño del negocio?'**
  String get errorGuardarEmpresa;

  /// No description provided for @tocaCamara.
  ///
  /// In es, this message translates to:
  /// **'Toca la cámara para cambiar tu foto'**
  String get tocaCamara;

  /// No description provided for @informacionPersonal.
  ///
  /// In es, this message translates to:
  /// **'Información personal'**
  String get informacionPersonal;

  /// No description provided for @correoCuenta.
  ///
  /// In es, this message translates to:
  /// **'Correo (de tu cuenta)'**
  String get correoCuenta;

  /// No description provided for @celular.
  ///
  /// In es, this message translates to:
  /// **'Celular'**
  String get celular;

  /// No description provided for @guardarPerfil.
  ///
  /// In es, this message translates to:
  /// **'Guardar perfil'**
  String get guardarPerfil;

  /// No description provided for @soloLectura.
  ///
  /// In es, this message translates to:
  /// **'Solo lectura'**
  String get soloLectura;

  /// No description provided for @soloDuenoEdita.
  ///
  /// In es, this message translates to:
  /// **'Solo el dueño del negocio puede editar estos datos.'**
  String get soloDuenoEdita;

  /// No description provided for @nombreEmpresa.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la empresa'**
  String get nombreEmpresa;

  /// No description provided for @nit.
  ///
  /// In es, this message translates to:
  /// **'NIT'**
  String get nit;

  /// No description provided for @correoEmpresa.
  ///
  /// In es, this message translates to:
  /// **'Correo de la empresa'**
  String get correoEmpresa;

  /// No description provided for @telefono.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get telefono;

  /// No description provided for @ubicacion.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get ubicacion;

  /// No description provided for @guardarEmpresa.
  ///
  /// In es, this message translates to:
  /// **'Guardar empresa'**
  String get guardarEmpresa;

  /// No description provided for @preferenciasNegocio.
  ///
  /// In es, this message translates to:
  /// **'Preferencias del negocio'**
  String get preferenciasNegocio;

  /// No description provided for @ajustesSeguridadCaption.
  ///
  /// In es, this message translates to:
  /// **'El idioma de la aplicación se puede cambiar aquí y se aplica a toda la app. País y moneda no se pueden cambiar por ahora.'**
  String get ajustesSeguridadCaption;

  /// No description provided for @seguridad.
  ///
  /// In es, this message translates to:
  /// **'Seguridad'**
  String get seguridad;

  /// No description provided for @notas.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get notas;

  /// No description provided for @buscadorHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar en tu negocio...'**
  String get buscadorHint;

  /// No description provided for @buscadorInicio.
  ///
  /// In es, this message translates to:
  /// **'Busca productos, insumos, pedidos, recetas, notas y catálogos.'**
  String get buscadorInicio;

  /// No description provided for @buscadorSinResultados.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados para «{q}»'**
  String buscadorSinResultados(String q);

  /// No description provided for @miembrosInvitaciones.
  ///
  /// In es, this message translates to:
  /// **'Miembros e invitaciones'**
  String get miembrosInvitaciones;

  /// No description provided for @miembrosInvitacionesSub.
  ///
  /// In es, this message translates to:
  /// **'Invita a tu equipo y gestiona roles'**
  String get miembrosInvitacionesSub;

  /// No description provided for @invitacionesTitulo.
  ///
  /// In es, this message translates to:
  /// **'Invitaciones'**
  String get invitacionesTitulo;

  /// No description provided for @generarInvitacion.
  ///
  /// In es, this message translates to:
  /// **'Generar invitación'**
  String get generarInvitacion;

  /// No description provided for @miembrosTitulo.
  ///
  /// In es, this message translates to:
  /// **'Miembros'**
  String get miembrosTitulo;

  /// No description provided for @rolDueno.
  ///
  /// In es, this message translates to:
  /// **'Dueño'**
  String get rolDueno;

  /// No description provided for @rolSocio.
  ///
  /// In es, this message translates to:
  /// **'Socio'**
  String get rolSocio;

  /// No description provided for @rolEmpleado.
  ///
  /// In es, this message translates to:
  /// **'Empleado'**
  String get rolEmpleado;

  /// No description provided for @elegirRolInvitacion.
  ///
  /// In es, this message translates to:
  /// **'¿Qué rol tendrá la persona?'**
  String get elegirRolInvitacion;

  /// No description provided for @invitacionCreada.
  ///
  /// In es, this message translates to:
  /// **'Invitación creada'**
  String get invitacionCreada;

  /// No description provided for @codigoInvitacion.
  ///
  /// In es, this message translates to:
  /// **'Código de invitación'**
  String get codigoInvitacion;

  /// No description provided for @copiar.
  ///
  /// In es, this message translates to:
  /// **'Copiar'**
  String get copiar;

  /// No description provided for @copiado.
  ///
  /// In es, this message translates to:
  /// **'Copiado'**
  String get copiado;

  /// No description provided for @compartirCodigoAyuda.
  ///
  /// In es, this message translates to:
  /// **'Comparte este código. La persona lo usa al registrarse para unirse a tu negocio.'**
  String get compartirCodigoAyuda;

  /// No description provided for @revocar.
  ///
  /// In es, this message translates to:
  /// **'Revocar'**
  String get revocar;

  /// No description provided for @invitacionPendiente.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get invitacionPendiente;

  /// No description provided for @invitacionUsada.
  ///
  /// In es, this message translates to:
  /// **'Usada'**
  String get invitacionUsada;

  /// No description provided for @sinInvitaciones.
  ///
  /// In es, this message translates to:
  /// **'No has generado invitaciones.'**
  String get sinInvitaciones;

  /// No description provided for @sinMiembros.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay otros miembros.'**
  String get sinMiembros;

  /// No description provided for @cambiarRolTitulo.
  ///
  /// In es, this message translates to:
  /// **'Cambiar rol'**
  String get cambiarRolTitulo;

  /// No description provided for @quitarDelNegocio.
  ///
  /// In es, this message translates to:
  /// **'Quitar del negocio'**
  String get quitarDelNegocio;

  /// No description provided for @quitarMiembroConfirmacion.
  ///
  /// In es, this message translates to:
  /// **'¿Quitar a {nombre} del negocio?'**
  String quitarMiembroConfirmacion(String nombre);

  /// No description provided for @unirseCodigo.
  ///
  /// In es, this message translates to:
  /// **'Unirme con un código'**
  String get unirseCodigo;

  /// No description provided for @unirseCodigoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Unirse a un negocio'**
  String get unirseCodigoTitulo;

  /// No description provided for @unirseCodigoAyuda.
  ///
  /// In es, this message translates to:
  /// **'Escribe el código de invitación que te compartió el dueño del negocio.'**
  String get unirseCodigoAyuda;

  /// No description provided for @unirme.
  ///
  /// In es, this message translates to:
  /// **'Unirme'**
  String get unirme;

  /// No description provided for @codigoVacio.
  ///
  /// In es, this message translates to:
  /// **'Escribe el código.'**
  String get codigoVacio;

  /// No description provided for @codigoNoExiste.
  ///
  /// In es, this message translates to:
  /// **'El código no existe.'**
  String get codigoNoExiste;

  /// No description provided for @codigoUsado.
  ///
  /// In es, this message translates to:
  /// **'Ese código ya fue usado.'**
  String get codigoUsado;

  /// No description provided for @codigoInvalido.
  ///
  /// In es, this message translates to:
  /// **'El código no es válido.'**
  String get codigoInvalido;

  /// No description provided for @unirseError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo unir. Intenta de nuevo.'**
  String get unirseError;

  /// No description provided for @sinNombre.
  ///
  /// In es, this message translates to:
  /// **'(sin nombre)'**
  String get sinNombre;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
