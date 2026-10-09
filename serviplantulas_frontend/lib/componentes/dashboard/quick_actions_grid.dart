import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';
import 'quick_action_button.dart';

class QuickActionsGrid extends StatelessWidget {
  final VoidCallback? onNuevaVenta;
  final VoidCallback? onNuevoProducto;
  final VoidCallback? onVerInventario;
  final VoidCallback? onChatBot;
  final VoidCallback? onAnalisis;
  final VoidCallback? onHistorial;

  const QuickActionsGrid({
    super.key,
    this.onNuevaVenta,
    this.onNuevoProducto,
    this.onVerInventario,
    this.onChatBot,
    this.onAnalisis,
    this.onHistorial,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Rápidas',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            QuickActionButton(
              icon: Icons.shopping_cart_outlined,
              label: 'Nueva Venta',
              iconColor: AppColors.accent,
              onTap: onNuevaVenta,
            ),
            const SizedBox(width: 12),
            QuickActionButton(
              icon: Icons.add_box_outlined,
              label: 'Nuevo Producto',
              onTap: onNuevoProducto,
            ),
            const SizedBox(width: 12),
            QuickActionButton(
              icon: Icons.grid_view,
              label: 'Ver Inventario',
              onTap: onVerInventario,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            QuickActionButton(
              icon: Icons.support_agent,
              label: 'Chat Bot',
              iconColor: AppColors.info,
              onTap: onChatBot,
            ),
            const SizedBox(width: 12),
            QuickActionButton(
              icon: Icons.bar_chart,
              label: 'Analisis de venta',
              onTap: onAnalisis,
            ),
            const SizedBox(width: 12),
            QuickActionButton(
              icon: Icons.receipt_long_outlined,
              label: 'Historial pedidos',
              onTap: onHistorial,
            ),
          ],
        ),
      ],
    );
  }
}
