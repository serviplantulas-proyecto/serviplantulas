import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

class VerificacionCuentaHeader extends StatelessWidget {
  final VoidCallback? onBack;

  const VerificacionCuentaHeader({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: Row(
        children: [
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(
              AppRadius.medium,
            ),
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(
                AppRadius.medium,
              ),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Verificar cuenta',
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}