import 'venta_productos_section.dart';
import '../../models/cliente.dart';
import '../../models/producto.dart';
import '../../services/clientes_service.dart';
import '../../services/pedidos_service.dart';
import '../../services/productos_service.dart';

/// Lógica de catálogo y registro (sin UI).
class RegistroVentaController {
  final _clientesService = ClientesService();
  final _productosService = ProductosService();
  final _pedidosService = PedidosService();

  List<Cliente> clientes = [];
  List<Producto> productos = [];
  Cliente? cliente;
  final List<ItemVenta> items = [];
  String metodoPago = 'Efectivo';

  double get subtotal => items.fold(0.0, (s, i) => s + i.subtotal);
  double get descuento =>
      subtotal * ((cliente?.descuentoFrecuente ?? 0) / 100);
  double get total => subtotal - descuento;

  Future<void> cargarCatalogo() async {
    clientes = await _clientesService.listar();
    productos = await _productosService.listar();
  }

  List<Cliente> filtrarClientes(String q) {
    final query = q.trim().toLowerCase();
    if (query.isEmpty) return [];
    return clientes
        .where((c) =>
            c.nombre.toLowerCase().contains(query) ||
            c.documento.contains(query))
        .toList();
  }

  List<Producto> filtrarProductos(String q) {
    final query = q.trim().toLowerCase();
    if (query.isEmpty) return [];
    return productos
        .where((p) => p.nombre.toLowerCase().contains(query))
        .toList();
  }

  void seleccionarCliente(Cliente c) => cliente = c;

  void limpiarCliente() => cliente = null;

  void agregarProducto(Producto p) {
    final idx = items.indexWhere((i) => i.producto.id == p.id);
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(cantidad: items[idx].cantidad + 1);
    } else {
      items.add(ItemVenta(producto: p, cantidad: 1));
    }
  }

  void cambiarCantidad(int index, int delta) {
    final nueva = items[index].cantidad + delta;
    if (nueva <= 0) {
      items.removeAt(index);
    } else {
      items[index] = items[index].copyWith(cantidad: nueva);
    }
  }

  Future<int> registrar() {
    if (cliente == null) {
      throw const PedidosException('Selecciona un cliente');
    }
    if (items.isEmpty) {
      throw const PedidosException('Agrega al menos un producto');
    }
    return _pedidosService.registrarVenta(
      idCliente: cliente!.idCliente,
      items: items,
      metodoPago: metodoPago,
    );
  }
}
