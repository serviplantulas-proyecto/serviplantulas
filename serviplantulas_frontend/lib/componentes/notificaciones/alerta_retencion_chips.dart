import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

/// Opciones de retención automática de notificaciones.
class AlertaRetencionChips extends StatelessWidget {
  final int diasSeleccionados;
  final ValueChanged<int> onChanged;

  const AlertaRetencionChips({
    super.key,
    required this.diasSeleccionados,
    required this.onChanged,
  });

  static const opciones = <(int, String)>[
    (7, 'Cada semana'),
    (30, 'Cada mes'),
    (90, '3 meses'),
    (180, '6 meses'),
    (365, '1 año'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Eliminación automática',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Borrar notificaciones más antiguas que el periodo elegido.',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: opciones.map((o) {
            final sel = o.$1 == diasSeleccionados;
            return ChoiceChip(
              label: Text(o.$2),
              selected: sel,
              onSelected: (_) => onChanged(o.$1),
              selectedColor: AppColors.primary,
              labelStyle: AppTextStyles.label.copyWith(
                color: sel ? Colors.white : AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: AppColors.surface,
              side: BorderSide(
                color: sel ? AppColors.primary : AppColors.border,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
