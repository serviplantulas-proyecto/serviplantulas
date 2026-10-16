import 'package:flutter/material.dart';
import 'package:serviplantulas_frontend/pantallas/login.dart';
import 'styles/app_theme.dart';

void main() {
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


//pantallas para reducir(sacar widgets): registrar_producto_page.dart, detalle_producto_page.dart, analisis_ventas_page.dart, chat_eva_page.dart y mi_cuenta_page.dart, verificar "editar planta" del frontend- inventario


//configirar permisos y credenciales del github:
//PS D:\Programacion\web-adso> git config --global user.name "serviplantulas-proyecto"            
//PS D:\Programacion\web-adso> git config --global user.email "serviplantulas@gmail.com"
//check list instructor |°/- https://jlombanar.github.io/adso_ficha_3169657/ -\°|