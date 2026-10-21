import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/categoria.dart';
import '../models/producto.dart';
import '../models/proveedor.dart';
import 'api_config.dart';

class ProductosException implements Exception {
  final String message;
  const ProductosException(this.message);

  @override
  String toString() => message;
}

/// Service del módulo productos / categorías / proveedores.
class ProductosService {
  static const _tokenKey = 'auth_token';

  // ═══════════════════════════════════════
  // PRODUCTOS
  // ═══════════════════════════════════════

  Future<List<Producto>> listar({
    String? busqueda,
    int? idCategoria,
  }) async {
    final uri = idCategoria != null
        ? Uri.parse(ApiConfig.productosByCategoriaUrl(idCategoria))
        : Uri.parse(ApiConfig.productosUrl);

    final decoded = await _get(uri);
    var lista = _asList(decoded).map(Producto.fromJson).toList();

    if (busqueda != null && busqueda.trim().isNotEmpty) {
      final q = busqueda.toLowerCase();
      lista = lista
          .where((p) =>
              p.nombreProducto.toLowerCase().contains(q) ||
              (p.descripcionProducto?.toLowerCase().contains(q) ?? false) ||
              p.id.contains(q))
          .toList();
    }
    return lista;
  }

  Future<Producto> obtenerPorId(int id) async {
    final decoded = await _get(Uri.parse(ApiConfig.productoByIdUrl(id)));
    if (decoded is! Map<String, dynamic>) {
      throw const ProductosException('Respuesta inválida del servidor.');
    }
    return Producto.fromJson(decoded);
  }

  Future<Producto> crear({
    required String nombreProducto,
    String? descripcionProducto,
    required double precioProducto,
    double? costoCompra,
    int stock = 0,
    int stockMinimo = 0,
    int? idProveedor,
    int? idCategoria,
    File? imagen,
  }) async {
    final token = await _token();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConfig.productosUrl),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    request.fields['nombre_producto'] = nombreProducto;
    if (descripcionProducto != null) {
      request.fields['descripcion_producto'] = descripcionProducto;
    }
    request.fields['precio_producto'] = precioProducto.toString();
    if (costoCompra != null) {
      request.fields['costo_compra'] = costoCompra.toString();
    }
    request.fields['stock'] = stock.toString();
    request.fields['stock_minimo'] = stockMinimo.toString();
    if (idProveedor != null) {
      request.fields['id_proveedor'] = idProveedor.toString();
    }
    if (idCategoria != null) {
      request.fields['id_categoria'] = idCategoria.toString();
    }
    if (imagen != null) {
      request.files.add(await _archivoImagen(imagen));
    }

    return _enviarMultipart(request, 'No se pudo crear el producto.');
  }

  Future<Producto> actualizar({
    required int id,
    Map<String, String>? campos,
    File? imagen,
  }) async {
    final token = await _token();
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse(ApiConfig.productoByIdUrl(id)),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    if (campos != null) request.fields.addAll(campos);
    if (imagen != null) {
      request.files.add(await _archivoImagen(imagen));
    }

    return _enviarMultipart(request, 'No se pudo actualizar el producto.');
  }

  Future<void> eliminar(int id) async {
    final token = await _token();
    final response = await http
        .delete(
          Uri.parse(ApiConfig.productoByIdUrl(id)),
          headers: ApiConfig.authHeaders(token),
        )
        .timeout(const Duration(seconds: 15));

    final decoded = _decodeBody(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ProductosException(
        _errorMsg(decoded, 'No se pudo eliminar el producto.'),
      );
    }
  }

  // ═══════════════════════════════════════
  // CATEGORÍAS / PROVEEDORES
  // ═══════════════════════════════════════

  Future<List<Categoria>> listarCategorias() async {
    final decoded = await _get(Uri.parse(ApiConfig.categoriasUrl));
    return _asList(decoded).map(Categoria.fromJson).toList();
  }

  Future<List<Proveedor>> listarProveedores() async {
    final decoded = await _get(Uri.parse(ApiConfig.proveedoresUrl));
    return _asList(decoded).map(Proveedor.fromJson).toList();
  }

  // ═══════════════════════════════════════
  // Multipart imagen (Cloudinary / Multer)
  // ═══════════════════════════════════════

  /// Campo `imagen` con Content-Type explícito (como en la guía ADSO).
  static Future<http.MultipartFile> _archivoImagen(File imagen) async {
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

  Future<Producto> _enviarMultipart(
    http.MultipartRequest request,
    String fallbackError,
  ) async {
    try {
      final streamed =
          await request.send().timeout(const Duration(seconds: 45));
      final response = await http.Response.fromStream(streamed);
      final decoded = _decodeBody(response);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ProductosException(_errorMsg(decoded, fallbackError));
      }

      final productoJson = decoded is Map && decoded['producto'] is Map
          ? Map<String, dynamic>.from(decoded['producto'] as Map)
          : (decoded is Map<String, dynamic> ? decoded : null);

      if (productoJson == null) {
        throw const ProductosException(
          'El servidor no devolvió el producto.',
        );
      }
      return Producto.fromJson(productoJson);
    } on SocketException {
      throw const ProductosException(
        'No se pudo conectar con el servidor.',
      );
    } on TimeoutException {
      throw const ProductosException(
        'El servidor tardó demasiado en responder.',
      );
    }
  }

  // ═══════════════════════════════════════
  // HTTP helpers
  // ═══════════════════════════════════════

  Future<dynamic> _get(Uri uri) async {
    try {
      final response = await http
          .get(uri, headers: ApiConfig.headers)
          .timeout(const Duration(seconds: 15));
      final decoded = _decodeBody(response);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ProductosException(
          _errorMsg(decoded, 'Error al consultar el servidor.'),
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
      throw const ProductosException(
        'No se pudo conectar con el servidor.',
      );
    }
  }

  Future<String> _token() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null || token.isEmpty) {
      throw const ProductosException(
        'No hay sesión activa. Inicia sesión de nuevo.',
      );
    }
    return token;
  }

  dynamic _decodeBody(http.Response response) {
    if (response.body.isEmpty) return null;
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw const ProductosException(
        'El servidor devolvió una respuesta no válida.',
      );
    }
  }

  List<Map<String, dynamic>> _asList(dynamic decoded) {
    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return const [];
  }

  String _errorMsg(dynamic decoded, String fallback) {
    if (decoded is Map && decoded['error'] is String) {
      final msg = decoded['error'] as String;
      if (msg.isNotEmpty) return msg;
    }
    return fallback;
  }
}
