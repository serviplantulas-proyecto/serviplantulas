import '../models/cliente.dart';
import 'pedidos_service.dart';

/// Enriquece clientes con total de pedidos, última compra e historial.
class ClienteComprasHelper {
  final _pedidos = PedidosService();

  Future<List<Cliente>> enriquecer(List<Cliente> clientes) async {
    List<Map<String, dynamic>> pedidos;
    try {
      pedidos = await _pedidos.listarPedidosRaw();
    } catch (_) {
      return clientes;
    }

    final porCliente = <int, List<Map<String, dynamic>>>{};
    for (final p in pedidos) {
      final idC = _asInt(p['id_cliente']);
      porCliente.putIfAbsent(idC, () => []).add(p);
    }

    return clientes.map((c) {
      final list = porCliente[c.idCliente] ?? const [];
      if (list.isEmpty) return c;

      list.sort((a, b) {
        final da = _fecha(a) ?? DateTime(1970);
        final db = _fecha(b) ?? DateTime(1970);
        return db.compareTo(da);
      });

      final ultima = _fecha(list.first);
      String? ultimaStr;
      if (ultima != null) {
        const meses = [
          'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
          'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
        ];
        ultimaStr =
            '${ultima.day.toString().padLeft(2, '0')} ${meses[ultima.month - 1]} ${ultima.year}';
      }

      final historial = list.take(5).map((p) {
        final id = _asInt(p['id_pedido']);
        final total = _asDouble(p['total']);
        return PedidoResumen(
          facturaId: id.toString(),
          descripcion: 'Pedido #$id · ${p['metodo_pago'] ?? 'Venta'}',
          total: total,
        );
      }).toList();

      return c.copyWith(
        totalPedidos: list.length,
        ultimaCompra: ultimaStr,
        historialReciente: historial,
      );
    }).toList();
  }

  Future<Cliente> enriquecerUno(Cliente c) async {
    final list = await enriquecer([c]);
    return list.first;
  }

  DateTime? _fecha(Map<String, dynamic> p) {
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
