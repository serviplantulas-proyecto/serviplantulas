import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

class ProveedorFormLabel extends StatelessWidget {
  final String text;
  const ProveedorFormLabel(this.text, {super.key});

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

class ProveedorFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboard;

  const ProveedorFormField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboard = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
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

const kProductosSuministro = [
  'Plantas',
  'Macetas',
  'Abonos',
  'Herramientas',
];

class ProveedorProductosChips extends StatelessWidget {
  final Set<String> seleccionados;
  final ValueChanged<String> onToggle;

  const ProveedorProductosChips({
    super.key,
    required this.seleccionados,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: kProductosSuministro.map((p) {
        final sel = seleccionados.contains(p);
        return FilterChip(
          label: Text(p),
          selected: sel,
          onSelected: (_) => onToggle(p),
          selectedColor: AppColors.editBackground,
          labelStyle: AppTextStyles.bodySmall.copyWith(
            color: sel ? AppColors.primary : AppColors.textSecondary,
            fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
          ),
          backgroundColor: AppColors.surface,
          side: BorderSide(
            color: sel ? AppColors.primary : AppColors.border,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          showCheckmark: false,
          padding: const EdgeInsets.symmetric(horizontal: 4),
        );
      }).toList(),
    );
  }
}
