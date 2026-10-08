import 'package:flutter/material.dart';
import 'package:serviplantulas_frontend/pantallas/registro.dart';

import '../services/auth_service.dart';
import '../componentes/login/login_logo.dart';
import '../componentes/login/login_email_field.dart';
import '../componentes/login/login_password_field.dart';
import '../componentes/login/login_button.dart';
import '../componentes/login/login_forgot_password.dart';
import '../componentes/login/login_register.dart';
import '../componentes/login/login_google_button.dart';
import '../componentes/login/login_footer.dart';
import 'solicitar_codigo_page.dart';
import 'menu_page.dart';
import '../styles/app_spacing.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  Future<void> _iniciarSesion() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      await AuthService.iniciarSesion(
        email: _emailController.text.trim(),
        contrasena: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MenuPage()),
      );
    } on AuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (error, stackTrace) {
      debugPrint('Error inesperado al iniciar sesión: $error\n$stackTrace');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocurrió un error al iniciar sesión. Inténtalo de nuevo.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  const LoginLogo(),

                  const SizedBox(
                    height: AppSpacing.huge,
                  ),

                  LoginEmailField(
                    controller: _emailController,
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (email.isEmpty) return 'Ingresa tu correo electrónico';
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                          .hasMatch(email)) {
                        return 'Ingresa un correo electrónico válido';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(
                    height: AppSpacing.medium,
                  ),

                  LoginPasswordField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu contraseña';
                      }
                      return null;
                    },
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
      ),
    );
  }
}