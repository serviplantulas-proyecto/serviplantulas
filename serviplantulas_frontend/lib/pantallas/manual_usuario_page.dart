import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';

/// Visor del manual de usuario (PDF en assets).
class ManualUsuarioPage extends StatefulWidget {
  const ManualUsuarioPage({super.key});

  static const assetPath = 'assets/docs/manual_usuario.pdf';

  @override
  State<ManualUsuarioPage> createState() => _ManualUsuarioPageState();
}

class _ManualUsuarioPageState extends State<ManualUsuarioPage> {
  late final PdfControllerPinch _controller;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _controller = PdfControllerPinch(
      document: PdfDocument.openAsset(ManualUsuarioPage.assetPath),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
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
            Expanded(
              child: _error
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'No se pudo cargar el manual.\n'
                          'Verifica que exista:\n'
                          '${ManualUsuarioPage.assetPath}',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  : PdfViewPinch(
                      controller: _controller,
                      onDocumentError: (_) {
                        if (mounted) setState(() => _error = true);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
