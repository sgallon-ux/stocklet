import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../tema.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final correoCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool cargando = false;
  bool verPassword = false;

  @override
  void dispose() {
    correoCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  void registrar() async {
    final correo = correoCtrl.text.trim();
    final password = passwordCtrl.text;
    if (correo.isEmpty || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Escribe un correo y una contraseña de mínimo 6 caracteres')),
      );
      return;
    }
    setState(() => cargando = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: correo,
        password: password,
      );
      if (mounted) Navigator.pop(context); // la compuerta lleva al onboarding
    } on FirebaseAuthException catch (e) {
      String msg = 'No se pudo crear la cuenta';
      if (e.code == 'email-already-in-use') msg = 'Ese correo ya tiene cuenta';
      if (e.code == 'invalid-email') msg = 'El correo no es válido';
      if (e.code == 'weak-password') msg = 'La contraseña es muy débil';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  // --- Encabezado ---
                  Container(
                    height: 72,
                    width: 72,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColores.verde.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.person_add_alt_1,
                        color: AppColores.verde, size: 36),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Crea tu cuenta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColores.texto),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Regístrate para empezar con tu negocio',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColores.textoSuave),
                  ),
                  const SizedBox(height: 32),

                  // --- Tarjeta con los campos ---
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: correoCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Correo',
                              prefixIcon: Icon(Icons.mail_outline),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: passwordCtrl,
                            obscureText: !verPassword,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              helperText: 'Mínimo 6 caracteres',
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
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: cargando ? null : registrar,
                            child: cargando
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white))
                                : const Text('Crear cuenta'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Volver al login ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿Ya tienes cuenta?',
                          style: TextStyle(color: AppColores.textoSuave)),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Inicia sesión'),
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