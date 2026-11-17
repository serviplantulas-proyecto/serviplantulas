import 'package:flutter/material.dart';

import '../../models/producto.dart';
import '../../services/productos_service.dart';
import '../../styles/app_colors.dart';

String detalleMoney(double v) {
  final s = v.toStringAsFixed(0);
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return '${buf.toString()} COP';
}

Future<bool> confirmarEliminarProducto(
  BuildContext context,
  String nombre,
) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Eliminar producto'),
      content: Text(
        '¿Seguro que quieres eliminar "$nombre"?\n'
        'Esta acción no se puede deshacer.',
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

void snackDetalle(
  BuildContext context,
  String mensaje, {
  bool error = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensaje),
      backgroundColor: error ? AppColors.error : AppColors.success,
    ),
  );
}

Future<Producto?> refrescarProducto(
  ProductosService service,
  int id,
) async {
  try {
    return await service.obtenerPorId(id);
  } catch (_) {
    return null;
  }
}
