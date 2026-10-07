import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

class LoginRegister extends StatelessWidget {
  final VoidCallback? onPressed;

  const LoginRegister({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          '¿No tiene cuenta? ',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: onPressed,
          child: Text(
            'Regístrese aquí',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}