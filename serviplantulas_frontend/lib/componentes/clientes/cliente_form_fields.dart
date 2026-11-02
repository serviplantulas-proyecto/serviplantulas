import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';
import '../compartidos/input_formatters.dart';

class ClienteFormLabel extends StatelessWidget {
  final String text;
  const ClienteFormLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ClienteFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final String? prefix;
  final TextInputType keyboard;
  final List<TextInputFormatter>? inputFormatters;

  const ClienteFormField({
    super.key,
    required this.controller,
    required this.hint,
    this.icon,
    this.prefix,
    this.keyboard = TextInputType.text,
    this.inputFormatters,
  });

  List<TextInputFormatter>? get _formatters {
    if (inputFormatters != null) return inputFormatters;
    if (keyboard == TextInputType.phone) return phone10Formatters;
    if (keyboard == TextInputType.number) return nonNegativeIntFormatters;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      inputFormatters: _formatters,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
        prefixIcon: icon != null
            ? Icon(icon, size: 18, color: AppColors.textMuted)
            : null,
        prefixText: prefix,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}

class ClienteTipoDocToggle extends StatelessWidget {
  final bool esCedula;
  final ValueChanged<bool> onChanged;

  const ClienteTipoDocToggle({
    super.key,
    required this.esCedula,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip('Cédula (C.C.)', esCedula, () => onChanged(true)),
        const SizedBox(width: 8),
        _chip('NIT', !esCedula, () => onChanged(false)),
      ],
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.neutral,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: selected ? AppColors.surface : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
