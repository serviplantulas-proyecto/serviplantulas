import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../componentes/boton/app_button.dart';
import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/proveedores/proveedor_form_body.dart';
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
    final dir = p.direccionProveedor;
    if (dir != null && dir.contains(' | ')) {
      final parts = dir.split(' | ');
      _ciudadCtrl.text = parts.first.trim();
      _direccionCtrl.text = parts.skip(1).join(' | ').trim();
    } else if (dir != null) {
      _direccionCtrl.text = dir;
    }
    _loadExtras(p.idProveedor);
  }

  Future<void> _loadExtras(int id) async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _nitCtrl.text = prefs.getString('prov_nit_$id') ?? '';
      _productosSel
        ..clear()
        ..addAll(prefs.getStringList('prov_prods_$id') ?? []);
    });
  }

  Future<void> _saveExtras(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('prov_nit_$id', _nitCtrl.text.trim());
    await prefs.setStringList('prov_prods_$id', _productosSel.toList());
  }

  String get _dir {
    final c = _ciudadCtrl.text.trim();
    final d = _direccionCtrl.text.trim();
    if (c.isNotEmpty && d.isNotEmpty) return '$c | $d';
    return c.isNotEmpty ? c : d;
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
    setState(() => _loading = true);
    try {
      if (_edit) {
        final id = widget.proveedor!.idProveedor;
        await _service.actualizar(id: id, campos: {
          'nombre_proveedor': nombre,
          'telefono_proveedor': _telCtrl.text.trim(),
          'email_proveedor': _emailCtrl.text.trim(),
          'direccion_proveedor': _dir,
        });
        await _saveExtras(id);
        if (mounted) _snack('Proveedor actualizado');
      } else {
        String? n(String s) => s.trim().isEmpty ? null : s.trim();
        final creado = await _service.crear(
          nombreProveedor: nombre,
          telefonoProveedor: n(_telCtrl.text),
          emailProveedor: n(_emailCtrl.text),
          direccionProveedor: _dir.isEmpty ? null : _dir,
        );
        await _saveExtras(creado.idProveedor);
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
    final id = widget.proveedor?.idProveedor;
    if (id == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar proveedor'),
        content: const Text(
          '¿Eliminar este proveedor? Los productos vinculados '
          'quedarán sin proveedor asignado.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _loading = true);
    try {
      await _service.eliminar(id);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('prov_nit_$id');
      await prefs.remove('prov_prods_$id');
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
