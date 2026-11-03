import 'package:flutter/material.dart';

import '../services/session_service.dart';
import '../styles/app_colors.dart';
import 'home_shell.dart';
import 'login.dart';

/// Login vs Home según token y timeout de 15 min de inactividad.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> with WidgetsBindingObserver {
  final _session = SessionService();
  bool _loading = true;
  bool _authed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bootstrap();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _bootstrap() async {
    final ok = await _session.hasValidSession();
    if (ok) await _session.touchActivity();
    if (!mounted) return;
    setState(() {
      _authed = ok;
      _loading = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _session.touchActivity();
    } else if (state == AppLifecycleState.resumed) {
      _onResume();
    }
  }

  Future<void> _onResume() async {
    final ok = await _session.hasValidSession();
    if (!mounted) return;
    if (ok) {
      await _session.touchActivity();
      if (!_authed) setState(() => _authed = true);
    } else if (_authed) {
      setState(() => _authed = false);
    }
  }

  void _onLoggedIn() {
    _session.touchActivity();
    setState(() => _authed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_authed) return const HomeShell();
    return LoginPage(onLoginSuccess: _onLoggedIn);
  }
}
