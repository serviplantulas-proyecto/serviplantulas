import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import 'category_chips.dart';
import 'inventory_search_bar.dart';

/// Barra de búsqueda + chips de categoría del inventario.
class InventarioSearchSection extends StatelessWidget {
  final TextEditingController searchController;
  final List<String> categorias;
  final String seleccionada;
  final ValueChanged<String> onCategoriaSelected;
  final VoidCallback onSearchChanged;

  const InventarioSearchSection({
    super.key,
    required this.searchController,
    required this.categorias,
    required this.seleccionada,
    required this.onCategoriaSelected,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        children: [
          InventorySearchBar(
            controller: searchController,
            onChanged: (_) => onSearchChanged(),
          ),
          const SizedBox(height: 12),
          CategoryChips(
            categorias: categorias,
            seleccionada: seleccionada,
            onSelected: onCategoriaSelected,
          ),
        ],
      ),
    );
  }
}
