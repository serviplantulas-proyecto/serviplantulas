import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/inventario/inventory_search_bar.dart';
import '../componentes/ventas/factura_filtro_chips.dart';
import '../componentes/ventas/factura_list_card.dart';
import '../styles/app_colors.dart';
import 'generar_factura_page.dart';

class HistorialFacturasPage extends StatefulWidget {
  const HistorialFacturasPage({super.key});

  @override
  State<HistorialFacturasPage> createState() => _HistorialFacturasPageState();
}

class _HistorialFacturasPageState extends State<HistorialFacturasPage> {
  final _searchCtrl = TextEditingController();
  FacturaFiltro _filtro = FacturaFiltro.todas;

  // Mock — conectar GET /facturas
  final _facturas = const [
    FacturaListItem(
      id: 'FAC-1045',
      cliente: 'Carlos Restrepo Restrepo',
      documento: 'C.C. 1045230981',
      fecha: '12 Oct 2023',
      unidades: 4,
      total: 81225,
      estado: 'Pagada',
      vendedor: 'David',
      descuentoPct: 5,
      lineas: [
        FacturaLinea(
          nombre: "Helecho Boston Maceta 10''",
          cantidad: 3,
          unitario: 22500,
        ),
        FacturaLinea(
          nombre: 'Cuna de Moisés (Spathiphyllum)',
          cantidad: 1,
          unitario: 18000,
        ),
      ],
    ),
    FacturaListItem(
      id: 'FAC-1044',
      cliente: 'Diana María Gómez Trujillo',
      documento: 'C.C. 52987654',
      fecha: '11 Oct 2023',
      unidades: 6,
      total: 120000,
      estado: 'Pendiente',
      vendedor: 'David',
      descuentoPct: 0,
      lineas: [
        FacturaLinea(
          nombre: 'Anturio Rojo Maceta 6"',
          cantidad: 6,
          unitario: 20000,
        ),
      ],
    ),
    FacturaListItem(
      id: 'FAC-1043',
      cliente: 'Inversiones del Bosque S.A.S',
      documento: 'NIT 900123456',
      fecha: '09 Oct 2023',
      unidades: 12,
      total: 345000,
      estado: 'Pagada',
      vendedor: 'Ana',
      descuentoPct: 5,
      lineas: [
        FacturaLinea(
          nombre: "Helecho Boston Maceta 10''",
          cantidad: 12,
          unitario: 22500,
        ),
      ],
    ),
    FacturaListItem(
      id: 'FAC-1042',
      cliente: 'María Camila Pérez',
      documento: 'C.C. 1012345678',
      fecha: '08 Oct 2023',
      unidades: 2,
      total: 45000,
      estado: 'Pagada',
      vendedor: 'David',
      lineas: [
        FacturaLinea(
          nombre: 'Cuna de Moisés (Spathiphyllum)',
          cantidad: 2,
          unitario: 18000,
        ),
      ],
    ),
    FacturaListItem(
      id: 'FAC-1041',
      cliente: 'Andrés Felipe Muñoz',
      documento: 'C.C. 1098765432',
      fecha: '05 Oct 2023',
      unidades: 1,
      total: 18000,
      estado: 'Pendiente',
      vendedor: 'Ana',
      lineas: [
        FacturaLinea(
          nombre: 'Cuna de Moisés (Spathiphyllum)',
          cantidad: 1,
          unitario: 18000,
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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
      MaterialPageRoute(
        builder: (_) => GenerarFacturaPage(factura: f),
      ),
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
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        'No hay facturas',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    )
                  : ListView.separated(
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
            ),
          ],
        ),
      ),
    );
  }
}
