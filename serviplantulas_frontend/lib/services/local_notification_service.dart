import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

/// Muestra notificaciones en la bandeja del sistema (Android/iOS).
/// No aplica en web.
class LocalNotificationService {
  LocalNotificationService._();
  static final instance = LocalNotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;
  int _id = 1000;

  static const _channelId = 'serviplantulas_alertas';
  static const _channelName = 'Alertas Serviplantulas';

  Future<void> init() async {
    if (kIsWeb || _ready) return;

    const android = AndroidInitializationSettings('@mipmap/launcher_icon');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: 'Stock, ventas y alertas del vivero',
        importance: Importance.high,
      ),
    );

    _ready = true;
  }

  /// Android 13+ y iOS: pedir permiso de notificaciones.
  Future<bool> pedirPermiso() async {
    if (kIsWeb) return false;
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<void> mostrar({
    required String titulo,
    required String cuerpo,
    String? payload,
  }) async {
    if (kIsWeb) return;
    if (!_ready) await init();

    const android = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Stock, ventas y alertas del vivero',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
    );
    const ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.show(
      _id++,
      titulo,
      cuerpo,
      const NotificationDetails(android: android, iOS: ios),
      payload: payload,
    );
  }
}
