import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../tema.dart';

class PantallaCambiarContrasena extends StatefulWidget {
  const PantallaCambiarContrasena({super.key});

  @override
  State<PantallaCambiarContrasena> createState() =>
      _PantallaCambiarContrasenaState();
}

class _PantallaCambiarContrasenaState extends State<PantallaCambiarContrasena> {
  final actualCtrl = TextEditingController();
  final nuevaCtrl = TextEditingController();
  final confirmarCtrl = TextEditingController();
  bool verActual = false, verNueva = false, verConfirmar = false;
  bool procesando = false;

  @override
  void dispose() {
    actualCtrl.dispose();
    nuevaCtrl.dispose();
    confirmarCtrl.dispose();
    super.dispose();
  }

  void _aviso(String t) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));
  }

  Future<void> _cambiar() async {
    final actual = actualCtrl.text;
    final nueva = nuevaCtrl.text;
    final confirmar = confirmarCtrl.text;

    if (actual.isEmpty || nueva.isEmpty || confirmar.isEmpty) {
      _aviso('Completa todos los campos.');
      return;
    }
    if (nueva.length < 6) {
      _aviso('La nueva contraseña debe tener al menos 6 caracteres.');
      return;
    }
    if (nueva != confirmar) {
      _aviso('La nueva contraseña y su confirmación no coinciden.');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;
    if (user == null || email == null) {
      _aviso('No hay una sesión válida.');
      return;
    }

    setState(() => procesando = true);
    try {
      final cred =
          EmailAuthProvider.credential(email: email, password: actual);
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(nueva);
      if (!mounted) return;
      _aviso('Contraseña actualizada');
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          msg = 'La contraseña actual es incorrecta.';
          break;
        case 'weak-password':
          msg = 'La nueva contraseña es muy débil.';
          break;
        case 'requires-recent-login':
          msg = 'Por seguridad, vuelve a iniciar sesión e intenta de nuevo.';
          break;
        case 'too-many-requests':
          msg = 'Demasiados intentos. Espera un momento e inténtalo de nuevo.';
          break;
        default:
          msg = 'No se pudo cambiar la contraseña. Intenta de nuevo.';
      }
      _aviso(msg);
    } catch (e) {
      _aviso('No se pudo cambiar la contraseña. Intenta de nuevo.');
    } finally {
      if (mounted) setState(() => procesando = false);
    }
  }

  Widget _campo(TextEditingController ctrl, String label, bool visible,
      VoidCallback toggle) {
    return TextField(
      controller: ctrl,
      obscureText: !visible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar contraseña')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _campo(actualCtrl, 'Contraseña actual', verActual,
                      () => setState(() => verActual = !verActual)),
                  const SizedBox(height: 16),
                  _campo(nuevaCtrl, 'Nueva contraseña', verNueva,
                      () => setState(() => verNueva = !verNueva)),
                  const SizedBox(height: 16),
                  _campo(confirmarCtrl, 'Confirmar nueva contraseña',
                      verConfirmar,
                      () => setState(() => verConfirmar = !verConfirmar)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
                'La nueva contraseña debe tener al menos 6 caracteres.',
                style: TextStyle(fontSize: 12, color: AppColores.textoSuave)),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: procesando ? null : _cambiar,
            icon: procesando
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.lock_reset),
            label: Text(procesando ? 'Guardando...' : 'Cambiar contraseña'),
          ),
        ],
      ),
    );
  }
}