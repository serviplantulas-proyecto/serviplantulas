import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

class ClienteFiltroChip extends StatelessWidget {
  final String? filtroActivo;
  final VoidCallback onActivar;
  final VoidCallback onQuitar;

  const ClienteFiltroChip({
    super.key,
    required this.filtroActivo,
    required this.onActivar,
    required this.onQuitar,
  });

  @override
  Widget build(BuildContext context) {
    if (filtroActivo == null) {
      return GestureDetector(
        onTap: onActivar,
        child: Text(
          'Filtro: Cédula de Ciudadanía',
          style: AppTextStyles.label.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE8E0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(
          'Filtro: $filtroActivo',
          style: AppTextStyles.label.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onQuitar,
          child: Icon(Icons.close, size: 16, color: AppColors.accent),
        ),
      ]),
    );
  }
}
