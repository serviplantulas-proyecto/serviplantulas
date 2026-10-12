import 'package:flutter/material.dart';

import '../../models/cliente.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

class VentaClienteSection extends StatelessWidget {
  final Cliente? cliente;
  final VoidCallback? onNuevoCliente;
  final VoidCallback? onBuscarCliente;

  const VentaClienteSection({
    super.key,
    this.cliente,
    this.onNuevoCliente,
    this.onBuscarCliente,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1. Datos del Cliente',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            TextButton.icon(
              onPressed: onNuevoCliente,
              icon: const Icon(Icons.person_add, size: 16),
              label: const Text('Nuevo Cliente'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accent,
                textStyle: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (cliente != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.editBackground,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cliente!.nombre,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'cel: ${cliente!.telefono ?? "—"}'
                        '${cliente!.descuentoFrecuente > 0 ? " · Descuento Frecuente (${cliente!.descuentoFrecuente.toStringAsFixed(0)}%)" : ""}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle, color: AppColors.success),
              ],
            ),
          )
        else
          GestureDetector(
            onTap: onBuscarCliente,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 18, color: AppColors.textMuted),
                  const SizedBox(width: 10),
                  Text(
                    'Buscar cliente por documento o nombre...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
