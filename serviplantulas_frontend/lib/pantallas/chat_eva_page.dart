import 'package:flutter/material.dart';

import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';

class ChatEvaPage extends StatefulWidget {
  const ChatEvaPage({super.key});

  @override
  State<ChatEvaPage> createState() => _ChatEvaPageState();
}

class _ChatEvaPageState extends State<ChatEvaPage> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();

  final List<_Msg> _mensajes = [
    _Msg(
      '¡Hola! Soy EVA, la asistente de Serviplantulas. ¿En qué puedo ayudarte hoy?',
      false,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _enviar() {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;
    setState(() {
      _mensajes.add(_Msg(texto, true));
      _controller.clear();
    });
    // TODO: conectar con chat_plantulas_service / backend EVA
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _mensajes.add(
          _Msg(
            'Recibí tu mensaje. Cuando el backend esté conectado responderé con datos reales del inventario y ventas.',
            false,
          ),
        );
      });
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.all(16),
                itemCount: _mensajes.length,
                itemBuilder: (context, i) {
                  final m = _mensajes[i];
                  // Reutiliza ChatBurbuja si existe; fallback simple
                  return Align(
                    alignment: m.esUsuario
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: m.esUsuario
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: m.esUsuario
                            ? null
                            : Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        m.texto,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: m.esUsuario
                              ? AppColors.surface
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            _inputBar(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.infoBackground,
            child: const Icon(
              Icons.smart_toy_outlined,
              size: 18,
              color: AppColors.info,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EVA',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'Asistente IA',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Escribe un mensaje...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                ),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _enviar(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: IconButton(
              onPressed: _enviar,
              icon: const Icon(Icons.send, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _Msg {
  final String texto;
  final bool esUsuario;
  const _Msg(this.texto, this.esUsuario);
}
