import 'package:flutter/material.dart';

import '../../models/producto.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

/// Banner de imagen del producto en la pantalla de detalle.
class DetalleProductoImageBanner extends StatelessWidget {
  final Producto producto;

  const DetalleProductoImageBanner({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.neutral,
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: producto.imagenUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.large),
              child: Image.network(
                producto.imagenUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.local_florist,
                  size: 64,
                  color: AppColors.mutedGreen,
                ),
              ),
            )
          : const Icon(
              Icons.local_florist,
              size: 64,
              color: AppColors.mutedGreen,
            ),
    );
  }
}

/// Badge de categoría / etiqueta en detalle de producto.
class DetalleProductoBadge extends StatelessWidget {
  final String text;

  const DetalleProductoBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.editBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: AppTextStyles.label.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Caja de información (precio, stock, etc.) en detalle de producto.
class DetalleProductoInfoBox extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const DetalleProductoInfoBox({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
