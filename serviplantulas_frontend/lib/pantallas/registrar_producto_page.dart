import 'package:flutter/material.dart';

import '../componentes/boton/app_button.dart';
import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/compartidos/form_dropdown.dart';
import '../componentes/compartidos/qty_stepper.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';

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
                    _label('Nombre del Producto'),
                    _field(_nombreCtrl, 'Ej. Helecho Boston Maceta 10"'),
                    const SizedBox(height: AppSpacing.large),
                    FormDropdown(
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
                              _label('Precio de Compra'),
                              _field(
                                _precioCompraCtrl,
                                '\$0',
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
                              _label('Precio de Venta'),
                              _field(
                                _precioVentaCtrl,
                                '\$0',
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
                          child: FormDropdown(
                            label: 'Unidad de Medida',
                            value: _unidad,
                            options: _unidades,
                            onChanged: (v) => setState(() => _unidad = v),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Stock Inicial'),
                              QtyStepper(
                                value: _stockInicial,
                                onChanged: (v) =>
                                    setState(() => _stockInicial = v),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.large),
                    FormDropdown(
                      label: 'Proveedor',
                      value: _proveedor,
                      options: _proveedores,
                      onChanged: (v) => setState(() => _proveedor = v),
                    ),
                    const SizedBox(height: AppSpacing.large),
                    _label('Descripción'),
                    TextField(
                      controller: _descCtrl,
                      maxLines: 3,
                      style: AppTextStyles.bodyMedium,
                      decoration: _decoration('Descripción del producto...'),
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    AppButton(
                      text: 'Guardar Producto',
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

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          t,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Widget _field(
    TextEditingController ctrl,
    String hint, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      style: AppTextStyles.bodyMedium,
      decoration: _decoration(hint),
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }
}