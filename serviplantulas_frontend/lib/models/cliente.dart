/// Modelo alineado a la tabla `clientes` del backend.
class Cliente {
  final int idCliente;
  final String nombreCliente;
  final String? telefonoCliente;
  final String? correoCliente;
  final String? direccionCliente;
  final String? cedulaCliente;

  /// Datos de UI (ventas / historial) — aún no vienen del API de clientes.
  final int totalPedidos;
  final String? ultimaCompra;
  final List<PedidoResumen> historialReciente;
  final double descuentoFrecuente;

  const Cliente({
    required this.idCliente,
    required this.nombreCliente,
    this.telefonoCliente,
    this.correoCliente,
    this.direccionCliente,
    this.cedulaCliente,
    this.totalPedidos = 0,
    this.ultimaCompra,
    this.historialReciente = const [],
    this.descuentoFrecuente = 0,
  });

  // Compatibilidad con pantallas existentes
  String get id => idCliente.toString();
  String get nombre => nombreCliente;
  String get documento => cedulaCliente ?? '';
  String get telefono => telefonoCliente ?? '';
  String get tipoDocumento {
    final d = cedulaCliente ?? '';
    if (d.contains('-') || d.replaceAll('.', '').length > 10) return 'NIT';
    return 'C.C.';
  }

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      idCliente: _asInt(json['id_cliente']),
      nombreCliente: (json['nombre_cliente'] ?? '').toString(),
      telefonoCliente: json['telefono_cliente']?.toString(),
      correoCliente: json['correo_cliente']?.toString(),
      direccionCliente: json['direccion_cliente']?.toString(),
      cedulaCliente: json['cedula_cliente']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre_cliente': nombreCliente,
        if (telefonoCliente != null) 'telefono_cliente': telefonoCliente,
        if (correoCliente != null) 'correo_cliente': correoCliente,
        if (direccionCliente != null) 'direccion_cliente': direccionCliente,
        if (cedulaCliente != null) 'cedula_cliente': cedulaCliente,
      };

  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }
}

class PedidoResumen {
  final String facturaId;
  final String descripcion;
  final double total;

  const PedidoResumen({
    required this.facturaId,
    required this.descripcion,
    required this.total,
  });
}
