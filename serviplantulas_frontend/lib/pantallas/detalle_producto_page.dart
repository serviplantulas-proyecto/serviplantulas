import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../models/producto.dart';
import '../services/productos_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
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

  String _money(double v) {
    final s = v.toStringAsFixed(0);
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return '${buf.toString()} COP';
  }

  Future<void> _editar() async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrarProductoPage(producto: _producto),
      ),
    );
    if (ok == true && mounted) {
      try {
        final actualizado =
            await _service.obtenerPorId(_producto.idProducto);
        setState(() => _producto = actualizado);
      } catch (_) {
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _ajustarStock() async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AjustarStockPage(producto: _producto),
      ),
    );
    if (ok == true && mounted) {
      try {
        final actualizado =
            await _service.obtenerPorId(_producto.idProducto);
        setState(() => _producto = actualizado);
      } catch (_) {
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _eliminar() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text(
          '¿Seguro que quieres eliminar "${_producto.nombre}"?\n'
          'Esta acción no se puede deshacer.',
        ),
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

    if (confirmar != true || !mounted) return;

    setState(() => _eliminando = true);
    try {
      await _service.eliminar(_producto.idProducto);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto eliminado'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context, true);
    } on ProductosException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: AppColors.error,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo eliminar el producto'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _eliminando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = _producto;
    final desc = (p.descripcionProducto != null &&
            p.descripcionProducto!.trim().isNotEmpty)
        ? p.descripcionProducto!
        : 'Sin descripción.';

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
                    _imageBanner(p),
                    const SizedBox(height: AppSpacing.large),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _badge(p.categoria),
                        Text(
                          _money(p.precio),
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
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
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
                        'Costo compra: ${_money(p.costoCompra!)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.large),
                    Row(
                      children: [
                        _infoBox(
                          'Stock Actual',
                          '${p.stock} Unidades',
                          p.stockBajo ? AppColors.warning : AppColors.success,
                        ),
                        const SizedBox(width: 12),
                        _infoBox(
                          'Stock mínimo',
                          '${p.stockMinimo} Unidades',
                          AppColors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _infoBox('Proveedor', p.proveedor, AppColors.primary),
                        const SizedBox(width: 12),
                        _infoBox(
                          'ID',
                          '#${p.idProducto}',
                          AppColors.textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _editar,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              minimumSize: const Size(0, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.medium),
                              ),
                            ),
                            child: const Text('Editar Planta'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _eliminando ? null : _eliminar,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                              minimumSize: const Size(0, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.medium),
                              ),
                            ),
                            child: _eliminando
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Eliminar'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: _ajustarStock,
                        icon: const Icon(Icons.swap_vert, size: 18),
                        label: const Text('Ajustar Stock'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
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

  Widget _imageBanner(Producto producto) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.neutral,
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: producto.imagenUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.large),
              child: Image.network(
                producto.imagenUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.local_florist,
                  size: 64,
                  color: AppColors.mutedGreen,
                ),
              ),
            )
          : const Icon(
              Icons.local_florist,
              size: 64,
              color: AppColors.mutedGreen,
            ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.editBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: AppTextStyles.label.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _infoBox(String label, String value, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
