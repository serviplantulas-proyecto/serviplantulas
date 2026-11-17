import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/productos/detalle_producto_actions.dart';
import '../componentes/productos/detalle_producto_helpers.dart';
import '../componentes/productos/detalle_producto_widgets.dart';
import '../models/producto.dart';
import '../services/productos_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';
import 'ajustar_stock_page.dart';
import 'registrar_producto_page.dart';

class DetalleProductoPage extends StatefulWidget {
  final Producto producto;

  const DetalleProductoPage({super.key, required this.producto});

  @override
  State<DetalleProductoPage> createState() => _DetalleProductoPageState();
}

class _DetalleProductoPageState extends State<DetalleProductoPage> {
  final _service = ProductosService();
  late Producto _producto;
  bool _eliminando = false;

  @override
  void initState() {
    super.initState();
    _producto = widget.producto;
  }
  Future<void> _volverSiCambio(Future<bool?> nav) async {
    final ok = await nav;
    if (ok == true && mounted) {
      final actualizado =
          await refrescarProducto(_service, _producto.idProducto);
      if (actualizado != null) {
        setState(() => _producto = actualizado);
      } else if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _editar() async {
    await _volverSiCambio(
      Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => RegistrarProductoPage(producto: _producto),
        ),
      ),
    );
  }

  Future<void> _ajustarStock() async {
    await _volverSiCambio(
      Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => AjustarStockPage(producto: _producto),
        ),
      ),
    );
  }

  Future<void> _eliminar() async {
    final ok = await confirmarEliminarProducto(context, _producto.nombre);
    if (!ok || !mounted) return;

    setState(() => _eliminando = true);
    try {
      await _service.eliminar(_producto.idProducto);
      if (!mounted) return;
      snackDetalle(context, 'Producto eliminado');
      Navigator.pop(context, true);
    } on ProductosException catch (e) {
      if (!mounted) return;
      snackDetalle(context, e.message, error: true);
      setState(() => _eliminando = false);
    } catch (_) {
      if (!mounted) return;
      snackDetalle(context, 'No se pudo eliminar el producto', error: true);
      setState(() => _eliminando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = _producto;
    final desc = (p.descripcion == null || p.descripcion!.trim().isEmpty)
        ? 'Sin descripción'
        : p.descripcion!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Detalle de Planta'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetalleProductoImageBanner(producto: p),
                    const SizedBox(height: AppSpacing.large),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DetalleProductoBadge(text: p.categoria),
                        Text(
                          detalleMoney(p.precio),
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      p.nombre,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      desc,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (p.costoCompra != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Costo compra: ${detalleMoney(p.costoCompra!)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.large),
                    Row(
                      children: [
                        DetalleProductoInfoBox(
                          label: 'Stock Actual',
                          value: '${p.stock} Unidades',
                          valueColor: p.stockBajo
                              ? AppColors.warning
                              : AppColors.success,
                        ),
                        const SizedBox(width: 12),
                        DetalleProductoInfoBox(
                          label: 'Stock mínimo',
                          value: '${p.stockMinimo} Unidades',
                          valueColor: AppColors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        DetalleProductoInfoBox(
                          label: 'Proveedor',
                          value: p.proveedor,
                          valueColor: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        DetalleProductoInfoBox(
                          label: 'ID',
                          value: '#${p.idProducto}',
                          valueColor: AppColors.textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    DetalleProductoActions(
                      onEditar: _editar,
                      onEliminar: _eliminar,
                      onAjustarStock: _ajustarStock,
                      eliminando: _eliminando,
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
