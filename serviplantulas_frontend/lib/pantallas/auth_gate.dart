import 'package:flutter/material.dart';

import '../services/session_service.dart';
import '../styles/app_colors.dart';
import 'home_shell.dart';
import 'login.dart';

/// Si hay token → Home; si no → Login.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _session = SessionService();
  bool _loading = true;
  bool _authed = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final ok = await _session.hasValidSession();
    if (!mounted) return;
    setState(() {
      _authed = ok;
      _loading = false;
    });
  }

  void _onLoggedIn() {
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