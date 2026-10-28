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

class ChatMensaje {
  final String texto;
  final bool esUsuario;
  final DateTime? fecha;

  const ChatMensaje({
    required this.texto,
    required this.esUsuario,
    this.fecha,
  });
}

class ChatSesionItem {
  final String sesionId;
  final String preview;
  final DateTime? ultimaFecha;

  const ChatSesionItem({
    required this.sesionId,
    required this.preview,
    this.ultimaFecha,
  });
}

class ChatEvaService {
  static Future<String> enviarMensaje(
    String mensaje, {
    required String sesionId,
  }) async {
    final decoded = await _post(
      Uri.parse(ApiConfig.chatbotUrl),
      {'mensaje': mensaje, 'sesionId': sesionId},
    );
    final respuesta = decoded['respuesta'];
    if (respuesta is! String || respuesta.isEmpty) {
      throw const ChatException('Sin respuesta del servidor.');
    }
    return respuesta;
  }

  static Future<List<ChatSesionItem>> listarSesiones() async {
    final decoded = await _get(Uri.parse(ApiConfig.chatbotSesionesUrl));
    final list = decoded['sesiones'];
    if (list is! List) return [];
    return list.whereType<Map>().map((e) {
      final m = Map<String, dynamic>.from(e);
      return ChatSesionItem(
        sesionId: (m['sesionId'] ?? m['sesion_id'] ?? '').toString(),
        preview: (m['preview'] ?? m['mensaje'] ?? '').toString(),
        ultimaFecha: m['ultimaFecha'] != null || m['created_at'] != null
            ? DateTime.tryParse(
                (m['ultimaFecha'] ?? m['created_at']).toString(),
              )
            : null,
      );
    }).where((s) => s.sesionId.isNotEmpty).toList();
  }

  static Future<List<ChatMensaje>> obtenerHistorial(String sesionId) async {
    final decoded =
        await _get(Uri.parse(ApiConfig.chatbotHistorialUrl(sesionId)));
    final list = decoded['historial'];
    if (list is! List) return [];
    // Backend: ascending true → oldest first
    return list.whereType<Map>().map((e) {
      final m = Map<String, dynamic>.from(e);
      final emisor = (m['emisor'] ?? '').toString().toLowerCase();
      return ChatMensaje(
        texto: (m['mensaje'] ?? '').toString(),
        esUsuario: emisor == 'user' || emisor == 'usuario',
        fecha: m['created_at'] != null
            ? DateTime.tryParse(m['created_at'].toString())
            : null,
      );
    }).toList();
  }

  static Future<Map<String, dynamic>> _post(
    Uri uri,
    Map<String, dynamic> body,
  ) async {
    try {
      final r = await http
          .post(uri, headers: ApiConfig.headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));
      return _handle(r, 'No fue posible procesar el mensaje.');
    } on SocketException {
      throw const ChatException('Sin conexión con el servidor.');
    } on TimeoutException {
      throw const ChatException('El servidor no respondió a tiempo.');
    }
  }

  static Future<Map<String, dynamic>> _get(Uri uri) async {
    try {
      final r = await http
          .get(uri, headers: ApiConfig.headers)
          .timeout(const Duration(seconds: 20));
      return _handle(r, 'No se pudo cargar el historial.');
    } on SocketException {
      throw const ChatException('Sin conexión con el servidor.');
    } on TimeoutException {
      throw const ChatException('El servidor no respondió a tiempo.');
    }
  }

  static Map<String, dynamic> _handle(http.Response r, String fallback) {
    dynamic decoded;
    try {
      decoded = jsonDecode(utf8.decode(r.bodyBytes));
    } on FormatException {
      throw const ChatException('Respuesta no válida del servidor.');
    }
    if (decoded is! Map<String, dynamic>) {
      throw const ChatException('Respuesta no válida del servidor.');
    }
    if (r.statusCode < 200 || r.statusCode >= 300) {
      final m = decoded['message'] ?? decoded['error'];
      throw ChatException(m is String && m.isNotEmpty ? m : fallback);
    }
    return decoded;
  }
}
