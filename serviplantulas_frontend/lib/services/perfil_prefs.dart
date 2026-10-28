import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PerfilPrefs {
  final String email;
  final String nombre;
  final String telefono;
  final String rol;

  const PerfilPrefs({
    required this.email,
    required this.nombre,
    required this.telefono,
    required this.rol,
  });

  static Future<PerfilPrefs> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('user_email') ?? '';
    var nombre = prefs.getString('user_nombre') ?? '';
    var apellido = prefs.getString('user_apellido') ?? '';
    var telefono = prefs.getString('user_telefono') ?? '';
    var rol = prefs.getString('user_rol') ?? '';
    final token = prefs.getString('auth_token');
    if (token != null && token.contains('.')) {
      try {
        final map = jsonDecode(utf8.decode(
          base64Url.decode(base64Url.normalize(token.split('.')[1])),
        ));
        if (map is Map) {
          if (email.isEmpty) email = (map['email'] ?? '').toString();
          if (nombre.isEmpty) nombre = (map['nombre'] ?? '').toString();
          if (apellido.isEmpty) apellido = (map['apellido'] ?? '').toString();
          if (rol.isEmpty) rol = (map['rol'] ?? '').toString();
          if (telefono.isEmpty) telefono = (map['telefono'] ?? '').toString();
        }
      } catch (_) {}
    }
    final full =
        [nombre, apellido].where((s) => s.trim().isNotEmpty).join(' ');
    final display =
        full.isNotEmpty ? full : (email.isNotEmpty ? email : 'Usuario');
    final r = rol.trim().toLowerCase();
    final rolLabel = (r == 'admin' || r == 'administrador')
        ? 'Administrador'
        : (r.isEmpty ? 'Usuario' : rol[0].toUpperCase() + rol.substring(1));
    return PerfilPrefs(
      email: email,
      nombre: display,
      telefono: telefono,
      rol: rolLabel,
    );
  }

  static Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    for (final k in [
      'auth_token', 'user_email', 'user_nombre', 'user_apellido',
      'user_telefono', 'user_rol', 'user_id',
    ]) {
      await prefs.remove(k);
    }
  }
}
