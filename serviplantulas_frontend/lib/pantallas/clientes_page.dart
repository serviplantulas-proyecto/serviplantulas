import 'package:flutter/material.dart';

import '../componentes/clientes/client_card.dart';
import '../componentes/clientes/cliente_filtro_chip.dart';
import '../componentes/inventario/inventory_search_bar.dart';
import '../models/cliente.dart';
import '../services/clientes_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import 'agregar_cliente_page.dart';
import 'detalle_cliente_page.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final _service = ClientesService();
  final _searchCtrl = TextEditingController();
  List<Cliente> _clientes = [];
  String? _expandidoId;
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
      final data = await _service.listar(busqueda: _searchCtrl.text);
      if (!mounted) return;
      setState(() {
        _clientes = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e is ClientesException
            ? e.message
            : 'No se pudieron cargar los clientes.';
      });
    }
  }

  Future<void> _filtrar() async {
    try {
      final data = await _service.listar(busqueda: _searchCtrl.text);
      if (mounted) setState(() => _clientes = data);
    } catch (_) {}
  }

  Future<void> _abrirAgregar() async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AgregarClientePage()),
    );
    if (ok == true) _cargar();
  }

  void _irDetalle(Cliente c) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetalleClientePage(cliente: c)),
    ).then((_) => _cargar());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _appBar(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: InventorySearchBar(
                controller: _searchCtrl,
                hint: 'Buscar por Nombre, Cédula o NIT...',
                onChanged: (_) => _filtrar(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ClienteFiltroChip(
                  filtroActivo: _filtroActivo,
                  onActivar: () =>
                      setState(() => _filtroActivo = 'Cédula de Ciudadanía'),
                  onQuitar: () => setState(() => _filtroActivo = null),
                ),
              ),
            ),
            Expanded(child: _body()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirAgregar,
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _appBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Directorio de Clientes',
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              fontSize: 18,
            ),
          ),
          const Icon(Icons.person_outline, color: AppColors.primary, size: 24),
        ],
      ),
    );
  }

  Widget _body() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_error!, textAlign: TextAlign.center),
          TextButton(onPressed: _cargar, child: const Text('Reintentar')),
        ]),
      );
    }
    if (_clientes.isEmpty) {
      return Center(
        child: Text(
          'No hay clientes',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _cargar,
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        itemCount: _clientes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final c = _clientes[i];
          return ClientCard(
            cliente: c,
            expandido: _expandidoId == c.id,
            onToggle: () => setState(
              () => _expandidoId = _expandidoId == c.id ? null : c.id,
            ),
            onVerDetalles: () => _irDetalle(c),
            onEditar: () async {
              final ok = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => AgregarClientePage(cliente: c),
                ),
              );
              if (ok == true) _cargar();
            },
          );
        },
      ),
    );
  }
}
