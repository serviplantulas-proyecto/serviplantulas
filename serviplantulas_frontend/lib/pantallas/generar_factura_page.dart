import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/ventas/factura_list_card.dart';
import '../componentes/ventas/factura_resumen_body.dart';
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

  void _enviar() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Envío por correo pendiente de API'),
        backgroundColor: AppColors.success,
      ));
    });
  }
}
