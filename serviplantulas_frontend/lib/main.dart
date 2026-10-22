import 'package:flutter/material.dart';
import 'package:serviplantulas_frontend/pantallas/login.dart';
import 'styles/app_theme.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final impl = ImagePickerPlatform.instance;
  if (impl is ImagePickerAndroid) {
    impl.useAndroidPhotoPicker = true;
  }

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

//pantallas para reducir(sacar widgets): detalle_producto_page.dart, analisis_ventas_page.dart, registro_venta_page.dart, registrar_producto_page.dart, inventario_page.dart, directorio_proveedores_page.dart, categorias_page.dart, agregar_proveedor_page.dart, generar_factura_page.dart, chat_eva_page.dart y mi_cuenta_page.dart, verificar "editar planta" del frontend- inventario

//configirar permisos y credenciales del github:
//PS D:\Programacion\web-adso> git config --global user.name "serviplantulas-proyecto"
//PS D:\Programacion\web-adso> git config --global user.email "serviplantulas@gmail.com"
//check list instructor |°/- https://jlombanar.github.io/adso_ficha_3169657/ -\°|

//comandos para elevar sv, apk:
//dependencia para instalar: npm install -g ngrok
//comando del token ngrok config add-authtoken 3L3KIYhhybxJYXmSMVStIIRxDZW_ttp6Qj9TW5b1q7nfUtay
//habilitar la puerta de enlace  ngrok http 3000
//pagina del ngrok: https://dashboard.ngrok.com/