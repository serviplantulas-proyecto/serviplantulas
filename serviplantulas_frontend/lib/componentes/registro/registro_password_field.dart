import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';
import '../compartidos/password_rules.dart';

class RegistroPasswordField extends StatefulWidget {
  final TextEditingController controller;

  const RegistroPasswordField({
    super.key,
    required this.controller,
  });

  @override
  State<RegistroPasswordField> createState() => _RegistroPasswordFieldState();
}

class _RegistroPasswordFieldState extends State<RegistroPasswordField> {
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: _obscurePassword,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            hintText: 'Crea una contraseña',
            labelStyle: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            hintStyle: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textMuted,
            ),
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.textSecondary,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              icon: Icon(
                _obscurePassword
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
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        PasswordRulesChecklist(password: widget.controller.text),
      ],
    );
  }
}
