import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../componentes/ventas/factura_list_card.dart';
import 'api_config.dart';
import 'clientes_service.dart';
import 'pedidos_service.dart';
import 'productos_service.dart';

class FacturasException implements Exception {
  final String message;
  const FacturasException(this.message);
  @override
  String toString() => message;
}

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

      final nombreCliente = _str(p['nombre_cliente_snapshot']).isNotEmpty
          ? _str(p['nombre_cliente_snapshot'])
          : (cliente?.nombre ??
              (idCliente == null ? 'Cliente eliminado' : 'Cliente #$idCliente'));

      final emailCli = (cliente?.correoCliente ?? '').trim();

      final lineasRaw = porPedido[id] ?? const [];
      final lineas = lineasRaw.map((d) {
        final idProdRaw = d['id_producto'];
        final idProd = idProdRaw == null ? null : _asInt(idProdRaw);
        final prod = idProd == null ? null : productoMap[idProd];
        final snap = _str(d['nombre_producto_snapshot']);
        final nombre = snap.isNotEmpty
            ? snap
            : (prod?.nombre ??
                (idProd == null ? 'Producto eliminado' : 'Producto #$idProd'));
        return FacturaLinea(
          nombre: nombre,
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
          cliente: nombreCliente,
          documento: cliente != null
              ? '${cliente.tipoDocumento} ${cliente.documento}'
              : null,
          emailCliente: emailCli.isEmpty ? null : emailCli,
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

  String _str(dynamic v) => (v?.toString() ?? '').trim();

  String _formatFecha(dynamic raw) {
    if (raw == null) return '—';
    try {
      final dt = DateTime.parse(raw.toString()).toLocal();
      const meses = [
        'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
      ];
      final fecha =
          '${dt.day.toString().padLeft(2, '0')} ${meses[dt.month - 1]} ${dt.year}';
      final hora =
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      return '$fecha · $hora';
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

  Future<Map<String, dynamic>> enviarPorCorreo({
    required FacturaListItem factura,
    String? email,
    String? nombre,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      throw const FacturasException('Sin sesión.');
    }

    final body = {
      if (email != null && email.isNotEmpty) 'email': email,
      if (nombre != null && nombre.isNotEmpty) 'nombre': nombre,
      'factura': {
        'id': factura.id,
        'cliente': factura.cliente,
        'documento': factura.documento,
        'fecha': factura.fecha,
        'metodoPago': factura.metodoPago,
        'estado': factura.estado,
        'unidades': factura.unidades,
        'total': factura.total,
        'descuentoPct': factura.descuentoPct,
        'ivaPct': factura.ivaPct,
        'lineas': factura.lineas
            .map((l) => {
                  'nombre': l.nombre,
                  'cantidad': l.cantidad,
                  'unitario': l.unitario,
                })
            .toList(),
      },
    };

    try {
      final r = await http
          .post(
            Uri.parse(ApiConfig.pedidosEnviarFacturaUrl),
            headers: ApiConfig.authHeaders(token),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));
      final d =
          r.body.isEmpty ? null : jsonDecode(utf8.decode(r.bodyBytes));
      if (r.statusCode < 200 || r.statusCode >= 300) {
        final err = d is Map && d['error'] is String
            ? d['error'] as String
            : 'No se pudo enviar el correo.';
        throw FacturasException(err);
      }
      return d is Map<String, dynamic> ? d : {'message': 'Enviado'};
    } on SocketException {
      throw const FacturasException('Sin conexión.');
    } on TimeoutException {
      throw const FacturasException('Tiempo de espera agotado.');
    }
  }
}
