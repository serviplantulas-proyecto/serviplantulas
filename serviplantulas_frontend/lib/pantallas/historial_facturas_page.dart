import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/inventario/inventory_search_bar.dart';
import '../componentes/ventas/factura_filtro_chips.dart';
import '../componentes/ventas/factura_list_card.dart';
import '../services/facturas_service.dart';
import '../services/pedidos_service.dart';
import '../styles/app_colors.dart';
import 'generar_factura_page.dart';

class HistorialFacturasPage extends StatefulWidget {
  const HistorialFacturasPage({super.key});

  @override
  State<HistorialFacturasPage> createState() => _HistorialFacturasPageState();
}

class _HistorialFacturasPageState extends State<HistorialFacturasPage> {
  final _searchCtrl = TextEditingController();
  final _service = FacturasService();
  FacturaFiltro _filtro = FacturaFiltro.todas;
  List<FacturaListItem> _facturas = [];
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
      final data = await _service.listar();
      if (!mounted) return;
      setState(() {
        _facturas = data;
        _loading = false;
      });
    } on PedidosException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'No se pudieron cargar las facturas.';
      });
    }
  }

  List<FacturaListItem> get _filtradas {
    final q = _searchCtrl.text.trim().toLowerCase();
    return _facturas.where((f) {
      final matchFiltro = switch (_filtro) {
        FacturaFiltro.todas => true,
        FacturaFiltro.pendientes => !f.isPagada,
        FacturaFiltro.pagadas => f.isPagada,
      };
      final matchSearch = q.isEmpty ||
          f.id.toLowerCase().contains(q) ||
          f.cliente.toLowerCase().contains(q);
      return matchFiltro && matchSearch;
    }).toList();
  }

  void _abrirResumen(FacturaListItem f) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GenerarFacturaPage(factura: f)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtradas;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Historial de Facturas'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: InventorySearchBar(
                controller: _searchCtrl,
                hint: 'Buscar por Factura o Cliente...',
                onChanged: (_) => setState(() {}),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: FacturaFiltroChips(
                selected: _filtro,
                onChanged: (f) => setState(() => _filtro = f),
              ),
            ),
            Expanded(child: _body(items)),
          ],
        ),
      ),
    );
  }

  Widget _body(List<FacturaListItem> items) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_error!, textAlign: TextAlign.center),
          TextButton(onPressed: _cargar, child: const Text('Reintentar')),
        ]),
      );
    }
    if (items.isEmpty) {
      return Center(
        child: Text('No hay facturas',
            style: TextStyle(color: AppColors.textMuted)),
      );
    }
    return RefreshIndicator(
      onRefresh: _cargar,
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final f = items[i];
          return FacturaListCard(
            factura: f,
            onTap: () => _abrirResumen(f),
          );
        },
      ),
    );
  }
}
