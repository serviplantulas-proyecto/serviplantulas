import 'package:shared_preferences/shared_preferences.dart';

import 'notificaciones_service.dart';
import 'productos_service.dart';

class AlertasPrefsService {
  static const _kStock = 'alerta_stock_bajo';
  static const _kVenta = 'alerta_venta_registrada';
  static const _kCliente = 'alerta_nuevo_cliente';
  static const _kFactura = 'alerta_factura_pendiente';
  static const _kDiario = 'alerta_recordatorio_diario';
  static const _kRetencionDias = 'alerta_retencion_dias';

  Future<Map<String, dynamic>> cargar() async {
    final p = await SharedPreferences.getInstance();
    return {
      'stock': p.getBool(_kStock) ?? true,
      'venta': p.getBool(_kVenta) ?? true,
      'cliente': p.getBool(_kCliente) ?? false,
      'factura': p.getBool(_kFactura) ?? true,
      'diario': p.getBool(_kDiario) ?? false,
      'retencionDias': p.getInt(_kRetencionDias) ?? 30,
    };
  }

  Future<void> guardar(Map<String, dynamic> flags) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kStock, flags['stock'] == true);
    await p.setBool(_kVenta, flags['venta'] == true);
    await p.setBool(_kCliente, flags['cliente'] == true);
    await p.setBool(_kFactura, flags['factura'] == true);
    await p.setBool(_kDiario, flags['diario'] == true);
    final dias = flags['retencionDias'];
    if (dias is int) await p.setInt(_kRetencionDias, dias);
  }

  Future<int> retencionDias() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt(_kRetencionDias) ?? 30;
  }

  /// Aplica retención en backend y genera alertas de stock si aplica.
  Future<String> guardarYAplicar(Map<String, dynamic> flags) async {
    await guardar(flags);
    final dias = flags['retencionDias'] is int
        ? flags['retencionDias'] as int
        : 30;
    var msg = 'Configuración guardada';
    try {
      final n = await NotificacionesService().limpiarAntiguas(dias);
      if (n > 0) msg = 'Guardado. $n notificación(es) antigua(s) eliminada(s).';
    } catch (_) {
      // Preferencias sí se guardaron
    }
    if (flags['stock'] == true) {
      final c = await sincronizarStockBajo();
      if (c > 0) {
        msg = '$msg $c alerta(s) de stock generada(s).';
      }
    }
    return msg;
  }

  Future<int> sincronizarStockBajo() async {
    final flags = await cargar();
    if (flags['stock'] != true) return 0;
    final productos = await ProductosService().listar();
    final notifs = NotificacionesService();
    final existentes = await notifs.listar();
    var creadas = 0;
    for (final prod in productos) {
      final min = prod.stockMinimo;
      if (min <= 0 || prod.stock >= min) continue;
      final titulo = 'Alerta de Stock Crítico';
      final mensaje =
          'El stock de ${prod.nombre} ha bajado a ${prod.stock} unidades '
          '(Mínimo requerido: $min).';
      final yaHay = existentes.any((n) =>
          n.titulo == titulo && n.mensaje.contains(prod.nombre) && !n.leida);
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
