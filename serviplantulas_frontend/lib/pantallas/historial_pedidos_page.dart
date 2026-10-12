import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/inventario/inventory_search_bar.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_text_styles.dart';

class HistorialPedidosPage extends StatefulWidget {
  const HistorialPedidosPage({super.key});

  @override
  State<HistorialPedidosPage> createState() => _HistorialPedidosPageState();
}

class _HistorialPedidosPageState extends State<HistorialPedidosPage> {
  final _searchCtrl = TextEditingController();

  final _pedidos = const [
    _Pedido('PED-220', 'Carlos Restrepo', '3 productos', 67500, 'En camino'),
    _Pedido('PED-219', 'Diana Gómez', '1 producto', 18000, 'Entregado'),
    _Pedido('PED-218', 'Inversiones del Bosque', '8 productos', 210000, 'Pendiente'),
    _Pedido('PED-217', 'María López', '2 productos', 45000, 'Entregado'),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Color _estadoColor(String e) {
    switch (e) {
      case 'Entregado':
        return AppColors.success;
      case 'En camino':
        return AppColors.info;
      default:
        return AppColors.warning;
    }
  }

  String _money(double v) {
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
        child: Column(
          children: [
            const AppBarSimple(title: 'Historial de Pedidos'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: InventorySearchBar(
                controller: _searchCtrl,
                hint: 'Buscar pedido o cliente...',
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: _pedidos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final p = _pedidos[i];
                  final color = _estadoColor(p.estado);
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.large),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '#${p.id}',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                '${p.cliente} · ${p.detalle}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _money(p.total),
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                p.estado,
                                style: AppTextStyles.label.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pedido {
  final String id;
  final String cliente;
  final String detalle;
  final double total;
  final String estado;

  const _Pedido(this.id, this.cliente, this.detalle, this.total, this.estado);
}
