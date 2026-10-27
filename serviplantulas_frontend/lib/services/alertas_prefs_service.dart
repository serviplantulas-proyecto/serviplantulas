import 'package:shared_preferences/shared_preferences.dart';

import 'notificaciones_service.dart';
import 'productos_service.dart';

/// Preferencias de alertas (no hay endpoint de config en el backend).
/// Stock bajo usa stock_minimo de cada producto.
class AlertasPrefsService {
  static const _kStock = 'alerta_stock_bajo';
  static const _kVenta = 'alerta_venta_registrada';
  static const _kCliente = 'alerta_nuevo_cliente';
  static const _kFactura = 'alerta_factura_pendiente';
  static const _kDiario = 'alerta_recordatorio_diario';

  Future<Map<String, bool>> cargar() async {
    final p = await SharedPreferences.getInstance();
    return {
      'stock': p.getBool(_kStock) ?? true,
      'venta': p.getBool(_kVenta) ?? true,
      'cliente': p.getBool(_kCliente) ?? false,
      'factura': p.getBool(_kFactura) ?? true,
      'diario': p.getBool(_kDiario) ?? false,
    };
  }

  Future<void> guardar(Map<String, bool> flags) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kStock, flags['stock'] ?? true);
    await p.setBool(_kVenta, flags['venta'] ?? true);
    await p.setBool(_kCliente, flags['cliente'] ?? false);
    await p.setBool(_kFactura, flags['factura'] ?? true);
    await p.setBool(_kDiario, flags['diario'] ?? false);
  }

  /// Si stock bajo está activo: genera notificaciones por producto
  /// con stock < stock_minimo del producto.
  Future<int> sincronizarStockBajo() async {
    final flags = await cargar();
    if (flags['stock'] != true) return 0;

    final productos = await ProductosService().listar();
    final notifs = NotificacionesService();
    final existentes = await notifs.listar();
    var creadas = 0;

    for (final prod in productos) {
      final min = prod.stockMinimo;
      if (min <= 0) continue;
      if (prod.stock >= min) continue;

      final titulo = 'Alerta de Stock Crítico';
      final mensaje =
          'El stock de ${prod.nombre} ha bajado a ${prod.stock} unidades '
          '(Mínimo requerido: $min).';

      // Evitar duplicados recientes con mismo título+producto
      final yaHay = existentes.any((n) =>
          n.titulo == titulo &&
          n.mensaje.contains(prod.nombre) &&
          !n.leida);
      if (yaHay) continue;

      await notifs.crear(
        titulo: titulo,
        mensaje: mensaje,
        tipo: 'poco_stock',
        idProducto: prod.idProducto,
      );
      creadas++;
    }
    return creadas;
  }
}
