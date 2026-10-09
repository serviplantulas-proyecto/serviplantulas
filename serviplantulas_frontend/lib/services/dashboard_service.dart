import '../models/dashboard_stats.dart';

/// Servicio de dashboard.
/// Actualmente usa datos mock. Reemplazar el cuerpo de [obtenerResumen]
/// con la llamada HTTP real al backend cuando esté listo.
class DashboardService {
  // TODO: inyectar ApiConfig.baseUrl + endpoint real
  // static const String _endpoint = 'dashboard/resumen';

  Future<DashboardStats> obtenerResumen() async {
    // Simula latencia de red
    await Future.delayed(const Duration(milliseconds: 300));

    // ── Datos mock (reemplazar por respuesta del backend) ──
    return const DashboardStats(
      ventasDelDia: 1420500,
      productosStock: 14820,
      clientesActivos: 312,
      pedidosPendientes: 18,
      variacionSemanal: 12.4,
      historicoVentas: [
        SalesBarData(label: 'Vie', value: 45),
        SalesBarData(label: 'Sáb', value: 80),
        SalesBarData(label: 'Dom', value: 86),
        SalesBarData(label: 'Lun', value: 30),
        SalesBarData(label: 'Mar', value: 65),
        SalesBarData(label: 'Mié', value: 50),
        SalesBarData(label: 'Jue', value: 75, isHighlighted: true),
      ],
    );
  }
}
