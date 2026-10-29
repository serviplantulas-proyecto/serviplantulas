import 'dart:io';

import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/registrar_producto/producto_image_selector.dart';
import '../componentes/registrar_producto/widgets.dart';
import '../models/categoria.dart';
import '../models/producto.dart';
import '../models/proveedor.dart';
import '../services/productos_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_spacing.dart';

/// Crear o editar producto (incluye foto → Cloudinary vía backend).
class RegistrarProductoPage extends StatefulWidget {
  final Producto? producto;

  const RegistrarProductoPage({super.key, this.producto});

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
  File? _imagen;
  bool _ocultarImagenUrl = false;
  bool _loadingMeta = true;
  bool _isLoading = false;
  String? _errorMeta;

  bool get _esEdicion => widget.producto != null;

  @override
  void initState() {
    super.initState();
    final p = widget.producto;
    if (p != null) {
      _nombreCtrl.text = p.nombreProducto;
      _precioVentaCtrl.text = p.precioProducto.toStringAsFixed(0);
      if (p.costoCompra != null) {
        _precioCompraCtrl.text = p.costoCompra!.toStringAsFixed(0);
      }
      _descCtrl.text = p.descripcionProducto ?? '';
      _stockMinimoCtrl.text = p.stockMinimo.toString();
      _stockInicial = p.stock;
    }
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

      Categoria? catSel;
      Proveedor? provSel;
      final p = widget.producto;

      if (p?.idCategoria != null) {
        final match = cats.where((c) => c.idCategoria == p!.idCategoria);
        if (match.isNotEmpty) catSel = match.first;
      }
      catSel ??= cats.isNotEmpty ? cats.first : null;

      if (p?.idProveedor != null) {
        final match = provs.where((x) => x.idProveedor == p!.idProveedor);
        if (match.isNotEmpty) provSel = match.first;
      }
      provSel ??= provs.isNotEmpty ? provs.first : null;

      setState(() {
        _categorias = cats;
        _proveedores = provs;
        _categoriaSel = catSel;
        _proveedorSel = provSel;
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
      if (_esEdicion) {
        final campos = <String, String>{
          'nombre_producto': nombre,
          'precio_producto': precioVenta.toString(),
          'stock': _stockInicial.toString(),
          'stock_minimo': stockMin.toString(),
          'id_categoria': _categoriaSel!.idCategoria.toString(),
        };
        if (precioCompra != null) {
          campos['costo_compra'] = precioCompra.toString();
        }
        if (_descCtrl.text.trim().isNotEmpty) {
          campos['descripcion_producto'] = _descCtrl.text.trim();
        }
        if (_proveedorSel != null) {
          campos['id_proveedor'] = _proveedorSel!.idProveedor.toString();
        }

        await _service.actualizar(
          id: widget.producto!.idProducto,
          campos: campos,
          imagen: _imagen,
        );
        if (!mounted) return;
        _snack('Producto actualizado');
      } else {
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
          imagen: _imagen,
        );
        if (!mounted) return;
        _snack('Producto creado correctamente');
      }
      Navigator.pop(context, true);
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
            AppBarSimple(
              title: _esEdicion ? 'Editar Producto' : 'Registrar Producto',
            ),
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
                          ProductoImageSelector(
                            imagen: _imagen,
                            imagenUrl: _ocultarImagenUrl
                                ? null
                                : widget.producto?.imagenUrl,
                            habilitado: !_isLoading,
                            onImagenSeleccionada: (file) {
                              setState(() {
                                _imagen = file;
                                _ocultarImagenUrl = false;
                              });
                            },
                            onQuitar: () {
                              setState(() {
                                _imagen = null;
                                _ocultarImagenUrl = true;
                              });
                            },
                          ),
                          const SizedBox(height: AppSpacing.large),
                          ProductoCampoTexto(
                            label: 'Nombre del Producto',
                            controller: _nombreCtrl,
                            hint: 'Ej. Helecho Boston Maceta 10"',
                          ),
                          const SizedBox(height: AppSpacing.large),
                          if (_categorias.isNotEmpty)
                            ProductoDropdownField(
                              label: 'Categoría',
                              value:
                                  _categoriaSel?.nombreCategoria ??
                                  _categorias.first.nombreCategoria,
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
                          if (_proveedores.isNotEmpty)
                            ProductoDropdownField(
                              label: 'Proveedor',
                              value:
                                  _proveedorSel?.nombreProveedor ??
                                  _proveedores.first.nombreProveedor,
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
                            onPressed: _guardar,
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
