import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/ventas/factura_list_card.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';

/// Resumen de venta / detalle de factura (Figma: generar-factura).
/// También se abre desde Historial al tocar una factura.
class GenerarFacturaPage extends StatefulWidget {
  final FacturaListItem? factura;

  const GenerarFacturaPage({
    super.key,
    this.factura,
  });

  @override
  State<GenerarFacturaPage> createState() => _GenerarFacturaPageState();
}

class _GenerarFacturaPageState extends State<GenerarFacturaPage> {
  String _metodoPago = 'Efectivo';
  bool _isLoading = false;

  static const _metodos = ['Efectivo', 'Transferencia', 'Tarjeta'];

  FacturaListItem get _f =>
      widget.factura ??
      const FacturaListItem(
        id: 'FAC-0000',
        cliente: 'Carlos Restrepo',
        documento: 'C.C. 1045230981',
        fecha: '08 Ago 2026 · 10:45 AM',
        unidades: 3,
        total: 64125,
        estado: 'Pendiente',
        vendedor: 'David',
        descuentoPct: 5,
        ivaPct: 19,
        lineas: [
          FacturaLinea(
            nombre: "Helecho Boston Maceta 10''",
            cantidad: 3,
            unitario: 22500,
          ),
        ],
      );

  double get _subtotal =>
      _f.lineas.fold(0.0, (s, l) => s + l.subtotal);

  double get _descuento => _subtotal * (_f.descuentoPct / 100);

  double get _base => _subtotal - _descuento;

  double get _iva => _base * (_f.ivaPct / 100);

  double get _total => _base + _iva;

  String _money(double v) {
    final s = v.toStringAsFixed(0);
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '\$${buf.toString()}';
  }

  void _enviarCorreo() {
    // TODO: POST /facturas/:id/enviar-correo
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Factura enviada por correo (mock)'),
          backgroundColor: AppColors.success,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final f = _f;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Resumen de Venta'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cliente + fecha
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  style: AppTextStyles.bodyMedium,
                                  children: [
                                    TextSpan(
                                      text: 'Cliente: ',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: f.cliente,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (f.documento != null)
                                Text(
                                  f.documento!,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          f.fecha,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Líneas de productos
                    ...f.lineas.map((l) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${l.cantidad}x ${l.nombre}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Text(
                                    'Unitario: ${_money(l.unitario)}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              _money(l.subtotal),
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    if (f.vendedor != null)
                      Text(
                        'Vendedor: ${f.vendedor}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    const SizedBox(height: 20),
                    // Método de pago (chips Figma)
                    Text(
                      'Método de Pago',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: _metodos.map((m) {
                        final selected = _metodoPago == m;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => setState(() => _metodoPago = m),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.mutedGreen
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.mutedGreen
                                      : AppColors.border,
                                ),
                              ),
                              child: Text(
                                m,
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: selected
                                      ? AppColors.surface
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),
                    // Totales
                    _totalRow('Subtotal', _money(_subtotal)),
                    if (f.descuentoPct > 0)
                      _totalRow(
                        'Descuento Cliente Frecuente (${f.descuentoPct.toStringAsFixed(0)}%)',
                        '-${_money(_descuento)}',
                      ),
                    _totalRow(
                      'IVA (${f.ivaPct.toStringAsFixed(0)}% Incluido)',
                      _money(_iva),
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total a Pagar',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          _money(_total),
                          style: AppTextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.accent,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    // Botón outline Figma
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _enviarCorreo,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.share_outlined, size: 18),
                        label: const Text('Enviar por Correo'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.medium),
                          ),
                          textStyle: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
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

  Widget _totalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
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
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
