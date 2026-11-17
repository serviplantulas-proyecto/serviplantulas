import 'package:flutter/material.dart';

import '../componentes/inventario/inventario_app_bar.dart';
import '../componentes/inventario/inventario_body.dart';
import '../componentes/inventario/inventario_search_section.dart';
import '../models/producto.dart';
import '../services/inventario_service.dart';
import '../services/productos_service.dart';
import '../styles/app_colors.dart';
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
  String? _error;

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
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final cats = await _service.obtenerCategorias();
      final prods = await _service.obtenerProductos(
        busqueda: _searchController.text,
        categoria: _categoriaSel,
      );
      if (!mounted) return;
      setState(() {
        _categorias = cats;
        _productos = prods;
        _loading = false;
      });
    } on ProductosException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'No se pudo cargar el inventario.';
      });
    }
  }

  Future<void> _filtrar() async {
    try {
      final prods = await _service.obtenerProductos(
        busqueda: _searchController.text,
        categoria: _categoriaSel,
      );
      if (mounted) setState(() => _productos = prods);
    } catch (_) {
      // silencioso en filtro; el usuario puede pull-to-refresh
    }
  }

  Future<void> _abrirRegistrar() async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const RegistrarProductoPage()),
    );
    if (ok == true) _cargar();
  }

  Future<void> _abrirAjustar(Producto p) async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AjustarStockPage(producto: p)),
    );
    if (ok == true) _cargar();
  }

  void _abrirDetalle(Producto p) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetalleProductoPage(producto: p)),
    ).then((_) => _cargar());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const InventarioAppBar(),
            InventarioSearchSection(
              searchController: _searchController,
              categorias: _categorias,
              seleccionada: _categoriaSel,
              onCategoriaSelected: (cat) {
                setState(() => _categoriaSel = cat);
                _filtrar();
              },
              onSearchChanged: () => _filtrar(),
            ),
            Expanded(
              child: InventarioBody(
                loading: _loading,
                error: _error,
                productos: _productos,
                onRefresh: _cargar,
                onRetry: _cargar,
                onAjustarStock: _abrirAjustar,
                onOpenDetalle: _abrirDetalle,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirRegistrar,
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
