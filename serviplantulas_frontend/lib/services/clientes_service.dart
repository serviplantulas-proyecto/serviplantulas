import '../models/cliente.dart';

/// Servicio de clientes.
/// Datos mock por ahora. Conectar al backend cuando esté listo.
class ClientesService {
  // TODO: ApiConfig.baseUrl + 'clientes'

  Future<List<Cliente>> obtenerClientes({String? busqueda}) async {
    await Future.delayed(const Duration(milliseconds: 250));

    var lista = _mockClientes;
    if (busqueda != null && busqueda.trim().isNotEmpty) {
      final q = busqueda.toLowerCase();
      lista = lista
          .where((c) =>
              c.nombre.toLowerCase().contains(q) ||
              c.documento.contains(q))
          .toList();
    }
    return lista;
  }

  static const List<Cliente> _mockClientes = [
    Cliente(
      id: 'C001',
      nombre: 'Carlos Restrepo Restrepo',
      documento: '1045.230.981',
      tipoDocumento: 'C.C.',
      telefono: '+57 312 450 9081',
      totalPedidos: 14,
      ultimoAcceso: '08 Oct 2023',
      descuentoFrecuente: 5,
      historialReciente: [
        PedidoResumen(
          facturaId: 'FACT-1042',
          descripcion: '3x Helechos',
          total: 67500,
        ),
        PedidoResumen(
          facturaId: 'FACT-0982',
          descripcion: '1x Abono Orgánico',
          total: 15000,
        ),
      ],
    ),
    Cliente(
      id: 'C002',
      nombre: 'Diana María Gómez Trujillo',
      documento: '32.540.912',
      tipoDocumento: 'C.C.',
      telefono: '+57 300 123 4567',
      totalPedidos: 7,
      ultimoAcceso: '02 Oct 2023',
    ),
    Cliente(
      id: 'C003',
      nombre: 'Inversiones del Bosque S.A.S',
      documento: '900.231.412-1',
      tipoDocumento: 'NIT',
      telefono: '+57 601 555 0101',
      totalPedidos: 22,
      ultimoAcceso: '05 Oct 2023',
      descuentoFrecuente: 8,
    ),
  ];
}
