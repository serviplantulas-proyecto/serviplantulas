import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/inventario/inventory_search_bar.dart';
import '../componentes/proveedores/proveedor_expandable_card.dart';
import '../models/proveedor.dart';
import '../services/proveedores_service.dart';
import '../styles/app_colors.dart';
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
  List<Proveedor> _todos = [];
  List<Proveedor> _filtrados = [];
  int? _expandedId;
  bool _loading = true;
  String? _error;
  String? _filtroActivo;

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
      final lista = await _service.listar();
      if (!mounted) return;
      setState(() {
        _todos = lista;
        _aplicarFiltro();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e is ProveedoresException
            ? e.message
            : 'No se pudieron cargar los proveedores.';
      });
    }
  }

  void _aplicarFiltro() {
    final q = _searchCtrl.text.trim().toLowerCase();
    _filtrados = q.isEmpty
        ? List.from(_todos)
        : _todos
            .where((p) =>
                p.nombreProveedor.toLowerCase().contains(q) ||
                (p.contactoRepresentante?.toLowerCase().contains(q) ??
                    false) ||
                (p.telefonoProveedor?.contains(q) ?? false) ||
                (p.emailProveedor?.toLowerCase().contains(q) ?? false) ||
                (p.direccionProveedor?.toLowerCase().contains(q) ?? false))
            .toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Directorio de Proveedores'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: InventorySearchBar(
                controller: _searchCtrl,
                hint: 'Buscar por Nombre, NIT o RUT...',
                onChanged: (_) => setState(_aplicarFiltro),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _filtroActivo != null
                    ? _chip(_filtroActivo!)
                    : GestureDetector(
                        onTap: () => setState(() => _filtroActivo = 'NIT'),
                        child: Text(
                          'Filtro: NIT',
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
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

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE8E0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text('Filtro: $label',
            style: AppTextStyles.label
                .copyWith(color: AppColors.accent, fontWeight: FontWeight.w700)),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () => setState(() => _filtroActivo = null),
          child: Icon(Icons.close, size: 16, color: AppColors.accent),
        ),
      ]),
    );
  }

  Widget _body() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            TextButton(onPressed: _cargar, child: const Text('Reintentar')),
          ],
        ),
      );
    }
    if (_filtrados.isEmpty) {
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
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        itemCount: _filtrados.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final p = _filtrados[i];
          final expanded = _expandedId == p.idProveedor;
          return ProveedorExpandableCard(
            proveedor: p,
            expanded: expanded,
            onToggle: () => setState(
              () => _expandedId = expanded ? null : p.idProveedor,
            ),
            onEdit: () => _abrirForm(proveedor: p),
          );
        },
      ),
    );
  }
}
