import '../models/producto.dart';

/// Servicio de inventario.
/// Actualmente usa datos mock. Conectar al backend reemplazando
/// el cuerpo de cada método.
class InventarioService {
  // TODO: ApiConfig.baseUrl + 'productos'

  Future<List<Producto>> obtenerProductos({
    String? busqueda,
    String? categoria,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));

    final todos = _mockProductos;

    var filtrados = todos;
    if (categoria != null && categoria != 'Todos') {
      filtrados = filtrados
          .where((p) =>
              p.categoria.toLowerCase() == categoria.toLowerCase())
          .toList();
    }
    if (busqueda != null && busqueda.trim().isNotEmpty) {
      final q = busqueda.toLowerCase();
      filtrados = filtrados
          .where((p) =>
              p.nombre.toLowerCase().contains(q) ||
              p.categoria.toLowerCase().contains(q) ||
              p.id.toLowerCase().contains(q))
          .toList();
    }
    return filtrados;
  }

  Future<List<String>> obtenerCategorias() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return const [
      'Todos',
      'Flores',
      'Arbustos',
      'Frutales',
      'Suculentas',
      'Helechos',
      'Sombra',
      'Interiores',
    ];
  }

  static const List<Producto> _mockProductos = [
    Producto(
      id: 'P001',
      nombre: "Helecho Boston Maceta 10''",
      categoria: 'Helechos',
      proveedor: 'Nativo Verde S.A.',
      precio: 22500,
      stock: 124,
    ),
    Producto(
      id: 'P002',
      nombre: 'Cuna de Moisés (Spathiphyllum)',
      categoria: 'Sombra',
      proveedor: 'Floricultura del Valle',
      precio: 18000,
      stock: 82,
    ),
    Producto(
      id: 'P003',
      nombre: 'Ficus Lyrata Elegance',
      categoria: 'Arbustos',
      proveedor: 'Importaciones Verdes',
      precio: 55000,
      stock: 15,
      stockBajo: true,
    ),
    Producto(
      id: 'P004',
      nombre: 'Monstera Deliciosa',
      categoria: 'Interiores',
      proveedor: 'Nativo Verde S.A.',
      precio: 32500,
      stock: 48,
    ),
  ];
}
