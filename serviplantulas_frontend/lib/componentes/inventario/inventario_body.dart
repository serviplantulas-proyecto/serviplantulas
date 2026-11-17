import 'package:flutter/material.dart';

import '../../models/producto.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';
import 'inventory_product_card.dart';

/// Cuerpo del inventario: loading, error, vacío o lista de productos.
class InventarioBody extends StatelessWidget {
  final bool loading;
  final String? error;
  final List<Producto> productos;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final void Function(Producto) onAjustarStock;
  final void Function(Producto) onOpenDetalle;

  const InventarioBody({
    super.key,
    required this.loading,
    required this.error,
    required this.productos,
    required this.onRefresh,
    required this.onRetry,
    required this.onAjustarStock,
    required this.onOpenDetalle,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                error!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              TextButton(onPressed: onRetry, child: const Text('Reintentar')),
            ],
          ),
        ),
      );
    }
    if (productos.isEmpty) {
      return Center(
        child: Text(
          'No hay productos',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textMuted,
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        itemCount: productos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final p = productos[index];
          return InventoryProductCard(
            producto: p,
            onAjustarStock: () => onAjustarStock(p),
            onEditar: () => onOpenDetalle(p),
            onTap: () => onOpenDetalle(p),
          );
        },
      ),
    );
  }
}
