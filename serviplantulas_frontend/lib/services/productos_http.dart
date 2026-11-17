import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/producto.dart';
import 'api_config.dart';
class ProductosException implements Exception {
  final String message;
  const ProductosException(this.message);

  @override
  String toString() => message;
}

/// Helpers HTTP / multipart del módulo productos.
class ProductosHttp {
  static const tokenKey = 'auth_token';

  /// Campo `imagen` con Content-Type explícito (como en la guía ADSO).
  static Future<http.MultipartFile> archivoImagen(File imagen) async {
    final bytes = await imagen.readAsBytes();
    final ext = imagen.path.split('.').last.toLowerCase();
    final subtipo = switch (ext) {
      'png' => 'png',
      'webp' => 'webp',
      'avif' => 'avif',
      _ => 'jpeg',
    };
    final filename =
        'producto_${DateTime.now().millisecondsSinceEpoch}.${subtipo == 'jpeg' ? 'jpg' : subtipo}';

    return http.MultipartFile.fromBytes(
      'imagen',
      bytes,
      contentType: MediaType('image', subtipo),
      filename: filename,
    );
  }

  Future<Producto> enviarMultipart(
    http.MultipartRequest request,
    String fallbackError,
  ) async {
    try {
      final streamed = await request.send().timeout(
        const Duration(seconds: 45),
      );
      final response = await http.Response.fromStream(streamed);
      final decoded = decodeBody(response);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ProductosException(errorMsg(decoded, fallbackError));
      }

      final productoJson = decoded is Map && decoded['producto'] is Map
          ? Map<String, dynamic>.from(decoded['producto'] as Map)
          : (decoded is Map<String, dynamic> ? decoded : null);

      if (productoJson == null) {
        throw const ProductosException('El servidor no devolvió el producto.');
      }
      return Producto.fromJson(productoJson);
    } on SocketException {
      throw const ProductosException('No se pudo conectar con el servidor.');
    } on TimeoutException {
      throw const ProductosException(
        'El servidor tardó demasiado en responder.',
      );
    }
  }

  // ═══════════════════════════════════════
  // HTTP helpers
  // ═══════════════════════════════════════

  Future<dynamic> getJson(Uri uri) async {
    try {
      final response = await http
          .get(uri, headers: ApiConfig.headers)
          .timeout(const Duration(seconds: 15));
      final decoded = decodeBody(response);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ProductosException(
          errorMsg(decoded, 'Error al consultar el servidor.'),
        );
      }
      return decoded;
    } on SocketException {
      throw const ProductosException(
        'No se pudo conectar con el servidor. Verifica que el backend esté en marcha.',
      );
    } on TimeoutException {
      throw const ProductosException(
        'El servidor tardó demasiado en responder.',
      );
    } on http.ClientException {
      throw const ProductosException('No se pudo conectar con el servidor.');
    }
  }

  Future<String> token() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(tokenKey);
    if (token == null || token.isEmpty) {
      throw const ProductosException(
        'No hay sesión activa. Inicia sesión de nuevo.',
      );
    }
    return token;
  }

  dynamic decodeBody(http.Response response) {
    if (response.body.isEmpty) return null;
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw const ProductosException(
        'El servidor devolvió una respuesta no válida.',
      );
    }
  }

  List<Map<String, dynamic>> asList(dynamic decoded) {
    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return const [];
  }

  String errorMsg(dynamic decoded, String fallback) {
    if (decoded is Map && decoded['error'] is String) {
      final msg = decoded['error'] as String;
      if (msg.isNotEmpty) return msg;
    }
    return fallback;
  }
}