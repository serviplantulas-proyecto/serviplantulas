import 'package:flutter/material.dart';

import '../componentes/boton/app_button.dart';
import '../componentes/compartidos/app_bar_simple.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';

class AgregarClientePage extends StatefulWidget {
  const AgregarClientePage({super.key});

  @override
  State<AgregarClientePage> createState() => _AgregarClientePageState();
}

class _AgregarClientePageState extends State<AgregarClientePage> {
  final _nombreCtrl = TextEditingController();
  final _docCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _dirCtrl = TextEditingController();
  String _tipoDoc = 'Cédula (C.C.)';
  bool _isLoading = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _docCtrl.dispose();
    _telCtrl.dispose();
    _emailCtrl.dispose();
    _dirCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    // TODO: POST /clientes
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cliente guardado (mock)'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Agregar Cliente'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Nombre Completo'),
                    _field(
                      _nombreCtrl,
                      'Ej. Juan Carlos Pérez',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: AppSpacing.large),
                    _label('Documento de Identidad'),
                    _tipoDocToggle(),
                    const SizedBox(height: 8),
                    _field(_docCtrl, 'Número de documento (sin puntos)'),
                    const SizedBox(height: AppSpacing.large),
                    _label('Teléfono Móvil'),
                    _field(
                      _telCtrl,
                      '300 123 4567',
                      prefix: '+57 ',
                      keyboard: TextInputType.phone,
                    ),
                    const SizedBox(height: AppSpacing.large),
                    _label('Correo Electrónico'),
                    _field(
                      _emailCtrl,
                      'correo@ejemplo.com',
                      icon: Icons.email_outlined,
                      keyboard: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: AppSpacing.large),
                    _label('Dirección de Envío'),
                    _field(
                      _dirCtrl,
                      'Calle, Carrera, Barrio, Ciudad',
                      icon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    AppButton(
                      text: 'Guardar Cliente',
                      icon: Icons.check,
                      isLoading: _isLoading,
                      onPressed: _guardar,
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

  Widget _tipoDocToggle() {
    return Row(
      children: [
        _chip('Cédula (C.C.)'),
        const SizedBox(width: 8),
        _chip('NIT'),
      ],
    );
  }

  Widget _chip(String label) {
    final selected = _tipoDoc == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tipoDoc = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.neutral,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: selected ? AppColors.surface : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          t,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Widget _field(
    TextEditingController ctrl,
    String hint, {
    IconData? icon,
    String? prefix,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
        prefixIcon: icon != null
            ? Icon(icon, size: 18, color: AppColors.textMuted)
            : null,
        prefixText: prefix,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
