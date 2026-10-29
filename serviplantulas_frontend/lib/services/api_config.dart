import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // Cambia a false cuando quieras volver a probar con tu servidor Node.js local
  static const bool useRemote = false;

  // URL de tu backend desplegado en Render
  static const String _remoteUrl = 'https://serviplantulas.onrender.com/';

  // ── Auth ──
  static String get loginUrl => '${_apiHost}auth/login';
  static String get registerUrl => '${_apiHost}auth/register';
  static String get verifyAccountUrl => '${_apiHost}auth/verify-account';
  static String get resendVerificationUrl =>
      '${_apiHost}auth/resend-verification';
  static String get forgotPasswordUrl => '${_apiHost}auth/forgot-password';
  static String get verifyRecoveryCodeUrl => '${_apiHost}auth/verify-code';
  static String get verifyProfileChangeUrl =>
      '${_apiHost}auth/verify-profile-change';

  // ── Chat ──
  static String get chatbotUrl => '${_apiHost}chatbot/';
  static String get chatbotSesionesUrl => '${chatbotUrl}sesiones';
  static String chatbotHistorialUrl(String sesionId) =>
      '${chatbotUrl}historial/$sesionId';

  // ── Productos ──
  // Backend: app.use("/productos", productosRouter)
  // Router: GET/POST /productos  →  /productos/productos
  static String get productosUrl => '${_apiHost}productos/productos';
  static String productoByIdUrl(int id) => '${productosUrl}/$id';
  static String productosByCategoriaUrl(int idCategoria) =>
      '${productosUrl}/categoria/$idCategoria';

  // ── Categorías ──
  static String get categoriasUrl => '${_apiHost}categorias/';
  static String categoriaByIdUrl(int id) => '${categoriasUrl}$id';

  // ── Proveedores ──
  static String get proveedoresUrl => '${_apiHost}proveedores/';
  static String proveedorByIdUrl(int id) => '${proveedoresUrl}$id';

  // ── Clientes ──
  static String get clientesUrl => '${_apiHost}clientes/';

  // ── Pedidos / ventas ──
  static String get pedidosUrl => '${_apiHost}pedidos/';
  static String pedidoByIdUrl(int id) => '${pedidosUrl}$id';
  static String get detallePedidosUrl => '${_apiHost}detalle-pedidos/';
  static String detallesPorPedidoUrl(int idPedido) =>
      '${detallePedidosUrl}pedido/$idPedido';

  // ── Notificaciones ──
  static String get notificacionesUrl => '${_apiHost}notificaciones/';
  static String get notificacionesNoLeidasUrl =>
      '${notificacionesUrl}no-leidas';
  static String notificacionLeidaUrl(int id) => '${notificacionesUrl}$id/leida';

  static String get _apiHost {
    if (useRemote) {
      return _remoteUrl;
    }
    if (kIsWeb) {
      return 'http://localhost:3000/';
    }
    if (Platform.isAndroid) {
      // Emulador Android → host de la máquina
      return 'http://10.0.2.2:3000/';
    }
    if (Platform.isIOS) {
      return 'http://localhost:3000/';
    }
    return 'http://localhost:3000/';
  }

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) => {
    ...headers,
    'Authorization': 'Bearer $token',
  };
}
