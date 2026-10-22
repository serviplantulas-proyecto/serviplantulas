import 'package:flutter/material.dart';

import '../../models/proveedor.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';
import 'proveedor_card_detail.dart';

/// Card expandible de proveedor (estilo Figma).
class ProveedorExpandableCard extends StatelessWidget {
  final Proveedor proveedor;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback? onEdit;

  const ProveedorExpandableCard({
    super.key,
    required this.proveedor,
    required this.expanded,
    required this.onToggle,
    this.onEdit,
  });

  String get _subtitulo {
    final dir = proveedor.direccionProveedor?.trim();
    if (dir != null && dir.isNotEmpty) return dir;
    final tel = proveedor.telefonoProveedor?.trim();
    if (tel != null && tel.isNotEmpty) return tel;
    return 'Sin NIT / dirección';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(AppRadius.large),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          proveedor.nombreProveedor,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _subtitulo,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            ProveedorCardDetail(proveedor: proveedor, onEdit: onEdit),
        ],
      ),
    );
  }
}
