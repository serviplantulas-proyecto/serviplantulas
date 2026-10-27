import 'package:shared_preferences/shared_preferences.dart';

import '../models/dashboard_stats.dart';
import 'clientes_service.dart';
import 'notificaciones_service.dart';
import 'pedidos_service.dart';
import 'productos_service.dart';

class DashboardService {
  final _productos = ProductosService();
  final _clientes = ClientesService();
  final _pedidos = PedidosService();
  final _notifs = NotificacionesService();

  static const _labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  Future<DashboardStats> obtenerResumen() async {
    final productos = await _productos.listar();
    final clientes = await _clientes.listar();
    final pedidos = await _pedidos.listarPedidosRaw();
    final detalles = await _pedidos.listarDetallesRaw();
    final noLeidas = await _notifs.contarNoLeidas();

    final prefs = await SharedPreferences.getInstance();
    final nombre = prefs.getString('user_nombre') ?? 'Admin';

    final stockTotal =
        productos.fold<int>(0, (s, p) => s + (p.stock));
    final pendientes = pedidos.where((p) {
      final e = (p['estado'] ?? '').toString().toLowerCase();
      return e == 'pendiente';
    }).length;

    final hoy = DateTime.now();
    final hoy0 = DateTime(hoy.year, hoy.month, hoy.day);

    // Detalles por pedido
    final detPorPedido = <int, List<Map<String, dynamic>>>{};
    for (final d in detalles) {
      final id = _asInt(d['id_pedido']);
      detPorPedido.putIfAbsent(id, () => []).add(d);
    }

    double ventasHoy = 0;
    // Mapa día-offset desde lunes (0=lun) -> (monto, unidades)
    final montoDia = List<double>.filled(7, 0);
    final unidDia = List<int>.filled(7, 0);

    // Lunes de esta semana
    final lun = hoy0.subtract(Duration(days: hoy0.weekday - 1));

    for (final p in pedidos) {
      final dt = _fechaPedido(p);
      if (dt == null) continue;
      final day0 = DateTime(dt.year, dt.month, dt.day);
      final id = _asInt(p['id_pedido']);
      final total = _asDouble(p['total']);
      final unids = (detPorPedido[id] ?? const [])
          .fold<int>(0, (s, d) => s + _asInt(d['cantidad']));

      if (day0 == hoy0) ventasHoy += total;

      if (!day0.isBefore(lun) && !day0.isAfter(hoy0)) {
        final idx = day0.difference(lun).inDays; // 0..6
        if (idx >= 0 && idx < 7) {
          montoDia[idx] += total;
          unidDia[idx] += unids;
        }
      }
    }

    // Solo hasta el día actual (weekday 1=lun … 7=dom)
    final hasta = hoy0.weekday; // 1..7
    final historicoFinal = <SalesBarData>[];
    for (var i = 0; i < hasta; i++) {
      historicoFinal.add(SalesBarData(
        label: _labels[i],
        value: montoDia[i],
        unidades: unidDia[i],
        isHighlighted: i == hasta - 1,
      ));
    }

    return DashboardStats(
      ventasDelDia: ventasHoy,
      productosStock: stockTotal,
      clientesActivos: clientes.length,
      pedidosPendientes: pendientes,
      variacionSemanal: 0,
      historicoVentas: historicoFinal,
      notificacionesNoLeidas: noLeidas,
      nombreUsuario: nombre.isEmpty ? 'Admin' : nombre,
    );
  }

  DateTime? _fechaPedido(Map<String, dynamic> p) {
    final raw =
        p['fecha_pedido'] ?? p['created_at'] ?? p['creado_en'] ?? p['fecha'];
    if (raw == null) return null;
    return DateTime.tryParse(raw.toString())?.toLocal();
  }

  int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }

  double _asDouble(dynamic v) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v?.toString() ?? '') ?? 0;
  }
}
