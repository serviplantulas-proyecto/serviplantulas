import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';

class ConfigurarAlertasPage extends StatefulWidget {
  const ConfigurarAlertasPage({super.key});

  @override
  State<ConfigurarAlertasPage> createState() => _ConfigurarAlertasPageState();
}

class _ConfigurarAlertasPageState extends State<ConfigurarAlertasPage> {
  bool _stockMinimo = true;
  bool _pedidosPendientes = true;
  bool _nuevasVentas = false;
  bool _alertasEmail = true;
  int _umbralStock = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Configurar Alertas'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    'Notificaciones de Inventario',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _switchTile(
                    'Stock mínimo',
                    'Avisa cuando un producto baje del umbral',
                    _stockMinimo,
                    (v) => setState(() => _stockMinimo = v),
                  ),
                  if (_stockMinimo) ...[
                    const SizedBox(height: 8),
                    _umbralRow(),
                  ],
                  const SizedBox(height: 8),
                  _switchTile(
                    'Pedidos pendientes',
                    'Recordatorio de pedidos sin despachar',
                    _pedidosPendientes,
                    (v) => setState(() => _pedidosPendientes = v),
                  ),
                  const SizedBox(height: AppSpacing.extraLarge),
                  Text(
                    'Notificaciones de Ventas',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _switchTile(
                    'Nuevas ventas',
                    'Notificar cada venta registrada',
                    _nuevasVentas,
                    (v) => setState(() => _nuevasVentas = v),
                  ),
                  const SizedBox(height: AppSpacing.extraLarge),
                  Text(
                    'Canales',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _switchTile(
                    'Alertas por correo',
                    'Enviar resumen diario al email registrado',
                    _alertasEmail,
                    (v) => setState(() => _alertasEmail = v),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.border),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
        ),
        value: value,
        activeColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }

  Widget _umbralRow() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.editBackground,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Row(
        children: [
          Text(
            'Umbral de stock:',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              if (_umbralStock > 1) setState(() => _umbralStock--);
            },
            icon: const Icon(Icons.remove_circle_outline, size: 20),
            color: AppColors.primary,
          ),
          Text(
            '$_umbralStock',
            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w800),
          ),
          IconButton(
            onPressed: () => setState(() => _umbralStock++),
            icon: const Icon(Icons.add_circle_outline, size: 20),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
