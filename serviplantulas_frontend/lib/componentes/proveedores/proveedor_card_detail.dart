import 'package:flutter/material.dart';

import '../../models/proveedor.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

class ProveedorCardDetail extends StatelessWidget {
  final Proveedor proveedor;
  final VoidCallback? onEdit;

  const ProveedorCardDetail({
    super.key,
    required this.proveedor,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final contacto = proveedor.contactoRepresentante?.trim();
    final tel = proveedor.telefonoProveedor?.trim();
    final email = proveedor.emailProveedor?.trim();
    final dir = proveedor.direccionProveedor?.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _stat(
                  'CONTACTO',
                  tel?.isNotEmpty == true
                      ? tel!
                      : (contacto?.isNotEmpty == true ? contacto! : '—'),
                ),
              ),
              const Expanded(child: _StatLabel('TOTAL PEDIDOS', '—')),
              const Expanded(child: _StatLabel('ÚLTIMO PEDIDO', '—')),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DATOS DEL PROVEEDOR',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 8),
                if (contacto != null && contacto.isNotEmpty)
                  _dato('Representante', contacto),
                if (email != null && email.isNotEmpty) _dato('Email', email),
                if (dir != null && dir.isNotEmpty) _dato('Dirección', dir),
                if ((contacto == null || contacto.isEmpty) &&
                    (email == null || email.isEmpty) &&
                    (dir == null || dir.isEmpty))
                  Text(
                    'Sin datos adicionales',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textMuted),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Editar'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) => _StatLabel(label, value);

  Widget _dato(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textMuted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatLabel extends StatelessWidget {
  final String label;
  final String value;
  const _StatLabel(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: AppColors.textMuted,
            fontWeight: FontWeight.w700,
            fontSize: 10,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
