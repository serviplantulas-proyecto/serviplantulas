import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/producto.dart';
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

  Future<bool> _flag(String key, {bool def = true}) async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(key) ?? def;
  }

  Future<String> guardarYAplicar(Map<String, dynamic> flags) async {
    await guardar(flags);
    final dias =
        flags['retencionDias'] is int ? flags['retencionDias'] as int : 30;
    var msg = 'Configuración guardada';
    try {
      final n = await NotificacionesService().limpiarAntiguas(dias);
      if (n > 0) msg = 'Guardado. $n notificación(es) antigua(s) eliminada(s).';
    } catch (_) {}
    if (flags['stock'] == true) {
      final c = await sincronizarStockBajo();
      if (c > 0) msg = '$msg $c alerta(s) de stock generada(s).';
    }
    return msg;
  }

  Future<void> solicitarPermisoNotificaciones() async {
    final status = await Permission.notification.request();
    if (status.isPermanentlyDenied) await openAppSettings();
  }

  /// Stock bajo + sin existencias (respeta preferencia stock).
  Future<int> sincronizarStockBajo() async {
    if (!await _flag(_kStock)) return 0;
    final productos = await ProductosService().listar();
    final notifs = NotificacionesService();
    final existentes = await notifs.listar();
    var creadas = 0;
    for (final prod in productos) {
      final r = await _crearStockSiAplica(notifs, existentes, prod);
      if (r) {
        creadas++;
        existentes.add(NotificacionItem(
          id: 0,
          titulo: '',
          mensaje: prod.nombre,
          tipo: prod.stock == 0 ? 'sin_stock' : 'poco_stock',
          leida: false,
        ));
      }
    }
    return creadas;
  }

  Future<void> evaluarProducto(Producto prod) async {
    if (!await _flag(_kStock)) return;
    final notifs = NotificacionesService();
    final existentes = await notifs.listar();
    await _crearStockSiAplica(notifs, existentes, prod);
  }

  Future<bool> _crearStockSiAplica(
    NotificacionesService notifs,
    List existentes,
    Producto prod,
  ) async {
    if (prod.stock == 0) {
      if (_yaTipo(existentes, 'sin_stock', prod)) return false;
      await notifs.crear(
        titulo: 'Sin existencias',
        mensaje:
            'El producto ${prod.nombre} se quedó sin existencias (0 unidades).',
        tipo: 'sin_stock',
        idProducto: prod.idProducto,
      );
      return true;
    }
    final min = prod.stockMinimo;
    if (min <= 0 || prod.stock > min) return false;
    if (_yaTipo(existentes, 'poco_stock', prod)) return false;
    await notifs.crear(
      titulo: 'Alerta de Stock Crítico',
      mensaje:
          'El stock de ${prod.nombre} ha bajado a ${prod.stock} unidades '
          '(Mínimo requerido: $min).',
      tipo: 'poco_stock',
      idProducto: prod.idProducto,
    );
    return true;
  }

  bool _yaTipo(List existentes, String tipo, Producto prod) {
    return existentes.any((n) =>
        n.tipo == tipo &&
        !n.leida &&
        (n.mensaje.contains(prod.nombre) ||
            n.mensaje.contains(prod.nombreProducto)));
  }

  /// Alerta "Venta registrada" (si está activa en preferencias).
  Future<void> notificarVenta({
    required String cliente,
    required double total,
    required int idPedido,
  }) async {
    if (!await _flag(_kVenta)) return;
    try {
      final t = total.toStringAsFixed(0);
      await NotificacionesService().crear(
        titulo: 'Venta registrada',
        mensaje: 'Pedido #$idPedido · $cliente · $t COP',
        tipo: 'venta_registrada',
      );
    } catch (_) {}
  }

  /// Alerta "Nuevo cliente".
  Future<void> notificarNuevoCliente(String nombre) async {
    if (!await _flag(_kCliente, def: false)) return;
    try {
      await NotificacionesService().crear(
        titulo: 'Nuevo cliente',
        mensaje: 'Se agregó al directorio: $nombre',
        tipo: 'nuevo_cliente',
      );
    } catch (_) {}
  }
}
