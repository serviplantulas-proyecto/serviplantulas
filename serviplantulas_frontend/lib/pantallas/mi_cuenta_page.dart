import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/cuenta/mi_cuenta_campo_tile.dart';
import '../componentes/cuenta/mi_cuenta_header.dart';
import '../componentes/cuenta/mi_cuenta_seguridad.dart';
import '../services/perfil_prefs.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';
import 'cambiar_dato_solicitar_page.dart';
import 'login.dart';
import 'solicitar_codigo_page.dart';

class MiCuentaPage extends StatefulWidget {
  const MiCuentaPage({super.key});

  @override
  State<MiCuentaPage> createState() => _MiCuentaPageState();
}

class _MiCuentaPageState extends State<MiCuentaPage> {
  PerfilPrefs? _p;
  bool _pass = false, _emailExp = false, _telExp = false, _loading = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final p = await PerfilPrefs.cargar();
    if (!mounted) return;
    setState(() {
      _p = p;
      _loading = false;
    });
  }

  String get _iniciales {
    final n = _p?.nombre ?? '';
    final parts = n.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Future<void> _irCambio(TipoCambioDato tipo) async {
    final email = _p?.email ?? '';
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay correo de sesión')),
      );
      return;
    }
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CambiarDatoSolicitarPage(tipo: tipo, emailActual: email),
      ),
    );
    if (ok == true) _cargar();
  }

  Future<void> _cerrar() async {
    await PerfilPrefs.cerrarSesion();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = _p;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Mi Cuenta'),
            Expanded(
              child: _loading || p == null
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          MiCuentaHeader(
                            iniciales: _iniciales,
                            nombre: p.nombre.split(RegExp(r'\s+')).take(2).join(' '),
                            rol: p.rol,
                          ),
                          const SizedBox(height: AppSpacing.extraLarge),
                          _title('Información Personal'),
                          MiCuentaNombreCard(nombre: p.nombre),
                          MiCuentaCampoTile(
                            label: 'CORREO ELECTRÓNICO',
                            value: p.email,
                            expanded: _emailExp,
                            onToggle: () =>
                                setState(() => _emailExp = !_emailExp),
                            onCambiar: () => _irCambio(TipoCambioDato.email),
                            botonTexto: 'Cambiar correo',
                            icon: Icons.email_outlined,
                          ),
                          MiCuentaCampoTile(
                            label: 'NÚMERO DE CONTACTO',
                            value: p.telefono,
                            expanded: _telExp,
                            onToggle: () =>
                                setState(() => _telExp = !_telExp),
                            onCambiar: () =>
                                _irCambio(TipoCambioDato.telefono),
                            botonTexto: 'Cambiar número',
                            icon: Icons.phone_outlined,
                          ),
                          const SizedBox(height: AppSpacing.large),
                          _title('Seguridad'),
                          MiCuentaPasswordTile(
                            expanded: _pass,
                            onToggle: () => setState(() => _pass = !_pass),
                            onCambiar: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SolicitarCodigoPage(),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.extraLarge),
                          _logout(),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(String t) => Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            t,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      );

  Widget _logout() => SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton(
          onPressed: _cerrar,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.error,
            side: const BorderSide(color: AppColors.error),
            backgroundColor: const Color(0xFFFFF0F0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
          ),
          child: Text('Cerrar Sesión',
              style: AppTextStyles.button.copyWith(color: AppColors.error)),
        ),
      );

}
