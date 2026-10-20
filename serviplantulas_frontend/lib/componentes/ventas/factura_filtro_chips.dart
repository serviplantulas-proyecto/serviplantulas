import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

enum FacturaFiltro { todas, pendientes, pagadas }

class FacturaFiltroChips extends StatelessWidget {
  final FacturaFiltro selected;
  final ValueChanged<FacturaFiltro> onChanged;

  const FacturaFiltroChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip('Todas', FacturaFiltro.todas),
        const SizedBox(width: 8),
        _chip('Pendientes', FacturaFiltro.pendientes),
        const SizedBox(width: 8),
        _chip('Pagadas', FacturaFiltro.pagadas),
      ],
    );
  }

  Widget _chip(String label, FacturaFiltro value) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.editBackground : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.mutedGreen : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w700,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
