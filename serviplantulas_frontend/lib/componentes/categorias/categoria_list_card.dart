import 'package:flutter/material.dart';

import '../../models/categoria.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

/// Card de categoría al estilo Figma (lista horizontal + editar/eliminar).
class CategoriaListCard extends StatelessWidget {
  final Categoria categoria;
  final int productosCount;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const CategoriaListCard({
    super.key,
    required this.categoria,
    this.productosCount = 0,
    required this.iconBg,
    required this.iconColor,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: InkWell(
        onTap: onTap ?? onEdit,
        borderRadius: BorderRadius.circular(AppRadius.large),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.grid_view_rounded, size: 22, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      categoria.nombreCategoria,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$productosCount productos registrados',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              _iconBtn(
                icon: Icons.edit_outlined,
                color: AppColors.primary,
                bg: AppColors.editBackground,
                onTap: onEdit,
              ),
              const SizedBox(width: 8),
              _iconBtn(
                icon: Icons.delete_outline,
                color: AppColors.error,
                bg: const Color(0xFFFFE8E6),
                onTap: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconBtn({
    required IconData icon,
    required Color color,
    required Color bg,
    VoidCallback? onTap,
  }) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}

/// Paleta pastel para iconos (como en Figma).
class CategoriaIconPalette {
  static const List<(Color bg, Color fg)> pairs = [
    (Color(0xFFFFF3D6), Color(0xFFC9A227)), // amarillo
    (Color(0xFFE3EEFF), Color(0xFF5B8DEF)), // azul
    (Color(0xFFE5F5E9), Color(0xFF5BAF6A)), // verde
    (Color(0xFFFFE8EF), Color(0xFFE06B8A)), // rosa
    (Color(0xFFF0E8FF), Color(0xFF8B6BC9)), // lila
    (Color(0xFFFFE8D6), Color(0xFFD4834A)), // naranja
  ];

  static (Color, Color) forIndex(int i) => pairs[i % pairs.length];
}
