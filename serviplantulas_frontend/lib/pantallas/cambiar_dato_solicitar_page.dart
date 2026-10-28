import 'package:flutter/material.dart';

import '../componentes/recuperar_contrasena/recuperar_badge.dart';
import '../componentes/recuperar_contrasena/recuperar_button.dart';
import '../componentes/recuperar_contrasena/recuperar_header.dart';
import '../services/auth_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import 'cambiar_dato_verificar_page.dart';

enum TipoCambioDato { email, telefono }

class CambiarDatoSolicitarPage extends StatefulWidget {
  final TipoCambioDato tipo;
  final String emailActual;

  const CambiarDatoSolicitarPage({
    super.key,
    required this.tipo,
    required this.emailActual,
  });

  @override
  State<CambiarDatoSolicitarPage> createState() =>
      _CambiarDatoSolicitarPageState();
}

class _CambiarDatoSolicitarPageState extends State<CambiarDatoSolicitarPage> {
  bool _isLoading = false;

  String get _titulo => widget.tipo == TipoCambioDato.email
      ? 'Cambiar correo electrónico'
      : 'Cambiar número de contacto';

  String get _subtitulo =>
      'Enviaremos un código de 6 dígitos a ${widget.emailActual} para confirmar el cambio.';

  Future<void> _enviar() async {
    setState(() => _isLoading = true);
    try {
      await AuthService.solicitarRecuperacion(email: widget.emailActual);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código enviado a tu correo.')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CambiarDatoVerificarPage(
            tipo: widget.tipo,
            emailActual: widget.emailActual,
          ),
        ),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Verificar identidad',
          style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RecuperarBadge(text: 'PASO 1 DE 2'),
              const SizedBox(height: 16),
              RecuperarHeader(title: _titulo, subtitle: _subtitulo),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  widget.emailActual,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              RecuperarButton(
                text: 'Enviar código',
                isLoading: _isLoading,
                onPressed: _enviar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
