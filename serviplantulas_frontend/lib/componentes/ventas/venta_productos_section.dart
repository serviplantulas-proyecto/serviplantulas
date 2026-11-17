import 'package:flutter/material.dart';

import '../../models/producto.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';
import 'venta_item_row.dart';
import 'venta_search_field.dart';
import 'venta_sugerencias_producto.dart';

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
  final void Function(int index, int cantidad)? onCantidadChanged;
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
    this.onCantidadChanged,
    this.onSearchChanged,
    this.onProductoSeleccionado,
    this.onClearSearch,
  });

  String _money(double v) {
    final s = v.toStringAsFixed(0);
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return '${buf.toString()} COP';
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
          VentaSugerenciasProducto(
            items: sugerencias,
            money: _money,
            onSelect: onProductoSeleccionado,
          ),
        ],
        const SizedBox(height: 12),
        ...List.generate(items.length, (i) {
          final item = items[i];
          return VentaItemRow(
            item: item,
            money: _money,
            onIncrement: () => onIncrement(i),
            onDecrement: () => onDecrement(i),
            onCantidadChanged: (v) => onCantidadChanged?.call(i, v),
          );
        }),
      ],
    );
  }
}
