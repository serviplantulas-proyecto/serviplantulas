import 'package:flutter/material.dart';

import '../../styles/app_spacing.dart';
import 'proveedor_form_fields.dart';

class ProveedorFormBody extends StatelessWidget {
  final TextEditingController nombreCtrl;
  final TextEditingController nitCtrl;
  final TextEditingController telCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController direccionCtrl;
  final TextEditingController ciudadCtrl;
  final Set<String> productosSel;
  final ValueChanged<String> onToggleProducto;

  const ProveedorFormBody({
    super.key,
    required this.nombreCtrl,
    required this.nitCtrl,
    required this.telCtrl,
    required this.emailCtrl,
    required this.direccionCtrl,
    required this.ciudadCtrl,
    required this.productosSel,
    required this.onToggleProducto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProveedorFormLabel('Nombre o Razón Social'),
        ProveedorFormField(
          controller: nombreCtrl,
          hint: 'Ej. Distribuidora del Bosque',
        ),
        const SizedBox(height: AppSpacing.large),
        const ProveedorFormLabel('NIT'),
        ProveedorFormField(controller: nitCtrl, hint: 'Ej. 901.442.234-1'),
        const SizedBox(height: AppSpacing.large),
        const ProveedorFormLabel('Teléfono'),
        ProveedorFormField(
          controller: telCtrl,
          hint: 'Ej. +57 321 456 7890',
          keyboard: TextInputType.phone,
        ),
        const SizedBox(height: AppSpacing.large),
        const ProveedorFormLabel('Email'),
        ProveedorFormField(
          controller: emailCtrl,
          hint: 'Ej. contacto@delbosque.com',
          keyboard: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.large),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProveedorFormLabel('Dirección'),
                  ProveedorFormField(
                    controller: direccionCtrl,
                    hint: 'Ej. Calle 10 # 5-20',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProveedorFormLabel('Ciudad'),
                  ProveedorFormField(
                    controller: ciudadCtrl,
                    hint: 'Ej. Medellín',
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.large),
        const ProveedorFormLabel('Productos que Suministra'),
        const SizedBox(height: 10),
        ProveedorProductosChips(
          seleccionados: productosSel,
          onToggle: onToggleProducto,
        ),
      ],
    );
  }
}
