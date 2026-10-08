import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_spacing.dart';
import '../../styles/app_text_styles.dart';

class VerificacionCuentaInfo extends StatelessWidget {
  const VerificacionCuentaInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Revisa tu correo',
          textAlign: TextAlign.center,
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        Text(
          'Hemos enviado un código de verificación a tu correo electrónico.',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}