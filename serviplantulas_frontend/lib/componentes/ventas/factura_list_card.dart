import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

class FacturaListItem {
  final String id;
  final String cliente;
  final String fecha;
  final int unidades;
  final double total;
  final String estado;
  final String? documento;
  final String? vendedor;
  final String metodoPago;
  final List<FacturaLinea> lineas;
  final double descuentoPct;
  final double ivaPct;

  const FacturaListItem({
    required this.id,
    required this.cliente,
    required this.fecha,
    required this.unidades,
    required this.total,
    required this.estado,
    this.documento,
    this.vendedor,
    this.metodoPago = 'Efectivo',
    this.lineas = const [],
    this.descuentoPct = 0,
    this.ivaPct = 19,
  });

  bool get isPagada => estado == 'Pagada';
}

class FacturaLinea {
  final String nombre;
  final int cantidad;
  final double unitario;

  const FacturaLinea({
    required this.nombre,
    required this.cantidad,
    required this.unitario,
  });

  double get subtotal => cantidad * unitario;
}

class FacturaListCard extends StatelessWidget {
  final FacturaListItem factura;
  final VoidCallback? onTap;

  const FacturaListCard({super.key, required this.factura, this.onTap});

  String _money(double v) {
    final s = v.toStringAsFixed(0);
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return '${buf.toString()} COP';
  }

  /// "Transferencia" → "Trans...", "Efectivo" → "Efec..." si hace falta espacio.
  String _metodoCorto(String m) {
    final t = m.trim();
    if (t.length <= 5) return t;
    return '${t.substring(0, 4)}…';
  }

  @override
  Widget build(BuildContext context) {
    final pagada = factura.isPagada;
    final metodo = _metodoCorto(factura.metodoPago);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Factura #${factura.id}',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: pagada
                        ? AppColors.successBackground
                        : AppColors.warningBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    factura.estado,
                    style: AppTextStyles.label.copyWith(
                      fontWeight: FontWeight.w700,
                      color: pagada ? AppColors.success : AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              factura.cliente,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${factura.fecha} · ${factura.unidades} Unid. · $metodo',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _money(factura.total),
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
