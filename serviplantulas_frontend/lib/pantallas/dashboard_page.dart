import 'package:flutter/material.dart';

import '../componentes/dashboard/dashboard_header.dart';
import '../componentes/dashboard/quick_actions_grid.dart';
import '../componentes/dashboard/sales_chart.dart';
import '../componentes/dashboard/stat_card.dart';
import '../models/dashboard_stats.dart';
import '../services/dashboard_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';

class DashboardPage extends StatefulWidget {
  final VoidCallback? onNuevaVenta;
  final VoidCallback? onVerInventario;
  final VoidCallback? onChatBot;
  final VoidCallback? onNuevoProducto;
  final VoidCallback? onAnalisis;
  final VoidCallback? onHistorial;
  final VoidCallback? onNotificaciones;

  const DashboardPage({
    super.key,
    this.onNuevaVenta,
    this.onVerInventario,
    this.onChatBot,
    this.onNuevoProducto,
    this.onAnalisis,
    this.onHistorial,
    this.onNotificaciones,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardService _service = DashboardService();
  DashboardStats? _stats;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _loading = true);
    try {
      final data = await _service.obtenerResumen();
      if (mounted) setState(() {
        _stats = data;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _formatMoney(double v) {
    final s = v.toStringAsFixed(0);
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '\$${buf.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _cargar,
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DashboardHeader(nombreUsuario: 'Admin'),
                      if (_stats != null) ...[
                        _buildStats(_stats!),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: SalesChart(
                            data: _stats!.historicoVentas,
                            variacion: _stats!.variacionSemanal,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: QuickActionsGrid(
                            onNuevaVenta: widget.onNuevaVenta,
                            onVerInventario: widget.onVerInventario,
                            onChatBot: widget.onChatBot,
                            onNuevoProducto: widget.onNuevoProducto,
                            onAnalisis: widget.onAnalisis,
                            onHistorial: widget.onHistorial,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildStats(DashboardStats stats) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen de Hoy',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          Row(
            children: [
              StatCard(
                label: 'Ventas del Día',
                value: _formatMoney(stats.ventasDelDia),
                icon: Icons.point_of_sale,
                iconBackground: AppColors.successBackground,
              ),
              const SizedBox(width: 12),
              StatCard(
                label: 'Productos Stock',
                value: '${_formatNumber(stats.productosStock)} uds',
                icon: Icons.local_florist,
                iconBackground: AppColors.editBackground,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              StatCard(
                label: 'Clientes Activos',
                value: '${stats.clientesActivos}',
                icon: Icons.people_outline,
                iconBackground: AppColors.infoBackground,
              ),
              const SizedBox(width: 12),
              StatCard(
                label: 'Pedidos Pendientes',
                value: '${stats.pedidosPendientes}',
                icon: Icons.hourglass_empty,
                iconBackground: AppColors.errorBackground,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
