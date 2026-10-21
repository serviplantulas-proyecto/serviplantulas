import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/categoria.dart';
import 'api_config.dart';

class CategoriasException implements Exception {
  final String message;
  const CategoriasException(this.message);

  @override
  String toString() => message;
}

class CategoriasService {
  /// GET /categorias/
  Future<List<Categoria>> listar() async {
    final decoded = await _get(Uri.parse(ApiConfig.categoriasUrl));
    return _asList(decoded).map(Categoria.fromJson).toList();
  }

  /// GET /categorias/:id
  Future<Categoria> obtenerPorId(int id) async {
    final decoded = await _get(Uri.parse(ApiConfig.categoriaByIdUrl(id)));
    if (decoded is! Map<String, dynamic>) {
      throw const CategoriasException('Respuesta inválida.');
    }
    return Categoria.fromJson(decoded);
  }

  /// POST /categorias/
  Future<Categoria> crear({
    required String nombreCategoria,
    String? descripcionCategoria,
    bool estado = true,
  }) async {
    final body = {
      'nombre_categoria': nombreCategoria,
      if (descripcionCategoria != null)
        'descripcion_categoria': descripcionCategoria,
      'estado': estado,
    };
    final decoded = await _post(Uri.parse(ApiConfig.categoriasUrl), body);
    return _extraerCategoria(decoded, 'categoria');
  }

  /// PUT /categorias/:id
  Future<Categoria> actualizar({
    required int id,
    required Map<String, dynamic> campos,
  }) async {
    final decoded =
        await _put(Uri.parse(ApiConfig.categoriaByIdUrl(id)), campos);
    return _extraerCategoria(decoded, 'categoria');
  }

  /// DELETE /categorias/:id
  Future<void> eliminar(int id) async {
    await _delete(Uri.parse(ApiConfig.categoriaByIdUrl(id)));
  }

  // ── HTTP ──

  Future<dynamic> _get(Uri uri) async {
    try {
      final r = await http
          .get(uri, headers: ApiConfig.headers)
          .timeout(const Duration(seconds: 15));
      final d = _decode(r);
      if (r.statusCode < 200 || r.statusCode >= 300) {
        throw CategoriasException(_err(d, 'Error al listar categorías.'));
      }
      return d;
    } on SocketException {
      throw const CategoriasException('Sin conexión con el servidor.');
    } on TimeoutException {
      throw const CategoriasException('El servidor no respondió a tiempo.');
    }
  }

  Future<dynamic> _post(Uri uri, Map<String, dynamic> body) async {
    try {
      final r = await http
          .post(uri, headers: ApiConfig.headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));
      final d = _decode(r);
      if (r.statusCode < 200 || r.statusCode >= 300) {
        throw CategoriasException(_err(d, 'No se pudo crear la categoría.'));
      }
      return d;
    } on SocketException {
      throw const CategoriasException('Sin conexión con el servidor.');
    } on TimeoutException {
      throw const CategoriasException('El servidor no respondió a tiempo.');
    }
  }

  Future<dynamic> _put(Uri uri, Map<String, dynamic> body) async {
    try {
      final r = await http
          .put(uri, headers: ApiConfig.headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));
      final d = _decode(r);
      if (r.statusCode < 200 || r.statusCode >= 300) {
        throw CategoriasException(
          _err(d, 'No se pudo actualizar la categoría.'),
        );
      }
      return d;
    } on SocketException {
      throw const CategoriasException('Sin conexión con el servidor.');
    } on TimeoutException {
      throw const CategoriasException('El servidor no respondió a tiempo.');
    }
  }

  Future<void> _delete(Uri uri) async {
    try {
      final r = await http
          .delete(uri, headers: ApiConfig.headers)
          .timeout(const Duration(seconds: 15));
      final d = _decode(r);
      if (r.statusCode < 200 || r.statusCode >= 300) {
        throw CategoriasException(
          _err(d, 'No se pudo eliminar la categoría.'),
        );
      }
    } on SocketException {
      throw const CategoriasException('Sin conexión con el servidor.');
    } on TimeoutException {
      throw const CategoriasException('El servidor no respondió a tiempo.');
    }
  }

  Categoria _extraerCategoria(dynamic decoded, String key) {
    if (decoded is Map && decoded[key] is Map) {
      return Categoria.fromJson(Map<String, dynamic>.from(decoded[key] as Map));
    }
    if (decoded is Map<String, dynamic>) {
      return Categoria.fromJson(decoded);
    }
    throw const CategoriasException('Respuesta inválida del servidor.');
  }

  dynamic _decode(http.Response r) {
    if (r.body.isEmpty) return null;
    try {
      return jsonDecode(utf8.decode(r.bodyBytes));
    } on FormatException {
      throw const CategoriasException('Respuesta no válida del servidor.');
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
