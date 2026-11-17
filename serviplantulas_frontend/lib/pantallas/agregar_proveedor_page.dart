import 'package:flutter/material.dart';

import '../componentes/boton/app_button.dart';
import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/proveedores/proveedor_form_body.dart';
import '../componentes/proveedores/proveedor_form_helpers.dart';
import '../models/proveedor.dart';
import '../services/proveedores_service.dart';
import '../styles/app_colors.dart';

class AgregarProveedorPage extends StatefulWidget {
  final Proveedor? proveedor;
  const AgregarProveedorPage({super.key, this.proveedor});

  @override
  State<AgregarProveedorPage> createState() => _AgregarProveedorPageState();
}

class _AgregarProveedorPageState extends State<AgregarProveedorPage> {
  final _service = ProveedoresService();
  final _nombreCtrl = TextEditingController();
  final _nitCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _ciudadCtrl = TextEditingController();
  final Set<String> _productosSel = {};
  bool _loading = false;
  bool get _edit => widget.proveedor != null;

  @override
  void initState() {
    super.initState();
    final p = widget.proveedor;
    if (p == null) return;
    _nombreCtrl.text = p.nombreProveedor;
    _telCtrl.text = p.telefonoProveedor ?? '';
    _emailCtrl.text = p.emailProveedor ?? '';
    splitProveedorDireccion(
      p.direccionProveedor,
      ciudadCtrl: _ciudadCtrl,
      direccionCtrl: _direccionCtrl,
    );
    loadProveedorExtras(
      id: p.idProveedor,
      nitCtrl: _nitCtrl,
      productosSel: _productosSel,
      setState: setState,
    );
  }

  @override
  void dispose() {
    for (final c in [
      _nombreCtrl, _nitCtrl, _telCtrl, _emailCtrl, _direccionCtrl, _ciudadCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _snack(String m, {bool err = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(m),
      backgroundColor: err ? AppColors.error : AppColors.success,
    ));
  }

  Future<void> _guardar() async {
    final nombre = _nombreCtrl.text.trim();
    if (nombre.isEmpty) {
      _snack('El nombre / razón social es obligatorio', err: true);
      return;
    }
    final dir = composeProveedorDireccion(_ciudadCtrl.text, _direccionCtrl.text);
    setState(() => _loading = true);
    try {
      if (_edit) {
        final id = widget.proveedor!.idProveedor;
        await _service.actualizar(id: id, campos: {
          'nombre_proveedor': nombre,
          'telefono_proveedor': _telCtrl.text.trim(),
          'email_proveedor': _emailCtrl.text.trim(),
          'direccion_proveedor': dir,
        });
        await saveProveedorExtras(
          id: id,
          nit: _nitCtrl.text.trim(),
          productos: _productosSel.toList(),
        );
        if (mounted) _snack('Proveedor actualizado');
      } else {
        String? n(String s) => s.trim().isEmpty ? null : s.trim();
        final creado = await _service.crear(
          nombreProveedor: nombre,
          telefonoProveedor: n(_telCtrl.text),
          emailProveedor: n(_emailCtrl.text),
          direccionProveedor: dir.isEmpty ? null : dir,
        );
        await saveProveedorExtras(
          id: creado.idProveedor,
          nit: _nitCtrl.text.trim(),
          productos: _productosSel.toList(),
        );
        if (mounted) _snack('Proveedor guardado');
      }
      if (mounted) Navigator.pop(context, true);
    } on ProveedoresException catch (e) {
      if (mounted) _snack(e.message, err: true);
    } catch (_) {
      if (mounted) _snack('Error al guardar', err: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _eliminar() async {
    final id = widget.proveedor!.idProveedor;
    final ok = await confirmarEliminarProveedor(context);
    if (!ok || !mounted) return;
    setState(() => _loading = true);
    try {
      await _service.eliminar(id);
      await removeProveedorExtras(id);
      if (!mounted) return;
      _snack('Proveedor eliminado');
      Navigator.pop(context, true);
    } on ProveedoresException catch (e) {
      if (mounted) _snack(e.message, err: true);
    } catch (_) {
      if (mounted) _snack('No se pudo eliminar', err: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppBarSimple(
              title: _edit ? 'Editar Proveedor' : 'Agregar Proveedor',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: ProveedorFormBody(
                  nombreCtrl: _nombreCtrl,
                  nitCtrl: _nitCtrl,
                  telCtrl: _telCtrl,
                  emailCtrl: _emailCtrl,
                  direccionCtrl: _direccionCtrl,
                  ciudadCtrl: _ciudadCtrl,
                  productosSel: _productosSel,
                  onToggleProducto: (p) => setState(() {
                    if (!_productosSel.add(p)) _productosSel.remove(p);
                  }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                children: [
                  AppButton(
                    text: 'Guardar Proveedor',
                    isLoading: _loading,
                    onPressed: _loading ? null : _guardar,
                  ),
                  if (_edit) ...[
                    const SizedBox(height: 10),
                    AppButton(
                      text: 'Eliminar Proveedor',
                      type: AppButtonType.danger,
                      isLoading: _loading,
                      onPressed: _loading ? null : _eliminar,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
