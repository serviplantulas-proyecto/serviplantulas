import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../componentes/recuperar_contrasena/recuperar_badge.dart';
import '../componentes/recuperar_contrasena/recuperar_button.dart';
import '../componentes/recuperar_contrasena/recuperar_header.dart';
import '../services/auth_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_text_styles.dart';
import 'cambiar_dato_solicitar_page.dart';

class CambiarDatoVerificarPage extends StatefulWidget {
  final TipoCambioDato tipo;
  final String emailActual;

  const CambiarDatoVerificarPage({
    super.key,
    required this.tipo,
    required this.emailActual,
  });

  @override
  State<CambiarDatoVerificarPage> createState() =>
      _CambiarDatoVerificarPageState();
}

class _CambiarDatoVerificarPageState extends State<CambiarDatoVerificarPage> {
  final _codigoCtrl = TextEditingController();
  final _nuevoCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  bool get _esEmail => widget.tipo == TipoCambioDato.email;

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _nuevoCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirmar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    try {
      final res = await AuthService.cambiarDatoPerfil(
        email: widget.emailActual,
        codigo: _codigoCtrl.text.trim(),
        nuevoEmail: _esEmail ? _nuevoCtrl.text.trim() : null,
        nuevoTelefono: _esEmail ? null : _nuevoCtrl.text.trim(),
      );
      final prefs = await SharedPreferences.getInstance();
      if (_esEmail && res['email'] != null) {
        await prefs.setString('user_email', res['email'].toString());
      }
      if (!_esEmail && res['telefono'] != null) {
        await prefs.setString('user_telefono', res['telefono'].toString());
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Datos actualizados correctamente'),
        backgroundColor: AppColors.success,
      ));
      Navigator.of(context).pop(true);
      Navigator.of(context).pop(true);
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _reenviar() async {
    try {
      await AuthService.solicitarRecuperacion(email: widget.emailActual);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Código reenviado.')),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
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
          'Confirmar cambio',
          style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RecuperarBadge(text: 'PASO 2 DE 2'),
                const SizedBox(height: 16),
                RecuperarHeader(
                  title: _esEmail
                      ? 'Código y nuevo correo'
                      : 'Código y nuevo número',
                  subtitle:
                      'Ingresa el código enviado a ${widget.emailActual}.',
                ),
                const SizedBox(height: 20),
                Text('Código de 6 dígitos', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _codigoCtrl,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _dec('000000'),
                  validator: (v) =>
                      (v == null || v.length != 6) ? 'Código de 6 dígitos' : null,
                ),
                const SizedBox(height: 8),
                Text(_esEmail ? 'Nuevo correo' : 'Nuevo teléfono', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nuevoCtrl,
                  keyboardType: _esEmail
                      ? TextInputType.emailAddress
                      : TextInputType.phone,
                  decoration: _dec(
                    _esEmail ? 'nuevo@correo.com' : '3001234567',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Campo requerido';
                    if (_esEmail && !v.contains('@')) return 'Correo inválido';
                    if (!_esEmail && v.trim().length < 7) {
                      return 'Teléfono inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                RecuperarButton(
                  text: 'Confirmar cambio',
                  isLoading: _isLoading,
                  onPressed: _confirmar,
                ),
                Center(
                  child: TextButton(
                    onPressed: _reenviar,
                    child: Text(
                      '¿No recibiste el código? Volver a solicitar',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.surface,
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      );
}
