import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

class PasswordRuleResult {
  final bool minLength;
  final bool hasNumber;
  final bool hasUpper;
  final bool hasSymbol;

  const PasswordRuleResult({
    required this.minLength,
    required this.hasNumber,
    required this.hasUpper,
    required this.hasSymbol,
  });

  int get score =>
      [minLength, hasNumber, hasUpper, hasSymbol].where((e) => e).length;

  bool get isValid => score == 4;

  String get strengthLabel {
    switch (score) {
      case 0:
      case 1:
        return 'Seguridad: Débil';
      case 2:
        return 'Seguridad: Media';
      case 3:
        return 'Seguridad: Buena';
      default:
        return 'Seguridad: Fuerte';
    }
  }

  Color get strengthColor {
    switch (score) {
      case 0:
      case 1:
        return AppColors.error;
      case 2:
        return AppColors.warning;
      case 3:
        return AppColors.primary;
      default:
        return AppColors.success;
    }
  }

  double get strengthProgress => score / 4;

  static PasswordRuleResult evaluate(String password) {
    return PasswordRuleResult(
      minLength: password.length >= 8,
      hasNumber: RegExp(r'[0-9]').hasMatch(password),
      hasUpper: RegExp(r'[A-ZÁÉÍÓÚÑ]').hasMatch(password),
      hasSymbol: RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\;/`]').hasMatch(password),
    );
  }
}

/// Lista de reglas + barra de seguridad (estilo checklist).
class PasswordRulesChecklist extends StatelessWidget {
  final String password;

  const PasswordRulesChecklist({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final r = PasswordRuleResult.evaluate(password);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        _rule('Mínimo 8 caracteres', r.minLength),
        _rule('Incluye un número', r.hasNumber),
        _rule('Incluye una mayúscula', r.hasUpper),
        _rule('Incluye un símbolo', r.hasSymbol),
        const SizedBox(height: 8),
        Text(
          r.strengthLabel,
          style: AppTextStyles.bodySmall.copyWith(
            color: r.strengthColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: r.strengthProgress,
            minHeight: 4,
            backgroundColor: AppColors.border,
            color: r.strengthColor,
          ),
        ),
      ],
    );
  }

  Widget _rule(String text, bool ok) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ok ? AppColors.success : Colors.transparent,
              border: Border.all(
                color: ok ? AppColors.success : AppColors.border,
                width: 1.5,
              ),
            ),
            child: ok
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: ok ? AppColors.success : AppColors.textMuted,
                fontWeight: ok ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
