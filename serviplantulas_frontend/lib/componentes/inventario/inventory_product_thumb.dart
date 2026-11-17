import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';

/// Miniatura de producto para tarjetas de inventario.
class InventoryProductThumb extends StatelessWidget {
  final String? imagenUrl;
  final double size;

  const InventoryProductThumb({
    super.key,
    this.imagenUrl,
    this.size = 68,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.neutral,
        borderRadius: BorderRadius.circular(10),
      ),
      child: imagenUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imagenUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.local_florist,
                  color: AppColors.mutedGreen,
                  size: 28,
                ),
              ),
            )
          : const Icon(
              Icons.local_florist,
              color: AppColors.mutedGreen,
              size: 28,
            ),
    );
  }
}
