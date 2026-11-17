import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../styles/app_colors.dart';

Future<void> loadProveedorExtras({
  required int id,
  required TextEditingController nitCtrl,
  required Set<String> productosSel,
  required void Function(VoidCallback) setState,
}) async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    nitCtrl.text = prefs.getString('prov_nit_$id') ?? '';
    productosSel
      ..clear()
      ..addAll(prefs.getStringList('prov_prods_$id') ?? []);
  });
}

Future<void> saveProveedorExtras({
  required int id,
  required String nit,
  required List<String> productos,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('prov_nit_$id', nit);
  await prefs.setStringList('prov_prods_$id', productos);
}

Future<void> removeProveedorExtras(int id) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('prov_nit_$id');
  await prefs.remove('prov_prods_$id');
}

String composeProveedorDireccion(String ciudad, String direccion) {
  final c = ciudad.trim();
  final d = direccion.trim();
  if (c.isNotEmpty && d.isNotEmpty) return '$c | $d';
  return c.isNotEmpty ? c : d;
}

void splitProveedorDireccion(
  String? dir, {
  required TextEditingController ciudadCtrl,
  required TextEditingController direccionCtrl,
}) {
  if (dir == null) return;
  if (dir.contains(' | ')) {
    final parts = dir.split(' | ');
    ciudadCtrl.text = parts.first.trim();
    direccionCtrl.text = parts.skip(1).join(' | ').trim();
  } else {
    direccionCtrl.text = dir;
  }
}

Future<bool> confirmarEliminarProveedor(BuildContext context) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Eliminar proveedor'),
      content: const Text(
        '¿Seguro que quieres eliminar este proveedor? Esta acción no se puede deshacer.',
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
