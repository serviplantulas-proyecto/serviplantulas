import 'package:flutter/material.dart';

import '../boton/app_button.dart';
import '../compartidos/form_dropdown.dart';
import '../compartidos/qty_stepper.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

class ProductoCampoTexto extends StatelessWidget {
  const ProductoCampoTexto({
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboard = TextInputType.text,
    this.maxLines = 1,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboard;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProductoLabel(label),
        TextField(
          controller: controller,
          keyboardType: keyboard,
          maxLines: maxLines,
          style: AppTextStyles.bodyMedium,
          decoration: _productoDecoration(hint),
        ),
      ],
    );
  }
}

class ProductoDropdownField extends StatelessWidget {
  const ProductoDropdownField({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    super.key,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return FormDropdown(
      label: label,
      value: value,
      options: options,
      onChanged: onChanged,
    );
  }
}

class ProductoCampoStock extends StatelessWidget {
  const ProductoCampoStock({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ProductoLabel('Stock Inicial'),
        QtyStepper(value: value, onChanged: onChanged),
      ],
    );
  }
}

class ProductoBotonGuardar extends StatelessWidget {
  const ProductoBotonGuardar({
    required this.isLoading,
    required this.onPressed,
    super.key,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: 'Guardar Producto',
      isLoading: isLoading,
      onPressed: onPressed,
    );
  }
}

class _ProductoLabel extends StatelessWidget {
  const _ProductoLabel(this.text);

  final String text;

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

InputDecoration _productoDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
  );
}
