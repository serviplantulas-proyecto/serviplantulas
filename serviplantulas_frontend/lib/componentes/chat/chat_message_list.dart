import 'package:flutter/material.dart';

import '../../services/chat_plantulas_service.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

class ChatMessageList extends StatelessWidget {
  final List<ChatMensaje> mensajes;
  final bool cargando;
  final ScrollController controller;

  const ChatMessageList({
    super.key,
    required this.mensajes,
    required this.cargando,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.all(16),
      itemCount: mensajes.length + (cargando ? 1 : 0),
      itemBuilder: (context, i) {
        if (cargando && i == mensajes.length) {
          return const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        final m = mensajes[i];
        return Align(
          alignment:
              m.esUsuario ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: m.esUsuario ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border:
                  m.esUsuario ? null : Border.all(color: AppColors.border),
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
    );
  }
}
