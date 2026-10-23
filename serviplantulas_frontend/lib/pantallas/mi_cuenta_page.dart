import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/cuenta/mi_cuenta_seguridad.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';
import 'login.dart';
import 'solicitar_codigo_page.dart';

class MiCuentaPage extends StatefulWidget {
  const MiCuentaPage({super.key});

  @override
  State<MiCuentaPage> createState() => _MiCuentaPageState();
}

class _MiCuentaPageState extends State<MiCuentaPage> {
  String _nombre = 'Usuario';
  String _nombreCompleto = '';
  String _email = '';
  String _telefono = 'telefono';
  String _rol = 'Usuario';
  bool _passExpanded = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('user_email') ?? '';
    var nombre = prefs.getString('user_nombre') ?? '';
    var apellido = prefs.getString('user_apellido') ?? '';
    var telefono = prefs.getString('user_telefono') ?? '';
    var rol = prefs.getString('user_rol') ?? '';

    // Completar desde JWT (login ya incluye nombre, apellido, email, rol)
    final token = prefs.getString('auth_token');
    if (token != null && token.contains('.')) {
      try {
        final map = jsonDecode(utf8.decode(
          base64Url.decode(base64Url.normalize(token.split('.')[1])),
        ));
        if (map is Map) {
          if (email.isEmpty) email = (map['email'] ?? '').toString();
          if (nombre.isEmpty) nombre = (map['nombre'] ?? '').toString();
          if (apellido.isEmpty) apellido = (map['apellido'] ?? '').toString();
          if (rol.isEmpty) rol = (map['rol'] ?? '').toString();
          if (telefono.isEmpty) rol = (map['telefono'] ?? '').toString();
        }
      } catch (_) {}
    }

    final full = [nombre, apellido].where((s) => s.trim().isNotEmpty).join(' ');
    final display = full.isNotEmpty ? full : (email.isNotEmpty ? email : 'Usuario');
    final short = display.split(RegExp(r'\s+')).take(2).join(' ');
    final rolLabel = _formatearRol(rol);

    if (!mounted) return;
    setState(() {
      _email = email;
      _telefono = telefono;
      _nombreCompleto = display;
      _nombre = short;
      _rol = rolLabel;
      _loading = false;
    });
  }

  String _formatearRol(String rol) {
    final r = rol.trim().toLowerCase();
    if (r == 'admin' || r == 'administrador') return 'Administrador';
    if (r == 'administradora') return 'Administradora';
    if (r.isEmpty) return 'Usuario';
    return rol[0].toUpperCase() + rol.substring(1);
  }

  String get _iniciales {
    final parts = _nombre.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Future<void> _cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_email');
    await prefs.remove('user_nombre');
    await prefs.remove('user_apellido');
    await prefs.remove('user_telefono');
    await prefs.remove('user_rol');
    await prefs.remove('user_id');
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Mi Cuenta'),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _avatar(),
                          const SizedBox(height: AppSpacing.extraLarge),
                          _sectionTitle('Información Personal'),
                          MiCuentaInfoCard(
                            nombreCompleto: _nombreCompleto,
                            email: _email,
                            telefono: _telefono,
                          ),
                          const SizedBox(height: AppSpacing.large),
                          _sectionTitle('Seguridad'),
                          MiCuentaPasswordTile(
                            expanded: _passExpanded,
                            onToggle: () => setState(
                              () => _passExpanded = !_passExpanded,
                            ),
                            onCambiar: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SolicitarCodigoPage(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacing.extraLarge),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: _cerrarSesion,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.error,
                                side: const BorderSide(color: AppColors.error),
                                backgroundColor: const Color(0xFFFFF0F0),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.medium),
                                ),
                              ),
                              child: Text(
                                'Cerrar Sesión',
                                style: AppTextStyles.button.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar() {
    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: AppColors.editBackground,
          child: Text(
            _iniciales,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _nombre,
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _rol,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String t) => Align(
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
}
