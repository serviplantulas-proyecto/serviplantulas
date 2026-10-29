import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../componentes/ventas/venta_productos_section.dart';
import 'api_config.dart';

class PedidosException implements Exception {
  final String message;
  const PedidosException(this.message);
  @override
  String toString() => message;
}

class PedidosService {
  Future<int> registrarVenta({
    required int idCliente,
    required List<ItemVenta> items,
    String metodoPago = 'Efectivo',
    String? observaciones,
    String? nombreCliente,
  }) async {
    if (items.isEmpty) {
      throw const PedidosException('Agrega al menos un producto.');
    }
    final token = await _token();
    final creado = await _post(
      Uri.parse(ApiConfig.pedidosUrl),
      {
        'id_cliente': idCliente,
        'metodo_pago': metodoPago,
        if (nombreCliente != null && nombreCliente.isNotEmpty)
          'nombre_cliente_snapshot': nombreCliente,
        if (observaciones != null && observaciones.isNotEmpty)
          'observaciones': observaciones,
      },
      token: token,
    );
    final pedido = creado is Map && creado['pedido'] is Map
        ? Map<String, dynamic>.from(creado['pedido'] as Map)
        : (creado is Map<String, dynamic> ? creado : null);
    final idPedido = _asInt(pedido?['id_pedido']);
    if (idPedido == 0) {
      throw const PedidosException('No se obtuvo el id del pedido.');
    }
    double total = 0;
    for (final item in items) {
      final precio = item.producto.precio;
      total += precio * item.cantidad;
      await _post(
        Uri.parse(ApiConfig.detallePedidosUrl),
        {
          'id_pedido': idPedido,
          'id_producto': item.producto.idProducto,
          'cantidad': item.cantidad,
          'precio_unitario': precio,
          'nombre_producto_snapshot': item.producto.nombre,
        },
        token: token,
      );
    }
    await _put(
      Uri.parse(ApiConfig.pedidoByIdUrl(idPedido)),
      {'total': total},
      token: token,
    );
    return idPedido;
  }

  Future<List<Map<String, dynamic>>> listarPedidosRaw() async {
    final token = await _token();
    return _asList(await _get(Uri.parse(ApiConfig.pedidosUrl), token: token));
  }

  Future<List<Map<String, dynamic>>> listarDetallesRaw() async {
    final token = await _token();
    return _asList(
        await _get(Uri.parse(ApiConfig.detallePedidosUrl), token: token));
  }

  Future<String> _token() async {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString('auth_token');
    if (t == null || t.isEmpty) {
      throw const PedidosException('No hay sesión. Inicia sesión de nuevo.');
    }
    return t;
  }

  Future<dynamic> _get(Uri uri, {required String token}) async {
    try {
      final r = await http
          .get(uri, headers: ApiConfig.authHeaders(token))
          .timeout(const Duration(seconds: 20));
      final d = _decode(r);
      if (r.statusCode < 200 || r.statusCode >= 300) {
        throw PedidosException(_err(d, 'Error al consultar pedidos.'));
      }
      return d;
    } on SocketException {
      throw const PedidosException('Sin conexión con el servidor.');
    } on TimeoutException {
      throw const PedidosException('El servidor no respondió a tiempo.');
    }
  }

  Future<dynamic> _post(
    Uri uri,
    Map<String, dynamic> body, {
    required String token,
  }) async {
    try {
      final r = await http
          .post(
            uri,
            headers: ApiConfig.authHeaders(token),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 20));
      final d = _decode(r);
      if (r.statusCode < 200 || r.statusCode >= 300) {
        throw PedidosException(_err(d, 'No se pudo completar la venta.'));
      }
      return d;
    } on SocketException {
      throw const PedidosException('Sin conexión con el servidor.');
    } on TimeoutException {
      throw const PedidosException('El servidor no respondió a tiempo.');
    }
  }

  Future<dynamic> _put(
    Uri uri,
    Map<String, dynamic> body, {
    required String token,
  }) async {
    try {
      final r = await http
          .put(
            uri,
            headers: ApiConfig.authHeaders(token),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));
      final d = _decode(r);
      if (r.statusCode < 200 || r.statusCode >= 300) {
        throw PedidosException(_err(d, 'No se pudo actualizar el total.'));
      }
      return d;
    } on SocketException {
      throw const PedidosException('Sin conexión con el servidor.');
    } on TimeoutException {
      throw const PedidosException('El servidor no respondió a tiempo.');
    }
  }

  dynamic _decode(http.Response r) {
    if (r.body.isEmpty) return null;
    try {
      return jsonDecode(utf8.decode(r.bodyBytes));
    } on FormatException {
      throw const PedidosException('Respuesta no válida del servidor.');
    }
  }

  List<Map<String, dynamic>> _asList(dynamic d) {
    if (d is List) {
      return d
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return const [];
  }

  int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }

  String _err(dynamic d, String fallback) {
    if (d is Map && d['error'] is String && (d['error'] as String).isNotEmpty) {
      return d['error'] as String;
    }
    return fallback;
  }
}
