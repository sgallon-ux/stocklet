// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get ajustesTitulo => 'Paramètres';

  @override
  String get miNegocio => 'Mon entreprise';

  @override
  String get perfil => 'Profil';

  @override
  String get perfilSubtitulo => 'Vos informations personnelles';

  @override
  String get datosEmpresa => 'Informations de l\'entreprise';

  @override
  String get datosEmpresaSubtitulo => 'Nom, numéro fiscal, contact et adresse';

  @override
  String get notificaciones => 'Notifications';

  @override
  String get notificacionesSubtitulo =>
      'Alertes de commandes, notes et inventaire';

  @override
  String get ajustesSeguridad => 'Paramètres et sécurité';

  @override
  String get ajustesSeguridadSubtitulo =>
      'Pays, devise, langue et mot de passe';

  @override
  String get apariencia => 'Apparence';

  @override
  String get aparienciaSubtitulo => 'Thème et mode sombre';

  @override
  String get idioma => 'Langue';

  @override
  String get idiomaSubtitulo => 'Langue de l\'application';

  @override
  String get idiomaAutomatico => 'Automatique (appareil)';

  @override
  String get idiomaTituloDialogo => 'Choisissez une langue';

  @override
  String get acercaDe => 'À propos';

  @override
  String get acercaDeSubtitulo => 'Version et informations de l\'application';

  @override
  String get acercaDeDescripcion =>
      'Application de comptabilité pour votre entreprise.';

  @override
  String get cerrarSesion => 'Se déconnecter';

  @override
  String get cerrarSesionConfirmacion =>
      'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get cancelar => 'Annuler';

  @override
  String get campoCorreo => 'E-mail';

  @override
  String get campoContrasena => 'Mot de passe';

  @override
  String get crearCuenta => 'Créez votre compte';

  @override
  String get iniciarSesion => 'Se connecter';

  @override
  String get iniciaSesion => 'Se connecter';

  @override
  String get errorCorreoInvalido => 'L\'e-mail n\'est pas valide';

  @override
  String get loginBienvenido => 'Bienvenue';

  @override
  String get loginSubtitulo => 'Connectez-vous pour gérer votre entreprise';

  @override
  String get loginRecordarCorreo => 'Se souvenir de mon e-mail';

  @override
  String get loginEresNuevo => 'Nouveau ?';

  @override
  String get loginCompletaCampos =>
      'Saisissez votre e-mail et votre mot de passe';

  @override
  String get loginErrorGeneral => 'Connexion impossible';

  @override
  String get loginErrorNoExiste => 'Aucun compte n\'existe avec cet e-mail';

  @override
  String get loginErrorCredenciales => 'E-mail ou mot de passe incorrect';

  @override
  String get registroSubtitulo =>
      'Inscrivez-vous pour démarrer avec votre entreprise';

  @override
  String get registroMinimo => 'Au moins 6 caractères';

  @override
  String get registroBoton => 'Créer un compte';

  @override
  String get registroYaTienes => 'Vous avez déjà un compte ?';

  @override
  String get registroCompletaCampos =>
      'Saisissez un e-mail et un mot de passe d\'au moins 6 caractères';

  @override
  String get registroErrorGeneral => 'Impossible de créer le compte';

  @override
  String get registroErrorEnUso => 'Cet e-mail a déjà un compte';

  @override
  String get registroErrorDebil => 'Le mot de passe est trop faible';

  @override
  String get crearHubTitulo => 'Créer et gérer';

  @override
  String get inventario => 'Inventaire';

  @override
  String get inventarioSub => 'Fournitures, coûts et stock';

  @override
  String get productos => 'Produits';

  @override
  String get productosSub => 'Créez et gérez vos produits';

  @override
  String get pedidos => 'Commandes';

  @override
  String get pedidosSub => 'Commandes des clients';

  @override
  String get recetas => 'Recettes';

  @override
  String get recetasSub => 'Guides de préparation étape par étape';

  @override
  String get catalogo => 'Catalogue';

  @override
  String get catalogoSub => 'Vos catalogues PDF';

  @override
  String get onboardingBienvenido => 'Bienvenue !';

  @override
  String get onboardingSubtitulo =>
      'Parlez-nous de votre entreprise pour personnaliser l\'application';

  @override
  String get onboardingNombreNegocio => 'Nom de l\'entreprise';

  @override
  String get onboardingNombreVacio => 'Saisissez le nom de votre entreprise';

  @override
  String get onboardingCrearBoton => 'Créer mon entreprise';

  @override
  String get onboardingBuscarPais => 'Rechercher un pays';

  @override
  String get campoPais => 'Pays';

  @override
  String get campoMoneda => 'Devise';

  @override
  String errorGenerico(String detalle) {
    return 'Erreur : $detalle';
  }

  @override
  String get panelUsuario => 'Panneau utilisateur';

  @override
  String get buscar => 'Rechercher';

  @override
  String get busquedaProximamente => 'Recherche bientôt disponible';

  @override
  String get agregarVenta => 'Ajouter une vente';

  @override
  String get agregarGasto => 'Ajouter une dépense';

  @override
  String get navInicio => 'Accueil';

  @override
  String get navCrear => 'Créer';

  @override
  String get navReportes => 'Rapports';

  @override
  String get rangoEsteMes => 'Ce mois-ci';

  @override
  String get rango3Meses => '3 mois';

  @override
  String get rango6Meses => '6 mois';

  @override
  String get rangoAnio => 'Année';

  @override
  String get resumen => 'Résumé';

  @override
  String get ingresos => 'Revenus';

  @override
  String get gastos => 'Dépenses';

  @override
  String get ganancia => 'Bénéfice';

  @override
  String get tendenciaGanancia => 'Tendance du bénéfice';

  @override
  String get graficaSinDatos => 'Pas encore assez de données à afficher.';

  @override
  String get pedidosProximos => 'Commandes à venir';

  @override
  String get verTodos => 'Voir tout';

  @override
  String get sinPedidosPendientes => 'Vous n\'avez aucune commande en attente.';

  @override
  String get pedidoAtrasado => 'En retard';

  @override
  String get hoy => 'Aujourd\'hui';

  @override
  String get manana => 'Demain';

  @override
  String enDias(int dias) {
    return 'Dans $dias jours';
  }

  @override
  String get notasImportantes => 'Notes importantes';

  @override
  String get nuevaNota => 'Nouvelle note';

  @override
  String get sinNotas => 'Vous n\'avez aucune note. Créez-en une avec +';

  @override
  String get eliminar => 'Supprimer';

  @override
  String get editar => 'Modifier';

  @override
  String get campoNombre => 'Nom';

  @override
  String get unidadMedida => 'Unité de mesure';

  @override
  String get unidadGramos => 'Grammes (g)';

  @override
  String get unidadMililitros => 'Millilitres (ml)';

  @override
  String get unidadUnidades => 'Unités';

  @override
  String get stockMinimoOpcional => 'Stock minimum (facultatif)';

  @override
  String get stockMinimoHint => 'Alerter quand il passe sous...';

  @override
  String get buscarHint => 'Rechercher...';

  @override
  String get insumo => 'Fourniture';

  @override
  String get buscarInsumoHint => 'Rechercher une fourniture...';

  @override
  String get cerrarBusqueda => 'Fermer la recherche';

  @override
  String get inventarioVacio =>
      'Aucune fourniture pour l\'instant.\nAjoutez la première avec le bouton +';

  @override
  String get inventarioSinCoincidencias =>
      'Aucune fourniture ne correspond à la recherche.';

  @override
  String get eliminarInsumoTitulo => 'Supprimer la fourniture';

  @override
  String eliminarInsumoConfirmacion(String nombre) {
    return 'Voulez-vous vraiment supprimer $nombre ?';
  }

  @override
  String insumoNoEliminarEnUso(String nombre) {
    return 'Vous ne pouvez pas supprimer $nombre : un produit l\'utilise';
  }

  @override
  String costoPorUnidadTexto(String costo, String unidad) {
    return '$costo par $unidad';
  }

  @override
  String stockTexto(String cantidad, String unidad) {
    return 'Stock : $cantidad $unidad';
  }

  @override
  String get completaCamposValidos =>
      'Remplissez tous les champs avec des valeurs valides';

  @override
  String get agregarInsumoTitulo => 'Ajouter une fourniture';

  @override
  String get insumoNombreHint => 'Ex : Farine';

  @override
  String get cantidadComprada => 'Quantité achetée';

  @override
  String get cantidadCompradaHint => 'Ex : 1000';

  @override
  String get precioTotalPagado => 'Prix total payé';

  @override
  String get agregarInsumoAyuda =>
      'Avec la quantité et le prix, l\'application calcule seule le coût unitaire.';

  @override
  String get guardarInsumo => 'Enregistrer la fourniture';

  @override
  String get revisaCamposNegativos =>
      'Vérifiez les champs : valeurs valides, sans négatifs';

  @override
  String get editarInsumoTitulo => 'Modifier la fourniture';

  @override
  String get costoPorUnidadLabel => 'Coût unitaire';

  @override
  String get stockActualLabel => 'Stock actuel';

  @override
  String get guardarCambios => 'Enregistrer les modifications';

  @override
  String get elegirInsumoTitulo => 'Choisir une fourniture';

  @override
  String get ningunInsumoCoincide => 'Aucune fourniture ne correspond.';

  @override
  String get nuevo => 'Nouveau';

  @override
  String get costo => 'Coût';

  @override
  String get margen => 'Marge';

  @override
  String get cantidad => 'Quantité';

  @override
  String get sinTipo => 'Sans type';

  @override
  String get tipoProducto => 'Type de produit';

  @override
  String get precioVenta => 'Prix de vente';

  @override
  String get recetaTitulo => 'Recette';

  @override
  String get eliminarProductoTitulo => 'Supprimer le produit';

  @override
  String eliminarProductoConfirmacion(String nombre) {
    return 'Supprimer «$nombre» ? Les ventes déjà enregistrées ne sont pas modifiées.';
  }

  @override
  String get productosVacio =>
      'Vous n\'avez pas encore de produits.\nCréez-en un avec le bouton +';

  @override
  String gananciaTexto(String valor) {
    return 'Bénéfice : $valor';
  }

  @override
  String get eligeInsumoCantidad =>
      'Choisissez une fourniture et une quantité valide';

  @override
  String get insumoYaEnReceta => 'Cette fourniture est déjà dans la recette';

  @override
  String get faltaNombrePrecioIngrediente =>
      'Il manque le nom, le prix ou au moins un ingrédient';

  @override
  String get crearProductoTitulo => 'Créer un produit';

  @override
  String get editarProductoTitulo => 'Modifier le produit';

  @override
  String get nombreProducto => 'Nom du produit';

  @override
  String get nombreProductoHint => 'Ex : Gâteau au chocolat';

  @override
  String get recetaAyuda => 'Ajoutez les fournitures et quantités d\'une unité';

  @override
  String get recetaSinInsumos =>
      'Ajoutez d\'abord des fournitures dans l\'écran Inventaire.';

  @override
  String get sinInsumosInventario =>
      'Il n\'y a pas de fournitures dans l\'inventaire.';

  @override
  String get sinIngredientes =>
      'Vous n\'avez pas encore ajouté d\'ingrédients.';

  @override
  String get recetaVacia => 'La recette est vide.';

  @override
  String ingredienteSubtitulo(String cantidad, String unidad, String costo) {
    return '$cantidad $unidad  ·  $costo';
  }

  @override
  String get guardarProducto => 'Enregistrer le produit';

  @override
  String get elegirProductoTitulo => 'Choisir un produit';

  @override
  String get ningunProductoCoincide => 'Aucun produit ne correspond.';

  @override
  String get crearTipoHint => 'Créer un type de produit, ex : Boissons';

  @override
  String get sinTipos => 'Vous n\'avez pas encore créé de types.';

  @override
  String get recetasVacio =>
      'Vous n\'avez pas encore de recettes.\nCréez-en une avec le bouton +';

  @override
  String recetaSubtitulo(int ingredientes, int pasos) {
    return '$ingredientes ingrédients · $pasos étapes';
  }

  @override
  String get eliminarRecetaTitulo => 'Supprimer la recette';

  @override
  String eliminarRecetaConfirmacion(String titulo) {
    return 'Voulez-vous vraiment supprimer «$titulo» ?';
  }

  @override
  String get recetaNoExiste => 'Cette recette n\'existe plus.';

  @override
  String get ingredientesLabel => 'Ingrédients';

  @override
  String get preparacion => 'Préparation';

  @override
  String get recetaFaltaTituloPaso => 'Écrivez le titre et au moins une étape';

  @override
  String get editarRecetaTitulo => 'Modifier la recette';

  @override
  String get nuevaRecetaTitulo => 'Nouvelle recette';

  @override
  String get tituloReceta => 'Titre de la recette';

  @override
  String get ingredientesHint => 'Un ingrédient par ligne';

  @override
  String get pasosPreparacion => 'Étapes de préparation';

  @override
  String get pasosHint => 'Une étape par ligne';

  @override
  String get recetaEditorAyuda =>
      'Écrivez chaque ingrédient et chaque étape sur sa propre ligne (Entrée pour séparer).';

  @override
  String get guardarReceta => 'Enregistrer la recette';

  @override
  String get confirmarVenta => 'Confirmer la vente';

  @override
  String confirmarVentaProducto(String nombre, String precio) {
    return 'Enregistrer la vente de $nombre pour $precio ?';
  }

  @override
  String get vender => 'Vendre';

  @override
  String ventaProductoRegistrada(String nombre) {
    return 'Vente de $nombre enregistrée';
  }

  @override
  String get ventaDescripcionValor =>
      'Saisissez une description et un montant valide';

  @override
  String confirmarVentaManual(String descripcion, String valor) {
    return 'Enregistrer la vente «$descripcion» pour $valor ?';
  }

  @override
  String get registrar => 'Enregistrer';

  @override
  String get ventaRegistrada => 'Vente enregistrée';

  @override
  String get ingresarVentaTitulo => 'Enregistrer une vente';

  @override
  String get ventaRapida => 'Vente rapide';

  @override
  String get ventaRapidaAyuda =>
      'Pour les ventes qui ne sont pas un produit du catalogue';

  @override
  String get descripcion => 'Description';

  @override
  String get ventaDescripcionHint => 'Ex : café, livraison…';

  @override
  String get valor => 'Montant';

  @override
  String get registrarVenta => 'Enregistrer la vente';

  @override
  String get venderProducto => 'Vendre un produit';

  @override
  String productosFiltro(String tipo) {
    return 'Produits : $tipo';
  }

  @override
  String get filtrarPorTipo => 'Filtrer par type';

  @override
  String get todos => 'Tous';

  @override
  String get sinProductosVenta =>
      'Aucun produit. Créez-en depuis le menu Créer.';

  @override
  String get revisaCamposMayorCero =>
      'Vérifiez les champs : valeurs valides et supérieures à zéro';

  @override
  String get editarVentaTitulo => 'Modifier la vente';

  @override
  String get precioUnitario => 'Prix unitaire';

  @override
  String get eliminarVentaTitulo => 'Supprimer la vente';

  @override
  String get eliminarVentaConfirmacion =>
      'Cela corrige les revenus, mais ne rend pas les fournitures à l\'inventaire. Continuer ?';

  @override
  String get historialVentasTitulo => 'Historique des ventes';

  @override
  String get sinVentas => 'Aucune vente enregistrée pour l\'instant.';

  @override
  String get mesLabel => 'Mois :';

  @override
  String sinVentasEnMes(String mes) {
    return 'Aucune vente en $mes.';
  }

  @override
  String ventaSubtitulo(String fecha, int cantidad) {
    return '$fecha  ·  Qté : $cantidad';
  }

  @override
  String get analisisVentasTitulo => 'Analyse des ventes';

  @override
  String get sinVentasAnalizar => 'Aucune vente à analyser pour l\'instant.';

  @override
  String get resumenGeneral => 'Aperçu général';

  @override
  String get ticketPromedio => 'Panier moyen';

  @override
  String get numVentasLabel => 'Nb de ventes';

  @override
  String get totalVendido => 'Total vendu';

  @override
  String get demandaPorMes => 'Demande par mois';

  @override
  String demandaFuerteFlojo(String fuerte, String flojo) {
    return 'Le plus fort : $fuerte · Le plus faible : $flojo';
  }

  @override
  String get ventasPorDia => 'Ventes par jour de la semaine';

  @override
  String mejorDia(String dia) {
    return 'Votre meilleur jour est $dia';
  }

  @override
  String get sinDatosSuficientes => 'Données insuffisantes';

  @override
  String get fechasPico => 'Dates de pointe';

  @override
  String get fechasPicoAyuda =>
      'Vos jours avec le plus de ventes (ce sont vos dates spéciales)';

  @override
  String get topProductosTitulo => 'Top des produits';

  @override
  String get sinVentasProductos =>
      'Aucune vente de produit enregistrée pour l\'instant.';

  @override
  String get sinVentasProductosMes => 'Aucune vente de produit ce mois-ci.';

  @override
  String totalTexto(String valor) {
    return 'Total : $valor';
  }

  @override
  String get categoriaInsumos => 'Fournitures';

  @override
  String get categoriaServicios => 'Services';

  @override
  String get categoriaEmpaques => 'Emballages';

  @override
  String get categoriaOtros => 'Autres';

  @override
  String get gastoDescripcionMonto =>
      'Saisissez une description et un montant valide';

  @override
  String get confirmarGasto => 'Confirmer la dépense';

  @override
  String confirmarGastoTexto(String descripcion, String monto) {
    return 'Enregistrer la dépense «$descripcion» pour $monto ?';
  }

  @override
  String get guardar => 'Enregistrer';

  @override
  String get primeroCreaInsumos =>
      'Créez d\'abord des fournitures dans l\'Inventaire.';

  @override
  String get insumoYaEnLista => 'Cette fourniture est déjà dans la liste.';

  @override
  String cantidadCompradaUnidad(String unidad) {
    return 'Quantité achetée ($unidad)';
  }

  @override
  String get totalPagado => 'Total payé';

  @override
  String get agregar => 'Ajouter';

  @override
  String get cantidadTotalMayorCero =>
      'La quantité et le total doivent être supérieurs à zéro.';

  @override
  String get agregaAlMenosInsumo => 'Ajoutez au moins une fourniture.';

  @override
  String get confirmarCompra => 'Confirmer l\'achat';

  @override
  String confirmarCompraTexto(int cantidad, String total) {
    return 'Enregistrer l\'achat de $cantidad fourniture(s) pour $total ? Le stock sera ajouté et la dépense enregistrée.';
  }

  @override
  String get registrarGastoTitulo => 'Enregistrer une dépense';

  @override
  String get gastoNormal => 'Dépense normale';

  @override
  String get compraInsumos => 'Achat de fournitures';

  @override
  String get gastoDescripcionHint => 'Ex : paiement du loyer';

  @override
  String get monto => 'Montant';

  @override
  String get categoria => 'Catégorie';

  @override
  String get guardarGasto => 'Enregistrer la dépense';

  @override
  String get compraInsumosAyuda =>
      'Ajoutez les fournitures achetées. Leur stock est ajouté et le coût unitaire est recalculé (moyenne pondérée).';

  @override
  String get agregarInsumoBtn => 'Ajouter une fourniture';

  @override
  String get sinInsumosAgregados =>
      'Vous n\'avez pas encore ajouté de fournitures.';

  @override
  String get descripcionOpcional => 'Description (facultatif)';

  @override
  String get compraDescHint => 'Ex : achat au marché';

  @override
  String get totalGasto => 'Total de la dépense';

  @override
  String get guardarCompraReponer => 'Enregistrer l\'achat et réapprovisionner';

  @override
  String get eliminarGastoTitulo => 'Supprimer la dépense';

  @override
  String eliminarGastoConfirmacion(String descripcion) {
    return 'Voulez-vous vraiment supprimer «$descripcion» ?';
  }

  @override
  String get historialGastosTitulo => 'Historique des dépenses';

  @override
  String get sinGastos => 'Aucune dépense enregistrée pour l\'instant.';

  @override
  String sinGastosEnMes(String mes) {
    return 'Aucune dépense en $mes.';
  }

  @override
  String gastoSubtitulo(String fecha, String categoria) {
    return '$fecha  ·  $categoria';
  }

  @override
  String get editarGastoTitulo => 'Modifier la dépense';

  @override
  String get entregarPedido => 'Livrer la commande';

  @override
  String entregarPedidoTexto(String precio) {
    return 'En marquant cette commande comme livrée, sa valeur de $precio sera enregistrée comme revenu et apparaîtra dans votre historique des ventes.';
  }

  @override
  String get pedidoEntregadoOk =>
      'Commande livrée et enregistrée dans les revenus';

  @override
  String pedidoEntregadoNegativo(String insumos) {
    return 'Livrée. Stock négatif : $insumos';
  }

  @override
  String get entregar => 'Livrer';

  @override
  String get eliminarPedidoTitulo => 'Supprimer la commande';

  @override
  String get eliminarPedidoEntregado =>
      'Cette commande a déjà été livrée. Son revenu est déjà enregistré comme une vente et NE sera PAS modifié en la supprimant.';

  @override
  String eliminarPedidoConfirmacion(String cliente) {
    return 'Voulez-vous vraiment supprimer la commande de $cliente ?';
  }

  @override
  String get pedidoArchivado => 'Commande archivée';

  @override
  String get deshacer => 'Annuler';

  @override
  String get pedidoFab => 'Commande';

  @override
  String get pedidosVacio =>
      'Aucune commande pour l\'instant.\nCréez la première avec le bouton +';

  @override
  String get pendientes => 'En attente';

  @override
  String get entregados => 'Livrées';

  @override
  String get sinEntregados => 'Vous n\'avez encore livré aucune commande.';

  @override
  String get ocultarArchivados => 'Masquer les archivées';

  @override
  String verArchivadosBtn(int n) {
    return 'Voir les archivées ($n)';
  }

  @override
  String get archivar => 'Archiver';

  @override
  String get desarchivar => 'Désarchiver';

  @override
  String get entregadoEstado => 'Livrée';

  @override
  String get archivadoEstado => 'Archivée';

  @override
  String get marcarEntregado => 'Marquer comme livrée';

  @override
  String get sinProductosCreados => 'Vous n\'avez pas encore de produits créés';

  @override
  String get itemManual => 'Article manuel';

  @override
  String get costoUnitarioOpcional => 'Coût unitaire (facultatif)';

  @override
  String get faltaClienteItemFecha =>
      'Il manque le client, au moins un article (ou montant) et la date';

  @override
  String get faltaClienteItem =>
      'Il manque le client ou au moins un article (ou montant)';

  @override
  String get otroValorItem => 'Autre montant';

  @override
  String get pedidoFallback => 'Commande';

  @override
  String get nuevoPedidoTitulo => 'Nouvelle commande';

  @override
  String get nombreCliente => 'Nom du client';

  @override
  String get telefonoOpcional => 'Téléphone (facultatif)';

  @override
  String get productosDelPedido => 'Produits de la commande';

  @override
  String get delCatalogo => 'Du catalogue';

  @override
  String get manual => 'Manuel';

  @override
  String get sinItemsCrear =>
      'Ajoutez des produits du catalogue ou des articles manuels.';

  @override
  String get otroValorLabel => 'Autre montant (livraison, services...)';

  @override
  String get precio => 'Prix';

  @override
  String get fechaEntrega => 'Date de livraison';

  @override
  String get sinElegir => 'Non choisie';

  @override
  String get elegir => 'Choisir';

  @override
  String get guardarPedido => 'Enregistrer la commande';

  @override
  String get editarPedidoTitulo => 'Modifier la commande';

  @override
  String get editarPedidoEntregado =>
      'Cette commande a déjà été livrée. La modifier ne change pas le revenu déjà enregistré.';

  @override
  String get sinItemsEditar =>
      'Aucun article. Ajoutez depuis le catalogue ou manuellement.';

  @override
  String get cambiar => 'Modifier';

  @override
  String get analisisYReportes => 'Analyse et rapports';

  @override
  String get reportesVacio =>
      'Aucune donnée à analyser pour l\'instant.\nEnregistrez des ventes et des dépenses pour voir vos rapports.';

  @override
  String gananciaDeMes(String mes) {
    return 'Bénéfice de $mes';
  }

  @override
  String get sinComparacion => '— sans comparaison';

  @override
  String mesAnterior(String mes, String valor) {
    return 'Mois précédent ($mes) : $valor';
  }

  @override
  String get gananciaPorMes => 'Bénéfice par mois';

  @override
  String get reportesMensuales => 'Rapports mensuels';

  @override
  String get reportesMensualesSub =>
      'Téléchargez le relevé PDF de chaque mois clôturé';

  @override
  String get pdfError => 'Impossible de générer le PDF.';

  @override
  String get sinMesesCerrados =>
      'Aucun mois clôturé à signaler pour l\'instant.\nÀ la fin du mois en cours, il apparaîtra ici.';

  @override
  String ingresosGastos(String ingresos, String gastos) {
    return 'Revenus : $ingresos  ·  Dépenses : $gastos';
  }

  @override
  String get descargarPdf => 'Télécharger le PDF';

  @override
  String get topProductosMes => 'Meilleurs produits du mois';

  @override
  String get topSinVentasMes =>
      'Aucune vente de produit ce mois-ci pour l\'instant.';

  @override
  String vendidosAbrev(int cantidad) {
    return '$cantidad vend.';
  }

  @override
  String resumenAnalisisCorto(String ticket, String dia) {
    return 'Panier moyen $ticket · Meilleur jour : $dia';
  }

  @override
  String get verMas => 'Voir plus';

  @override
  String get nombreCatalogo => 'Nom du catalogue';

  @override
  String get subir => 'Téléverser';

  @override
  String get errorLeerArchivo => 'Impossible de lire le fichier.';

  @override
  String get soloPdf => 'Seuls les fichiers PDF sont acceptés pour l\'instant.';

  @override
  String get archivoSupera15 => 'Le fichier dépasse la limite de 15 Mo.';

  @override
  String get errorSubirCatalogo =>
      'Impossible de téléverser le catalogue. Réessayez.';

  @override
  String get errorAbrirCatalogo => 'Impossible d\'ouvrir le catalogue.';

  @override
  String get eliminarCatalogoTitulo => 'Supprimer le catalogue';

  @override
  String eliminarCatalogoConfirmacion(String nombre) {
    return 'Supprimer «$nombre» ? Le fichier PDF sera supprimé.';
  }

  @override
  String get errorEliminar => 'Impossible de supprimer.';

  @override
  String get subiendo => 'Téléversement...';

  @override
  String get subirPdf => 'Téléverser un PDF';

  @override
  String get catalogosVacio =>
      'Vous n\'avez pas encore de catalogues.\nTéléversez un PDF avec le bouton ci-dessous.';

  @override
  String get abrir => 'Ouvrir';

  @override
  String get notaFaltaAsunto => 'Écrivez au moins l\'objet de la note';

  @override
  String get editarNotaTitulo => 'Modifier la note';

  @override
  String get asunto => 'Objet';

  @override
  String get contenido => 'Contenu';

  @override
  String get notaContenidoHint => 'Écrivez le détail de la note...';

  @override
  String get guardarNota => 'Enregistrer la note';

  @override
  String get eliminarNotaTitulo => 'Supprimer la note';

  @override
  String eliminarNotaConfirmacion(String asunto) {
    return 'Voulez-vous vraiment supprimer «$asunto» ?';
  }

  @override
  String get notaTitulo => 'Note';

  @override
  String get notaNoExiste => 'Cette note n\'existe plus.';

  @override
  String notaPorAutor(String fecha, String autor) {
    return '$fecha  ·  Par $autor';
  }

  @override
  String get sinContenido => '(Aucun contenu)';

  @override
  String get entregaHoy => 'Livraison aujourd\'hui';

  @override
  String get entregaManana => 'Livraison demain';

  @override
  String get sinAvisos => 'Aucune alerte pour l\'instant. Tout est à jour !';

  @override
  String avisoPedidoDetalle(String urgencia, String precio) {
    return '$urgencia  ·  $precio';
  }

  @override
  String get inventarioBajo => 'Stock faible';

  @override
  String insumoBajoDetalle(String stock, String unidad, String minimo) {
    return 'Il reste $stock $unidad (minimum $minimo)';
  }

  @override
  String get notasNuevas => 'Nouvelles notes';

  @override
  String porAutor(String autor) {
    return 'Par $autor';
  }

  @override
  String get notifConfigAyuda =>
      'Choisissez les alertes que vous souhaitez recevoir dans l\'application.';

  @override
  String get notifPedidosSub =>
      'Livraisons d\'aujourd\'hui, de demain ou en retard';

  @override
  String get notifNotasSub => 'Lorsque quelqu\'un crée une note';

  @override
  String get notifInsumosSub => 'Fournitures sous leur stock minimum';

  @override
  String get modo => 'Mode';

  @override
  String get modoClaro => 'Clair';

  @override
  String get modoOscuro => 'Sombre';

  @override
  String get modoAuto => 'Automatique (selon le système)';

  @override
  String get colorAcento => 'Couleur d\'accent';

  @override
  String get acentoVerde => 'Vert';

  @override
  String get acentoAzul => 'Bleu';

  @override
  String get acentoTurquesa => 'Turquoise';

  @override
  String get acentoMorado => 'Violet';

  @override
  String get acentoNaranja => 'Orange';

  @override
  String get acentoRosa => 'Rose';

  @override
  String get aparienciaNota =>
      'Le thème et la couleur d\'accent s\'appliquent à toute l\'application.';

  @override
  String get completaCampos => 'Remplissez tous les champs.';

  @override
  String get passwordMin6 =>
      'Le nouveau mot de passe doit comporter au moins 6 caractères.';

  @override
  String get passwordNoCoincide =>
      'Le nouveau mot de passe et sa confirmation ne correspondent pas.';

  @override
  String get sinSesionValida => 'Aucune session valide.';

  @override
  String get passwordActualizada => 'Mot de passe mis à jour';

  @override
  String get passwordActualIncorrecta =>
      'Le mot de passe actuel est incorrect.';

  @override
  String get passwordDebil => 'Le nouveau mot de passe est trop faible.';

  @override
  String get requiereReloginPassword =>
      'Pour des raisons de sécurité, reconnectez-vous et réessayez.';

  @override
  String get demasiadosIntentos =>
      'Trop de tentatives. Attendez un instant et réessayez.';

  @override
  String get errorCambiarPassword =>
      'Impossible de changer le mot de passe. Réessayez.';

  @override
  String get cambiarContrasena => 'Changer le mot de passe';

  @override
  String get passwordActual => 'Mot de passe actuel';

  @override
  String get passwordNueva => 'Nouveau mot de passe';

  @override
  String get passwordConfirmar => 'Confirmer le nouveau mot de passe';

  @override
  String get guardando => 'Enregistrement...';

  @override
  String get errorLeerImagen => 'Impossible de lire l\'image.';

  @override
  String get imagenSupera5 => 'L\'image dépasse la limite de 5 Mo.';

  @override
  String get fotoActualizada => 'Photo mise à jour';

  @override
  String get errorSubirFoto => 'Impossible de téléverser la photo.';

  @override
  String get logoActualizado => 'Logo mis à jour';

  @override
  String get errorSubirLogo =>
      'Impossible de téléverser le logo. Êtes-vous le propriétaire ?';

  @override
  String get quitar => 'Retirer';

  @override
  String get quitarFoto => 'Retirer la photo';

  @override
  String get quitarFotoConfirmacion => 'Retirer votre photo de profil ?';

  @override
  String get fotoEliminada => 'Photo supprimée';

  @override
  String get errorEliminarFoto => 'Impossible de supprimer la photo.';

  @override
  String get quitarLogo => 'Retirer le logo';

  @override
  String get quitarLogoConfirmacion => 'Retirer le logo de l\'entreprise ?';

  @override
  String get logoEliminado => 'Logo supprimé';

  @override
  String get errorEliminarLogo => 'Impossible de supprimer le logo.';

  @override
  String get logoEmpresa => 'Logo de l\'entreprise';

  @override
  String get subirLogo => 'Téléverser le logo';

  @override
  String get cambiarLogo => 'Changer le logo';

  @override
  String get soloDuenoCambia => 'Seul le propriétaire peut le changer';

  @override
  String get perfilGuardado => 'Profil enregistré';

  @override
  String get errorGuardarPerfil => 'Impossible d\'enregistrer le profil.';

  @override
  String get nombreEmpresaVacio =>
      'Le nom de l\'entreprise ne peut pas être vide.';

  @override
  String get empresaGuardada => 'Informations de l\'entreprise enregistrées';

  @override
  String get errorGuardarEmpresa =>
      'Impossible d\'enregistrer. Êtes-vous le propriétaire de l\'entreprise ?';

  @override
  String get tocaCamara => 'Touchez l\'appareil photo pour changer votre photo';

  @override
  String get informacionPersonal => 'Informations personnelles';

  @override
  String get correoCuenta => 'E-mail (de votre compte)';

  @override
  String get celular => 'Portable';

  @override
  String get guardarPerfil => 'Enregistrer le profil';

  @override
  String get soloLectura => 'Lecture seule';

  @override
  String get soloDuenoEdita =>
      'Seul le propriétaire de l\'entreprise peut modifier ces informations.';

  @override
  String get nombreEmpresa => 'Nom de l\'entreprise';

  @override
  String get nit => 'N° fiscal';

  @override
  String get correoEmpresa => 'E-mail de l\'entreprise';

  @override
  String get telefono => 'Téléphone';

  @override
  String get ubicacion => 'Emplacement';

  @override
  String get guardarEmpresa => 'Enregistrer l\'entreprise';

  @override
  String get preferenciasNegocio => 'Préférences de l\'entreprise';

  @override
  String get ajustesSeguridadCaption =>
      'La langue de l\'application peut être changée ici et s\'applique à toute l\'application. Le pays et la devise ne peuvent pas être modifiés pour l\'instant.';

  @override
  String get seguridad => 'Sécurité';

  @override
  String get notas => 'Notes';

  @override
  String get buscadorHint => 'Rechercher dans votre entreprise...';

  @override
  String get buscadorInicio =>
      'Recherchez produits, fournitures, commandes, recettes, notes et catalogues.';

  @override
  String buscadorSinResultados(String q) {
    return 'Aucun résultat pour «$q»';
  }

  @override
  String get miembrosInvitaciones => 'Membres et invitations';

  @override
  String get miembrosInvitacionesSub =>
      'Invitez votre équipe et gérez les rôles';

  @override
  String get invitacionesTitulo => 'Invitations';

  @override
  String get generarInvitacion => 'Générer une invitation';

  @override
  String get miembrosTitulo => 'Membres';

  @override
  String get rolDueno => 'Propriétaire';

  @override
  String get rolSocio => 'Associé';

  @override
  String get rolEmpleado => 'Employé';

  @override
  String get elegirRolInvitacion => 'Quel rôle aura la personne ?';

  @override
  String get invitacionCreada => 'Invitation créée';

  @override
  String get codigoInvitacion => 'Code d\'invitation';

  @override
  String get copiar => 'Copier';

  @override
  String get copiado => 'Copié';

  @override
  String get compartirCodigoAyuda =>
      'Partagez ce code. La personne l\'utilise lors de son inscription pour rejoindre votre entreprise.';

  @override
  String get revocar => 'Révoquer';

  @override
  String get invitacionPendiente => 'En attente';

  @override
  String get invitacionUsada => 'Utilisé';

  @override
  String get sinInvitaciones => 'Vous n\'avez généré aucune invitation.';

  @override
  String get sinMiembros => 'Il n\'y a pas encore d\'autres membres.';

  @override
  String get cambiarRolTitulo => 'Changer de rôle';

  @override
  String get quitarDelNegocio => 'Retirer de l\'entreprise';

  @override
  String quitarMiembroConfirmacion(String nombre) {
    return 'Retirer $nombre de l\'entreprise ?';
  }

  @override
  String get unirseCodigo => 'Rejoindre avec un code';

  @override
  String get unirseCodigoTitulo => 'Rejoindre une entreprise';

  @override
  String get unirseCodigoAyuda =>
      'Saisissez le code d\'invitation que le propriétaire vous a partagé.';

  @override
  String get unirme => 'Rejoindre';

  @override
  String get codigoVacio => 'Saisissez le code.';

  @override
  String get codigoNoExiste => 'Le code n\'existe pas.';

  @override
  String get codigoUsado => 'Ce code a déjà été utilisé.';

  @override
  String get codigoInvalido => 'Le code n\'est pas valide.';

  @override
  String get unirseError => 'Impossible de rejoindre. Réessayez.';

  @override
  String get sinNombre => '(sans nom)';

  @override
  String get ver => 'Voir';
}
