import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/registrar_producto/widgets.dart';
import '../models/categoria.dart';
import '../models/proveedor.dart';
import '../services/productos_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_spacing.dart';

class RegistrarProductoPage extends StatefulWidget {
  const RegistrarProductoPage({super.key});

  @override
  State<RegistrarProductoPage> createState() => _RegistrarProductoPageState();
}

class _RegistrarProductoPageState extends State<RegistrarProductoPage> {
  final _service = ProductosService();
  final _nombreCtrl = TextEditingController();
  final _precioCompraCtrl = TextEditingController();
  final _precioVentaCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _stockMinimoCtrl = TextEditingController(text: '5');

  List<Categoria> _categorias = [];
  List<Proveedor> _proveedores = [];
  Categoria? _categoriaSel;
  Proveedor? _proveedorSel;
  int _stockInicial = 0;
  bool _loadingMeta = true;
  bool _isLoading = false;
  String? _errorMeta;

  @override
  void initState() {
    super.initState();
    _cargarMeta();
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _precioCompraCtrl.dispose();
    _precioVentaCtrl.dispose();
    _descCtrl.dispose();
    _stockMinimoCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarMeta() async {
    setState(() {
      _loadingMeta = true;
      _errorMeta = null;
    });
    try {
      final cats = await _service.listarCategorias();
      final provs = await _service.listarProveedores();
      if (!mounted) return;
      setState(() {
        _categorias = cats;
        _proveedores = provs;
        _categoriaSel = cats.isNotEmpty ? cats.first : null;
        _proveedorSel = provs.isNotEmpty ? provs.first : null;
        _loadingMeta = false;
      });
    } on ProductosException catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingMeta = false;
        _errorMeta = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingMeta = false;
        _errorMeta = 'No se pudieron cargar categorías/proveedores.';
      });
    }
  }

  Future<void> _guardar() async {
    final nombre = _nombreCtrl.text.trim();
    final precioVenta =
        double.tryParse(_precioVentaCtrl.text.replaceAll(',', '.')) ?? -1;
    final precioCompra = double.tryParse(
      _precioCompraCtrl.text.replaceAll(',', '.'),
    );
    final stockMin = int.tryParse(_stockMinimoCtrl.text.trim()) ?? 0;

    if (nombre.isEmpty) {
      _snack('El nombre es obligatorio', error: true);
      return;
    }
    if (precioVenta < 0) {
      _snack('Ingresa un precio de venta válido', error: true);
      return;
    }
    if (_categoriaSel == null) {
      _snack('Selecciona una categoría', error: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _service.crear(
        nombreProducto: nombre,
        descripcionProducto: _descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim(),
        precioProducto: precioVenta,
        costoCompra: precioCompra,
        stock: _stockInicial,
        stockMinimo: stockMin,
        idCategoria: _categoriaSel!.idCategoria,
        idProveedor: _proveedorSel?.idProveedor,
      );
      if (!mounted) return;
      _snack('Producto creado correctamente');
      Navigator.pop(context, true); // true = recargar inventario
    } on ProductosException catch (e) {
      if (!mounted) return;
      _snack(e.message, error: true);
    } catch (_) {
      if (!mounted) return;
      _snack('Error inesperado al guardar', error: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? AppColors.error : AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Registrar Producto'),
            Expanded(
              child: _loadingMeta
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMeta != null
                  ? _errorView()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductoCampoTexto(
                            label: 'Nombre del Producto',
                            controller: _nombreCtrl,
                            hint: 'Ej. Helecho Boston Maceta 10"',
                          ),
                          const SizedBox(height: AppSpacing.large),
                          ProductoDropdownField(
                            label: 'Categoría',
                            value: _categoriaSel?.nombreCategoria ?? '',
                            options: _categorias
                                .map((c) => c.nombreCategoria)
                                .toList(),
                            onChanged: (nombre) {
                              setState(() {
                                _categoriaSel = _categorias.firstWhere(
                                  (c) => c.nombreCategoria == nombre,
                                );
                              });
                            },
                          ),
                          const SizedBox(height: AppSpacing.large),
                          Row(
                            children: [
                              Expanded(
                                child: ProductoCampoTexto(
                                  label: 'Precio de Compra',
                                  controller: _precioCompraCtrl,
                                  hint: '0',
                                  keyboard: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ProductoCampoTexto(
                                  label: 'Precio de Venta',
                                  controller: _precioVentaCtrl,
                                  hint: '0',
                                  keyboard: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.large),
                          Row(
                            children: [
                              Expanded(
                                child: ProductoCampoTexto(
                                  label: 'Stock mínimo',
                                  controller: _stockMinimoCtrl,
                                  hint: '5',
                                  keyboard: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ProductoCampoStock(
                                  value: _stockInicial,
                                  onChanged: (v) =>
                                      setState(() => _stockInicial = v),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.large),
                          ProductoDropdownField(
                            label: 'Proveedor',
                            value:
                                _proveedorSel?.nombreProveedor ??
                                (_proveedores.isEmpty ? 'Sin proveedores' : ''),
                            options: _proveedores
                                .map((p) => p.nombreProveedor)
                                .toList(),
                            onChanged: (nombre) {
                              setState(() {
                                _proveedorSel = _proveedores.firstWhere(
                                  (p) => p.nombreProveedor == nombre,
                                );
                              });
                            },
                          ),
                          const SizedBox(height: AppSpacing.large),
                          ProductoCampoTexto(
                            label: 'Descripción',
                            controller: _descCtrl,
                            hint: 'Descripción del producto...',
                            maxLines: 3,
                          ),
                          const SizedBox(height: AppSpacing.extraLarge),
                          ProductoBotonGuardar(
                            isLoading: _isLoading,
                            onPressed: _guardar, // sin el ? null
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _errorMeta!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: _cargarMeta, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}
