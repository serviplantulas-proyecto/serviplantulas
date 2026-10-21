import '../models/producto.dart';
import 'productos_service.dart';

/// Capa de inventario usada por las pantallas.
/// Delega en [ProductosService] (backend real).
///
/// Mantiene la misma API que antes para no romper InventarioPage.
class InventarioService {
  final ProductosService _api = ProductosService();

  /// Lista productos desde el backend.
  /// [categoria] es el **nombre** de la categoría (como en los chips),
  /// o 'Todos' para no filtrar.
  Future<List<Producto>> obtenerProductos({
    String? busqueda,
    String? categoria,
  }) async {
    int? idCategoria;

    if (categoria != null && categoria != 'Todos') {
      final cats = await _api.listarCategorias();
      final match = cats.where(
        (c) => c.nombreCategoria.toLowerCase() == categoria.toLowerCase(),
      );
      if (match.isNotEmpty) {
        idCategoria = match.first.idCategoria;
      }
    }

    final productos = await _api.listar(
      busqueda: busqueda,
      idCategoria: idCategoria,
    );

    // Enriquecer con nombres de categoría/proveedor si el API no los trae.
    return _enriquecer(productos);
  }

  /// Nombres de categoría para los chips (+ "Todos").
  Future<List<String>> obtenerCategorias() async {
    final cats = await _api.listarCategorias();
    return ['Todos', ...cats.map((c) => c.nombreCategoria)];
  }

  Future<List<Producto>> _enriquecer(List<Producto> productos) async {
    if (productos.isEmpty) return productos;

    // Cargar mapas una sola vez
    final cats = await _api.listarCategorias();
    final provs = await _api.listarProveedores();

    final catMap = {
      for (final c in cats) c.idCategoria: c.nombreCategoria,
    };
    final provMap = {
      for (final p in provs) p.idProveedor: p.nombreProveedor,
    };

    return productos.map((p) {
      return p.copyWith(
        nombreCategoria: p.nombreCategoria ??
            (p.idCategoria != null ? catMap[p.idCategoria] : null),
        nombreProveedor: p.nombreProveedor ??
            (p.idProveedor != null ? provMap[p.idProveedor] : null),
      );
    }).toList();
  }
}
