import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/inventario/inventory_search_bar.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_text_styles.dart';

class HistorialFacturasPage extends StatefulWidget {
  const HistorialFacturasPage({super.key});

  @override
  State<HistorialFacturasPage> createState() => _HistorialFacturasPageState();
}

class _HistorialFacturasPageState extends State<HistorialFacturasPage> {
  final _searchCtrl = TextEditingController();

  // Mock data — conectar GET /facturas
  final _facturas = const [
    _Factura('FACT-1042', 'Carlos Restrepo', '08 Oct 2023', 67500, 'Pagada'),
    _Factura('FACT-1041', 'Diana Gómez', '07 Oct 2023', 45000, 'Pendiente'),
    _Factura('FACT-1040', 'Inversiones del Bosque', '05 Oct 2023', 210000, 'Pagada'),
    _Factura('FACT-1039', 'Carlos Restrepo', '02 Oct 2023', 15000, 'Pagada'),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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
            const AppBarSimple(title: 'Historial de Facturas'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: InventorySearchBar(
                controller: _searchCtrl,
                hint: 'Buscar factura o cliente...',
                onChanged: (_) => setState(() {}),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: _facturas.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final f = _facturas[i];
                  final pagada = f.estado == 'Pagada';
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.large),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: pagada
                                ? AppColors.successBackground
                                : AppColors.warningBackground,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.receipt_long,
                            size: 20,
                            color: pagada
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '#${f.id}',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                '${f.cliente} · ${f.fecha}',
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
                              _money(f.total),
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              f.estado,
                              style: AppTextStyles.label.copyWith(
                                color: pagada
                                    ? AppColors.success
                                    : AppColors.warning,
                                fontWeight: FontWeight.w700,
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

class _Factura {
  final String id;
  final String cliente;
  final String fecha;
  final double total;
  final String estado;

  const _Factura(this.id, this.cliente, this.fecha, this.total, this.estado);
}
