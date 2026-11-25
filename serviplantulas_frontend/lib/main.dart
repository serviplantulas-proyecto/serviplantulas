import 'package:flutter/material.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:serviplantulas_frontend/pantallas/login.dart';

import 'services/local_notification_service.dart';
import 'styles/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // final impl = ImagePickerPlatform.instance;
    // if (impl is ImagePickerAndroid) {
    //   ImagePickerAndroid().useAndroidPhotoPicker = true;
    // }
  } catch (_) {}

  // NO pedir permisos ni init de notificaciones aquí:
  // en Android release suele cerrar la app a los pocos segundos.

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    // Después del primer frame, inicializar en segundo plano
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initNotificacionesSeguro();
    });
  }

  Future<void> _initNotificacionesSeguro() async {
    try {
      await LocalNotificationService.instance.init();
      // El permiso se puede pedir después; no bloquear el arranque
      await LocalNotificationService.instance.pedirPermiso();
    } catch (_) {
      // Si falla, la app sigue; solo no habrá push local
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
