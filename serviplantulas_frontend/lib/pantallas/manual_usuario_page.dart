import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfx/pdfx.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';

class ManualUsuarioPage extends StatefulWidget {
  const ManualUsuarioPage({super.key});

  static const assetPath = 'assets/docs/manual_usuario.pdf';

  @override
  State<ManualUsuarioPage> createState() => _ManualUsuarioPageState();
}

class _ManualUsuarioPageState extends State<ManualUsuarioPage> {
  PdfControllerPinch? _controller;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _abrir();
  }

  Future<void> _abrir() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // rootBundle es más fiable que openAsset en web/móvil
      final byteData = await rootBundle.load(ManualUsuarioPage.assetPath);
      final bytes = byteData.buffer.asUint8List();
      if (bytes.isEmpty) {
        throw Exception('El PDF está vacío (0 bytes).');
      }
      final doc = await PdfDocument.openData(bytes);
      if (!mounted) return;
      _controller?.dispose();
      setState(() {
        _controller = PdfControllerPinch(document: Future.value(doc));
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Manual de Usuario'),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null || _controller == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'No se pudo cargar el manual.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Ruta: ${ManualUsuarioPage.assetPath}\n\n'
                'Detalle:\n${_error ?? "desconocido"}\n\n'
                'Prueba: flutter clean && flutter pub get && flutter run',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              TextButton(onPressed: _abrir, child: const Text('Reintentar')),
            ],
          ),
        ),
      );
    }
    return PdfViewPinch(controller: _controller!);
  }
}
