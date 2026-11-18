import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';
import '../compartidos/legal_dialog.dart';

class RegistroTerminosCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const RegistroTerminosCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.bodySmall.copyWith(
      color: AppColors.textSecondary,
      height: 1.35,
    );
    final link = base.copyWith(
      color: AppColors.primary,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.primary,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
            activeColor: AppColors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: base,
              children: [
                const TextSpan(
                  text: 'Al registrarme, acepto los ',
                ),
                TextSpan(
                  text: 'Términos y Condiciones',
                  style: link,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => showLegalDialog(
                          context,
                          LegalDocumento.terminos,
                        ),
                ),
                const TextSpan(
                  text: ' y autorizo el tratamiento de mis datos personales conforme a la ',
                ),
                TextSpan(
                  text: 'Política de Privacidad',
                  style: link,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => showLegalDialog(
                          context,
                          LegalDocumento.privacidad,
                        ),
                ),
                const TextSpan(
                  text:
                      ' de SERVIPLANTULAS (Ley 1581 de 2012).',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
