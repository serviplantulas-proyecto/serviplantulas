import 'api_config.dart';
import 'auth_http.dart';

export 'auth_http.dart' show AuthException;

class AuthService {
  static Future<void> registrarCuenta({
    required String nombre,
    required String apellido,
    required String telefono,
    required String email,
    required String contrasena,
  }) async {
    await postAuth(
      url: ApiConfig.registerUrl,
      body: {
        'nombre_usuarios': nombre,
        'apellido_usuarios': apellido,
        'telefono_usuarios': telefono,
        'email_usuarios': email,
        'contrasena_usuarios': contrasena,
      },
      fallbackMessage: 'No fue posible crear la cuenta. Inténtalo de nuevo.',
    );
  }

  static Future<void> verificarCuenta({
    required String email,
    required String codigo,
  }) async {
    await postAuth(
      url: ApiConfig.verifyAccountUrl,
      body: {'email_usuarios': email, 'codigo': codigo},
      fallbackMessage: 'No fue posible verificar la cuenta.',
    );
  }

  static Future<void> reenviarCodigoVerificacion({
    required String email,
  }) async {
    await postAuth(
      url: ApiConfig.resendVerificationUrl,
      body: {'email_usuarios': email},
      fallbackMessage: 'No fue posible enviar un nuevo código.',
    );
  }

  static Future<void> solicitarRecuperacion({required String email}) async {
    await postAuth(
      url: ApiConfig.forgotPasswordUrl,
      body: {'email': email},
      fallbackMessage: 'No fue posible enviar el código de recuperación.',
      timeout: const Duration(seconds: 60),
    );
  }

  static Future<void> cambiarContrasena({
    required String email,
    required String codigo,
    required String nuevaContrasena,
  }) async {
    await postAuth(
      url: ApiConfig.verifyRecoveryCodeUrl,
      body: {
        'email': email,
        'codigo': codigo,
        'nuevaContrasena': nuevaContrasena,
      },
      fallbackMessage: 'No fue posible actualizar la contraseña.',
      timeout: const Duration(seconds: 30),
    );
  }

   static Future<Map<String, dynamic>> cambiarDatoPerfil({
    required String email,
    required String codigo,
    String? nuevoEmail,
    String? nuevoTelefono,
  }) async {
    return postAuth(
      url: ApiConfig.verifyProfileChangeUrl,
      body: {
        'email': email,
        'codigo': codigo,
        if (nuevoEmail != null) 'nuevo_email': nuevoEmail,
        if (nuevoTelefono != null) 'nuevo_telefono': nuevoTelefono,
      },
      fallbackMessage: 'No fue posible actualizar los datos.',
      timeout: const Duration(seconds: 30),
    );
  }

  static Future<void> iniciarSesion({
    required String email,
    required String contrasena,
  }) async {
    final decoded = await postAuth(
      url: ApiConfig.loginUrl,
      body: {'email_usuarios': email, 'contrasena_usuarios': contrasena},
      fallbackMessage: 'No fue posible iniciar sesión. Inténtalo de nuevo.',
    );
    await guardarSesionDesdeLogin(decoded, emailFallback: email);
  }

  static Future<void> iniciarSesionGoogle({required String idToken}) async {
    final decoded = await postAuth(
      url: ApiConfig.googleAuthUrl,
      body: {'idToken': idToken},
      fallbackMessage: 'No fue posible iniciar sesión con Google.',
    );
    await guardarSesionDesdeLogin(decoded);
  }
}
