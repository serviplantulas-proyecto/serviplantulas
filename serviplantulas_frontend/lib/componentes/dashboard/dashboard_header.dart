import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

class DashboardHeader extends StatelessWidget {
  final String nombreUsuario;
  final VoidCallback? onAvatarTap;

  const DashboardHeader({
    super.key,
    this.nombreUsuario = 'Admin',
    this.onAvatarTap,
  });

  static const _dias = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  static const _meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  String get _fechaHoy {
    final now = DateTime.now();
    final dia = _dias[now.weekday - 1];
    final mes = _meses[now.month - 1];
    return '$dia, ${now.day} de $mes';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Hola, $nombreUsuario!',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _fechaHoy,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onAvatarTap,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary,
              child: Text(
                nombreUsuario.isNotEmpty
                    ? nombreUsuario[0].toUpperCase()
                    : 'A',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.surface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
