import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

class RecuperarBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const RecuperarBadge({
    super.key,
    required this.text,
    this.backgroundColor = AppColors.neutral,
    this.textColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.label.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}