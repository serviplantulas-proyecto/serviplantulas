import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_spacing.dart';
import '../../styles/app_text_styles.dart';

class VerificacionCuentaResend extends StatelessWidget {
  final VoidCallback? onResend;

  const VerificacionCuentaResend({
    super.key,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '¿No recibiste el código? ',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: onResend,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.extraSmall,
              vertical: AppSpacing.extraSmall,
            ),
            child: Text(
              'Volver a solicitar',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}