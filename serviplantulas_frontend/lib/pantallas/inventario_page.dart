import 'package:flutter/material.dart';

import '../componentes/inventario/category_chips.dart';
import '../componentes/inventario/inventory_product_card.dart';
import '../componentes/inventario/inventory_search_bar.dart';
import '../models/producto.dart';
import '../services/inventario_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import 'ajustar_stock_page.dart';
import 'detalle_producto_page.dart';
import 'registrar_producto_page.dart';

class InventarioPage extends StatefulWidget {
  const InventarioPage({super.key});

  @override
  State<InventarioPage> createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  final InventarioService _service = InventarioService();
  final TextEditingController _searchController = TextEditingController();

  List<Producto> _productos = [];
  List<String> _categorias = ['Todos'];
  String _categoriaSel = 'Todos';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    setState(() => _loading = true);
    final cats = await _service.obtenerCategorias();
    final prods = await _service.obtenerProductos(
      busqueda: _searchController.text,
      categoria: _categoriaSel,
    );
    if (mounted) {
      setState(() {
        _categorias = cats;
        _productos = prods;
        _loading = false;
      });
    }
  }

  Future<void> _filtrar() async {
    final prods = await _service.obtenerProductos(
      busqueda: _searchController.text,
      categoria: _categoriaSel,
    );
    if (mounted) setState(() => _productos = prods);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildAppBar(),
            _buildSearchSection(),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _cargar,
                      color: AppColors.primary,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                        itemCount: _productos.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final p = _productos[index];
                          return InventoryProductCard(
                            producto: p,
                            onAjustarStock: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AjustarStockPage(producto: p),
                                ),
                              );
                            },
                            onEditar: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetalleProductoPage(producto: p),
                                ),
                              );
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetalleProductoPage(producto: p),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegistrarProductoPage()),
          );
        },
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Inventario Serviplantulas',
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              fontSize: 18,
            ),
          ),
          const Icon(Icons.grid_view, color: AppColors.primary, size: 24),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        children: [
          InventorySearchBar(
            controller: _searchController,
            onChanged: (_) => _filtrar(),
            onFilterTap: () {
              // TODO: modal de filtros avanzados
            },
          ),
          const SizedBox(height: 12),
          CategoryChips(
            categorias: _categorias,
            seleccionada: _categoriaSel,
            onSelected: (cat) {
              setState(() => _categoriaSel = cat);
              _filtrar();
            },
          ),
        ],
      ),
    );
  }
}
