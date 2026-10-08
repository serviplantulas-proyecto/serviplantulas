import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

class VerificacionCuentaBadge extends StatelessWidget {
  const VerificacionCuentaBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.errorBackground,
        borderRadius: BorderRadius.circular(
          AppRadius.small,
        ),
      ),
      child: Text(
        'VERIFICACIÓN DE CUENTA',
        style: AppTextStyles.label.copyWith(
          color: AppColors.error,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}