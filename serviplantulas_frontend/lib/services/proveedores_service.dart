import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/proveedor.dart';
import 'api_config.dart';

class ProveedoresException implements Exception {
  final String message;
  const ProveedoresException(this.message);

  @override
  String toString() => message;
}

class ProveedoresService {
  /// GET /proveedores/
  Future<List<Proveedor>> listar({String? busqueda}) async {
    final decoded = await _get(Uri.parse(ApiConfig.proveedoresUrl));
    var lista = _asList(decoded).map(Proveedor.fromJson).toList();
    if (busqueda != null && busqueda.trim().isNotEmpty) {
      final q = busqueda.toLowerCase();
      lista = lista
          .where((p) =>
              p.nombreProveedor.toLowerCase().contains(q) ||
              (p.contactoRepresentante?.toLowerCase().contains(q) ?? false) ||
              (p.telefonoProveedor?.contains(q) ?? false) ||
              (p.emailProveedor?.toLowerCase().contains(q) ?? false))
          .toList();
    }
    return lista;
  }

  /// GET /proveedores/:id
  Future<Proveedor> obtenerPorId(int id) async {
    final decoded = await _get(Uri.parse(ApiConfig.proveedorByIdUrl(id)));
    if (decoded is! Map<String, dynamic>) {
      throw const ProveedoresException('Respuesta inválida.');
    }
    return Proveedor.fromJson(decoded);
  }

  /// POST /proveedores/
  Future<Proveedor> crear({
    required String nombreProveedor,
    String? contactoRepresentante,
    String? telefonoProveedor,
    String? emailProveedor,
    String? direccionProveedor,
  }) async {
    final body = {
      'nombre_proveedor': nombreProveedor,
      if (contactoRepresentante != null)
        'contacto_representante': contactoRepresentante,
      if (telefonoProveedor != null) 'telefono_proveedor': telefonoProveedor,
      if (emailProveedor != null) 'email_proveedor': emailProveedor,
      if (direccionProveedor != null) 'direccion_proveedor': direccionProveedor,
    };
    final decoded = await _post(Uri.parse(ApiConfig.proveedoresUrl), body);
    return _extraer(decoded, 'proveedor');
  }

  /// PUT /proveedores/:id
  Future<Proveedor> actualizar({
    required int id,
    required Map<String, dynamic> campos,
  }) async {
    final decoded =
        await _put(Uri.parse(ApiConfig.proveedorByIdUrl(id)), campos);
    return _extraer(decoded, 'proveedor');
  }

  /// DELETE /proveedores/:id
  Future<void> eliminar(int id) async {
    await _delete(Uri.parse(ApiConfig.proveedorByIdUrl(id)));
  }

  // ── HTTP ──

  Future<dynamic> _get(Uri uri) async {
    try {
      final r = await http
          .get(uri, headers: ApiConfig.headers)
          .timeout(const Duration(seconds: 15));
      final d = _decode(r);
      if (r.statusCode < 200 || r.statusCode >= 300) {
        throw ProveedoresException(_err(d, 'Error al listar proveedores.'));
      }
      return d;
    } on SocketException {
      throw const ProveedoresException('Sin conexión con el servidor.');
    } on TimeoutException {
      throw const ProveedoresException('El servidor no respondió a tiempo.');
    }
  }

  Future<dynamic> _post(Uri uri, Map<String, dynamic> body) async {
    try {
      final r = await http
          .post(uri, headers: ApiConfig.headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));
      final d = _decode(r);
      if (r.statusCode < 200 || r.statusCode >= 300) {
        throw ProveedoresException(_err(d, 'No se pudo crear el proveedor.'));
      }
      return d;
    } on SocketException {
      throw const ProveedoresException('Sin conexión con el servidor.');
    } on TimeoutException {
      throw const ProveedoresException('El servidor no respondió a tiempo.');
    }
  }

  Future<dynamic> _put(Uri uri, Map<String, dynamic> body) async {
    try {
      final r = await http
          .put(uri, headers: ApiConfig.headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));
      final d = _decode(r);
      if (r.statusCode < 200 || r.statusCode >= 300) {
        throw ProveedoresException(
          _err(d, 'No se pudo actualizar el proveedor.'),
        );
      }
      return d;
    } on SocketException {
      throw const ProveedoresException('Sin conexión con el servidor.');
    } on TimeoutException {
      throw const ProveedoresException('El servidor no respondió a tiempo.');
    }
  }

  Future<void> _delete(Uri uri) async {
    try {
      final r = await http
          .delete(uri, headers: ApiConfig.headers)
          .timeout(const Duration(seconds: 15));
      final d = _decode(r);
      if (r.statusCode < 200 || r.statusCode >= 300) {
        throw ProveedoresException(
          _err(d, 'No se pudo eliminar el proveedor.'),
        );
      }
    } on SocketException {
      throw const ProveedoresException('Sin conexión con el servidor.');
    } on TimeoutException {
      throw const ProveedoresException('El servidor no respondió a tiempo.');
    }
  }

  Proveedor _extraer(dynamic decoded, String key) {
    if (decoded is Map && decoded[key] is Map) {
      return Proveedor.fromJson(Map<String, dynamic>.from(decoded[key] as Map));
    }
    if (decoded is Map<String, dynamic>) {
      return Proveedor.fromJson(decoded);
    }
    throw const ProveedoresException('Respuesta inválida del servidor.');
  }

  dynamic _decode(http.Response r) {
    if (r.body.isEmpty) return null;
    try {
      return jsonDecode(utf8.decode(r.bodyBytes));
    } on FormatException {
      throw const ProveedoresException('Respuesta no válida del servidor.');
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
