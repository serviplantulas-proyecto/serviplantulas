import 'package:flutter/material.dart';

import '../componentes/clientes/client_card.dart';
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
  final ClientesService _service = ClientesService();
  final TextEditingController _searchController = TextEditingController();

  List<Cliente> _clientes = [];
  String? _expandidoId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    setState(() => _loading = true);
    final data = await _service.obtenerClientes(
      busqueda: _searchController.text,
    );
    if (mounted) {
      setState(() {
        _clientes = data;
        _loading = false;
      });
    }
  }

  Future<void> _filtrar() async {
    final data = await _service.obtenerClientes(
      busqueda: _searchController.text,
    );
    if (mounted) setState(() => _clientes = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildAppBar(),
            _buildSearch(),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _cargar,
                      color: AppColors.primary,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                        itemCount: _clientes.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final c = _clientes[index];
                          return ClientCard(
                            cliente: c,
                            expandido: _expandidoId == c.id,
                            onToggle: () {
                              setState(() {
                                _expandidoId =
                                    _expandidoId == c.id ? null : c.id;
                              });
                            },
                            onEditar: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetalleClientePage(cliente: c),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AgregarClientePage()),
          );
        },
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
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

  Widget _buildSearch() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: InventorySearchBar(
        controller: _searchController,
        hint: 'Buscar por Nombre, Cédula o NIT...',
        onChanged: (_) => _filtrar(),
      ),
    );
  }
}
