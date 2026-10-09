class Cliente {
  final String id;
  final String nombre;
  final String documento;
  final String tipoDocumento;
  final String? telefono;
  final int totalPedidos;
  final String? ultimoAcceso;
  final List<PedidoResumen> historialReciente;
  final double descuentoFrecuente;

  const Cliente({
    required this.id,
    required this.nombre,
    required this.documento,
    required this.tipoDocumento,
    this.telefono,
    this.totalPedidos = 0,
    this.ultimoAcceso,
    this.historialReciente = const [],
    this.descuentoFrecuente = 0,
  });
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
