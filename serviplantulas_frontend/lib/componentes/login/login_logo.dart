import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(
              AppRadius.large,
            ),
          ),
          child: const Icon(
            Icons.eco_outlined,
            color: AppColors.surface,
            size: 42,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          'Serviplantulas',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          'Gestión Profesional de Viveros',
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }
}