class Categoria {
  final int idCategoria;
  final String nombreCategoria;
  final String? descripcionCategoria;
  final bool estado;

  const Categoria({
    required this.idCategoria,
    required this.nombreCategoria,
    this.descripcionCategoria,
    this.estado = true,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      idCategoria: _asInt(json['id_categoria']),
      nombreCategoria: (json['nombre_categoria'] ?? '').toString(),
      descripcionCategoria: json['descripcion_categoria']?.toString(),
      estado: json['estado'] == true || json['estado'] == 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre_categoria': nombreCategoria,
        if (descripcionCategoria != null)
          'descripcion_categoria': descripcionCategoria,
        'estado': estado,
      };

  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }
}
