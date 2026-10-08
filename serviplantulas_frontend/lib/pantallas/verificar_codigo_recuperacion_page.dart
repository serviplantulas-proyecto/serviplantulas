import 'package:flutter/material.dart';
import '../componentes/recuperar_contrasena/recuperar_badge.dart';
import '../componentes/recuperar_contrasena/recuperar_button.dart';
import '../componentes/recuperar_contrasena/recuperar_code_input.dart';
import '../componentes/recuperar_contrasena/recuperar_header.dart';
import '../componentes/recuperar_contrasena/recuperar_password_field.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';

class VerificarCodigoRecuperacionPage extends StatefulWidget {
  final String email;

  const VerificarCodigoRecuperacionPage({super.key, required this.email});

  @override
  State<VerificarCodigoRecuperacionPage> createState() =>
      _VerificarCodigoRecuperacionPageState();
}

class _VerificarCodigoRecuperacionPageState
    extends State<VerificarCodigoRecuperacionPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _code = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitChange() async {
    if (_code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa el código completo de 6 dígitos'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // TODO: Conectar con backend para enviar código y nueva contraseña
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      setState(() => _isLoading = false);

      // Redirigir al Login o pantalla de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contraseña actualizada correctamente'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RecuperarBadge(
                  text: 'PASO 2 DE 2',
                  backgroundColor: AppColors.errorBackground,
                  textColor: AppColors.accent,
                ),
                const SizedBox(height: 16),
                const RecuperarHeader(
                  title: 'Ingresa el código y una nueva contraseña',
                  subtitle: '',
                  titleFontSize: 14,
                ),
                RecuperarCodeInput(
                  onChanged: (code) => setState(() => _code = code),
                ),
                const SizedBox(height: 24),
                RecuperarPasswordField(
                  label: 'Nueva Contraseña',
                  hintText: 'Min. 8 caracteres',
                  controller: _newPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa la nueva contraseña';
                    }
                    if (value.length < 8) {
                      return 'Debe tener al menos 8 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                RecuperarPasswordField(
                  label: 'Confirmar Nueva Contraseña',
                  hintText: 'Repite la contraseña',
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirma tu contraseña';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                RecuperarButton(
                  text: 'Confirmar Cambio',
                  backgroundColor: AppColors.accent,
                  isLoading: _isLoading,
                  onPressed: _submitChange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
