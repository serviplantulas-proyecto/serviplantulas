class DashboardStats {
  final double ventasDelDia;
  final int productosStock;
  final int clientesActivos;
  final int pedidosPendientes;
  final double variacionSemanal;
  final List<SalesBarData> historicoVentas;

  const DashboardStats({
    required this.ventasDelDia,
    required this.productosStock,
    required this.clientesActivos,
    required this.pedidosPendientes,
    required this.variacionSemanal,
    required this.historicoVentas,
  });
}

class SalesBarData {
  final String label;
  final double value;
  final bool isHighlighted;

  const SalesBarData({
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });
}
