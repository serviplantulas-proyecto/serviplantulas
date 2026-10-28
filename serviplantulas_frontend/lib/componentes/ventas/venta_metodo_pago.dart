import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

class VentaMetodoPago extends StatelessWidget {
  final String value;
  final ValueChanged<String>? onChanged;
  final List<String> metodos;
  final bool enabled;

  const VentaMetodoPago({
    super.key,
    required this.value,
    this.onChanged,
    this.metodos = const ['Efectivo', 'Transferencia'],
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Método de Pago',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: metodos.map((m) {
            final selected = value == m;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: enabled && onChanged != null
                    ? () => onChanged!(m)
                    : null,
                child: Opacity(
                  opacity: enabled || selected ? 1 : 0.45,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color:
                          selected ? AppColors.mutedGreen : AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? AppColors.mutedGreen
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      m,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: selected
                            ? AppColors.surface
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
