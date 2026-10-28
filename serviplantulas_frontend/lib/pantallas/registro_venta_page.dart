import 'package:flutter/material.dart';

import '../componentes/boton/app_button.dart';
import '../componentes/ventas/registro_venta_controller.dart';
import '../componentes/ventas/venta_cliente_section.dart';
import '../componentes/ventas/venta_metodo_pago.dart';
import '../componentes/ventas/venta_page_app_bar.dart';
import '../componentes/ventas/venta_productos_section.dart';
import '../componentes/ventas/venta_totales.dart';
import '../models/cliente.dart';
import '../models/producto.dart';
import '../services/pedidos_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_spacing.dart';
import 'agregar_cliente_page.dart';

class RegistroVentaPage extends StatefulWidget {
  const RegistroVentaPage({super.key});

  @override
  State<RegistroVentaPage> createState() => _RegistroVentaPageState();
}

class _RegistroVentaPageState extends State<RegistroVentaPage> {
  final _ctrl = RegistroVentaController();
  final _clienteSearchCtrl = TextEditingController();
  final _productoSearchCtrl = TextEditingController();

  List<Cliente> _sugerenciasCliente = [];
  List<Producto> _sugerenciasProducto = [];
  bool _isLoading = false;
  bool _cargandoCatalogo = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      await _ctrl.cargarCatalogo();
    } catch (_) {}
    if (mounted) setState(() => _cargandoCatalogo = false);
  }

  @override
  void dispose() {
    _clienteSearchCtrl.dispose();
    _productoSearchCtrl.dispose();
    super.dispose();
  }

  void _snack(String m, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(m),
      backgroundColor: error ? AppColors.error : AppColors.success,
    ));
  }

  Future<void> _registrar() async {
    setState(() => _isLoading = true);
    try {
      final id = await _ctrl.registrar();
      if (!mounted) return;
      _snack('Venta #$id registrada');
      Navigator.pop(context, true);
    } on PedidosException catch (e) {
      if (mounted) _snack(e.message, error: true);
    } catch (_) {
      if (mounted) _snack('Error al registrar la venta', error: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const VentaPageAppBar(title: 'Nueva Venta'),
            if (_cargandoCatalogo) const LinearProgressIndicator(minHeight: 2),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VentaClienteSection(
                      cliente: _ctrl.cliente,
                      searchController: _clienteSearchCtrl,
                      sugerencias: _sugerenciasCliente,
                      onNuevoCliente: () async {
                        final ok = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AgregarClientePage(),
                          ),
                        );
                        if (ok == true) _cargar();
                      },
                      onSearchChanged: (q) => setState(
                        () => _sugerenciasCliente = _ctrl.filtrarClientes(q),
                      ),
                      onClienteSeleccionado: (c) {
                        setState(() {
                          _ctrl.seleccionarCliente(c);
                          _clienteSearchCtrl.text =
                              '${c.tipoDocumento} ${c.documento} - ${c.nombre}';
                          _sugerenciasCliente = [];
                        });
                      },
                      onClearSearch: () {
                        setState(() {
                          _clienteSearchCtrl.clear();
                          _sugerenciasCliente = [];
                          _ctrl.limpiarCliente();
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    VentaProductosSection(
                      items: _ctrl.items,
                      searchController: _productoSearchCtrl,
                      sugerencias: _sugerenciasProducto,
                      onIncrement: (i) =>
                          setState(() => _ctrl.cambiarCantidad(i, 1)),
                      onDecrement: (i) =>
                          setState(() => _ctrl.cambiarCantidad(i, -1)),
                      onCantidadChanged: (i, v) =>
                          setState(() => _ctrl.setCantidad(i, v)),
                      onSearchChanged: (q) => setState(
                        () => _sugerenciasProducto = _ctrl.filtrarProductos(q),
                      ),
                      onProductoSeleccionado: (p) {
                        setState(() {
                          _ctrl.agregarProducto(p);
                          _productoSearchCtrl.clear();
                          _sugerenciasProducto = [];
                        });
                      },
                      onClearSearch: () {
                        setState(() {
                          _productoSearchCtrl.clear();
                          _sugerenciasProducto = [];
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    VentaMetodoPago(
                      value: _ctrl.metodoPago,
                      onChanged: (m) => setState(() => _ctrl.metodoPago = m),
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    VentaTotales(
                      subtotal: _ctrl.subtotal,
                      descuento: _ctrl.descuento,
                      total: _ctrl.total,
                      porcentajeDescuento:
                          _ctrl.cliente?.descuentoFrecuente ?? 0,
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    AppButton(
                      text: 'Registrar Venta',
                      type: AppButtonType.accent,
                      icon: Icons.check,
                      isLoading: _isLoading,
                      onPressed: _ctrl.items.isEmpty ? null : _registrar,
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
}
