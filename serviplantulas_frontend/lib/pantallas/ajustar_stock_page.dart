import 'package:flutter/material.dart';

import '../componentes/boton/app_button.dart';
import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/compartidos/form_dropdown.dart';
import '../componentes/compartidos/qty_stepper.dart';
import '../componentes/stock/stock_product_banner.dart';
import '../models/producto.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';

class AjustarStockPage extends StatefulWidget {
  final Producto? producto;

  const AjustarStockPage({super.key, this.producto});

  @override
  State<AjustarStockPage> createState() => _AjustarStockPageState();
}

class _AjustarStockPageState extends State<AjustarStockPage> {
  late final Producto _producto;
  String _tipoAjuste = 'Ingreso (Suma al stock)';
  String _motivo = 'Compra';
  int _cantidad = 10;
  final _notaCtrl = TextEditingController(
    text: 'Ingreso por compra directa a Nativo Verde',
  );
  bool _isLoading = false;

  static const _tipos = [
    'Ingreso (Suma al stock)',
    'Salida (Resta del stock)',
    'Ajuste manual',
  ];
  static const _motivos = [
    'Compra', 'Venta', 'Merma', 'Devolución', 'Inventario físico',
  ];

  @override
  void initState() {
    super.initState();
    _producto = widget.producto ??
        const Producto(
          id: 'CC-9081',
          nombre: "Helecho Boston Maceta 10''",
          categoria: 'Plantas',
          proveedor: 'Nativo Verde S.A.',
          precio: 22500,
          stock: 45,
        );
  }

  @override
  void dispose() {
    _notaCtrl.dispose();
    super.dispose();
  }

  int get _nuevoStock {
    if (_tipoAjuste.startsWith('Ingreso')) return _producto.stock + _cantidad;
    if (_tipoAjuste.startsWith('Salida')) {
      return (_producto.stock - _cantidad).clamp(0, 999999);
    }
    return _cantidad;
  }

  void _confirmar() {
    // TODO: POST /inventario/ajuste
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stock ajustado (mock)'),
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
            const AppBarSimple(title: 'Ajustar Stock'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StockProductBanner(producto: _producto),
                    const SizedBox(height: AppSpacing.extraLarge),
                    FormDropdown(
                      label: 'Tipo de Ajuste',
                      value: _tipoAjuste,
                      options: _tipos,
                      onChanged: (v) => setState(() => _tipoAjuste = v),
                    ),
                    const SizedBox(height: AppSpacing.large),
                    Text(
                      'Cantidad a Ajustar',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    QtyStepper(
                      value: _cantidad,
                      onChanged: (v) => setState(() => _cantidad = v),
                      min: 1,
                    ),
                    const SizedBox(height: AppSpacing.large),
                    FormDropdown(
                      label: 'Motivo del Ajuste',
                      value: _motivo,
                      options: _motivos,
                      onChanged: (v) => setState(() => _motivo = v),
                    ),
                    const SizedBox(height: AppSpacing.large),
                    Text(
                      'Nota / Observación (Opcional)',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _notaCtrl,
                      maxLines: 2,
                      style: AppTextStyles.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Observación del ajuste...',
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    StockPreview(
                      stockActual: _producto.stock,
                      stockNuevo: _nuevoStock,
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    AppButton(
                      text: 'Confirmar Ajuste',
                      isLoading: _isLoading,
                      onPressed: _confirmar,
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
