import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';
import 'venta_productos_section.dart';
import 'venta_qty_controls.dart';

/// Fila de un producto seleccionado en el registro de venta.
class VentaItemRow extends StatelessWidget {
  final ItemVenta item;
  final String Function(double) money;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<int>? onCantidadChanged;

  const VentaItemRow({
    super.key,
    required this.item,
    required this.money,
    required this.onIncrement,
    required this.onDecrement,
    this.onCantidadChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.producto.nombre,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Unitario: ${money(item.producto.precio)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            VentaQtyBtn(
              icon: Icons.remove,
              onTap: onDecrement,
            ),
            VentaQtyField(
              value: item.cantidad,
              onChanged: onCantidadChanged,
            ),
            VentaQtyBtn(
              icon: Icons.add,
              onTap: onIncrement,
            ),
            const SizedBox(width: 8),
            Text(
              money(item.subtotal),
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
