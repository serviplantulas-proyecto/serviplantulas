import 'package:flutter/material.dart';

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
  bool _isLoading = false;

  void _verificarCuenta() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _volverASolicitar() {
    // Aquí conectaremos posteriormente el reenvío del código.
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

                    const VerificacionCuentaCode(),

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
                      onResend: _volverASolicitar,
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