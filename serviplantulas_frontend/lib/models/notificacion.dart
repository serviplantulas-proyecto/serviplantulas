/// Ítem de notificación del sistema.
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
      creadaEn: _parseFecha(j['creada_en']),
    );
  }

  /// Supabase guarda UTC sin zona; si no hay Z/+offset, se asume UTC.
  static DateTime? _parseFecha(dynamic raw) {
    if (raw == null) return null;
    final s = raw.toString().trim();
    if (s.isEmpty) return null;
    final parsed = DateTime.tryParse(s);
    if (parsed == null) return null;
    final hasTz =
        s.endsWith('Z') || RegExp(r'[+-]\d{2}:\d{2}$').hasMatch(s);
    if (!hasTz) {
      return DateTime.utc(
        parsed.year,
        parsed.month,
        parsed.day,
        parsed.hour,
        parsed.minute,
        parsed.second,
        parsed.millisecond,
      ).toLocal();
    }
    return parsed.toLocal();
  }

  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }
}

