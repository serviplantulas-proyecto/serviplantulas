import 'package:flutter/material.dart';
import 'package:serviplantulas_frontend/pantallas/registro.dart';

import '../componentes/login/login_logo.dart';
import '../componentes/login/login_email_field.dart';
import '../componentes/login/login_password_field.dart';
import '../componentes/login/login_button.dart';
import '../componentes/login/login_forgot_password.dart';
import '../componentes/login/login_register.dart';
import '../componentes/login/login_google_button.dart';
import '../componentes/login/login_footer.dart';
import 'solicitar_codigo_page.dart';
import '../styles/app_spacing.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _iniciarSesion() {
    // Aquí conectaremos posteriormente el backend.
  }

  void _recuperarContrasena() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SolicitarCodigoPage(),
      ),
    );
  }

  void _registrarse() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const RegistroPage(),
    ),
  );
}

  void _iniciarConGoogle() {
    // Aquí conectaremos posteriormente Google Sign-In.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.large,
              vertical: AppSpacing.extraLarge,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 354,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const LoginLogo(),

                  const SizedBox(
                    height: AppSpacing.huge,
                  ),

                  LoginEmailField(
                    controller: _emailController,
                  ),

                  const SizedBox(
                    height: AppSpacing.medium,
                  ),

                  LoginPasswordField(
                    controller: _passwordController,
                  ),

                  const SizedBox(
                    height: AppSpacing.small,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: LoginForgotPassword(
                      onPressed: _recuperarContrasena,
                    ),
                  ),

                  const SizedBox(
                    height: AppSpacing.large,
                  ),

                  LoginButton(
                    onPressed: _iniciarSesion,
                    isLoading: _isLoading,
                  ),

                  const SizedBox(
                    height: AppSpacing.large,
                  ),

                  LoginRegister(
                    onPressed: _registrarse,
                  ),

                  const SizedBox(
                    height: AppSpacing.large,
                  ),

                  LoginGoogleButton(
                    onPressed: _iniciarConGoogle,
                  ),

                  const SizedBox(
                    height: AppSpacing.huge,
                  ),

                  const LoginFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}