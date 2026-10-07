import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

class LoginForgotPassword extends StatelessWidget {
  final VoidCallback? onPressed;

  const LoginForgotPassword({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(  
        '¿Olvidé mi contraseña?',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.accent,
        ),
      ),
    );
  }
}