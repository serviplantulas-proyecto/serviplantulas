import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

class ChatEvaHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onHistorial;

  const ChatEvaHeader({
    super.key,
    required this.onBack,
    required this.onHistorial,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          ),
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.infoBackground,
            child: Icon(Icons.smart_toy_outlined,
                size: 18, color: AppColors.info),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('EVA',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    )),
                Text('Asistente IA',
                    style: AppTextStyles.label
                        .copyWith(color: AppColors.success)),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Historial',
            onPressed: onHistorial,
            icon: const Icon(Icons.history, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
