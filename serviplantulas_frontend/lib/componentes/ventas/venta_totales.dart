import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

class VentaTotales extends StatelessWidget {
  final double subtotal;
  final double descuento;
  final double total;
  final double porcentajeDescuento;

  const VentaTotales({
    super.key,
    required this.subtotal,
    required this.descuento,
    required this.total,
    this.porcentajeDescuento = 0,
  });

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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _row('Subtotal', _money(subtotal)),
          if (descuento > 0)
            _row(
              'Descuento Cliente Frecuente '
              '(${porcentajeDescuento.toStringAsFixed(0)}%)',
              '-${_money(descuento)}',
              color: AppColors.success,
            ),
          const Divider(height: 20),
          _row('Total a Pagar', _money(total), isTotal: true),
        ],
      ),
    );
  }

  Widget _row(String label, String value,
      {Color? color, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700)
                : AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w800,
              color: color ??
                  (isTotal ? AppColors.accent : AppColors.primary),
              fontSize: isTotal ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
