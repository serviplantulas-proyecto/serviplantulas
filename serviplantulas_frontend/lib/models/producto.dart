class Producto {
  final String id;
  final String nombre;
  final String categoria;
  final String proveedor;
  final double precio;
  final int stock;
  final String? imagenUrl;
  final bool stockBajo;

  const Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.proveedor,
    required this.precio,
    required this.stock,
    this.imagenUrl,
    this.stockBajo = false,
  });

  Producto copyWith({
    String? id,
    String? nombre,
    String? categoria,
    String? proveedor,
    double? precio,
    int? stock,
    String? imagenUrl,
    bool? stockBajo,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      proveedor: proveedor ?? this.proveedor,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      stockBajo: stockBajo ?? this.stockBajo,
    );
  }
}
