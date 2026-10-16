import 'package:flutter/material.dart';

import '../componentes/boton/app_button.dart';
import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/compartidos/form_dropdown.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';

class GenerarFacturaPage extends StatefulWidget {
  final double total;
  final String? clienteNombre;

  const GenerarFacturaPage({
    super.key,
    this.total = 81225,
    this.clienteNombre = 'Carlos Restrepo',
  });

  @override
  State<GenerarFacturaPage> createState() => _GenerarFacturaPageState();
}

class _GenerarFacturaPageState extends State<GenerarFacturaPage> {
  String _metodoPago = 'Efectivo';
  bool _isLoading = false;

  static const _metodos = ['Efectivo', 'Transferencia', 'Tarjeta', 'Crédito'];

  String _money(double v) {
    final s = v.toStringAsFixed(0);
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '\$${buf.toString()}';
  }

  void _generar() {
    // TODO: POST /facturas
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Factura generada (mock)'),
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
            const AppBarSimple(title: 'Generar Factura'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.large),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Resumen de venta',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _row('Cliente', widget.clienteNombre ?? '—'),
                          _row('Total a facturar', _money(widget.total),
                              highlight: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    FormDropdown(
                      label: 'Método de Pago',
                      value: _metodoPago,
                      options: _metodos,
                      onChanged: (v) => setState(() => _metodoPago = v),
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    AppButton(
                      text: 'Generar Factura',
                      type: AppButtonType.accent,
                      icon: Icons.receipt_long,
                      isLoading: _isLoading,
                      onPressed: _generar,
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

  Widget _row(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w800,
              color: highlight ? AppColors.accent : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
