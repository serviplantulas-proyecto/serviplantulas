import 'package:shared_preferences/shared_preferences.dart';

/// Sesión local: el token se mantiene hasta cerrar sesión manualmente.
class SessionService {
  static const _kToken = 'auth_token';

  Future<bool> hasToken() async {
    final p = await SharedPreferences.getInstance();
    final t = p.getString(_kToken);
    return t != null && t.isNotEmpty;
  }

  /// True si hay token guardado (no se limpia al salir de la app).
  Future<bool> hasValidSession() async {
    return hasToken();
  }

  Future<void> touchActivity() async {
    // Ya no se usa para caducar sesión; se deja por compatibilidad.
  }

  Future<void> clearSession() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kToken);
    await p.remove('session_last_activity_ms');
  }
}