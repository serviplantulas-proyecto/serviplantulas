import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

/// Selector de mes/año en bottom sheet.
/// No usa showDatePicker ni flutter_localizations.
class AnalisisMesPicker {
  static const meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime mesActual,
  }) {
    return showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _MesPickerSheet(mesInicial: mesActual),
    );
  }
}

class _MesPickerSheet extends StatefulWidget {
  final DateTime mesInicial;

  const _MesPickerSheet({required this.mesInicial});

  @override
  State<_MesPickerSheet> createState() => _MesPickerSheetState();
}

class _MesPickerSheetState extends State<_MesPickerSheet> {
  late int _anio;
  late int _mes;

  @override
  void initState() {
    super.initState();
    _anio = widget.mesInicial.year;
    _mes = widget.mesInicial.month;
  }

  @override
  Widget build(BuildContext context) {
    final anioMax = DateTime.now().year + 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Seleccionar mes',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          // Año
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _anio > 2020
                    ? () => setState(() => _anio--)
                    : null,
                icon: const Icon(Icons.chevron_left),
                color: AppColors.primary,
              ),
              Text(
                '$_anio',
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              IconButton(
                onPressed: _anio < anioMax
                    ? () => setState(() => _anio++)
                    : null,
                icon: const Icon(Icons.chevron_right),
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Grid de meses
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.4,
            ),
            itemCount: 12,
            itemBuilder: (context, i) {
              final mesNum = i + 1;
              final selected = mesNum == _mes;
              return GestureDetector(
                onTap: () => setState(() => _mes = mesNum),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.mutedGreen
                        : AppColors.editBackground,
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    border: Border.all(
                      color: selected
                          ? AppColors.mutedGreen
                          : AppColors.border,
                    ),
                  ),
                  child: Text(
                    AnalisisMesPicker.meses[i].substring(0, 3),
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? AppColors.surface
                          : AppColors.primary,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, DateTime(_anio, _mes));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
              ),
              child: Text(
                'Aplicar',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.surface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
