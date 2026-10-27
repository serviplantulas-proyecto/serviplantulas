import 'package:flutter/material.dart';

import '../../services/notificaciones_service.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

class NotificacionTile extends StatelessWidget {
  final NotificacionItem item;
  final VoidCallback? onTap;

  const NotificacionTile({super.key, required this.item, this.onTap});

  (Color, IconData) get _estilo {
    final t = item.tipo.toLowerCase();
    if (t.contains('stock') || t.contains('poco') || t.contains('critico')) {
      return (const Color(0xFFE8A838), Icons.inventory_2_outlined);
    }
    if (t.contains('venta') || t.contains('pedido')) {
      return (AppColors.mutedGreen, Icons.shopping_cart_outlined);
    }
    if (t.contains('error') || t.contains('sincro')) {
      return (AppColors.error, Icons.error_outline);
    }
    if (t.contains('cliente')) {
      return (AppColors.info, Icons.person_outline);
    }
    return (AppColors.info, Icons.notifications_outlined);
  }

  String get _tiempo {
    final d = item.creadaEn;
    if (d == null) return '';
    final diff = DateTime.now().difference(d.toLocal());
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} hora${diff.inHours == 1 ? '' : 's'}';
    if (diff.inDays == 1) return 'Hace 1 día';
    return 'Hace ${diff.inDays} días';
  }

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _estilo;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.titulo,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.mensaje,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                  if (_tiempo.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      _tiempo,
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (!item.leida)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(left: 6, top: 4),
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
