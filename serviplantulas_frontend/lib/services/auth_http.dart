import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_config.dart';

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}

Future<Map<String, dynamic>> postAuth({
  required String url,
  required Map<String, Object?> body,
  required String fallbackMessage,
  Duration timeout = const Duration(seconds: 45),
}) async {
  late final http.Response response;
  try {
    response = await http
        .post(
          Uri.parse(url),
          headers: ApiConfig.headers,
          body: jsonEncode(body),
        )
        .timeout(timeout);
  } on SocketException {
    throw const AuthException(
      'No se pudo conectar con el servidor. Verifica tu conexión e inténtalo de nuevo.',
    );
  } on TimeoutException {
    throw const AuthException(
      'El servidor tardó demasiado en responder. Inténtalo de nuevo.',
    );
  } on http.ClientException {
    throw const AuthException(
      'No se pudo conectar con el servidor. Inténtalo de nuevo.',
    );
  }

  final dynamic decoded;
  try {
    decoded = jsonDecode(utf8.decode(response.bodyBytes));
  } on FormatException {
    throw const AuthException(
      'El servidor devolvió una respuesta no válida.',
    );
  }

  if (decoded is! Map) {
    throw const AuthException(
      'El servidor devolvió una respuesta no válida.',
    );
  }

  final map = Map<String, dynamic>.from(decoded);

  if (response.statusCode < 200 || response.statusCode >= 300) {
    final error = map['error'];
    throw AuthException(
      error is String && error.isNotEmpty ? error : fallbackMessage,
    );
  }

  return map;
}

Future<void> guardarSesionDesdeLogin(
  Map<String, dynamic> decoded, {
  String? emailFallback,
}) async {
  final token = decoded['token'];
  if (token is! String || token.isEmpty) {
    throw const AuthException(
      'El servidor no devolvió un token de sesión válido.',
    );
  }

  final preferences = await SharedPreferences.getInstance();
  final saved = await preferences.setString('auth_token', token);
  if (!saved) {
    throw const AuthException(
      'No se pudo guardar la sesión en este dispositivo.',
    );
  }

  final u = decoded['usuario'];
  if (u is! Map) return;

  final usuario = Map<String, dynamic>.from(u);

  await preferences.setString(
    'user_email',
    (usuario['email'] ?? emailFallback ?? '').toString(),
  );
  await preferences.setString(
    'user_nombre',
    (usuario['nombre'] ?? '').toString(),
  );
  await preferences.setString(
    'user_apellido',
    (usuario['apellido'] ?? '').toString(),
  );
  await preferences.setString(
    'user_rol',
    (usuario['rol'] ?? 'usuario').toString(),
  );
  if (usuario['telefono'] != null) {
    await preferences.setString(
      'user_telefono',
      usuario['telefono'].toString(),
    );
  }
  if (usuario['id'] != null) {
    await preferences.setInt(
      'user_id',
      int.tryParse(usuario['id'].toString()) ?? 0,
    );
  }
  if (usuario['avatar'] != null) {
    await preferences.setString(
      'user_avatar',
      usuario['avatar'].toString(),
    );
  }
}
