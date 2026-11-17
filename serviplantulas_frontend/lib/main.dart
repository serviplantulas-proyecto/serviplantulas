import 'package:flutter/material.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:serviplantulas_frontend/pantallas/login.dart';

import 'services/local_notification_service.dart';
import 'styles/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final impl = ImagePickerPlatform.instance;
  if (impl is ImagePickerAndroid) {
    impl.useAndroidPhotoPicker = true;
  }

  await LocalNotificationService.instance.init();
  await LocalNotificationService.instance.pedirPermiso();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

//pagina para los iconos |°/- https://www.flaticon.es/ -\°|
//pagina para convertir formato imagen a SVG |°/- https://www.autotracer.org/ -\°|
//comando para iniciar con opera |°/- $env:CHROME_EXECUTABLE="C:\Users\FINISTERRA\AppData\Local\Programs\Opera GX\opera.exe" -\°|
//guia del panel administrativo  |°/- https://jlombanar.github.io/adso_3169657/ -\°|

//archivos para reducir(sacar widgets): inventory_product_card.dart, producto_image_selector.dart, venta_productos_section.dart, agregar_categoria_page.dart, agregar_proveedor_page.dart, detalle_producto_page.dart, inventario_page.dart, registrar_producto_page.dart, auth_service.dart, notificaciones_service.dart, productos_service.dart

//configirar permisos y credenciales del github:
//PS D:\Programacion\web-adso> git config --global user.name "serviplantulas-proyecto"
//PS D:\Programacion\web-adso> git config --global user.email "serviplantulas@gmail.com"
//check list instructor |°/- https://jlombanar.github.io/adso_ficha_3169657/ -\°|

//comandos para elevar sv, apk:
//dependencia para instalar: npm install -g ngrok
//comando del token: ngrok config add-authtoken 3L3KIYhhybxJYXmSMVStIIRxDZW_ttp6Qj9TW5b1q7nfUtay
//habilitar la puerta de enlace:  ngrok http 3000
//pagina del ngrok: https://dashboard.ngrok.com/
//comando para compilar el proyecto a apk con ngrok: flutter build apk --debug --dart-define=API_BASE_URL=https://surging-gaffe-shell.ngrok-free.dev
//comando para compilar el proyeccto a apk normal: flutter build apk
//se guarda en la carpeta \build\app\outputs\apk\debug\"archivo.apk"

//cosas para modificar:

//solucionar error al editar producto, permitir realizar la compra incluso si esta por debajo del stock minimo(se realiza pero no se actualiza el stock), permitir editar un producto incluso si esta por debajo del stock minimo o es igual al stock minimo(dale error)