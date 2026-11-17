import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}

/// POST JSON a endpoints de auth con manejo de errores común.
Future<Map<String, dynamic>> postAuth({
  required String url,
  required Map<String, Object?> body,
  required String fallbackMessage,
  Duration timeout = const Duration(seconds: 30),
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

  if (decoded is! Map<String, dynamic>) {
    throw const AuthException(
      'El servidor devolvió una respuesta no válida.',
    );
  }

  if (response.statusCode < 200 || response.statusCode >= 300) {
    final error = decoded['error'];
    throw AuthException(
      error is String && error.isNotEmpty ? error : fallbackMessage,
    );
  }

  return decoded;
}



/// Guarda token y datos básicos del usuario en SharedPreferences.
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

  await preferences.setString(
    'user_email',
    (u['email'] ?? emailFallback ?? '').toString(),
  );
  await preferences.setString(
    'user_nombre',
    (u['nombre'] ?? '').toString(),
  );
  await preferences.setString(
    'user_apellido',
    (u['apellido'] ?? '').toString(),
  );
  if (u['telefono'] != null) {
    await preferences.setString('user_telefono', u['telefono'].toString());
  }
  if (u['id'] != null) {
    await preferences.setInt(
      'user_id',
      int.tryParse(u['id'].toString()) ?? 0,
    );
  }
  if (u['avatar'] != null) {
    await preferences.setString('user_avatar', u['avatar'].toString());
  }
}
