import 'dart:io';

import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../models/categoria.dart';
import '../models/producto.dart';
import '../models/proveedor.dart';
import '../services/productos_service.dart';
import '../styles/app_colors.dart';
import '../componentes/registrar_producto/registrar_producto_error.dart';
import '../componentes/registrar_producto/registrar_producto_form.dart';
import '../componentes/registrar_producto/registrar_producto_save.dart';

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
  bool _ocultarImagenUrl = false, _loadingMeta = true, _isLoading = false;
  String? _errorMeta;

  bool get _esEdicion => widget.producto != null;

  @override
  void initState() {
    super.initState();
    aplicarProductoEnFormulario(
      producto: widget.producto,
      nombreCtrl: _nombreCtrl,
      precioVentaCtrl: _precioVentaCtrl,
      precioCompraCtrl: _precioCompraCtrl,
      descCtrl: _descCtrl,
      stockMinimoCtrl: _stockMinimoCtrl,
      setStock: (v) => _stockInicial = v,
    );
    _cargarMeta();
  }

  @override
  void dispose() {
    for (final c in [_nombreCtrl, _precioCompraCtrl, _precioVentaCtrl, _descCtrl, _stockMinimoCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _cargarMeta() async {
    setState(() { _loadingMeta = true; _errorMeta = null; });
    try {
      final cats = await _service.listarCategorias();
      final provs = await _service.listarProveedores();
      if (!mounted) return;
      final p = widget.producto;
      final sel = resolverSeleccionesProducto(
        categorias: cats,
        proveedores: provs,
        idCategoria: p?.idCategoria,
        idProveedor: p?.idProveedor,
      );
      setState(() {
        _categorias = cats; _proveedores = provs;
        _categoriaSel = sel.categoria; _proveedorSel = sel.proveedor;
        _loadingMeta = false;
      });
    } on ProductosException catch (e) {
      if (!mounted) return;
      setState(() { _loadingMeta = false; _errorMeta = e.message; });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingMeta = false;
        _errorMeta = 'No se pudieron cargar categorías/proveedores.';
      });
    }
  }

  Future<void> _guardar() async {
    final data = parseRegistrarProductoForm(
      nombre: _nombreCtrl.text,
      precioVentaText: _precioVentaCtrl.text,
      precioCompraText: _precioCompraCtrl.text,
      stockMinText: _stockMinimoCtrl.text,
      categoriaSel: _categoriaSel,
    );
    if (data.error != null) {
      _snack(data.error!, error: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ejecutarGuardarProducto(
        service: _service,
        esEdicion: _esEdicion,
        idProducto: widget.producto?.idProducto,
        data: data,
        stockInicial: _stockInicial,
        categoriaSel: _categoriaSel!,
        proveedorSel: _proveedorSel,
        descripcion: _descCtrl.text,
        imagen: _imagen,
      );
      if (!mounted) return;
      _snack(_esEdicion ? 'Producto actualizado' : 'Producto creado correctamente');
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? AppColors.error : AppColors.success,
    ));
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
                      ? RegistrarProductoError(
                          mensaje: _errorMeta!,
                          onRetry: _cargarMeta,
                        )
                      : RegistrarProductoForm(
                          imagen: _imagen,
                          imagenUrl: widget.producto?.imagenUrl,
                          ocultarImagenUrl: _ocultarImagenUrl,
                          isLoading: _isLoading,
                          nombreCtrl: _nombreCtrl,
                          precioCompraCtrl: _precioCompraCtrl,
                          precioVentaCtrl: _precioVentaCtrl,
                          descCtrl: _descCtrl,
                          stockMinimoCtrl: _stockMinimoCtrl,
                          stockInicial: _stockInicial,
                          onStockChanged: (v) =>
                              setState(() => _stockInicial = v),
                          categorias: _categorias,
                          proveedores: _proveedores,
                          categoriaSel: _categoriaSel,
                          proveedorSel: _proveedorSel,
                          onCategoriaChanged: (c) =>
                              setState(() => _categoriaSel = c),
                          onProveedorChanged: (p) =>
                              setState(() => _proveedorSel = p),
                          onImagenSeleccionada: (file) => setState(() {
                            _imagen = file;
                            _ocultarImagenUrl = false;
                          }),
                          onQuitarImagen: () => setState(() {
                            _imagen = null;
                            _ocultarImagenUrl = true;
                          }),
                          onGuardar: _guardar,
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
