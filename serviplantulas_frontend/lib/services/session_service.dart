import 'package:shared_preferences/shared_preferences.dart';

/// Sesión local: token + caducidad por inactividad (15 min).
class SessionService {
  static const _kToken = 'auth_token';
  static const _kLast = 'session_last_activity_ms';
  static const inactivityTimeout = Duration(minutes: 15);

  Future<bool> hasToken() async {
    final p = await SharedPreferences.getInstance();
    final t = p.getString(_kToken);
    return t != null && t.isNotEmpty;
  }

  /// True si hay token y no superó los 15 min desde la última actividad.
  Future<bool> hasValidSession() async {
    final p = await SharedPreferences.getInstance();
    final t = p.getString(_kToken);
    if (t == null || t.isEmpty) return false;

    final last = p.getInt(_kLast);
    if (last == null) {
      await touchActivity();
      return true;
    }

    final elapsed = DateTime.now().millisecondsSinceEpoch - last;
    if (elapsed > inactivityTimeout.inMilliseconds) {
      await clearSession();
      return false;
    }
    return true;
  }

  Future<void> touchActivity() async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kLast, DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> clearSession() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kToken);
    await p.remove(_kLast);
    // Opcional: no borramos user_* para rellenar email en login
  }
}
