import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/registrar_producto/widgets.dart';
import '../styles/app_colors.dart';
import '../styles/app_spacing.dart';

class RegistrarProductoPage extends StatefulWidget {
  const RegistrarProductoPage({super.key});

  @override
  State<RegistrarProductoPage> createState() => _RegistrarProductoPageState();
}

class _RegistrarProductoPageState extends State<RegistrarProductoPage> {
  final _nombreCtrl = TextEditingController();
  final _precioCompraCtrl = TextEditingController();
  final _precioVentaCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _categoria = 'Plantas';
  String _unidad = 'Unidad';
  String _proveedor = 'Nativo Verde S.A.';
  int _stockInicial = 0;
  bool _isLoading = false;

  static const _categorias = [
    'Plantas',
    'Flores',
    'Arbustos',
    'Frutales',
    'Suculentas',
    'Helechos',
  ];
  static const _unidades = ['Unidad', 'Bandeja', 'Caja', 'Kg'];
  static const _proveedores = [
    'Nativo Verde S.A.',
    'Floricultura del Valle',
    'Importaciones Verdes',
  ];

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _precioCompraCtrl.dispose();
    _precioVentaCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    // TODO: POST /productos
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto guardado (mock)'),
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
            const AppBarSimple(title: 'Registrar Producto'),
            Expanded(
              child: SingleChildScrollView(
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
                      value: _categoria,
                      options: _categorias,
                      onChanged: (v) => setState(() => _categoria = v),
                    ),
                    const SizedBox(height: AppSpacing.large),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProductoCampoTexto(
                                label: 'Precio de Compra',
                                controller: _precioCompraCtrl,
                                hint: '\$0',
                                keyboard: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProductoCampoTexto(
                                label: 'Precio de Venta',
                                controller: _precioVentaCtrl,
                                hint: '\$0',
                                keyboard: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.large),
                    Row(
                      children: [
                        Expanded(
                          child: ProductoDropdownField(
                            label: 'Unidad de Medida',
                            value: _unidad,
                            options: _unidades,
                            onChanged: (v) => setState(() => _unidad = v),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ProductoCampoStock(
                            value: _stockInicial,
                            onChanged: (v) => setState(() => _stockInicial = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.large),
                    ProductoDropdownField(
                      label: 'Proveedor',
                      value: _proveedor,
                      options: _proveedores,
                      onChanged: (v) => setState(() => _proveedor = v),
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
}
