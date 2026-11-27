import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _kToken = 'auth_token';

  Future<bool> hasToken() async {
    final t = await _readToken();
    return t != null && t.isNotEmpty;
  }

  /// Token presente y no vencido según el claim `exp` del JWT.
  Future<bool> hasValidSession() async {
    final t = await _readToken();
    if (t == null || t.isEmpty) return false;
    if (_jwtExpired(t)) {
      await clearSession();
      return false;
    }
    return true;
  }

  Future<void> touchActivity() async {}

  Future<void> clearSession() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kToken);
    await p.remove('session_last_activity_ms');
  }

  Future<String?> _readToken() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kToken);
  }

  bool _jwtExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return true;
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      if (payload is! Map || payload['exp'] == null) return false;
      final exp = int.tryParse(payload['exp'].toString());
      if (exp == null) return false;
      // margen de 30 s
      return DateTime.now().millisecondsSinceEpoch >= (exp * 1000) - 30000;
    } catch (_) {
      return true;
    }
  }
}