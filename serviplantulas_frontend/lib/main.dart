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

//pantallas para reducir(sacar widgets): detalle_producto_page.dart, analisis_ventas_page.dart, registro_venta_page.dart, registrar_producto_page.dart, inventario_page.dart, directorio_proveedores_page.dart, categorias_page.dart, agregar_proveedor_page.dart, generar_factura_page.dart, chat_eva_page.dart, mi_cuenta_page.dart.

//configirar permisos y credenciales del github:
//PS D:\Programacion\web-adso> git config --global user.name "serviplantulas-proyecto"
//PS D:\Programacion\web-adso> git config --global user.email "serviplantulas@gmail.com"
//check list instructor |°/- https://jlombanar.github.io/adso_ficha_3169657/ -\°|

//comandos para elevar sv, apk:
//dependencia para instalar: npm install -g ngrok
//comando del token: ngrok config add-authtoken 3L3KIYhhybxJYXmSMVStIIRxDZW_ttp6Qj9TW5b1q7nfUtay
//habilitar la puerta de enlace:  ngrok http 3000
//pagina del ngrok: https://dashboard.ngrok.com/
//comando para compilar el proyecto a apk: flutter build apk --debug --dart-define=API_BASE_URL=https://surging-gaffe-shell.ngrok-free.dev
//se guarda en la carpeta \build\app\outputs\apk\debug\"archivo.apk"

//cosas para modificar:
//organizar dashboard
//organizar gestionar notificaciones
//organizar notificaciones
//organizar el token de mantener inicio se secion
//organizar el token de inicio se secion con google
//organizar input de "cantidad a ajustar" en Ajustar stock
//organizar quitar icono de filtros en el inventario 
//organizar colocar metoco de pago en "nueva venta", metodos(Efectivo y transferencia)
//organizar bloquear el metodo de pago en "resumen de venta", segun el que se escoja al momento de hacer la venta
//organizar el boton de enviar por correo en "resumen de venta"
//organizar el permitir cambiar el correo y el numero en "mi cuenta"
//organizar la fecha de registro en "detalle del cliente"
//organizar lo de ultimas compras en "detalle del cliente"
//organizar el historial del chatbot