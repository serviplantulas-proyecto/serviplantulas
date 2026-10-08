import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

class RecuperarPasswordField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const RecuperarPasswordField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
  });

  @override
  State<RecuperarPasswordField> createState() => _RecuperarPasswordFieldState();
}

class _RecuperarPasswordFieldState extends State<RecuperarPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          style: AppTextStyles.bodyMedium,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: () {
                setState(() => _obscureText = !_obscureText);
              },
            ),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}