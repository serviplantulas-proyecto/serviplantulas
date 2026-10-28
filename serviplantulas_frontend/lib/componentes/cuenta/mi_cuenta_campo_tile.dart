import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

/// Campo expandible (correo / teléfono) → botón cambiar.
class MiCuentaCampoTile extends StatelessWidget {
  final String label;
  final String value;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onCambiar;
  final String botonTexto;
  final IconData icon;

  const MiCuentaCampoTile({
    super.key,
    required this.label,
    required this.value,
    required this.expanded,
    required this.onToggle,
    required this.onCambiar,
    required this.botonTexto,
    this.icon = Icons.edit_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: AppTextStyles.label.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                        Text(
                          value.isEmpty ? '—' : value,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: onCambiar,
                  icon: Icon(icon, size: 18),
                  label: Text(botonTexto),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
