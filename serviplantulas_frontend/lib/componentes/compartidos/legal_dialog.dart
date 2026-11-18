import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_spacing.dart';
import '../../styles/app_text_styles.dart';

enum LegalDocumento { terminos, privacidad }

class LegalTexts {
  static const terminos = '''
Términos y Condiciones de SERVIPLANTULAS

Última actualización: noviembre de 2026.

1. Aceptación
Al crear una cuenta o usar la aplicación SERVIPLANTULAS, usted acepta estos Términos y Condiciones. Si no está de acuerdo, no debe utilizar el servicio.

2. Descripción del servicio
SERVIPLANTULAS es una aplicación de gestión para viveros e inventarios de plantulas. Permite administrar productos, categorías, proveedores, clientes, ventas, facturas, notificaciones y asistencia mediante chatbot, según las funciones habilitadas en su cuenta.

3. Registro y cuenta
Usted se compromete a proporcionar información veraz y a mantener la confidencialidad de sus credenciales. Es responsable de las actividades realizadas desde su cuenta. Puede cerrar sesión o solicitar la eliminación de su cuenta conforme a la Política de Privacidad.

4. Uso permitido
El uso debe ser lícito y relacionado con la gestión del vivero o actividad autorizada. Está prohibido intentar vulnerar la seguridad, acceder a datos de terceros sin autorización o usar el servicio para fines ilegales.

5. Contenido y datos del negocio
La información de productos, clientes, ventas y demás datos de operación que usted registre es de su responsabilidad. SERVIPLANTULAS actúa como herramienta de apoyo y no garantiza resultados comerciales específicos.

6. Disponibilidad
Se procura mantener el servicio disponible, pero pueden existir interrupciones por mantenimiento, fallas técnicas o causas ajenas. No se garantiza disponibilidad ininterrumpida.

7. Limitación de responsabilidad
En la medida permitida por la ley colombiana, SERVIPLANTULAS no será responsable por daños indirectos, lucro cesante o pérdida de datos derivados del uso o la imposibilidad de uso de la aplicación, salvo dolo o culpa grave.

8. Modificaciones
Estos términos pueden actualizarse. El uso continuado después de la publicación de cambios implica aceptación de la versión vigente.

9. Legislación aplicable
Estos términos se rigen por las leyes de la República de Colombia. Cualquier controversia se someterá a los jueces competentes del domicilio del responsable del tratamiento, salvo norma especial en contrario.
''';

  static const privacidad = '''
Política de Privacidad de SERVIPLANTULAS

Última actualización: noviembre de 2026.

1. Responsable del tratamiento
SERVIPLANTULAS, en el marco del proyecto formativo, actúa como responsable del tratamiento de los datos personales recolectados a través de la aplicación.

2. Datos que se recolectan
Con ocasión del registro y uso del servicio pueden tratarse, entre otros: nombre, apellido, correo electrónico, número de teléfono, datos de autenticación (incluida opción de inicio con Google), y datos operativos del negocio que usted registre (productos, clientes, proveedores, ventas, etc.).

3. Finalidad
Los datos se tratan para: gestionar el registro y verificación de cuenta; permitir el acceso y uso de la aplicación; recuperar o cambiar credenciales; enviar notificaciones relacionadas con el servicio; mejorar la seguridad y el funcionamiento técnico; y cumplir obligaciones legales.

4. Base legal
El tratamiento se realiza conforme a la Ley 1581 de 2012, el Decreto 1377 de 2013 y demás normas aplicables en Colombia, con base en su autorización al registrarse y en la ejecución del servicio solicitado.

5. Seguridad
Se adoptan medidas razonables de seguridad técnica y organizativa para proteger la información. Ningún sistema es 100 % invulnerable; usted también debe cuidar sus credenciales.

6. Compartición con terceros
Los datos no se venden ni se comparten con terceros con fines comerciales. Pueden tratarse por proveedores tecnológicos necesarios para el servicio (por ejemplo, alojamiento, correo transaccional o autenticación), bajo deberes de confidencialidad, o cuando la ley lo exija.

7. Conservación
Los datos se conservan mientras la cuenta esté activa y por el tiempo adicional necesario para cumplir obligaciones legales o resolver controversias. Puede configurarse la eliminación automática de notificaciones según las opciones de la app.

8. Derechos del titular (ARCO)
Usted puede ejercer en cualquier momento los derechos de acceso, rectificación, cancelación y oposición, así como revocar la autorización, contactando al responsable del tratamiento a través de los canales indicados en la aplicación o el proyecto.

9. Menores de edad
El servicio está orientado a uso profesional o formativo de personas con capacidad legal para contratar. No está dirigido a menores de 18 años sin representación.

10. Cambios
Esta política puede actualizarse. Se publicará la versión vigente en la aplicación. El uso continuado implica conocimiento de los cambios.
''';
}

Future<void> showLegalDialog(
  BuildContext context,
  LegalDocumento documento,
) {
  final esTerminos = documento == LegalDocumento.terminos;
  return showDialog<void>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: const Color(0xFF2A3A32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          esTerminos ? 'Términos y condiciones' : 'Política de privacidad',
          style: AppTextStyles.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              esTerminos ? LegalTexts.terminos : LegalTexts.privacidad,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.92),
                height: 1.45,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cerrar',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
}
