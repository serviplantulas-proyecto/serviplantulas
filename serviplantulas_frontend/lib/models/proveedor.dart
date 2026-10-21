class Proveedor {
  final int idProveedor;
  final String nombreProveedor;
  final String? contactoRepresentante;
  final String? telefonoProveedor;
  final String? emailProveedor;
  final String? direccionProveedor;

  const Proveedor({
    required this.idProveedor,
    required this.nombreProveedor,
    this.contactoRepresentante,
    this.telefonoProveedor,
    this.emailProveedor,
    this.direccionProveedor,
  });

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      idProveedor: _asInt(json['id_proveedor']),
      nombreProveedor: (json['nombre_proveedor'] ?? '').toString(),
      contactoRepresentante: json['contacto_representante']?.toString(),
      telefonoProveedor: json['telefono_proveedor']?.toString(),
      emailProveedor: json['email_proveedor']?.toString(),
      direccionProveedor: json['direccion_proveedor']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre_proveedor': nombreProveedor,
        if (contactoRepresentante != null)
          'contacto_representante': contactoRepresentante,
        if (telefonoProveedor != null) 'telefono_proveedor': telefonoProveedor,
        if (emailProveedor != null) 'email_proveedor': emailProveedor,
        if (direccionProveedor != null)
          'direccion_proveedor': direccionProveedor,
      };

  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }
}
