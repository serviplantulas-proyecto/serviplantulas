import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

/// Campo de búsqueda reutilizable (cliente / productos) según Figma.
class VentaSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData leadingIcon;
  final bool showClear;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onTap;
  final bool readOnly;

  const VentaSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    this.leadingIcon = Icons.search,
    this.showClear = false,
    this.onChanged,
    this.onClear,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textMuted,
          ),
          prefixIcon: Icon(
            leadingIcon,
            size: 18,
            color: AppColors.textMuted,
          ),
          suffixIcon: showClear
              ? IconButton(
                  onPressed: onClear,
                  icon: const Icon(
                    Icons.cancel_outlined,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
