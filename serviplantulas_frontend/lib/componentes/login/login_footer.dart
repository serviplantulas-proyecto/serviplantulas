import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'V 2.4.1 • Serviplantulas S.A.S',
      textAlign: TextAlign.center,
      style: AppTextStyles.label.copyWith(
        color: AppColors.textMuted,
      ),
    );
  }
}