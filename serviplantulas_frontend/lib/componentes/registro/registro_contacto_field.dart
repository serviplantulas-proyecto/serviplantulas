import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';
import '../compartidos/input_formatters.dart';

class RegistroContactoField extends StatelessWidget {
  final TextEditingController controller;

  const RegistroContactoField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      inputFormatters: phone10Formatters,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        labelText: 'Número de contacto',
        hintText: '3001234567',
        labelStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
        hintStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textMuted,
        ),
        prefixIcon: const Icon(
          Icons.phone_outlined,
          color: AppColors.textSecondary,
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
