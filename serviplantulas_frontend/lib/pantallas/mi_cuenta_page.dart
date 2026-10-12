import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';
import 'login.dart';

class MiCuentaPage extends StatelessWidget {
  const MiCuentaPage({super.key});

  // Mock — conectar con backend de usuario
  static const _nombre = 'María López';
  static const _nombreCompleto = 'María Camila López Cardona';
  static const _email = 'maria.lopez@serviplantulas.com';
  static const _telefono = '+57 300 678 9012';
  static const _rol = 'Administradora';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Mi Cuenta'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildAvatar(),
                    const SizedBox(height: AppSpacing.extraLarge),
                    _sectionTitle('Información Personal'),
                    _infoCard([
                      _infoRow('NOMBRE COMPLETO', _nombreCompleto),
                      _infoRow('CORREO ELECTRÓNICO', _email),
                      _infoRow('NÚMERO DE CONTACTO', _telefono),
                    ]),
                    const SizedBox(height: AppSpacing.large),
                    _sectionTitle('Seguridad'),
                    _securityTile('CONTRASEÑA', '••••••••', () {}),
                    const SizedBox(height: 8),
                    _securityTile(
                      'AUTENTICACIÓN DE DOS PASOS',
                      'Desactivado',
                      () {},
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                            (_) => false,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.medium),
                          ),
                        ),
                        child: Text(
                          'Cerrar Sesión',
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
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

  Widget _buildAvatar() {
    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: AppColors.editBackground,
          child: Text(
            'ML',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _nombre,
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        Text(
          _rol,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String t) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          t,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _securityTile(String label, String value, VoidCallback onTap) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.label.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      value,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
