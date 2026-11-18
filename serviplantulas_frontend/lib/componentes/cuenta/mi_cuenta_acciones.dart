import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_spacing.dart';
import '../../styles/app_text_styles.dart';

Future<bool> confirmarEliminarCuenta(BuildContext context) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Eliminar cuenta'),
      content: const Text(
        '¿Estás seguro de que quieres eliminar tu cuenta? '
        'Esta acción no se puede deshacer y perderás el acceso a la aplicación.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );
  return ok == true;
}

class MiCuentaAcciones extends StatelessWidget {
  final VoidCallback onCerrarSesion;
  final VoidCallback onEliminarCuenta;
  final bool eliminando;

  const MiCuentaAcciones({
    super.key,
    required this.onCerrarSesion,
    required this.onEliminarCuenta,
    this.eliminando = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: eliminando ? null : onCerrarSesion,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              backgroundColor: const Color(0xFFFFF0F0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
            ),
            child: Text(
              'Cerrar Sesión',
              style: AppTextStyles.button.copyWith(color: AppColors.error),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            onPressed: eliminando ? null : onEliminarCuenta,
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: eliminando
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Eliminar cuenta',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
