import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';

class VerificacionCuentaIcon extends StatelessWidget {
  const VerificacionCuentaIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.successBackground,
        borderRadius: BorderRadius.circular(
          AppRadius.large,
        ),
      ),
      child: const Icon(
        Icons.verified_user_outlined,
        color: AppColors.primary,
        size: 32,
      ),
    );
  }
}