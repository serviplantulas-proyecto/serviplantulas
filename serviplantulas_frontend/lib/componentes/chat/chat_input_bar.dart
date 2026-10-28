import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool cargando;
  final VoidCallback onEnviar;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.cargando,
    required this.onEnviar,
  });

  @override
  Widget build(BuildContext context) {
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
              controller: controller,
              enabled: !cargando,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Escribe un mensaje...',
                hintStyle: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.background,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => onEnviar(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: cargando ? AppColors.textMuted : AppColors.primary,
            child: IconButton(
              onPressed: cargando ? null : onEnviar,
              icon: const Icon(Icons.send, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
