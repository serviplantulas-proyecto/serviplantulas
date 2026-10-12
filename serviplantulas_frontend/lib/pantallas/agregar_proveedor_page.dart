import 'package:flutter/material.dart';

import '../componentes/boton/app_button.dart';
import '../componentes/compartidos/app_bar_simple.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';

class AgregarProveedorPage extends StatefulWidget {
  const AgregarProveedorPage({super.key});

  @override
  State<AgregarProveedorPage> createState() => _AgregarProveedorPageState();
}

class _AgregarProveedorPageState extends State<AgregarProveedorPage> {
  final _nombreCtrl = TextEditingController();
  final _nitCtrl = TextEditingController();
  final _contactoCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _nitCtrl.dispose();
    _contactoCtrl.dispose();
    _telCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    // TODO: POST /proveedores
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Proveedor guardado (mock)'),
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
            const AppBarSimple(title: 'Agregar Proveedor'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Nombre / Razón Social'),
                    _field(_nombreCtrl, 'Ej. Nativo Verde S.A.'),
                    const SizedBox(height: AppSpacing.large),
                    _label('NIT'),
                    _field(_nitCtrl, '900.000.000-0'),
                    const SizedBox(height: AppSpacing.large),
                    _label('Persona de Contacto'),
                    _field(_contactoCtrl, 'Nombre del contacto'),
                    const SizedBox(height: AppSpacing.large),
                    _label('Teléfono'),
                    _field(
                      _telCtrl,
                      '300 123 4567',
                      keyboard: TextInputType.phone,
                    ),
                    const SizedBox(height: AppSpacing.large),
                    _label('Correo Electrónico'),
                    _field(
                      _emailCtrl,
                      'contacto@proveedor.com',
                      keyboard: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    AppButton(
                      text: 'Guardar Proveedor',
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
      ),
    );
  }
}
