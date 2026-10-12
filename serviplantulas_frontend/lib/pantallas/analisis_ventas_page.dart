import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';

class AnalisisVentasPage extends StatelessWidget {
  const AnalisisVentasPage({super.key});

  // Mock — GET /analisis/ventas
  static const _revenue = 8750000.0;
  static const _topSelling = [
    ('Helecho Boston', 142),
    ('Monstera Deliciosa', 98),
    ('Cuna de Moisés', 76),
    ('Ficus Lyrata', 54),
  ];

  String _money(double v) {
    final s = v.toStringAsFixed(0);
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '\$${buf.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Análisis de Ventas'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _dateBanner(),
                    const SizedBox(height: AppSpacing.large),
                    _revenueCard(),
                    const SizedBox(height: AppSpacing.extraLarge),
                    Text(
                      'Más Vendidos',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._topSelling.map((e) => _topRow(e.$1, e.$2)),
                    const SizedBox(height: AppSpacing.extraLarge),
                    Text(
                      'Desglose',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _breakdownRow('Ventas contado', 0.62, AppColors.success),
                    _breakdownRow('Ventas crédito', 0.28, AppColors.info),
                    _breakdownRow('Devoluciones', 0.10, AppColors.warning),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.editBackground,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            '01 Oct 2023 — 08 Oct 2023',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _revenueCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingresos del período',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.surface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _money(_revenue),
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.surface,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '+18.2% vs período anterior',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.successBackground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _topRow(String nombre, int uds) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.local_florist, size: 18, color: AppColors.mutedGreen),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                nombre,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '$uds uds',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _breakdownRow(String label, double pct, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.bodyMedium),
              Text(
                '${(pct * 100).toStringAsFixed(0)}%',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}
