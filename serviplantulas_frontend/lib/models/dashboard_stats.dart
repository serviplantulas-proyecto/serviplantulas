class DashboardStats {
  final double ventasDelDia;
  final int productosStock;
  final int clientesActivos;
  final int pedidosPendientes;
  final double variacionSemanal;
  final List<SalesBarData> historicoVentas;
  final int notificacionesNoLeidas;
  final String nombreUsuario;

  const DashboardStats({
    required this.ventasDelDia,
    required this.productosStock,
    required this.clientesActivos,
    required this.pedidosPendientes,
    required this.variacionSemanal,
    required this.historicoVentas,
    this.notificacionesNoLeidas = 0,
    this.nombreUsuario = 'Admin',
  });
}

class SalesBarData {
  final String label;
  final double value;
  final int unidades;
  final bool isHighlighted;

  const SalesBarData({
    required this.label,
    required this.value,
    this.unidades = 0,
    this.isHighlighted = false,
  });
}
