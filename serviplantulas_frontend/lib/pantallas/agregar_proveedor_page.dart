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
  bool _isLoading = false;

  bool get _esEdicion => widget.proveedor != null;

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
    _cargarExtras(p.idProveedor);
  }

  Future<void> _cargarExtras(int id) async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _nitCtrl.text = prefs.getString('prov_nit_$id') ?? '';
      _productosSel
        ..clear()
        ..addAll(prefs.getStringList('prov_prods_$id') ?? []);
    });
  }

  Future<void> _guardarExtras(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('prov_nit_$id', _nitCtrl.text.trim());
    await prefs.setStringList('prov_prods_$id', _productosSel.toList());
  }

  String get _dirCompleta {
    final c = _ciudadCtrl.text.trim();
    final d = _direccionCtrl.text.trim();
    if (c.isNotEmpty && d.isNotEmpty) return '$c | $d';
    return c.isNotEmpty ? c : d;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _nitCtrl.dispose();
    _telCtrl.dispose();
    _emailCtrl.dispose();
    _direccionCtrl.dispose();
    _ciudadCtrl.dispose();
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
      final dir = _dirCompleta;
      if (_esEdicion) {
        final id = widget.proveedor!.idProveedor;
        await _service.actualizar(id: id, campos: {
          'nombre_proveedor': nombre,
          'telefono_proveedor': _telCtrl.text.trim(),
          'email_proveedor': _emailCtrl.text.trim(),
          'direccion_proveedor': dir,
        });
        await _guardarExtras(id);
        if (!mounted) return;
        _snack('Proveedor actualizado');
      } else {
        String? n(String s) => s.trim().isEmpty ? null : s.trim();
        final creado = await _service.crear(
          nombreProveedor: nombre,
          telefonoProveedor: n(_telCtrl.text),
          emailProveedor: n(_emailCtrl.text),
          direccionProveedor: dir.isEmpty ? null : dir,
        );
        await _guardarExtras(creado.idProveedor);
        if (!mounted) return;
        _snack('Proveedor guardado');
      }
      Navigator.pop(context, true);
    } on ProveedoresException catch (e) {
      if (mounted) _snack(e.message, error: true);
    } catch (_) {
      if (mounted) _snack('Error al guardar', error: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? AppColors.error : AppColors.success,
    ));
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
                text: 'Guardar Proveedor',
                isLoading: _isLoading,
                onPressed: _guardar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
