import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../componentes/verificacion_de_cuenta/verificacion_cuenta_header.dart';
import '../componentes/verificacion_de_cuenta/verificacion_cuenta_badge.dart';
import '../componentes/verificacion_de_cuenta/verificacion_cuenta_icon.dart';
import '../componentes/verificacion_de_cuenta/verificacion_cuenta_info.dart';
import '../componentes/verificacion_de_cuenta/verificacion_cuenta_email.dart';
import '../componentes/verificacion_de_cuenta/verificacion_cuenta_code.dart';
import '../componentes/verificacion_de_cuenta/verificacion_cuenta_expiracion.dart';
import '../componentes/verificacion_de_cuenta/verificacion_cuenta_button.dart';
import '../componentes/verificacion_de_cuenta/verificacion_cuenta_resend.dart';

import '../styles/app_colors.dart';
import '../styles/app_spacing.dart';

class VerificarCuentaPage extends StatefulWidget {
  final String email;

  const VerificarCuentaPage({
    super.key,
    required this.email,
  });

  @override
  State<VerificarCuentaPage> createState() => _VerificarCuentaPageState();
}

class _VerificarCuentaPageState extends State<VerificarCuentaPage> {
  final TextEditingController _codigoController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  Future<void> _verificarCuenta() async {
    final codigo = _codigoController.text.trim();
    if (codigo.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el código completo de 6 dígitos.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.verificarCuenta(email: widget.email, codigo: codigo);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cuenta verificada. Ya puedes iniciar sesión.'),
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on AuthException catch (exception) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(exception.message)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _volverASolicitar() async {
    if (_isResending || _isLoading) return;

    setState(() => _isResending = true);
    try {
      await AuthService.reenviarCodigoVerificacion(email: widget.email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Te enviamos un nuevo código.')),
      );
    } on AuthException catch (exception) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(exception.message)),
      );
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            VerificacionCuentaHeader(
              onBack: () {
                Navigator.pop(context);
              },
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.large,
                  vertical: AppSpacing.extraLarge,
                ),
                child: Column(
                  children: [
                    const VerificacionCuentaBadge(),

                    const SizedBox(
                      height: AppSpacing.extraLarge,
                    ),

                    const VerificacionCuentaIcon(),

                    const SizedBox(
                      height: AppSpacing.large,
                    ),

                    const VerificacionCuentaInfo(),

                    const SizedBox(
                      height: AppSpacing.extraLarge,
                    ),

                    VerificacionCuentaEmail(
                      email: widget.email,
                    ),

                    const SizedBox(
                      height: AppSpacing.extraLarge,
                    ),

                    VerificacionCuentaCode(controller: _codigoController),

                    const SizedBox(
                      height: AppSpacing.small,
                    ),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: VerificacionCuentaExpiracion(),
                    ),

                    const SizedBox(
                      height: AppSpacing.extraLarge,
                    ),

                    VerificacionCuentaButton(
                      onPressed: _verificarCuenta,
                      isLoading: _isLoading,
                    ),

                    const SizedBox(
                      height: AppSpacing.large,
                    ),

                    VerificacionCuentaResend(
                      onResend: _isResending || _isLoading
                          ? null
                          : _volverASolicitar,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}