import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_config.dart';

class NotificacionesException implements Exception {
  final String message;
  const NotificacionesException(this.message);
  @override
  String toString() => message;
}



class NotificacionItem {
  final int id;
  final String titulo;
  final String mensaje;
  final String tipo;
  final bool leida;
  final DateTime? creadaEn;

  const NotificacionItem({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.tipo,
    required this.leida,
    this.creadaEn,
  });

  factory NotificacionItem.fromJson(Map<String, dynamic> j) {
    return NotificacionItem(
      id: _asInt(j['id_notificacion']),
      titulo: (j['titulo'] ?? '').toString(),
      mensaje: (j['mensaje'] ?? '').toString(),
      tipo: (j['tipo'] ?? 'general').toString(),
      leida: j['leida'] == true,
      creadaEn: j['creada_en'] != null
          ? DateTime.tryParse(j['creada_en'].toString())
          : null,
    );
  }

  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }
}

class NotificacionesService {
  Future<List<NotificacionItem>> listar() async {
    final token = await _token();
    final d = await _get(Uri.parse(ApiConfig.notificacionesUrl), token);
    return _asList(d).map(NotificacionItem.fromJson).toList();
  }

  Future<List<NotificacionItem>> listarNoLeidas() async {
    final token = await _token();
    final d =
        await _get(Uri.parse(ApiConfig.notificacionesNoLeidasUrl), token);
    return _asList(d).map(NotificacionItem.fromJson).toList();
  }

  Future<int> contarNoLeidas() async {
    try {
      return (await listarNoLeidas()).length;
    } catch (_) {
      return 0;
    }
  }

  Future<int> limpiarAntiguas(int dias) async {
    final token = await _token();
    final r = await http
        .post(
          Uri.parse(ApiConfig.notificacionesLimpiarUrl),
          headers: ApiConfig.authHeaders(token),
          body: jsonEncode({'dias': dias}),
        )
        .timeout(const Duration(seconds: 20));
    final d = _decode(r);
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw NotificacionesException(_err(d, 'No se pudo limpiar.'));
    }
    if (d is Map && d['eliminadas'] != null) {
      final v = d['eliminadas'];
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }
    return 0;
  }

  Future<void> marcarLeida(int id) async {
    final token = await _token();
    await _put(Uri.parse(ApiConfig.notificacionLeidaUrl(id)), token);
  }

  Future<void> marcarTodasLeidas() async {
    for (final n in await listarNoLeidas()) {
      await marcarLeida(n.id);
    }
  }

  Future<void> crear({
    required String titulo,
    required String mensaje,
    String tipo = 'general',
    int? idProducto,
  }) async {
    final token = await _token();
    await _post(
      Uri.parse(ApiConfig.notificacionesUrl),
      {
        'titulo': titulo,
        'mensaje': mensaje,
        'tipo': tipo,
        if (idProducto != null) 'id_producto': idProducto,
      },
      token,
    );
  }

  Future<String> _token() async {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString('auth_token');
    if (t == null || t.isEmpty) {
      throw const NotificacionesException('Sin sesión.');
    }
    return t;
  }

  Future<dynamic> _get(Uri uri, String token) async {
    try {
      final r = await http
          .get(uri, headers: ApiConfig.authHeaders(token))
          .timeout(const Duration(seconds: 15));
      final d = _decode(r);
      if (r.statusCode < 200 || r.statusCode >= 300) {
        throw NotificacionesException(_err(d, 'Error al listar.'));
      }
      return d;
    } on SocketException {
      throw const NotificacionesException('Sin conexión.');
    } on TimeoutException {
      throw const NotificacionesException('Tiempo de espera agotado.');
    }
  }

  Future<void> _put(Uri uri, String token) async {
    final r = await http
        .put(uri, headers: ApiConfig.authHeaders(token))
        .timeout(const Duration(seconds: 15));
    final d = _decode(r);
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw NotificacionesException(_err(d, 'No se pudo actualizar.'));
    }
  }

  Future<void> _post(
    Uri uri,
    Map<String, dynamic> body,
    String token,
  ) async {
    final r = await http
        .post(
          uri,
          headers: ApiConfig.authHeaders(token),
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));
    final d = _decode(r);
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw NotificacionesException(_err(d, 'No se pudo crear.'));
    }
  }

  dynamic _decode(http.Response r) {
    if (r.body.isEmpty) return null;
    try {
      return jsonDecode(utf8.decode(r.bodyBytes));
    } on FormatException {
      throw const NotificacionesException('Respuesta inválida.');
    }
  }

  List<Map<String, dynamic>> _asList(dynamic d) {
    if (d is List) {
      return d
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return const [];
  }

  String _err(dynamic d, String f) {
    if (d is Map && d['error'] is String && (d['error'] as String).isNotEmpty) {
      return d['error'] as String;
    }
    return f;
  }
}
