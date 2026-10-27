/// Modelo alineado a la tabla `clientes` del backend.
class Cliente {
  final int idCliente;
  final String nombreCliente;
  final String? telefonoCliente;
  final String? correoCliente;
  final String? direccionCliente;
  final String? cedulaCliente;
  final String? fechaRegistro;

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
    this.fechaRegistro,
    this.totalPedidos = 0,
    this.ultimaCompra,
    this.historialReciente = const [],
    this.descuentoFrecuente = 0,
  });

  String get id => idCliente.toString();
  String get nombre => nombreCliente;
  String get documento => cedulaCliente ?? '';
  String get telefono => telefonoCliente ?? '';
  String get tipoDocumento {
    final d = cedulaCliente ?? '';
    if (d.contains('-') || d.replaceAll('.', '').length > 10) return 'NIT';
    return 'C.C.';
  }

  Cliente copyWith({
    int? totalPedidos,
    String? ultimaCompra,
    List<PedidoResumen>? historialReciente,
    String? fechaRegistro,
  }) {
    return Cliente(
      idCliente: idCliente,
      nombreCliente: nombreCliente,
      telefonoCliente: telefonoCliente,
      correoCliente: correoCliente,
      direccionCliente: direccionCliente,
      cedulaCliente: cedulaCliente,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      totalPedidos: totalPedidos ?? this.totalPedidos,
      ultimaCompra: ultimaCompra ?? this.ultimaCompra,
      historialReciente: historialReciente ?? this.historialReciente,
      descuentoFrecuente: descuentoFrecuente,
    );
  }

  factory Cliente.fromJson(Map<String, dynamic> json) {
    final rawFecha = json['fecha_registro'] ??
        json['created_at'] ??
        json['creado_en'] ??
        json['fecha_creacion'];
    return Cliente(
      idCliente: _asInt(json['id_cliente']),
      nombreCliente: (json['nombre_cliente'] ?? '').toString(),
      telefonoCliente: json['telefono_cliente']?.toString(),
      correoCliente: json['correo_cliente']?.toString(),
      direccionCliente: json['direccion_cliente']?.toString(),
      cedulaCliente: json['cedula_cliente']?.toString(),
      fechaRegistro: _formatFecha(rawFecha),
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre_cliente': nombreCliente,
        if (telefonoCliente != null) 'telefono_cliente': telefonoCliente,
        if (correoCliente != null) 'correo_cliente': correoCliente,
        if (direccionCliente != null) 'direccion_cliente': direccionCliente,
        if (cedulaCliente != null) 'cedula_cliente': cedulaCliente,
      };

  static String? _formatFecha(dynamic raw) {
    if (raw == null) return null;
    try {
      final dt = DateTime.parse(raw.toString()).toLocal();
      const meses = [
        'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
      ];
      return '${dt.day.toString().padLeft(2, '0')} ${meses[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw.toString();
    }
  }

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
