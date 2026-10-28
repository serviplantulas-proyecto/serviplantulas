import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';
import 'factura_list_card.dart';
import 'venta_metodo_pago.dart';

class FacturaResumenBody extends StatelessWidget {
  final FacturaListItem factura;

  const FacturaResumenBody({super.key, required this.factura});

  String _money(double v) {
    final s = v.toStringAsFixed(0);
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return '${buf.toString()} COP';
  }

  @override
  Widget build(BuildContext context) {
    final f = factura;
    final subtotal = f.lineas.fold(0.0, (s, l) => s + l.subtotal);
    final descuento = subtotal * (f.descuentoPct / 100);
    final base = subtotal - descuento;
    final iva = base * (f.ivaPct / 100);
    final total = base + iva;
    final metodo = f.metodoPago.isEmpty ? 'Efectivo' : f.metodoPago;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(TextSpan(
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
                  )),
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
        ...f.lineas.map((l) => Padding(
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
            )),
        const SizedBox(height: 12),
        VentaMetodoPago(
          value: metodo,
          enabled: false,
          metodos: const ['Efectivo', 'Transferencia'],
        ),
        const SizedBox(height: 28),
        _row('Subtotal', _money(subtotal)),
        if (f.descuentoPct > 0)
          _row(
            'Descuento (${f.descuentoPct.toStringAsFixed(0)}%)',
            '-${_money(descuento)}',
          ),
        _row('IVA (${f.ivaPct.toStringAsFixed(0)}% Incluido)', _money(iva)),
        const Divider(color: AppColors.border),
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
              _money(total),
              style: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.accent,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _row(String label, String value) {
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
