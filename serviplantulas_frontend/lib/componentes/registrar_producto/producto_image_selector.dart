import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

/// Selector de foto del producto (galería, cámara o drag & drop en desktop).
/// Adaptado de la guía ADSO (AdminImageSelector).
class ProductoImageSelector extends StatefulWidget {
  final File? imagen;
  final String? imagenUrl;
  final ValueChanged<File> onImagenSeleccionada;
  final bool habilitado;

  const ProductoImageSelector({
    super.key,
    required this.imagen,
    required this.onImagenSeleccionada,
    this.imagenUrl,
    this.habilitado = true,
  });

  @override
  State<ProductoImageSelector> createState() => _ProductoImageSelectorState();
}

class _ProductoImageSelectorState extends State<ProductoImageSelector> {
  final _picker = ImagePicker();
  bool _arrastrando = false;

  Future<void> _elegir(ImageSource source) async {
    if (!widget.habilitado) return;
    try {
      final x = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (x == null) return;
      widget.onImagenSeleccionada(File(x.path));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo obtener la imagen: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _mostrarOpciones() {
    if (!widget.habilitado) return;
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
                _elegir(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Cámara'),
              onTap: () {
                Navigator.pop(ctx);
                _elegir(ImageSource.camera);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tieneLocal = widget.imagen != null;
    final tieneUrl =
        widget.imagenUrl != null && widget.imagenUrl!.trim().isNotEmpty;

    Widget contenido = GestureDetector(
      onTap: _mostrarOpciones,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: _arrastrando
              ? AppColors.editBackground
              : AppColors.neutral,
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(
            color: _arrastrando ? AppColors.primary : AppColors.border,
            width: _arrastrando ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: tieneLocal
            ? Image.file(widget.imagen!, fit: BoxFit.cover)
            : tieneUrl
                ? Image.network(
                    widget.imagenUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
      ),
    );

    // Drag & drop solo en desktop (no web / no móvil puro)
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      contenido = DropTarget(
        onDragEntered: (_) => setState(() => _arrastrando = true),
        onDragExited: (_) => setState(() => _arrastrando = false),
        onDragDone: (detail) {
          setState(() => _arrastrando = false);
          if (detail.files.isEmpty) return;
          final path = detail.files.first.path;
          final ext = path.split('.').last.toLowerCase();
          if (!['jpg', 'jpeg', 'png', 'webp', 'avif'].contains(ext)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Solo se permiten imágenes (jpg, png, webp…)'),
                backgroundColor: AppColors.error,
              ),
            );
            return;
          }
          widget.onImagenSeleccionada(File(path));
        },
        child: contenido,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foto del producto',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        contenido,
        const SizedBox(height: 6),
        Text(
          'Toca para elegir galería o cámara'
          '${(!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) ? ' · o arrastra una imagen' : ''}',
          style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add_a_photo_outlined,
            size: 40,
            color: AppColors.mutedGreen,
          ),
          const SizedBox(height: 8),
          Text(
            'Agregar imagen',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
