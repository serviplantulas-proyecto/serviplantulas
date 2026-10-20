import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

/// Selector de rango de tiempo (mes) + etiqueta "Actual".
class AnalisisPeriodoSelector extends StatelessWidget {
  final DateTime mesSeleccionado;
  final VoidCallback onTapMes;
  final String rangoTexto;

  const AnalisisPeriodoSelector({
    super.key,
    required this.mesSeleccionado,
    required this.onTapMes,
    required this.rangoTexto,
  });

  static const _meses = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
  ];

  static String formatearRango(DateTime mes) {
    final inicio = DateTime(mes.year, mes.month, 1);
    final fin = DateTime(mes.year, mes.month + 1, 0);
    return '${_pad(inicio.day)} ${_meses[inicio.month - 1]} ${inicio.year}'
        ' - ${_pad(fin.day)} ${_meses[fin.month - 1]} ${fin.year}';
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final hoy = DateTime.now();
    final esMesActual =
        mesSeleccionado.year == hoy.year && mesSeleccionado.month == hoy.month;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'RANGO DE TIEMPO',
              style: AppTextStyles.label.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
            const Spacer(),
            if (esMesActual)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.successBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Actual · ${_pad(hoy.day)} ${_meses[hoy.month - 1]}',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTapMes,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    rangoTexto,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down,
                    color: AppColors.primary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
