import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/ventas/factura_list_card.dart';
import '../componentes/ventas/factura_resumen_body.dart';
import '../services/facturas_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_spacing.dart';

class GenerarFacturaPage extends StatefulWidget {
  final FacturaListItem? factura;

  const GenerarFacturaPage({super.key, this.factura});

  @override
  State<GenerarFacturaPage> createState() => _GenerarFacturaPageState();
}

class _GenerarFacturaPageState extends State<GenerarFacturaPage> {
  final _service = FacturasService();
  bool _isLoading = false;

  FacturaListItem get _f =>
      widget.factura ??
      const FacturaListItem(
        id: '0',
        cliente: '—',
        fecha: '—',
        unidades: 0,
        total: 0,
        estado: 'Pendiente',
        lineas: [],
      );

  Future<void> _enviar() async {
    if (_f.id == '0') {
      _snack('No hay factura para enviar', error: true);
      return;
    }

    final email = (_f.emailCliente ?? '').trim();
    if (email.isEmpty) {
      _snack(
        'El cliente no tiene correo registrado. Agrégalo en su ficha.',
        error: true,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final res = await _service.enviarPorCorreo(
        factura: _f,
        email: email,
        nombre: _f.cliente,
      );
      if (!mounted) return;
      _snack('Enviado a ${res['email'] ?? email}');
    } on FacturasException catch (e) {
      if (mounted) _snack(e.message, error: true);
    } catch (_) {
      if (mounted) _snack('No se pudo enviar el correo', error: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? AppColors.error : AppColors.success,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Resumen de Venta'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    FacturaResumenBody(factura: _f),
                    const SizedBox(height: AppSpacing.extraLarge),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _enviar,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.share_outlined, size: 18),
                        label: const Text('Enviar por Correo'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.medium),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
