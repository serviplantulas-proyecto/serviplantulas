import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

class RecuperarButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color backgroundColor;

  const RecuperarButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: AppColors.surface,
          elevation: 0,
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppColors.surface,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: AppTextStyles.button,
              ),
      ),
    );
  }
}