import 'package:flutter/material.dart';

import 'verificar_cuenta.dart';
import '../componentes/registro/registro_header.dart';
import '../componentes/registro/registro_nombre_field.dart';
import '../componentes/registro/registro_email_field.dart';
import '../componentes/registro/registro_contacto_field.dart';
import '../componentes/registro/registro_password_field.dart';
import '../componentes/registro/registro_confirm_password_field.dart';
import '../componentes/registro/registro_button.dart';
import '../componentes/registro/registro_login.dart';
import '../styles/app_colors.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final TextEditingController _nombreController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _contactoController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _contactoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _crearCuenta() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            VerificarCuentaPage(email: _emailController.text.trim()),
      ),
    );
  }

  void _irAlLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            RegistroHeader(onBack: _irAlLogin),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.large,
                  vertical: AppSpacing.extraLarge,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 354),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Crea tu cuenta',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.small),

                        Text(
                          'Registra tus datos para comenzar a utilizar Serviplantulas.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.extraLarge),

                        RegistroNombreField(controller: _nombreController),

                        const SizedBox(height: AppSpacing.medium),

                        RegistroEmailField(controller: _emailController),

                        const SizedBox(height: AppSpacing.medium),

                        RegistroContactoField(controller: _contactoController),

                        const SizedBox(height: AppSpacing.medium),

                        RegistroPasswordField(controller: _passwordController),

                        const SizedBox(height: AppSpacing.medium),

                        RegistroConfirmPasswordField(
                          controller: _confirmPasswordController,
                        ),

                        const SizedBox(height: AppSpacing.extraLarge),

                        RegistroButton(
                          onPressed: _crearCuenta,
                          isLoading: _isLoading,
                        ),

                        const SizedBox(height: AppSpacing.large),

                        Center(child: RegistroLogin(onPressed: _irAlLogin)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
