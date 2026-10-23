import 'package:flutter/material.dart';

import '../componentes/boton/app_button.dart';
import '../componentes/ventas/venta_cliente_section.dart';
import '../componentes/ventas/venta_productos_section.dart';
import '../componentes/ventas/venta_totales.dart';
import '../models/cliente.dart';
import '../models/producto.dart';
import 'agregar_cliente_page.dart';
import '../styles/app_colors.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';

class RegistroVentaPage extends StatefulWidget {
  const RegistroVentaPage({super.key});

  @override
  State<RegistroVentaPage> createState() => _RegistroVentaPageState();
}

class _RegistroVentaPageState extends State<RegistroVentaPage> {
  final _clienteSearchCtrl = TextEditingController();
  final _productoSearchCtrl = TextEditingController();

  // Mock clientes — más adelante GET /clientes
    static const _clientesMock = [
    Cliente(
      idCliente: 1,
      nombreCliente: 'Carlos Restrepo',
      cedulaCliente: '1045230981',
      telefonoCliente: '+57 312 450 9081',
      descuentoFrecuente: 5,
    ),
    Cliente(
      idCliente: 2,
      nombreCliente: 'María López',
      cedulaCliente: '52987654',
      telefonoCliente: '+57 300 111 2233',
      descuentoFrecuente: 0,
    ),
  ];

  // Mock productos con el constructor nuevo (campos del backend)
  static const _productosMock = [
    Producto(
      idProducto: 1,
      nombreProducto: "Helecho Boston Maceta 10''",
      precioProducto: 22500,
      stock: 124,
      stockMinimo: 10,
      nombreCategoria: 'Helechos',
      nombreProveedor: 'Nativo Verde S.A.',
    ),
    Producto(
      idProducto: 2,
      nombreProducto: 'Cuna de Moisés (Spathiphyllum)',
      precioProducto: 18000,
      stock: 82,
      stockMinimo: 10,
      nombreCategoria: 'Sombra',
      nombreProveedor: 'Floricultura del Valle',
    ),
    Producto(
      idProducto: 3,
      nombreProducto: 'Anturio Rojo Maceta 6"',
      precioProducto: 15000,
      stock: 56,
      stockMinimo: 5,
      nombreCategoria: 'Florales',
      nombreProveedor: 'Nativo Verde S.A.',
    ),
  ];

  Cliente? _cliente;
  List<Cliente> _sugerenciasCliente = [];
  List<Producto> _sugerenciasProducto = [];
  final List<ItemVenta> _items = [];
  bool _isLoading = false;

  double get _subtotal => _items.fold(0.0, (s, i) => s + i.subtotal);
  double get _descuento =>
      _subtotal * ((_cliente?.descuentoFrecuente ?? 0) / 100);
  double get _total => _subtotal - _descuento;

  @override
  void dispose() {
    _clienteSearchCtrl.dispose();
    _productoSearchCtrl.dispose();
    super.dispose();
  }

  void _onClienteSearch(String q) {
    final query = q.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _sugerenciasCliente = [];
      } else {
        // TODO: GET /clientes?q=...
        _sugerenciasCliente = _clientesMock
            .where(
              (c) =>
                  c.nombre.toLowerCase().contains(query) ||
                  c.documento.contains(query),
            )
            .toList();
      }
    });
  }

  void _seleccionarCliente(Cliente c) {
    setState(() {
      _cliente = c;
      _clienteSearchCtrl.text =
          '${c.tipoDocumento} ${c.documento} - ${c.nombre}';
      _sugerenciasCliente = [];
    });
  }

  void _onProductoSearch(String q) {
    final query = q.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _sugerenciasProducto = [];
      } else {
        // TODO: GET /productos/productos (ProductosService.listar)
        _sugerenciasProducto = _productosMock
            .where((p) => p.nombre.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _seleccionarProducto(Producto p) {
    setState(() {
      final idx = _items.indexWhere((i) => i.producto.id == p.id);
      if (idx >= 0) {
        _items[idx] = _items[idx].copyWith(cantidad: _items[idx].cantidad + 1);
      } else {
        _items.add(ItemVenta(producto: p, cantidad: 1));
      }
      _productoSearchCtrl.clear();
      _sugerenciasProducto = [];
    });
  }

  void _cambiarCantidad(int index, int delta) {
    setState(() {
      final nueva = _items[index].cantidad + delta;
      if (nueva <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(cantidad: nueva);
      }
    });
  }

  void _registrarVenta() {
    if (_cliente == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona un cliente'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    // TODO: POST /pedidos al backend
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Venta registrada (mock)'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VentaClienteSection(
                      cliente: _cliente,
                      searchController: _clienteSearchCtrl,
                      sugerencias: _sugerenciasCliente,
                      onNuevoCliente: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AgregarClientePage(),
                          ),
                        );
                      },
                      onSearchChanged: _onClienteSearch,
                      onClienteSeleccionado: _seleccionarCliente,
                      onClearSearch: () {
                        setState(() {
                          _clienteSearchCtrl.clear();
                          _sugerenciasCliente = [];
                          _cliente = null;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    VentaProductosSection(
                      items: _items,
                      searchController: _productoSearchCtrl,
                      sugerencias: _sugerenciasProducto,
                      onIncrement: (i) => _cambiarCantidad(i, 1),
                      onDecrement: (i) => _cambiarCantidad(i, -1),
                      onSearchChanged: _onProductoSearch,
                      onProductoSeleccionado: _seleccionarProducto,
                      onClearSearch: () {
                        setState(() {
                          _productoSearchCtrl.clear();
                          _sugerenciasProducto = [];
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    VentaTotales(
                      subtotal: _subtotal,
                      descuento: _descuento,
                      total: _total,
                      porcentajeDescuento: _cliente?.descuentoFrecuente ?? 0,
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    AppButton(
                      text: 'Registrar Venta',
                      type: AppButtonType.accent,
                      icon: Icons.check,
                      isLoading: _isLoading,
                      onPressed: _items.isEmpty ? null : _registrarVenta,
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

  Widget _buildAppBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          ),
          Text(
            'Nueva Venta',
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
