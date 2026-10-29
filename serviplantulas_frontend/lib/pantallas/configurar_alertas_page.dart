import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/notificaciones/alerta_retencion_chips.dart';
import '../componentes/notificaciones/alerta_switch_row.dart';
import '../services/alertas_prefs_service.dart';
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
  final _prefs = AlertasPrefsService();
  bool _stock = true;
  bool _venta = true;
  bool _cliente = false;
  bool _factura = true;
  bool _diario = false;
  int _retencionDias = 30;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final f = await _prefs.cargar();
    if (!mounted) return;
    setState(() {
      _stock = f['stock'] == true;
      _venta = f['venta'] == true;
      _cliente = f['cliente'] == true;
      _factura = f['factura'] == true;
      _diario = f['diario'] == true;
      _retencionDias = f['retencionDias'] is int ? f['retencionDias'] as int : 30;
      _loading = false;
    });
  }

  Future<void> _guardar() async {
    setState(() => _saving = true);
    try {
      final msg = await _prefs.guardarYAplicar({
        'stock': _stock,
        'venta': _venta,
        'cliente': _cliente,
        'factura': _factura,
        'diario': _diario,
        'retencionDias': _retencionDias,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.success,
      ));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No se pudo guardar'),
        backgroundColor: AppColors.error,
      ));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Configurar Alertas'),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        Text(
                          'Notificaciones Push y Alertas',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius:
                                BorderRadius.circular(AppRadius.large),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            children: [
                              AlertaSwitchRow(
                                title: 'Stock Bajo',
                                subtitle:
                                    'Avisar cuando un producto esté por debajo del límite.',
                                value: _stock,
                                onChanged: (v) => setState(() => _stock = v),
                              ),
                              AlertaSwitchRow(
                                title: 'Venta Registrada',
                                subtitle:
                                    'Recibir un resumen de cada venta efectuada.',
                                value: _venta,
                                onChanged: (v) => setState(() => _venta = v),
                              ),
                              AlertaSwitchRow(
                                title: 'Nuevo Cliente',
                                subtitle:
                                    'Notificar cuando se agregue un cliente al directorio.',
                                value: _cliente,
                                onChanged: (v) => setState(() => _cliente = v),
                              ),
                              AlertaSwitchRow(
                                title: 'Factura Pendiente',
                                subtitle:
                                    'Recordatorio de cobro para facturas con pago pendiente.',
                                value: _factura,
                                onChanged: (v) => setState(() => _factura = v),
                              ),
                              AlertaSwitchRow(
                                title: 'Recordatorio Diario',
                                subtitle:
                                    'Alerta diaria para realizar la sincronización de inventario.',
                                value: _diario,
                                onChanged: (v) => setState(() => _diario = v),
                                showDivider: false,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.extraLarge),
                        AlertaRetencionChips(
                          diasSeleccionados: _retencionDias,
                          onChanged: (d) =>
                              setState(() => _retencionDias = d),
                        ),
                        const SizedBox(height: AppSpacing.extraLarge),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _saving ? null : _guardar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.medium),
                              ),
                            ),
                            child: _saving
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Guardar Configuración',
                                    style: AppTextStyles.button.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
