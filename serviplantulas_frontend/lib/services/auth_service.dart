import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_config.dart';

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  static Future<void> iniciarSesion({
    required String email,
    required String contrasena,
  }) async {
    late final http.Response response;
    try {
      response = await http
          .post(
            Uri.parse(ApiConfig.loginUrl),
            headers: ApiConfig.headers,
            body: jsonEncode({
              'email_usuarios': email,
              'contrasena_usuarios': contrasena,
            }),
          )
          .timeout(const Duration(seconds: 15));
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
      throw const AuthException('El servidor devolvió una respuesta no válida.');
    }

    if (response.statusCode != 200) {
      final error = decoded['error'];
      throw AuthException(
        error is String && error.isNotEmpty
            ? error
            : 'No fue posible iniciar sesión. Inténtalo de nuevo.',
      );
    }

    final token = decoded['token'];
    if (token is! String || token.isEmpty) {
      throw const AuthException(
        'El servidor no devolvió un token de sesión válido.',
      );
    }

    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = await preferences.setString('auth_token', token);
      if (!saved) {
        throw const AuthException(
          'No se pudo guardar la sesión en este dispositivo.',
        );
      }
    } on PlatformException {
      throw const AuthException(
        'No se pudo guardar la sesión en este dispositivo.',
      );
    }
  }
}
