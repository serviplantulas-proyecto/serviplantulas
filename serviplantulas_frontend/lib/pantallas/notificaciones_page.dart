import 'package:flutter/material.dart';

import '../componentes/notificaciones/notificacion_tile.dart';
import '../componentes/notificaciones/notificaciones_app_bar.dart';
import '../services/notificaciones_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';

class NotificacionesPage extends StatefulWidget {
  const NotificacionesPage({super.key});

  @override
  State<NotificacionesPage> createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  final _service = NotificacionesService();
  List<NotificacionItem> _items = [];
  bool _loading = true;
  String? _error;

  int get _noLeidas => _items.where((n) => !n.leida).length;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await _service.listar();
      if (!mounted) return;
      setState(() {
        _items = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e is NotificacionesException
            ? e.message
            : 'No se pudieron cargar las notificaciones.';
      });
    }
  }

  Future<void> _marcarTodas() async {
    try {
      await _service.marcarTodasLeidas();
      await _cargar();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No se pudo marcar como leídas'),
        backgroundColor: AppColors.error,
      ));
    }
  }

  Future<void> _abrir(NotificacionItem n) async {
    if (!n.leida) {
      try {
        await _service.marcarLeida(n.id);
        await _cargar();
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            NotificacionesAppBar(noLeidas: _noLeidas),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(
                children: [
                  Text(
                    'Mostrando alertas de hoy',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _noLeidas == 0 ? null : _marcarTodas,
                    child: Text(
                      'Marcar todo como leído',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _noLeidas == 0
                            ? AppColors.textMuted
                            : AppColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_error!, textAlign: TextAlign.center),
          TextButton(onPressed: _cargar, child: const Text('Reintentar')),
        ]),
      );
    }
    if (_items.isEmpty) {
      return Center(
        child: Text(
          'Sin notificaciones',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _cargar,
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final n = _items[i];
          return NotificacionTile(item: n, onTap: () => _abrir(n));
        },
      ),
    );
  }
}
