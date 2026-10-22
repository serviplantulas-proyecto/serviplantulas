import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../componentes/boton/app_button.dart';
import '../componentes/categorias/categoria_color_picker.dart';
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
  int _colorIndex = 0;
  bool _isLoading = false;

  bool get _esEdicion => widget.categoria != null;

  @override
  void initState() {
    super.initState();
    final c = widget.categoria;
    if (c != null) {
      _nombreCtrl.text = c.nombreCategoria;
      _descCtrl.text = c.descripcionCategoria ?? '';
      _cargarColor(c.idCategoria);
    }
  }

  Future<void> _cargarColor(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final idx = prefs.getInt('cat_color_$id') ?? 0;
    if (mounted) {
      setState(() =>
          _colorIndex = idx.clamp(0, kCategoriaColores.length - 1));
    }
  }

  Future<void> _guardarColor(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cat_color_$id', _colorIndex);
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
        final id = widget.categoria!.idCategoria;
        await _service.actualizar(
          id: id,
          campos: {
            'nombre_categoria': nombre,
            'descripcion_categoria': _descCtrl.text.trim(),
            'estado': true,
          },
        );
        await _guardarColor(id);
        if (!mounted) return;
        _snack('Categoría actualizada');
      } else {
        final creada = await _service.crear(
          nombreCategoria: nombre,
          descripcionCategoria:
              _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
          estado: true,
        );
        await _guardarColor(creada.idCategoria);
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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Nombre de la Categoría'),
                    _field(_nombreCtrl, 'Ej. Plantas de Interior'),
                    const SizedBox(height: AppSpacing.large),
                    _label('Descripción (Opcional)'),
                    TextField(
                      controller: _descCtrl,
                      maxLines: 3,
                      style: AppTextStyles.bodyMedium,
                      decoration: _decoration(
                        'Escribe una breve descripción para organizar los productos de esta categoría...',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.large),
                    _label('Identificador (Icono o Color)'),
                    const SizedBox(height: 10),
                    CategoriaColorPicker(
                      selectedIndex: _colorIndex,
                      onChanged: (i) => setState(() => _colorIndex = i),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 0.5),
                ),
              ),
              child: AppButton(
                text: 'Guardar Categoría',
                isLoading: _isLoading,
                onPressed: _guardar,
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
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }
}
