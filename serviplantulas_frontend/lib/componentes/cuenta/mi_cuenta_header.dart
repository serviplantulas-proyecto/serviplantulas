import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

class MiCuentaHeader extends StatelessWidget {
  final String iniciales;
  final String nombre;
  final String rol;

  const MiCuentaHeader({
    super.key,
    required this.iniciales,
    required this.nombre,
    required this.rol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: AppColors.editBackground,
          child: Text(
            iniciales,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          nombre,
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          rol,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}


class MiCuentaNombreCard extends StatelessWidget {
  final String nombre;
  const MiCuentaNombreCard({super.key, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NOMBRE COMPLETO',
            style: AppTextStyles.label.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 10,
              color: AppColors.textMuted,
            ),
          ),
          Text(
            nombre.isEmpty ? '—' : nombre,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
