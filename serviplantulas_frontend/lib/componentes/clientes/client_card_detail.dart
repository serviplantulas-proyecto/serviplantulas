import 'package:flutter/material.dart';

import '../../models/cliente.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

class ClientCardDetail extends StatelessWidget {
  final Cliente cliente;
  final VoidCallback? onVerDetalles;
  final VoidCallback? onEditar;

  const ClientCardDetail({
    super.key,
    required this.cliente,
    this.onVerDetalles,
    this.onEditar,
  });

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 12),
          Row(
            children: [
              _stat('TELÉFONO', cliente.telefono.isEmpty ? '—' : cliente.telefono),
              _stat(
                'TOTAL COMPRAS',
                cliente.totalPedidos > 0
                    ? '${cliente.totalPedidos} Compras'
                    : '—',
                valueColor: AppColors.success,
              ),
              _stat('ÚLTIMA COMPRA', cliente.ultimaCompra ?? '—'),
            ],
          ),
          if (cliente.historialReciente.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              'HISTORIAL RECIENTE',
              style: AppTextStyles.label.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            ...cliente.historialReciente.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '#${p.facturaId} · ${p.descripcion}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Text(
                      _money(p.total),
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: onVerDetalles,
                icon: const Icon(Icons.visibility_outlined, size: 16),
                label: const Text('Ver Detalles'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
              TextButton.icon(
                onPressed: onEditar,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Editar'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, {Color? valueColor}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.primary,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
