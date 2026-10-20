import 'package:flutter/material.dart';

import '../../models/cliente.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';
import 'venta_search_field.dart';

class VentaClienteSection extends StatelessWidget {
  final Cliente? cliente;
  final TextEditingController searchController;
  final List<Cliente> sugerencias;
  final VoidCallback? onNuevoCliente;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<Cliente>? onClienteSeleccionado;
  final VoidCallback? onClearSearch;

  const VentaClienteSection({
    super.key,
    this.cliente,
    required this.searchController,
    this.sugerencias = const [],
    this.onNuevoCliente,
    this.onSearchChanged,
    this.onClienteSeleccionado,
    this.onClearSearch,
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
        // Buscador siempre visible (Figma)
        VentaSearchField(
          controller: searchController,
          hintText: 'Buscar por documento o nombre...',
          leadingIcon: Icons.search,
          showClear: searchController.text.isNotEmpty,
          onChanged: onSearchChanged,
          onClear: onClearSearch,
        ),
        if (sugerencias.isNotEmpty) ...[
          const SizedBox(height: 6),
          _SugerenciasCliente(
            items: sugerencias,
            onSelect: onClienteSeleccionado,
          ),
        ],
        if (cliente != null) ...[
          const SizedBox(height: 10),
          _ClienteSeleccionadoCard(cliente: cliente!),
        ],
      ],
    );
  }
}

class _ClienteSeleccionadoCard extends StatelessWidget {
  final Cliente cliente;

  const _ClienteSeleccionadoCard({required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  cliente.nombre,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'cel: ${cliente.telefono ?? "—"}'
                  '${cliente.descuentoFrecuente > 0 ? " · Descuento Frecuente (${cliente.descuentoFrecuente.toStringAsFixed(0)}%)" : ""}',
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
    );
  }
}

class _SugerenciasCliente extends StatelessWidget {
  final List<Cliente> items;
  final ValueChanged<Cliente>? onSelect;

  const _SugerenciasCliente({required this.items, this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: items.map((c) {
          return InkWell(
            onTap: () => onSelect?.call(c),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.person_outline,
                      size: 18, color: AppColors.textMuted),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${c.tipoDocumento} ${c.documento} - ${c.nombre}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
