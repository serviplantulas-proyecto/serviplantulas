import 'package:flutter/material.dart';
import 'nombre_imagen.dart';

class AppBackground extends StatelessWidget {
  final TipoFondo tipo;
  final Widget child;

  const AppBackground({
    super.key,
    required this.tipo,
    required this.child,
  });

  String _asset() {
    switch (tipo) {
      case TipoFondo.azul:
        return 'assets/images/fondo_azul.png';
      
      case TipoFondo.azul2:
      return 'assets/images/fondo_azul2.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          _asset(),
          fit: BoxFit.fill,
          filterQuality: FilterQuality.high,
        ),
        child,
      ],
    );
  }
}