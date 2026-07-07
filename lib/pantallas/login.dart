import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../tema.dart';
import 'registro.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final correoCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool cargando = false;
  bool verPassword = false;
  bool recordar = true;

  @override
  void initState() {
    super.initState();
    _cargarCorreoRecordado();
  }

  // Al abrir el login, trae el último correo guardado (si lo hay)
  Future<void> _cargarCorreoRecordado() async {
    final prefs = await SharedPreferences.getInstance();
    final recordarGuardado = prefs.getBool('recordarCorreo') ?? true;
    final correoGuardado = prefs.getString('correoRecordado');
    if (!mounted) return;
    setState(() {
      recordar = recordarGuardado;
      if (recordarGuardado && correoGuardado != null) {
        correoCtrl.text = correoGuardado;
      }
    });
  }

  @override
  void dispose() {
    correoCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  void iniciarSesion() async {
    final t = AppLocalizations.of(context)!;
    final correo = correoCtrl.text.trim();
    final password = passwordCtrl.text;
    if (correo.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.loginCompletaCampos)),
      );
      return;
    }
    setState(() => cargando = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: correo,
        password: password,
      );
      // Guarda (o borra) el correo recordado según el marcador
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('recordarCorreo', recordar);
      if (recordar) {
        await prefs.setString('correoRecordado', correo);
      } else {
        await prefs.remove('correoRecordado');
      }
      // la compuerta se encarga de llevar a la app
    } on FirebaseAuthException catch (e) {
      String msg = t.loginErrorGeneral;
      if (e.code == 'invalid-email') msg = t.errorCorreoInvalido;
      if (e.code == 'user-not-found') msg = t.loginErrorNoExiste;
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        msg = t.loginErrorCredenciales;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = AppColores.of(context);
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 72,
                    width: 72,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: m.verde.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.storefront, color: m.verde, size: 38),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    t.loginBienvenido,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: m.texto),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    t.loginSubtitulo,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: m.textoSuave),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: correoCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: t.campoCorreo,
                              prefixIcon: const Icon(Icons.mail_outline),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: passwordCtrl,
                            obscureText: !verPassword,
                            decoration: InputDecoration(
                              labelText: t.campoContrasena,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(verPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () =>
                                    setState(() => verPassword = !verPassword),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Checkbox(
                                value: recordar,
                                onChanged: (v) =>
                                    setState(() => recordar = v ?? false),
                              ),
                              Expanded(child: Text(t.loginRecordarCorreo)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: cargando ? null : iniciarSesion,
                            child: cargando
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white))
                                : Text(t.iniciarSesion),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(t.loginEresNuevo,
                          style: TextStyle(color: m.textoSuave)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PantallaRegistro()),
                          );
                        },
                        child: Text(t.crearCuenta),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
