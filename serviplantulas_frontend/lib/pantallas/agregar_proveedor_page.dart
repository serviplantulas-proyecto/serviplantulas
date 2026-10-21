import 'package:flutter/material.dart';

import '../componentes/boton/app_button.dart';
import '../componentes/compartidos/app_bar_simple.dart';
import '../models/proveedor.dart';
import '../services/proveedores_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';

class AgregarProveedorPage extends StatefulWidget {
  final Proveedor? proveedor;

  const AgregarProveedorPage({super.key, this.proveedor});

  @override
  State<AgregarProveedorPage> createState() => _AgregarProveedorPageState();
}

class _AgregarProveedorPageState extends State<AgregarProveedorPage> {
  final _service = ProveedoresService();
  final _nombreCtrl = TextEditingController();
  final _contactoCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  bool _isLoading = false;

  bool get _esEdicion => widget.proveedor != null;

  @override
  void initState() {
    super.initState();
    final p = widget.proveedor;
    if (p != null) {
      _nombreCtrl.text = p.nombreProveedor;
      _contactoCtrl.text = p.contactoRepresentante ?? '';
      _telCtrl.text = p.telefonoProveedor ?? '';
      _emailCtrl.text = p.emailProveedor ?? '';
      _direccionCtrl.text = p.direccionProveedor ?? '';
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _contactoCtrl.dispose();
    _telCtrl.dispose();
    _emailCtrl.dispose();
    _direccionCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final nombre = _nombreCtrl.text.trim();
    if (nombre.isEmpty) {
      _snack('El nombre / razón social es obligatorio', error: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_esEdicion) {
        await _service.actualizar(
          id: widget.proveedor!.idProveedor,
          campos: {
            'nombre_proveedor': nombre,
            'contacto_representante': _contactoCtrl.text.trim(),
            'telefono_proveedor': _telCtrl.text.trim(),
            'email_proveedor': _emailCtrl.text.trim(),
            'direccion_proveedor': _direccionCtrl.text.trim(),
          },
        );
        if (!mounted) return;
        _snack('Proveedor actualizado');
      } else {
        await _service.crear(
          nombreProveedor: nombre,
          contactoRepresentante: _emptyToNull(_contactoCtrl.text),
          telefonoProveedor: _emptyToNull(_telCtrl.text),
          emailProveedor: _emptyToNull(_emailCtrl.text),
          direccionProveedor: _emptyToNull(_direccionCtrl.text),
        );
        if (!mounted) return;
        _snack('Proveedor guardado');
      }
      Navigator.pop(context, true);
    } on ProveedoresException catch (e) {
      if (!mounted) return;
      _snack(e.message, error: true);
    } catch (_) {
      if (!mounted) return;
      _snack('Error al guardar', error: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _emptyToNull(String s) {
    final t = s.trim();
    return t.isEmpty ? null : t;
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
              title: _esEdicion ? 'Editar Proveedor' : 'Agregar Proveedor',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Nombre / Razón Social'),
                    _field(_nombreCtrl, 'Ej. Nativo Verde S.A.'),
                    const SizedBox(height: AppSpacing.large),
                    _label('Persona de Contacto'),
                    _field(_contactoCtrl, 'Nombre del contacto'),
                    const SizedBox(height: AppSpacing.large),
                    _label('Teléfono'),
                    _field(
                      _telCtrl,
                      '300 123 4567',
                      keyboard: TextInputType.phone,
                    ),
                    const SizedBox(height: AppSpacing.large),
                    _label('Correo Electrónico'),
                    _field(
                      _emailCtrl,
                      'contacto@proveedor.com',
                      keyboard: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: AppSpacing.large),
                    _label('Dirección'),
                    _field(_direccionCtrl, 'Ciudad, dirección...'),
                    const SizedBox(height: AppSpacing.extraLarge),
                    AppButton(
                      text: _esEdicion
                          ? 'Guardar cambios'
                          : 'Guardar Proveedor',
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

  Widget _field(
    TextEditingController ctrl,
    String hint, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
