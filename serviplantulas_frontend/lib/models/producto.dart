/// Modelo alineado a la tabla `productos` del backend (Supabase).
class Producto {
  final int idProducto;
  final String nombreProducto;
  final String? descripcionProducto;
  final double precioProducto;
  final double? costoCompra;
  final int stock;
  final int stockMinimo;
  final int? idProveedor;
  final int? idCategoria;
  final String? imagenUrl;

  /// Nombres resueltos (si el API o el service los rellenan).
  final String? nombreCategoria;
  final String? nombreProveedor;

  const Producto({
    required this.idProducto,
    required this.nombreProducto,
    this.descripcionProducto,
    required this.precioProducto,
    this.costoCompra,
    required this.stock,
    this.stockMinimo = 0,
    this.idProveedor,
    this.idCategoria,
    this.imagenUrl,
    this.nombreCategoria,
    this.nombreProveedor,
  });

  // ── Getters de compatibilidad con la UI actual ──
  String get id => idProducto.toString();
  String get nombre => nombreProducto;
  double get precio => precioProducto;
  String get categoria => nombreCategoria ?? (idCategoria?.toString() ?? '—');
  String get proveedor => nombreProveedor ?? (idProveedor?.toString() ?? '—');
  bool get stockBajo => stock <= stockMinimo;

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: _asInt(json['id_producto']),
      nombreProducto: (json['nombre_producto'] ?? '').toString(),
      descripcionProducto: json['descripcion_producto']?.toString(),
      precioProducto: _asDouble(json['precio_producto']),
      costoCompra: json['costo_compra'] != null
          ? _asDouble(json['costo_compra'])
          : null,
      stock: _asInt(json['stock']),
      stockMinimo: _asInt(json['stock_minimo'] ?? 0),
      idProveedor: json['id_proveedor'] != null
          ? _asInt(json['id_proveedor'])
          : null,
      idCategoria: json['id_categoria'] != null
          ? _asInt(json['id_categoria'])
          : null,
      imagenUrl: json['imagen_url']?.toString(),
      nombreCategoria: json['nombre_categoria']?.toString() ??
          json['categorias']?['nombre_categoria']?.toString(),
      nombreProveedor: json['nombre_proveedor_snapshot']?.toString() ??
    json['nombre_proveedor']?.toString() ??
    json['proveedores']?['nombre_proveedor']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre_producto': nombreProducto,
      if (descripcionProducto != null)
        'descripcion_producto': descripcionProducto,
      'precio_producto': precioProducto,
      if (costoCompra != null) 'costo_compra': costoCompra,
      'stock': stock,
      'stock_minimo': stockMinimo,
      if (idProveedor != null) 'id_proveedor': idProveedor,
      if (idCategoria != null) 'id_categoria': idCategoria,
      if (imagenUrl != null) 'imagen_url': imagenUrl,
    };
  }

  Producto copyWith({
    int? idProducto,
    String? nombreProducto,
    String? descripcionProducto,
    double? precioProducto,
    double? costoCompra,
    int? stock,
    int? stockMinimo,
    int? idProveedor,
    int? idCategoria,
    String? imagenUrl,
    String? nombreCategoria,
    String? nombreProveedor,
  }) {
    return Producto(
      idProducto: idProducto ?? this.idProducto,
      nombreProducto: nombreProducto ?? this.nombreProducto,
      descripcionProducto: descripcionProducto ?? this.descripcionProducto,
      precioProducto: precioProducto ?? this.precioProducto,
      costoCompra: costoCompra ?? this.costoCompra,
      stock: stock ?? this.stock,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      idProveedor: idProveedor ?? this.idProveedor,
      idCategoria: idCategoria ?? this.idCategoria,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      nombreCategoria: nombreCategoria ?? this.nombreCategoria,
      nombreProveedor: nombreProveedor ?? this.nombreProveedor,
    );
  }

  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }

  static double _asDouble(dynamic v) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v?.toString() ?? '') ?? 0;
  }
}
