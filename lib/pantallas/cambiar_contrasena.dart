import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
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

  void _aviso(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _cambiar() async {
    final t = AppLocalizations.of(context)!;
    final actual = actualCtrl.text;
    final nueva = nuevaCtrl.text;
    final confirmar = confirmarCtrl.text;

    if (actual.isEmpty || nueva.isEmpty || confirmar.isEmpty) {
      _aviso(t.completaCampos);
      return;
    }
    if (nueva.length < 6) {
      _aviso(t.passwordMin6);
      return;
    }
    if (nueva != confirmar) {
      _aviso(t.passwordNoCoincide);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;
    if (user == null || email == null) {
      _aviso(t.sinSesionValida);
      return;
    }

    setState(() => procesando = true);
    try {
      final cred =
          EmailAuthProvider.credential(email: email, password: actual);
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(nueva);
      if (!mounted) return;
      _aviso(t.passwordActualizada);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          msg = t.passwordActualIncorrecta;
          break;
        case 'weak-password':
          msg = t.passwordDebil;
          break;
        case 'requires-recent-login':
          msg = t.requiereReloginPassword;
          break;
        case 'too-many-requests':
          msg = t.demasiadosIntentos;
          break;
        default:
          msg = t.errorCambiarPassword;
      }
      _aviso(msg);
    } catch (e) {
      _aviso(t.errorCambiarPassword);
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
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.cambiarContrasena)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _campo(actualCtrl, t.passwordActual, verActual,
                      () => setState(() => verActual = !verActual)),
                  const SizedBox(height: 16),
                  _campo(nuevaCtrl, t.passwordNueva, verNueva,
                      () => setState(() => verNueva = !verNueva)),
                  const SizedBox(height: 16),
                  _campo(confirmarCtrl, t.passwordConfirmar, verConfirmar,
                      () => setState(() => verConfirmar = !verConfirmar)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(t.passwordMin6,
                style: TextStyle(
                    fontSize: 12, color: AppColores.of(context).textoSuave)),
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
            label: Text(procesando ? t.guardando : t.cambiarContrasena),
          ),
        ],
      ),
    );
  }
}
