import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';
import 'analisis_ingresos_card.dart';

class CategoriaVentaItem {
  final String nombre;
  final double monto;
  final double porcentaje; // 0–1 relativo al máximo

  const CategoriaVentaItem({
    required this.nombre,
    required this.monto,
    required this.porcentaje,
  });
}

class AnalisisVentasCategoria extends StatelessWidget {
  final List<CategoriaVentaItem> items;

  const AnalisisVentasCategoria({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ventas por Categoría',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 14),
        ...items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.nombre,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Text(
                      AnalisisIngresosCard.formatCop(item.monto),
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item.porcentaje.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: AppColors.border,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.mutedGreen),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
