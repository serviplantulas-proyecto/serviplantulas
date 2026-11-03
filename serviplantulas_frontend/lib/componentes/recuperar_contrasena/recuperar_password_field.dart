import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';
import '../compartidos/password_rules.dart';

class RecuperarPasswordField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool showRules;

  const RecuperarPasswordField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.showRules = false,
  });

  @override
  State<RecuperarPasswordField> createState() => _RecuperarPasswordFieldState();
}

class _RecuperarPasswordFieldState extends State<RecuperarPasswordField> {
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    if (widget.showRules) {
      widget.controller.addListener(_onChange);
    }
  }

  @override
  void dispose() {
    if (widget.showRules) {
      widget.controller.removeListener(_onChange);
    }
    super.dispose();
  }

  void _onChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscure,
          validator: widget.validator,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textMuted,
            ),
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.textSecondary,
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(
                _obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textMuted,
              ),
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
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        if (widget.showRules)
          PasswordRulesChecklist(password: widget.controller.text),
      ],
    );
  }
}
