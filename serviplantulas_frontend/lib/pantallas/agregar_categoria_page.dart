import 'package:flutter/material.dart';

import '../componentes/boton/app_button.dart';
import '../componentes/compartidos/app_bar_simple.dart';
import '../models/categoria.dart';
import '../services/categorias_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';

class AgregarCategoriaPage extends StatefulWidget {
  final Categoria? categoria;

  const AgregarCategoriaPage({super.key, this.categoria});

  @override
  State<AgregarCategoriaPage> createState() => _AgregarCategoriaPageState();
}

class _AgregarCategoriaPageState extends State<AgregarCategoriaPage> {
  final _service = CategoriasService();
  final _nombreCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _estado = true;
  bool _isLoading = false;

  bool get _esEdicion => widget.categoria != null;

  @override
  void initState() {
    super.initState();
    final c = widget.categoria;
    if (c != null) {
      _nombreCtrl.text = c.nombreCategoria;
      _descCtrl.text = c.descripcionCategoria ?? '';
      _estado = c.estado;
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final nombre = _nombreCtrl.text.trim();
    if (nombre.isEmpty) {
      _snack('El nombre es obligatorio', error: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_esEdicion) {
        await _service.actualizar(
          id: widget.categoria!.idCategoria,
          campos: {
            'nombre_categoria': nombre,
            'descripcion_categoria': _descCtrl.text.trim(),
            'estado': _estado,
          },
        );
        if (!mounted) return;
        _snack('Categoría actualizada');
      } else {
        await _service.crear(
          nombreCategoria: nombre,
          descripcionCategoria:
              _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
          estado: _estado,
        );
        if (!mounted) return;
        _snack('Categoría creada');
      }
      Navigator.pop(context, true);
    } on CategoriasException catch (e) {
      if (!mounted) return;
      _snack(e.message, error: true);
    } catch (_) {
      if (!mounted) return;
      _snack('Error al guardar', error: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? AppColors.error : AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppBarSimple(
              title: _esEdicion ? 'Editar Categoría' : 'Agregar Categoría',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Nombre de la Categoría'),
                    _field(_nombreCtrl, 'Ej. Suculentas, Frutales...'),
                    const SizedBox(height: AppSpacing.large),
                    _label('Descripción (Opcional)'),
                    TextField(
                      controller: _descCtrl,
                      maxLines: 3,
                      style: AppTextStyles.bodyMedium,
                      decoration: _decoration(
                        'Breve descripción de la categoría...',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.large),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Categoría activa',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      value: _estado,
                      activeColor: AppColors.mutedGreen,
                      onChanged: (v) => setState(() => _estado = v),
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    AppButton(
                      text: _esEdicion
                          ? 'Guardar cambios'
                          : 'Guardar Categoría',
                      isLoading: _isLoading,
                      onPressed: _guardar,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          t,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Widget _field(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      style: AppTextStyles.bodyMedium,
      decoration: _decoration(hint),
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    );
  }
}
