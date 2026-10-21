import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/inventario/inventory_search_bar.dart';
import '../models/proveedor.dart';
import '../services/proveedores_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_text_styles.dart';
import 'agregar_proveedor_page.dart';

class DirectorioProveedoresPage extends StatefulWidget {
  const DirectorioProveedoresPage({super.key});

  @override
  State<DirectorioProveedoresPage> createState() =>
      _DirectorioProveedoresPageState();
}

class _DirectorioProveedoresPageState extends State<DirectorioProveedoresPage> {
  final _service = ProveedoresService();
  final _searchCtrl = TextEditingController();
  List<Proveedor> _proveedores = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final lista = await _service.listar(busqueda: _searchCtrl.text);
      if (!mounted) return;
      setState(() {
        _proveedores = lista;
        _loading = false;
      });
    } on ProveedoresException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'No se pudieron cargar los proveedores.';
      });
    }
  }

  Future<void> _filtrar() async {
    try {
      final lista = await _service.listar(busqueda: _searchCtrl.text);
      if (mounted) setState(() => _proveedores = lista);
    } catch (_) {}
  }

  Future<void> _abrirForm({Proveedor? proveedor}) async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AgregarProveedorPage(proveedor: proveedor),
      ),
    );
    if (ok == true) _cargar();
  }

  Future<void> _eliminar(Proveedor p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar proveedor'),
        content: Text('¿Eliminar "${p.nombreProveedor}"?'),
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
    if (ok != true) return;
    try {
      await _service.eliminar(p.idProveedor);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Proveedor eliminado'),
          backgroundColor: AppColors.success,
        ),
      );
      _cargar();
    } on ProveedoresException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Directorio de Proveedores'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: InventorySearchBar(
                controller: _searchCtrl,
                hint: 'Buscar proveedor, contacto o teléfono...',
                onChanged: (_) => _filtrar(),
              ),
            ),
            Expanded(child: _body()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirForm(),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _body() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              TextButton(onPressed: _cargar, child: const Text('Reintentar')),
            ],
          ),
        ),
      );
    }
    if (_proveedores.isEmpty) {
      return Center(
        child: Text(
          'No hay proveedores',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _cargar,
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        itemCount: _proveedores.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final p = _proveedores[i];
          final sub = [
            if (p.contactoRepresentante != null &&
                p.contactoRepresentante!.isNotEmpty)
              p.contactoRepresentante!,
            if (p.telefonoProveedor != null && p.telefonoProveedor!.isNotEmpty)
              p.telefonoProveedor!,
          ].join(' · ');

          return GestureDetector(
            onTap: () => _abrirForm(proveedor: p),
            onLongPress: () => _eliminar(p),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.large),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.editBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.local_shipping_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.nombreProveedor,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        if (sub.isNotEmpty)
                          Text(
                            sub,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        if (p.emailProveedor != null &&
                            p.emailProveedor!.isNotEmpty)
                          Text(
                            p.emailProveedor!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textMuted),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
