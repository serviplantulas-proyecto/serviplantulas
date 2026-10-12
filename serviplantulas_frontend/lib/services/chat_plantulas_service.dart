import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class ChatException implements Exception {
  final String message;

  const ChatException(this.message);

  @override
  String toString() => message;
}

class ChatEvaService {
  static Future<String> enviarMensaje(
    String mensaje, {
    required String sesionId,
  }) async {
    late final http.Response response;
    try {
      response = await http
          .post(
            Uri.parse(ApiConfig.chatbotUrl),
            headers: ApiConfig.headers,
            body: jsonEncode({'mensaje': mensaje, 'sesionId': sesionId}),
          )
          .timeout(const Duration(seconds: 30));
    } on SocketException {
      throw const ChatException(
        'No se pudo conectar con el servidor. Verifica tu conexión e inténtalo de nuevo.',
      );
    } on TimeoutException {
      throw const ChatException(
        'El servidor tardó demasiado en responder. Inténtalo de nuevo.',
      );
    } on http.ClientException {
      throw const ChatException(
        'No se pudo conectar con el servidor. Inténtalo de nuevo.',
      );
    }

    final dynamic decoded;
    try {
      decoded = jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw const ChatException('El servidor devolvió una respuesta no válida.');
    }

    if (decoded is! Map<String, dynamic>) {
      throw const ChatException('El servidor devolvió una respuesta no válida.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded['message'];
      throw ChatException(
        message is String && message.isNotEmpty
            ? message
            : 'No fue posible procesar el mensaje. Inténtalo de nuevo.',
      );
    }

    final respuesta = decoded['respuesta'];
    if (respuesta is! String || respuesta.isEmpty) {
      throw const ChatException(
        'El servidor no devolvió una respuesta para tu mensaje.',
      );
    }

    return respuesta;
  }
}
