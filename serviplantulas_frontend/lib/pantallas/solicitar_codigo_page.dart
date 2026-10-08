import 'package:flutter/material.dart';
import '../componentes/recuperar_contrasena/recuperar_badge.dart';
import '../componentes/recuperar_contrasena/recuperar_button.dart';
import '../componentes/recuperar_contrasena/recuperar_email_field.dart';
import '../componentes/recuperar_contrasena/recuperar_header.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import 'verificar_codigo_recuperacion_page.dart';

class SolicitarCodigoPage extends StatefulWidget {
  const SolicitarCodigoPage({super.key});

  @override
  State<SolicitarCodigoPage> createState() => _SolicitarCodigoPageState();
}

class _SolicitarCodigoPageState extends State<SolicitarCodigoPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // Simulación de respuesta de backend / API
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      setState(() => _isLoading = false);

      // Navegación hacia el Paso 2 enviando el email
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificarCodigoRecuperacionPage(
            email: _emailController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.neutral,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          'Recuperar Acceso',
          style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RecuperarBadge(text: 'PASO 1 DE 2'),
                const SizedBox(height: 16),
                const RecuperarHeader(
                  title: 'Solicitar código de verificación',
                  subtitle:
                      'Ingresa tu correo registrado para enviarte un código de seguridad de 6 dígitos.',
                ),
                const SizedBox(height: 24),
                RecuperarEmailField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa tu correo';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value.trim())) {
                      return 'Ingresa un correo válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                RecuperarButton(
                  text: 'Enviar código',
                  isLoading: _isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
