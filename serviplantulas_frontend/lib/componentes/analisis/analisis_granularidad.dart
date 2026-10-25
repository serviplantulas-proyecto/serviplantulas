import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

enum AnalisisVista { diario, semanal, mensual }

class AnalisisGranularidad extends StatelessWidget {
  final AnalisisVista vista;
  final DateTime mes;
  final ValueChanged<AnalisisVista> onVistaChanged;
  final int? diaSeleccionado; // día del mes 1..31
  final int? semanaSeleccionada; // 1..5
  final ValueChanged<int>? onDiaChanged;
  final ValueChanged<int>? onSemanaChanged;

  const AnalisisGranularidad({
    super.key,
    required this.vista,
    required this.mes,
    required this.onVistaChanged,
    this.diaSeleccionado,
    this.semanaSeleccionada,
    this.onDiaChanged,
    this.onSemanaChanged,
  });

  int get _diasMes => DateTime(mes.year, mes.month + 1, 0).day;

  int get _numSemanas => ((_diasMes - 1) ~/ 7) + 1;

  /// Rango de fechas de la semana n (1-based) dentro del mes.
  (int, int) _rangoSemana(int semana) {
    final inicio = (semana - 1) * 7 + 1;
    final fin = (inicio + 6).clamp(1, _diasMes);
    return (inicio, fin);
  }

  static const _mesesCortos = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
  ];

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
          _subLabel(
            'Día de ${_mesesCortos[mes.month - 1]} ${mes.year} '
            '(${diaSeleccionado ?? 1}/$_diasMes)',
          ),
          const SizedBox(height: 8),
          _scrollChips(
            count: _diasMes,
            selected: diaSeleccionado ?? 1,
            labelBuilder: (i) => '$i',
            onSelect: onDiaChanged,
          ),
        ],
        if (vista == AnalisisVista.semanal) ...[
          const SizedBox(height: 12),
          _subLabel('Semana de ${_mesesCortos[mes.month - 1]}'),
          const SizedBox(height: 8),
          _scrollChips(
            count: _numSemanas,
            selected: semanaSeleccionada ?? 1,
            labelBuilder: (i) {
              final (a, b) = _rangoSemana(i);
              return 'S$i · $a–$b';
            },
            onSelect: onSemanaChanged,
          ),
        ],
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
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
