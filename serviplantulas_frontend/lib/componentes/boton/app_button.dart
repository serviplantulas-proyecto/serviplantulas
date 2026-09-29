import 'package:flutter/material.dart';

import '../../colores/app_colors.dart';
import '../../colores/app_radius.dart';
import '../../styles/app_text_styles.dart';

enum AppButtonType {
  primary,
  accent,
  secondary,
  danger,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.icon,
  });

  Color get _backgroundColor {
    switch (type) {
      case AppButtonType.primary:
        return AppColors.primary;

      case AppButtonType.accent:
        return AppColors.accent;

      case AppButtonType.secondary:
        return AppColors.background;

      case AppButtonType.danger:
        return AppColors.error;
    }
  }

  Color get _textColor {
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.accent:
      case AppButtonType.danger:
        return AppColors.surface;

      case AppButtonType.secondary:
        return AppColors.textPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _backgroundColor,
          foregroundColor: _textColor,
          disabledBackgroundColor: AppColors.textMuted,
          disabledForegroundColor: AppColors.surface,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppRadius.medium,
            ),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.surface,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: AppTextStyles.button.copyWith(
                      color: _textColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}