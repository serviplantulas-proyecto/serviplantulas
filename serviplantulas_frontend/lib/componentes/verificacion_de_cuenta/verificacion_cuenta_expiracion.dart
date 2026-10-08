import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_spacing.dart';
import '../../styles/app_text_styles.dart';

class VerificacionCuentaExpiracion extends StatelessWidget {
  const VerificacionCuentaExpiracion({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.schedule_outlined,
          size: 16,
          color: AppColors.textMuted,
        ),
        const SizedBox(width: AppSpacing.extraSmall),
        Text(
          'El código expira en 15 minutos',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}