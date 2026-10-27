import 'package:flutter/material.dart';

import '../componentes/boton/app_button.dart';
import '../componentes/clientes/cliente_detalle_info.dart';
import '../componentes/compartidos/app_bar_simple.dart';
import '../models/cliente.dart';
import '../services/cliente_compras_helper.dart';
import '../services/clientes_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import 'agregar_cliente_page.dart';

class DetalleClientePage extends StatefulWidget {
  final Cliente cliente;

  const DetalleClientePage({super.key, required this.cliente});

  @override
  State<DetalleClientePage> createState() => _DetalleClientePageState();
}

class _DetalleClientePageState extends State<DetalleClientePage> {
  final _service = ClientesService();
  final _compras = ClienteComprasHelper();
  late Cliente _cliente;
  bool _eliminando = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cliente = widget.cliente;
    _refrescar();
  }

  Future<void> _refrescar() async {
    setState(() => _loading = true);
    try {
      final base = await _service.obtenerPorId(_cliente.idCliente);
      final full = await _compras.enriquecerUno(base);
      if (!mounted) return;
      setState(() {
        _cliente = full;
        _loading = false;
      });
    } catch (_) {
      try {
        final full = await _compras.enriquecerUno(_cliente);
        if (!mounted) return;
        setState(() {
          _cliente = full;
          _loading = false;
        });
      } catch (_) {
        if (mounted) setState(() => _loading = false);
      }
    }
  }

  Future<void> _editar() async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AgregarClientePage(cliente: _cliente),
      ),
    );
    if (ok == true && mounted) _refrescar();
  }

  Future<void> _eliminar() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar cliente'),
        content: Text('¿Eliminar a "${_cliente.nombre}"?'),
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
    setState(() => _eliminando = true);
    try {
      await _service.eliminar(_cliente.idCliente);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Cliente eliminado'),
        backgroundColor: AppColors.success,
      ));
      Navigator.pop(context, true);
    } on ClientesException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message),
          backgroundColor: AppColors.error,
        ));
      }
    } finally {
      if (mounted) setState(() => _eliminando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _cliente;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Detalle del Cliente'),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClienteDetalleInfo(cliente: c),
                          const SizedBox(height: 24),
                          Text(
                            'Últimas Compras',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (c.historialReciente.isEmpty)
                            Text(
                              'Sin compras registradas',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textMuted,
                              ),
                            )
                          else
                            ...c.historialReciente
                                .map((p) => ClienteCompraItem(pedido: p)),
                          const SizedBox(height: 28),
                          AppButton(
                            text: 'Editar Datos del Cliente',
                            onPressed: _editar,
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: TextButton(
                              onPressed: _eliminando ? null : _eliminar,
                              child: Text(
                                _eliminando
                                    ? 'Eliminando...'
                                    : 'Eliminar Cliente',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
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
