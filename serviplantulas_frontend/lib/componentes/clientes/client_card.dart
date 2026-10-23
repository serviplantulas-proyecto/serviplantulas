import 'package:flutter/material.dart';

import '../../models/cliente.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';
import 'client_card_detail.dart';

class ClientCard extends StatelessWidget {
  final Cliente cliente;
  final bool expandido;
  final VoidCallback? onToggle;
  final VoidCallback? onEditar;
  final VoidCallback? onVerDetalles;

  const ClientCard({
    super.key,
    required this.cliente,
    this.expandido = false,
    this.onToggle,
    this.onEditar,
    this.onVerDetalles,
  });

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
                          cliente.nombre,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${cliente.tipoDocumento} ${cliente.documento}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    expandido
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          if (expandido)
            ClientCardDetail(
              cliente: cliente,
              onVerDetalles: onVerDetalles,
              onEditar: onEditar,
            ),
        ],
      ),
    );
  }
}
