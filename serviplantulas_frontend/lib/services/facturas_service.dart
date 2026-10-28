import '../componentes/ventas/factura_list_card.dart';
import 'clientes_service.dart';
import 'pedidos_service.dart';
import 'productos_service.dart';

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
      final idClienteRaw = p['id_cliente'];
      final idCliente = idClienteRaw == null ? null : _asInt(idClienteRaw);
      final cliente = idCliente == null ? null : clienteMap[idCliente];
      final lineasRaw = porPedido[id] ?? const [];
      final lineas = lineasRaw.map((d) {
        final idProdRaw = d['id_producto'];
        final idProd = idProdRaw == null ? null : _asInt(idProdRaw);
        final prod = idProd == null ? null : productoMap[idProd];
        return FacturaLinea(
          nombre:
              prod?.nombre ??
              (idProd == null ? 'Producto eliminado' : 'Producto #$idProd'),
          cantidad: _asInt(d['cantidad']),
          unitario: _asDouble(d['precio_unitario']),
        );
      }).toList();
      final unidades = lineas.fold<int>(0, (s, l) => s + l.cantidad);
      final estadoRaw = (p['estado'] ?? 'completado').toString().toLowerCase();
      final estado = estadoRaw == 'pendiente' ? 'Pendiente' : 'Pagada';
      final metodo = (p['metodo_pago'] ?? 'Efectivo').toString();

      facturas.add(
        FacturaListItem(
          id: id.toString(),
          cliente:
              cliente?.nombre ??
              (idCliente == null ? 'Cliente eliminado' : 'Cliente #$idCliente'),
          documento: cliente != null
              ? '${cliente.tipoDocumento} ${cliente.documento}'
              : null,
          fecha: _formatFecha(
            p['fecha_pedido'] ?? p['created_at'] ?? p['creado_en'],
          ),
          unidades: unidades,
          total: _asDouble(p['total']),
          estado: estado,
          metodoPago: metodo,
          lineas: lineas,
        ),
      );
    }
    facturas.sort((a, b) => int.parse(b.id).compareTo(int.parse(a.id)));
    return facturas;
  }

  String _formatFecha(dynamic raw) {
    if (raw == null) return '—';
    try {
      final dt = DateTime.parse(raw.toString()).toLocal();
      const meses = [
        'Ene',
        'Feb',
        'Mar',
        'Abr',
        'May',
        'Jun',
        'Jul',
        'Ago',
        'Sep',
        'Oct',
        'Nov',
        'Dic',
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
