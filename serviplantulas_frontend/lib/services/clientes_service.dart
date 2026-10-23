import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/cliente.dart';
import 'api_config.dart';

class ClientesException implements Exception {
  final String message;
  const ClientesException(this.message);
  @override
  String toString() => message;
}

class ClientesService {
  Future<List<Cliente>> listar({String? busqueda}) async {
    final decoded = await _get(Uri.parse(ApiConfig.clientesUrl));
    var lista = _asList(decoded).map(Cliente.fromJson).toList();
    if (busqueda != null && busqueda.trim().isNotEmpty) {
      final q = busqueda.toLowerCase();
      lista = lista
          .where((c) =>
              c.nombreCliente.toLowerCase().contains(q) ||
              (c.cedulaCliente?.toLowerCase().contains(q) ?? false) ||
              (c.telefonoCliente?.contains(q) ?? false))
          .toList();
    }
    return lista;
  }

  /// Alias usado por pantallas antiguas.
  Future<List<Cliente>> obtenerClientes({String? busqueda}) =>
      listar(busqueda: busqueda);

  Future<Cliente> obtenerPorId(int id) async {
    final decoded =
        await _get(Uri.parse('${ApiConfig.clientesUrl}$id'));
    if (decoded is! Map<String, dynamic>) {
      throw const ClientesException('Respuesta inválida.');
    }
    return Cliente.fromJson(decoded);
  }

  Future<Cliente> crear({
    required String nombreCliente,
    required String telefonoCliente,
    String? correoCliente,
    String? direccionCliente,
    String? cedulaCliente,
  }) async {
    final body = {
      'nombre_cliente': nombreCliente,
      'telefono_cliente': telefonoCliente,
      if (correoCliente != null) 'correo_cliente': correoCliente,
      if (direccionCliente != null) 'direccion_cliente': direccionCliente,
      if (cedulaCliente != null) 'cedula_cliente': cedulaCliente,
    };
    final decoded = await _post(Uri.parse(ApiConfig.clientesUrl), body);
    return _extraer(decoded);
  }

  Future<Cliente> actualizar({
    required int id,
    required Map<String, dynamic> campos,
  }) async {
    final decoded =
        await _put(Uri.parse('${ApiConfig.clientesUrl}$id'), campos);
    return _extraer(decoded);
  }

  Future<void> eliminar(int id) async {
    await _delete(Uri.parse('${ApiConfig.clientesUrl}$id'));
  }

  Cliente _extraer(dynamic decoded) {
    if (decoded is Map && decoded['cliente'] is Map) {
      return Cliente.fromJson(
          Map<String, dynamic>.from(decoded['cliente'] as Map));
    }
    if (decoded is Map<String, dynamic>) return Cliente.fromJson(decoded);
    throw const ClientesException('Respuesta inválida del servidor.');
  }

  Future<dynamic> _get(Uri uri) async {
    try {
      final r = await http
          .get(uri, headers: ApiConfig.headers)
          .timeout(const Duration(seconds: 15));
      final d = _decode(r);
      if (r.statusCode < 200 || r.statusCode >= 300) {
        throw ClientesException(_err(d, 'Error al listar clientes.'));
      }
      return d;
    } on SocketException {
      throw const ClientesException('Sin conexión con el servidor.');
    } on TimeoutException {
      throw const ClientesException('El servidor no respondió a tiempo.');
    }
  }

  Future<dynamic> _post(Uri uri, Map<String, dynamic> body) async {
    try {
      final r = await http
          .post(uri, headers: ApiConfig.headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));
      final d = _decode(r);
      if (r.statusCode < 200 || r.statusCode >= 300) {
        throw ClientesException(_err(d, 'No se pudo crear el cliente.'));
      }
      return d;
    } on SocketException {
      throw const ClientesException('Sin conexión con el servidor.');
    } on TimeoutException {
      throw const ClientesException('El servidor no respondió a tiempo.');
    }
  }

  Future<dynamic> _put(Uri uri, Map<String, dynamic> body) async {
    try {
      final r = await http
          .put(uri, headers: ApiConfig.headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));
      final d = _decode(r);
      if (r.statusCode < 200 || r.statusCode >= 300) {
        throw ClientesException(_err(d, 'No se pudo actualizar el cliente.'));
      }
      return d;
    } on SocketException {
      throw const ClientesException('Sin conexión con el servidor.');
    } on TimeoutException {
      throw const ClientesException('El servidor no respondió a tiempo.');
    }
  }

  Future<void> _delete(Uri uri) async {
    try {
      final r = await http
          .delete(uri, headers: ApiConfig.headers)
          .timeout(const Duration(seconds: 15));
      final d = _decode(r);
      if (r.statusCode < 200 || r.statusCode >= 300) {
        throw ClientesException(_err(d, 'No se pudo eliminar el cliente.'));
      }
    } on SocketException {
      throw const ClientesException('Sin conexión con el servidor.');
    } on TimeoutException {
      throw const ClientesException('El servidor no respondió a tiempo.');
    }
  }

  dynamic _decode(http.Response r) {
    if (r.body.isEmpty) return null;
    try {
      return jsonDecode(utf8.decode(r.bodyBytes));
    } on FormatException {
      throw const ClientesException('Respuesta no válida del servidor.');
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

  String _err(dynamic d, String fallback) {
    if (d is Map && d['error'] is String && (d['error'] as String).isNotEmpty) {
      return d['error'] as String;
    }
    return fallback;
  }
}
