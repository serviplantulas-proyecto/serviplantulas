import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/categoria.dart';
import '../models/producto.dart';
import '../models/proveedor.dart';
import 'api_config.dart';
import 'productos_http.dart';

export 'productos_http.dart' show ProductosException;

/// Service del módulo productos / categorías / proveedores.
class ProductosService {
  // ═══════════════════════════════════════
  // PRODUCTOS
  // ═══════════════════════════════════════

  Future<List<Producto>> listar({String? busqueda, int? idCategoria}) async {
    final uri = idCategoria != null
        ? Uri.parse(ApiConfig.productosByCategoriaUrl(idCategoria))
        : Uri.parse(ApiConfig.productosUrl);

    final decoded = await ProductosHttp().getJson(uri);
    var lista = ProductosHttp().asList(decoded).map(Producto.fromJson).toList();

    if (busqueda != null && busqueda.trim().isNotEmpty) {
      final q = busqueda.toLowerCase();
      lista = lista
          .where(
            (p) =>
                p.nombreProducto.toLowerCase().contains(q) ||
                (p.descripcionProducto?.toLowerCase().contains(q) ?? false) ||
                p.id.contains(q),
          )
          .toList();
    }
    return lista;
  }

  Future<Producto> obtenerPorId(int id) async {
    final decoded = await ProductosHttp().getJson(Uri.parse(ApiConfig.productoByIdUrl(id)));
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
    final token = await ProductosHttp().token();
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
      request.files.add(await ProductosHttp.archivoImagen(imagen));
    }

    return ProductosHttp().enviarMultipart(request, 'No se pudo crear el producto.');
  }

  Future<Producto> actualizar({
    required int id,
    Map<String, String>? campos,
    File? imagen,
  }) async {
    final token = await ProductosHttp().token();
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse(ApiConfig.productoByIdUrl(id)),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    if (campos != null) request.fields.addAll(campos);
    if (imagen != null) {
      request.files.add(await ProductosHttp.archivoImagen(imagen));
    }

    return ProductosHttp().enviarMultipart(request, 'No se pudo actualizar el producto.');
  }

  Future<Producto> actualizarJson({
    required int id,
    required Map<String, dynamic> campos,
  }) async {
    final token = await ProductosHttp().token();
    try {
      final response = await http
          .put(
            Uri.parse(ApiConfig.productoByIdUrl(id)),
            headers: ApiConfig.authHeaders(token),
            body: jsonEncode(campos),
          )
          .timeout(const Duration(seconds: 20));
      final decoded = ProductosHttp().decodeBody(response);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ProductosException(
          ProductosHttp().errorMsg(decoded, 'No se pudo actualizar el producto.'),
        );
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
      throw const ProductosException('El servidor tardó demasiado.');
    }
  }

  Future<void> eliminar(int id) async {
    final token = await ProductosHttp().token();
    final response = await http
        .delete(
          Uri.parse(ApiConfig.productoByIdUrl(id)),
          headers: ApiConfig.authHeaders(token),
        )
        .timeout(const Duration(seconds: 15));

    final decoded = ProductosHttp().decodeBody(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ProductosException(
        ProductosHttp().errorMsg(decoded, 'No se pudo eliminar el producto.'),
      );
    }
  }

  // ═══════════════════════════════════════
  // CATEGORÍAS / PROVEEDORES
  // ═══════════════════════════════════════

  Future<List<Categoria>> listarCategorias() async {
    final decoded = await ProductosHttp().getJson(Uri.parse(ApiConfig.categoriasUrl));
    return ProductosHttp().asList(decoded).map(Categoria.fromJson).toList();
  }

  Future<List<Proveedor>> listarProveedores() async {
    final decoded = await ProductosHttp().getJson(Uri.parse(ApiConfig.proveedoresUrl));
    return ProductosHttp().asList(decoded).map(Proveedor.fromJson).toList();
  }

  // ═══════════════════════════════════════
  // Multipart imagen (Cloudinary / Multer)
  // ═══════════════════════════════════════
}
