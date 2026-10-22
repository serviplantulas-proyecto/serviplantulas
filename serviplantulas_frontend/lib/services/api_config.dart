import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  static const String _apiBaseUrlOverride = String.fromEnvironment(
    'API_BASE_URL',
  );

  // ── Auth ──
  static String get loginUrl => '${_apiHost}auth/login';
  static String get registerUrl => '${_apiHost}auth/register';
  static String get verifyAccountUrl => '${_apiHost}auth/verify-account';
  static String get resendVerificationUrl =>
      '${_apiHost}auth/resend-verification';
  static String get forgotPasswordUrl => '${_apiHost}auth/forgot-password';
  static String get verifyRecoveryCodeUrl => '${_apiHost}auth/verify-code';

  // ── Chat ──
  static String get chatbotUrl => '${_apiHost}chatbot/';

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

  static String get _apiHost {
    if (_apiBaseUrlOverride.isNotEmpty) {
      return _apiBaseUrlOverride.endsWith('/')
          ? _apiBaseUrlOverride
          : '$_apiBaseUrlOverride/';
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
    'ngrok-skip-browser-warning': 'true',
  };

  static Map<String, String> authHeaders(String token) => {
    ...headers,
    'Authorization': 'Bearer $token',
  };
}
