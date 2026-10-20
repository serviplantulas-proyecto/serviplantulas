import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

enum AnalisisVista { diario, semanal, mensual }

class AnalisisGranularidad extends StatelessWidget {
  final AnalisisVista vista;
  final ValueChanged<AnalisisVista> onVistaChanged;
  final int? diaSeleccionado; // 1..7 en modo diario
  final int? semanaSeleccionada; // 1..4 en modo semanal
  final ValueChanged<int>? onDiaChanged;
  final ValueChanged<int>? onSemanaChanged;

  const AnalisisGranularidad({
    super.key,
    required this.vista,
    required this.onVistaChanged,
    this.diaSeleccionado,
    this.semanaSeleccionada,
    this.onDiaChanged,
    this.onSemanaChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _chip('Diario', AnalisisVista.diario),
            const SizedBox(width: 8),
            _chip('Semanal', AnalisisVista.semanal),
            const SizedBox(width: 8),
            _chip('Mensual', AnalisisVista.mensual),
          ],
        ),
        if (vista == AnalisisVista.diario) ...[
          const SizedBox(height: 12),
          _subLabel('Día de la semana (1–7)'),
          const SizedBox(height: 8),
          _scrollChips(
            count: 7,
            selected: diaSeleccionado ?? 1,
            labelBuilder: (i) => 'D$i',
            onSelect: onDiaChanged,
          ),
        ],
        if (vista == AnalisisVista.semanal) ...[
          const SizedBox(height: 12),
          _subLabel('Semana del mes'),
          const SizedBox(height: 8),
          _scrollChips(
            count: 4,
            selected: semanaSeleccionada ?? 1,
            labelBuilder: (i) => 'Semana $i',
            onSelect: onSemanaChanged,
          ),
        ],
        // Mensual: sin sub-selector (el mes ya se eligió arriba)
      ],
    );
  }

  Widget _subLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.label.copyWith(
        color: AppColors.textMuted,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _chip(String label, AnalisisVista value) {
    final selected = vista == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onVistaChanged(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.surface : AppColors.editBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary : Colors.transparent,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _scrollChips({
    required int count,
    required int selected,
    required String Function(int) labelBuilder,
    required ValueChanged<int>? onSelect,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(count, (index) {
          final value = index + 1;
          final isSel = selected == value;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelect?.call(value),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSel ? AppColors.mutedGreen : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSel ? AppColors.mutedGreen : AppColors.border,
                  ),
                ),
                child: Text(
                  labelBuilder(value),
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isSel ? AppColors.surface : AppColors.primary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
