import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

class VerificacionCuentaButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const VerificacionCuentaButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.surface,
          disabledBackgroundColor: AppColors.accent.withValues(
            alpha: 0.6,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppRadius.medium,
            ),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.surface,
                ),
              )
            : Text(
                'Verificar cuenta',
                style: AppTextStyles.button,
              ),
      ),
    );
  }
}