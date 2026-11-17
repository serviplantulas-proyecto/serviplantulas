import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

/// App bar simple de la pantalla de inventario.
class InventarioAppBar extends StatelessWidget {
  const InventarioAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Inventario Serviplantulas',
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              fontSize: 18,
            ),
          ),
          const Icon(Icons.grid_view, color: AppColors.primary, size: 24),
        ],
      ),
    );
  }
}
