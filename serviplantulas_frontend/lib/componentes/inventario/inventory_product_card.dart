import 'package:flutter/material.dart';

import '../../models/producto.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';
import 'inventory_product_thumb.dart';
import 'inventory_small_action.dart';

class InventoryProductCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback? onAjustarStock;
  final VoidCallback? onEditar;
  final VoidCallback? onTap;

  const InventoryProductCard({
    super.key,
    required this.producto,
    this.onAjustarStock,
    this.onEditar,
    this.onTap,
  });

  String _formatPrecio(double precio) {
    final s = precio.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
      buffer.write(s[i]);
    }
    return '\$${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final stockColor =
        producto.stockBajo ? AppColors.warning : AppColors.success;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InventoryProductThumb(imagenUrl: producto.imagenUrl),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.editBackground,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          producto.categoria,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          producto.proveedor,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    producto.nombre,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatPrecio(producto.precio),
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: stockColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${producto.stock} Unidades',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      InventorySmallAction(
                        icon: Icons.swap_vert,
                        label: 'Ajustar Stock',
                        onTap: onAjustarStock,
                      ),
                      const SizedBox(width: 8),
                      InventorySmallAction(
                        icon: Icons.edit_outlined,
                        label: 'Editar',
                        onTap: onEditar,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
