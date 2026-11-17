import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../styles/app_colors.dart';

/// Bottom sheet con opciones de galería / cámara / quitar imagen.
void showProductoImageOptionsSheet({
  required BuildContext context,
  required bool tieneImagen,
  required VoidCallback? onQuitar,
  required ValueChanged<ImageSource> onElegir,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Galería'),
            onTap: () {
              Navigator.pop(ctx);
              onElegir(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: const Text('Cámara'),
            onTap: () {
              Navigator.pop(ctx);
              onElegir(ImageSource.camera);
            },
          ),
          if (tieneImagen && onQuitar != null)
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.error),
              title: const Text('Quitar imagen'),
              onTap: () {
                Navigator.pop(ctx);
                onQuitar();
              },
            ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
