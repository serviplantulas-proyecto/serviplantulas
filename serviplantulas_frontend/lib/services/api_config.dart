import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  static String get serverUrl {
    //1. evaluar web primero para evitar que platform.isx genere un error en json
    if (kIsWeb) {
      return 'http://localhost:3000';
    }

    //2. Evaluaciones para dispositivos moviles / desktop
    if (Platform.isAndroid) {
      //emulador de android
      return 'http://10.0.2.2:3000';
    } else if (Platform.isIOS) {
      //simulador de iOS
      return 'http://localhost:3000';
    }

    //Fallback para macOS, Windows, Linux, etc.
    return 'http://localhost:3000';
  }

  static String get baseUrl => '$serverUrl/chatbot/';
  static String get loginUrl => '$serverUrl/auth/login';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
