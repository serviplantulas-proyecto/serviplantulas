import 'package:flutter/material.dart';
import 'package:serviplantulas_frontend/pantallas/menu_page.dart';
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
      home: Scaffold(body: MenuPage()));
  }
}

//pagina para los iconos |°/- flaticon -\°|