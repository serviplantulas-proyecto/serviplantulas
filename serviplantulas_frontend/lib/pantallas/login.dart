import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:serviplantulas_frontend/pantallas/registro.dart';

import '../componentes/login/login_button.dart';
import '../componentes/login/login_email_field.dart';
import '../componentes/login/login_footer.dart';
import '../componentes/login/login_forgot_password.dart';
import '../componentes/login/login_google_button.dart';
import '../componentes/login/login_logo.dart';
import '../componentes/login/login_password_field.dart';
import '../componentes/login/login_register.dart';
import '../services/api_config.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';
import '../styles/app_spacing.dart';
import 'home_shell.dart';
import 'solicitar_codigo_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const LoginPage({super.key, this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: const ['email', 'profile'],
    // Necesario para obtener idToken en Android/iOS
    serverClientId: ApiConfig.googleWebClientId,
    clientId: kIsWeb ? ApiConfig.googleWebClientId : null,
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _afterLoginOk() async {
    await SessionService().touchActivity();
    if (!mounted) return;
    if (widget.onLoginSuccess != null) {
      widget.onLoginSuccess!();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeShell()),
      );
    }
  }

  Future<void> _iniciarSesion() async {
    setState(() => _isLoading = true);
    try {
      await AuthService.iniciarSesion(
        email: _emailController.text.trim(),
        contrasena: _passwordController.text,
      );
      await _afterLoginOk();
    } on AuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _iniciarConGoogle() async {
    if (_isGoogleLoading || _isLoading) return;
    setState(() => _isGoogleLoading = true);
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        // Usuario canceló
        return;
      }
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw const AuthException(
          'Google no devolvió idToken. Revisa el Client ID web (serverClientId).',
        );
      }
      await AuthService.iniciarSesionGoogle(idToken: idToken);
      await _afterLoginOk();
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error con Google: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  void _recuperarContrasena() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SolicitarCodigoPage()),
    );
  }

  void _registrarse() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistroPage()),
    );
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
              constraints: const BoxConstraints(maxWidth: 354),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const LoginLogo(),
                  const SizedBox(height: AppSpacing.huge),
                  LoginEmailField(controller: _emailController),
                  const SizedBox(height: AppSpacing.medium),
                  LoginPasswordField(controller: _passwordController),
                  const SizedBox(height: AppSpacing.small),
                  Align(
                    alignment: Alignment.centerRight,
                    child: LoginForgotPassword(onPressed: _recuperarContrasena),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  LoginButton(onPressed: _iniciarSesion, isLoading: _isLoading),
                  const SizedBox(height: AppSpacing.large),
                  LoginRegister(onPressed: _registrarse),
                  const SizedBox(height: AppSpacing.large),
                  LoginGoogleButton(
                    onPressed: _iniciarConGoogle,
                    isLoading: _isGoogleLoading,
                  ),
                  const SizedBox(height: AppSpacing.huge),
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
