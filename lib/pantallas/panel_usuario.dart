import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../datos_app.dart';
import '../models/negocio.dart';
import '../tema.dart';
import 'package:file_picker/file_picker.dart';
import 'cambiar_contrasena.dart';

class PantallaPanelUsuario extends StatefulWidget {
  const PantallaPanelUsuario({super.key});

  @override
  State<PantallaPanelUsuario> createState() => _PantallaPanelUsuarioState();
}

class _PantallaPanelUsuarioState extends State<PantallaPanelUsuario> {
  late final TextEditingController nombreCtrl;
  late final TextEditingController celularCtrl;
  bool guardandoPerfil = false;

  late final TextEditingController empNombreCtrl;
  late final TextEditingController empNitCtrl;
  late final TextEditingController empCorreoCtrl;
  late final TextEditingController empTelCtrl;
  late final TextEditingController empUbicacionCtrl;
  bool guardandoEmpresa = false;
  bool subiendoFoto = false;
  bool subiendoLogo = false;

  @override
  void initState() {
    super.initState();
    final datos = context.read<DatosApp>();
    nombreCtrl = TextEditingController(text: datos.perfilNombre);
    celularCtrl = TextEditingController(text: datos.perfilCelular);

    final n = datos.negocio;
    empNombreCtrl = TextEditingController(text: n?.nombre ?? '');
    empNitCtrl = TextEditingController(text: n?.nit ?? '');
    empCorreoCtrl = TextEditingController(text: n?.correo ?? '');
    empTelCtrl = TextEditingController(text: n?.tel ?? '');
    empUbicacionCtrl = TextEditingController(text: n?.ubicacion ?? '');
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    celularCtrl.dispose();
    empNombreCtrl.dispose();
    empNitCtrl.dispose();
    empCorreoCtrl.dispose();
    empTelCtrl.dispose();
    empUbicacionCtrl.dispose();
    super.dispose();
  }

  void _aviso(String t) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));
  }

  String _mime(String? ext) {
    switch ((ext ?? '').toLowerCase()) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      default:
        return 'image/jpeg';
    }
  }

  Future<void> _cambiarFoto() async {
    final result =
        await FilePicker.pickFiles(type: FileType.image, withData: true);
    if (result == null || !mounted) return;
    final archivo = result.files.first;
    final bytes = archivo.bytes;
    if (bytes == null) {
      _aviso('No se pudo leer la imagen.');
      return;
    }
    if (archivo.size > 5 * 1024 * 1024) {
      _aviso('La imagen supera el límite de 5 MB.');
      return;
    }
    setState(() => subiendoFoto = true);
    try {
      await context
          .read<DatosApp>()
          .guardarFotoPerfil(bytes, _mime(archivo.extension));
      _aviso('Foto actualizada');
    } catch (e) {
      _aviso('No se pudo subir la foto.');
    } finally {
      if (mounted) setState(() => subiendoFoto = false);
    }
  }

  Future<void> _cambiarLogo() async {
    final result =
        await FilePicker.pickFiles(type: FileType.image, withData: true);
    if (result == null || !mounted) return;
    final archivo = result.files.first;
    final bytes = archivo.bytes;
    if (bytes == null) {
      _aviso('No se pudo leer la imagen.');
      return;
    }
    if (archivo.size > 5 * 1024 * 1024) {
      _aviso('La imagen supera el límite de 5 MB.');
      return;
    }
    setState(() => subiendoLogo = true);
    try {
      await context
          .read<DatosApp>()
          .guardarLogo(bytes, _mime(archivo.extension));
      _aviso('Logo actualizado');
    } catch (e) {
      _aviso('No se pudo subir el logo. ¿Eres el dueño?');
    } finally {
      if (mounted) setState(() => subiendoLogo = false);
    }
  }

  Future<bool?> _confirmar(String titulo, String mensaje) {
    final m = AppColores.of(context);
    return showDialog<bool>(
      context: context,
      builder: (dc) => AlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc, false),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(dc, true),
            style: TextButton.styleFrom(foregroundColor: m.rojo),
            child: const Text('Quitar'),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarFoto() async {
    final ok = await _confirmar('Quitar foto', '¿Quitar tu foto de perfil?');
    if (ok != true || !mounted) return;
    setState(() => subiendoFoto = true);
    try {
      await context.read<DatosApp>().eliminarFotoPerfil();
      _aviso('Foto eliminada');
    } catch (e) {
      _aviso('No se pudo eliminar la foto.');
    } finally {
      if (mounted) setState(() => subiendoFoto = false);
    }
  }

  Future<void> _eliminarLogo() async {
    final ok = await _confirmar('Quitar logo', '¿Quitar el logo de la empresa?');
    if (ok != true || !mounted) return;
    setState(() => subiendoLogo = true);
    try {
      await context.read<DatosApp>().eliminarLogo();
      _aviso('Logo eliminado');
    } catch (e) {
      _aviso('No se pudo eliminar el logo.');
    } finally {
      if (mounted) setState(() => subiendoLogo = false);
    }
  }

  Widget _logoEmpresa(String url, bool esDueno) {
    final m = AppColores.of(context);
    return Row(
      children: [
        Container(
          height: 64,
          width: 64,
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: m.verde.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: m.borde),
          ),
          child: url.isEmpty
              ? Icon(Icons.image_outlined, color: m.textoSuave)
              : Image.network(url,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      Icon(Icons.image_outlined, color: m.textoSuave)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Logo de la empresa',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, color: m.texto)),
              const SizedBox(height: 4),
              if (esDueno) ...[
                OutlinedButton.icon(
                  onPressed: subiendoLogo ? null : _cambiarLogo,
                  icon: subiendoLogo
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.upload_outlined, size: 18),
                  label: Text(subiendoLogo
                      ? 'Subiendo...'
                      : (url.isEmpty ? 'Subir logo' : 'Cambiar logo')),
                ),
                if (url.isNotEmpty)
                  TextButton.icon(
                    onPressed: subiendoLogo ? null : _eliminarLogo,
                    icon: Icon(Icons.delete_outline, size: 18, color: m.rojo),
                    label:
                        Text('Quitar logo', style: TextStyle(color: m.rojo)),
                  ),
              ] else
                Text('Solo el dueño puede cambiarlo',
                    style: TextStyle(fontSize: 12, color: m.textoSuave)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _avatar(String url) {
    final m = AppColores.of(context);
    return Stack(
      children: [
        Container(
          height: 88,
          width: 88,
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: m.verde.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: url.isEmpty
              ? Icon(Icons.person, color: m.verde, size: 44)
              : Image.network(
                  url,
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      Icon(Icons.person, color: m.verde, size: 44),
                ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Material(
            color: m.verde,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: subiendoFoto ? null : _cambiarFoto,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: subiendoFoto
                    ? const SizedBox(
                        height: 14,
                        width: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.camera_alt,
                        color: Colors.white, size: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _guardarPerfil() async {
    setState(() => guardandoPerfil = true);
    try {
      await context.read<DatosApp>().guardarPerfil(
            nombre: nombreCtrl.text.trim(),
            celular: celularCtrl.text.trim(),
          );
      _aviso('Perfil guardado');
    } catch (e) {
      _aviso('No se pudo guardar el perfil.');
    } finally {
      if (mounted) setState(() => guardandoPerfil = false);
    }
  }

  Future<void> _guardarEmpresa() async {
    final nombre = empNombreCtrl.text.trim();
    if (nombre.isEmpty) {
      _aviso('El nombre de la empresa no puede quedar vacío.');
      return;
    }
    setState(() => guardandoEmpresa = true);
    try {
      await context.read<DatosApp>().editarNegocioDatos(
            nombre: nombre,
            nit: empNitCtrl.text.trim(),
            correo: empCorreoCtrl.text.trim(),
            tel: empTelCtrl.text.trim(),
            ubicacion: empUbicacionCtrl.text.trim(),
          );
      _aviso('Datos de la empresa guardados');
    } catch (e) {
      _aviso('No se pudo guardar. ¿Eres el dueño del negocio?');
    } finally {
      if (mounted) setState(() => guardandoEmpresa = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<DatosApp>();
    final m = AppColores.of(context);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final correo = FirebaseAuth.instance.currentUser?.email ?? '—';
    final negocio = datos.negocio;
    final esDueno = negocio != null && negocio.duenoUid == uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                _avatar(datos.perfilFotoUrl),
                const SizedBox(height: 8),
                Text('Toca la cámara para cambiar tu foto',
                    style: TextStyle(fontSize: 12, color: m.textoSuave)),
                if (datos.perfilFotoUrl.isNotEmpty)
                  TextButton.icon(
                    onPressed: subiendoFoto ? null : _eliminarFoto,
                    icon: Icon(Icons.delete_outline, size: 18, color: m.rojo),
                    label:
                        Text('Quitar foto', style: TextStyle(color: m.rojo)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Información personal',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: m.texto)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nombreCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: correo,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Correo (de tu cuenta)',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: celularCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Celular',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: guardandoPerfil ? null : _guardarPerfil,
                    icon: guardandoPerfil
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.save_outlined),
                    label: Text(
                        guardandoPerfil ? 'Guardando...' : 'Guardar perfil'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('Datos de la empresa',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: m.texto)),
                      ),
                      if (!esDueno)
                        Text('Solo lectura',
                            style:
                                TextStyle(fontSize: 11, color: m.textoSuave)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _logoEmpresa(negocio?.logoUrl ?? '', esDueno),
                  const SizedBox(height: 16),
                  if (esDueno)
                    ..._camposEmpresaEditables()
                  else
                    ..._camposEmpresaLectura(negocio),
                ],
              ),
            ),
          ),
          if (!esDueno) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text('Solo el dueño del negocio puede editar estos datos.',
                  style: TextStyle(fontSize: 12, color: m.textoSuave)),
            ),
          ],
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const PantallaCambiarContrasena())),
            icon: const Icon(Icons.lock_outline),
            label: const Text('Cambiar contraseña'),
          ),
        ],
      ),
    );
  }

  List<Widget> _camposEmpresaEditables() {
    return [
      TextField(
        controller: empNombreCtrl,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          labelText: 'Nombre de la empresa',
          prefixIcon: Icon(Icons.storefront_outlined),
        ),
      ),
      const SizedBox(height: 16),
      TextField(
        controller: empNitCtrl,
        decoration: const InputDecoration(
          labelText: 'NIT',
          prefixIcon: Icon(Icons.badge_outlined),
        ),
      ),
      const SizedBox(height: 16),
      TextField(
        controller: empCorreoCtrl,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: 'Correo de la empresa',
          prefixIcon: Icon(Icons.alternate_email),
        ),
      ),
      const SizedBox(height: 16),
      TextField(
        controller: empTelCtrl,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          labelText: 'Teléfono',
          prefixIcon: Icon(Icons.phone_outlined),
        ),
      ),
      const SizedBox(height: 16),
      TextField(
        controller: empUbicacionCtrl,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
          labelText: 'Ubicación',
          prefixIcon: Icon(Icons.location_on_outlined),
        ),
      ),
      const SizedBox(height: 16),
      ElevatedButton.icon(
        onPressed: guardandoEmpresa ? null : _guardarEmpresa,
        icon: guardandoEmpresa
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.save_outlined),
        label: Text(guardandoEmpresa ? 'Guardando...' : 'Guardar empresa'),
      ),
    ];
  }

  List<Widget> _camposEmpresaLectura(Negocio? negocio) {
    final m = AppColores.of(context);
    Widget fila(IconData ic, String label, String valor) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(ic, size: 20, color: m.textoSuave),
              const SizedBox(width: 12),
              Text(label, style: TextStyle(color: m.textoSuave)),
              const Spacer(),
              Flexible(
                child: Text(valor.isEmpty ? '—' : valor,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: m.texto, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        );

    return [
      fila(Icons.storefront_outlined, 'Nombre', negocio?.nombre ?? ''),
      fila(Icons.badge_outlined, 'NIT', negocio?.nit ?? ''),
      fila(Icons.alternate_email, 'Correo', negocio?.correo ?? ''),
      fila(Icons.phone_outlined, 'Teléfono', negocio?.tel ?? ''),
      fila(Icons.location_on_outlined, 'Ubicación', negocio?.ubicacion ?? ''),
    ];
  }
}