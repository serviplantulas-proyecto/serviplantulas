import 'package:flutter/material.dart';

import '../../models/producto.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';
import 'venta_search_field.dart';

class ItemVenta {
  final Producto producto;
  final int cantidad;

  const ItemVenta({required this.producto, required this.cantidad});

  ItemVenta copyWith({Producto? producto, int? cantidad}) {
    return ItemVenta(
      producto: producto ?? this.producto,
      cantidad: cantidad ?? this.cantidad,
    );
  }

  double get subtotal => producto.precio * cantidad;
}

class VentaProductosSection extends StatelessWidget {
  final List<ItemVenta> items;
  final TextEditingController searchController;
  final List<Producto> sugerencias;
  final ValueChanged<int> onIncrement;
  final ValueChanged<int> onDecrement;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<Producto>? onProductoSeleccionado;
  final VoidCallback? onClearSearch;

  const VentaProductosSection({
    super.key,
    required this.items,
    required this.searchController,
    this.sugerencias = const [],
    required this.onIncrement,
    required this.onDecrement,
    this.onSearchChanged,
    this.onProductoSeleccionado,
    this.onClearSearch,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2. Productos Seleccionados',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        // Buscador de productos (Figma)
        VentaSearchField(
          controller: searchController,
          hintText: 'Escribe el nombre de la planta para añadir...',
          leadingIcon: Icons.cancel_outlined,
          showClear: searchController.text.isNotEmpty,
          onChanged: onSearchChanged,
          onClear: onClearSearch,
        ),
        if (sugerencias.isNotEmpty) ...[
          const SizedBox(height: 6),
          _SugerenciasProducto(
            items: sugerencias,
            money: _money,
            onSelect: onProductoSeleccionado,
          ),
        ],
        const SizedBox(height: 12),
        ...List.generate(items.length, (i) {
          final item = items[i];
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
                          'Unitario: ${_money(item.producto.precio)}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _QtyBtn(
                    icon: Icons.remove,
                    onTap: () => onDecrement(i),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '${item.cantidad}',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _QtyBtn(
                    icon: Icons.add,
                    onTap: () => onIncrement(i),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _money(item.subtotal),
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _SugerenciasProducto extends StatelessWidget {
  final List<Producto> items;
  final String Function(double) money;
  final ValueChanged<Producto>? onSelect;

  const _SugerenciasProducto({
    required this.items,
    required this.money,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: items.map((p) {
          return InkWell(
            onTap: () => onSelect?.call(p),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      p.nombre,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    money(p.precio),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }
}
