import '../componentes/ventas/factura_list_card.dart';
import '../services/clientes_service.dart';
import '../services/pedidos_service.dart';
import '../services/productos_service.dart';

/// Arma FacturaListItem desde pedidos + detalles + clientes + productos.
class FacturasService {
  final _pedidos = PedidosService();
  final _clientes = ClientesService();
  final _productos = ProductosService();

  Future<List<FacturaListItem>> listar() async {
    final pedidos = await _pedidos.listarPedidosRaw();
    final detalles = await _pedidos.listarDetallesRaw();
    final clientes = await _clientes.listar();
    final productos = await _productos.listar();

    final clienteMap = {for (final c in clientes) c.idCliente: c};
    final productoMap = {for (final p in productos) p.idProducto: p};

    final porPedido = <int, List<Map<String, dynamic>>>{};
    for (final d in detalles) {
      final idP = _asInt(d['id_pedido']);
      porPedido.putIfAbsent(idP, () => []).add(d);
    }

    final facturas = <FacturaListItem>[];
    for (final p in pedidos) {
      final id = _asInt(p['id_pedido']);
      final idCliente = _asInt(p['id_cliente']);
      final cliente = clienteMap[idCliente];
      final lineasRaw = porPedido[id] ?? const [];
      final lineas = lineasRaw.map((d) {
        final idProd = _asInt(d['id_producto']);
        final prod = productoMap[idProd];
        return FacturaLinea(
          nombre: prod?.nombre ?? 'Producto #$idProd',
          cantidad: _asInt(d['cantidad']),
          unitario: _asDouble(d['precio_unitario']),
        );
      }).toList();
      final unidades = lineas.fold<int>(0, (s, l) => s + l.cantidad);
      final estadoRaw = (p['estado'] ?? 'completado').toString().toLowerCase();
      final estado = estadoRaw == 'pendiente' ? 'Pendiente' : 'Pagada';

      facturas.add(FacturaListItem(
        id: id.toString(),
        cliente: cliente?.nombre ?? 'Cliente #$idCliente',
        documento: cliente != null
            ? '${cliente.tipoDocumento} ${cliente.documento}'
            : null,
        fecha: _formatFecha(
          p['fecha_pedido'] ?? p['created_at'] ?? p['creado_en'],
        ),
        unidades: unidades,
        total: _asDouble(p['total']),
        estado: estado,
        lineas: lineas,
      ));
    }
    facturas.sort((a, b) => int.parse(b.id).compareTo(int.parse(a.id)));
    return facturas;
  }

  String _formatFecha(dynamic raw) {
    if (raw == null) return '—';
    try {
      final dt = DateTime.parse(raw.toString()).toLocal();
      const meses = [
        'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
      ];
      return '${dt.day.toString().padLeft(2, '0')} ${meses[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw.toString();
    }
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
