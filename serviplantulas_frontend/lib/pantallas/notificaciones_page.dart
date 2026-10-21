import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_text_styles.dart';

class NotificacionesPage extends StatefulWidget {
  const NotificacionesPage({super.key});

  @override
  State<NotificacionesPage> createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  // Mock — GET /notificaciones
  final List<_Notif> _items = [
    _Notif(
      'Stock bajo',
      'Ficus Lyrata Elegance tiene solo 15 Unidades',
      'Hace 2 h',
      Icons.warning_amber_rounded,
      AppColors.warning,
      false,
    ),
    _Notif(
      'Nueva venta',
      'Venta #FACT-1042 por \$67,500',
      'Hace 5 h',
      Icons.shopping_cart_outlined,
      AppColors.success,
      false,
    ),
    _Notif(
      'Pedido pendiente',
      '18 pedidos esperan despacho',
      'Ayer',
      Icons.hourglass_empty,
      AppColors.info,
      true,
    ),
  ];

  void _marcarTodasLeidas() {
    setState(() {
      for (var i = 0; i < _items.length; i++) {
        _items[i] = _items[i].copyWith(leida: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppBarSimple(
              title: 'Notificaciones',
              trailing: TextButton(
                onPressed: _marcarTodasLeidas,
                child: Text(
                  'Leer todas',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final n = _items[i];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: n.leida
                          ? AppColors.surface
                          : AppColors.editBackground,
                      borderRadius: BorderRadius.circular(AppRadius.large),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: n.color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(n.icon, size: 18, color: n.color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                n.titulo,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                n.mensaje,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                n.tiempo,
                                style: AppTextStyles.label.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!n.leida)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
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

class _Notif {
  final String titulo;
  final String mensaje;
  final String tiempo;
  final IconData icon;
  final Color color;
  final bool leida;

  const _Notif(
    this.titulo,
    this.mensaje,
    this.tiempo,
    this.icon,
    this.color,
    this.leida,
  );

  _Notif copyWith({bool? leida}) {
    return _Notif(titulo, mensaje, tiempo, icon, color, leida ?? this.leida);
  }
}
