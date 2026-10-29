import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

/// Selector de foto (galería, cámara, drag & drop) con opción de quitar.
class ProductoImageSelector extends StatefulWidget {
  final File? imagen;
  final String? imagenUrl;
  final ValueChanged<File> onImagenSeleccionada;
  final VoidCallback? onQuitar;
  final bool habilitado;

  const ProductoImageSelector({
    super.key,
    required this.imagen,
    required this.onImagenSeleccionada,
    this.imagenUrl,
    this.onQuitar,
    this.habilitado = true,
  });

  @override
  State<ProductoImageSelector> createState() => _ProductoImageSelectorState();
}

class _ProductoImageSelectorState extends State<ProductoImageSelector> {
  final _picker = ImagePicker();
  bool _arrastrando = false;

  bool get _tieneImagen {
    final local = widget.imagen != null;
    final url =
        widget.imagenUrl != null && widget.imagenUrl!.trim().isNotEmpty;
    return local || url;
  }

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
            if (_tieneImagen && widget.onQuitar != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppColors.error),
                title: const Text('Quitar imagen'),
                onTap: () {
                  Navigator.pop(ctx);
                  widget.onQuitar!();
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

    Widget preview = Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: _arrastrando ? AppColors.editBackground : AppColors.neutral,
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
    );

    Widget contenido = GestureDetector(
      onTap: _mostrarOpciones,
      child: Stack(
        children: [
          preview,
          if (_tieneImagen && widget.onQuitar != null && widget.habilitado)
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.black54,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: widget.onQuitar,
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.close, size: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      contenido = DropTarget(
        onDragEntered: (_) => setState(() => _arrastrando = true),
        onDragExited: (_) => setState(() => _arrastrando = false),
        onDragDone: (detail) {
          setState(() => _arrastrando = false);
          if (detail.files.isEmpty || !widget.habilitado) return;
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
          _tieneImagen
              ? 'Toca para cambiar · o usa la X para quitar'
              : 'Toca para elegir galería o cámara'
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
          Icon(Icons.add_a_photo_outlined, size: 40, color: AppColors.mutedGreen),
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
