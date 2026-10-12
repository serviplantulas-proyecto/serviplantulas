import 'package:flutter/material.dart';

import '../componentes/boton/app_button.dart';
import '../componentes/ventas/venta_cliente_section.dart';
import '../componentes/ventas/venta_productos_section.dart';
import '../componentes/ventas/venta_totales.dart';
import '../models/cliente.dart';
import '../models/producto.dart';
import '../styles/app_colors.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';

class RegistroVentaPage extends StatefulWidget {
  const RegistroVentaPage({super.key});

  @override
  State<RegistroVentaPage> createState() => _RegistroVentaPageState();
}

class _RegistroVentaPageState extends State<RegistroVentaPage> {
  // Mock — reemplazar con datos del backend
  Cliente? _cliente = const Cliente(
    id: 'C001',
    nombre: 'Carlos Restrepo',
    documento: '1045230981',
    tipoDocumento: 'C.C.',
    telefono: '+57 312 450 9081',
    descuentoFrecuente: 5,
  );

  final List<ItemVenta> _items = [
    ItemVenta(
      producto: const Producto(
        id: 'P001',
        nombre: "Helecho Boston Maceta 10''",
        categoria: 'Helechos',
        proveedor: 'Nativo Verde S.A.',
        precio: 22500,
        stock: 124,
      ),
      cantidad: 3,
    ),
    ItemVenta(
      producto: const Producto(
        id: 'P002',
        nombre: 'Cuna de Moisés (Spathiphyllum)',
        categoria: 'Sombra',
        proveedor: 'Floricultura del Valle',
        precio: 18000,
        stock: 82,
      ),
      cantidad: 1,
    ),
  ];

  bool _isLoading = false;

  double get _subtotal =>
      _items.fold(0.0, (s, i) => s + i.subtotal);

  double get _descuento =>
      _subtotal * ((_cliente?.descuentoFrecuente ?? 0) / 100);

  double get _total => _subtotal - _descuento;

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
    // TODO: POST /ventas al backend
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
                      onNuevoCliente: () {
                        // TODO: navegar a agregar-cliente
                      },
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    VentaProductosSection(
                      items: _items,
                      onIncrement: (i) => _cambiarCantidad(i, 1),
                      onDecrement: (i) => _cambiarCantidad(i, -1),
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    VentaTotales(
                      subtotal: _subtotal,
                      descuento: _descuento,
                      total: _total,
                      porcentajeDescuento:
                          _cliente?.descuentoFrecuente ?? 0,
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    AppButton(
                      text: 'Registrar Venta',
                      type: AppButtonType.accent,
                      icon: Icons.check,
                      isLoading: _isLoading,
                      onPressed:
                          _items.isEmpty ? null : _registrarVenta,
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
