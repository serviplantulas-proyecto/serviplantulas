import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_spacing.dart';
import '../../styles/app_text_styles.dart';

class VerificacionCuentaCode extends StatelessWidget {
  const VerificacionCuentaCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Código de verificación',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        Row(
          children: List.generate(
            6,
            (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == 5
                        ? 0
                        : AppSpacing.small,
                  ),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppRadius.medium,
                      ),
                      border: Border.all(
                        color: AppColors.border,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '',
                      style: AppTextStyles.titleSmall,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}