import '../models/producto.dart';
import 'productos_service.dart';

class InventarioService {
  final ProductosService _api = ProductosService();

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
      if (match.isNotEmpty) idCategoria = match.first.idCategoria;
    }
    final productos = await _api.listar(
      busqueda: busqueda,
      idCategoria: idCategoria,
    );
    return _enriquecer(productos);
  }

  Future<List<String>> obtenerCategorias() async {
    final cats = await _api.listarCategorias();
    return ['Todos', ...cats.map((c) => c.nombreCategoria)];
  }

  Future<List<Producto>> _enriquecer(List<Producto> productos) async {
    if (productos.isEmpty) return productos;
    final cats = await _api.listarCategorias();
    final provs = await _api.listarProveedores();
    final catMap = {for (final c in cats) c.idCategoria: c.nombreCategoria};
    final provMap = {for (final p in provs) p.idProveedor: p.nombreProveedor};

    return productos.map((p) {
      // Si ya hay nombre (p.ej. snapshot desde API), no lo pisa
      final nombreProv = (p.nombreProveedor != null &&
              p.nombreProveedor!.trim().isNotEmpty)
          ? p.nombreProveedor
          : (p.idProveedor != null ? provMap[p.idProveedor] : null);
      return p.copyWith(
        nombreCategoria: p.nombreCategoria ??
            (p.idCategoria != null ? catMap[p.idCategoria] : null),
        nombreProveedor: nombreProv,
      );
    }).toList();
  }
}
