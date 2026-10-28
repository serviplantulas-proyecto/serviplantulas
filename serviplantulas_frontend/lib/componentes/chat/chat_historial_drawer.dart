import 'package:flutter/material.dart';

import '../../services/chat_plantulas_service.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

class ChatHistorialDrawer extends StatelessWidget {
  final List<ChatSesionItem> sesiones;
  final bool loading;
  final String? sesionActiva;
  final ValueChanged<ChatSesionItem> onSeleccionar;
  final VoidCallback onNueva;

  const ChatHistorialDrawer({
    super.key,
    required this.sesiones,
    required this.loading,
    required this.onSeleccionar,
    required this.onNueva,
    this.sesionActiva,
  });

  String _fecha(DateTime? d) {
    if (d == null) return '';
    final l = d.toLocal();
    return '${l.day.toString().padLeft(2, '0')}/'
        '${l.month.toString().padLeft(2, '0')} '
        '${l.hour.toString().padLeft(2, '0')}:'
        '${l.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    'Historial',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Nueva conversación',
                    onPressed: onNueva,
                    icon: const Icon(Icons.add_comment_outlined,
                        color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            if (loading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (sesiones.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'Sin conversaciones aún',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textMuted),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: sesiones.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final s = sesiones[i];
                    final activa = s.sesionId == sesionActiva;
                    return ListTile(
                      selected: activa,
                      selectedTileColor: AppColors.editBackground,
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.infoBackground,
                        child: const Icon(Icons.chat_bubble_outline,
                            size: 16, color: AppColors.info),
                      ),
                      title: Text(
                        s.preview.isEmpty ? 'Conversación' : s.preview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      subtitle: Text(
                        _fecha(s.ultimaFecha),
                        style: AppTextStyles.label
                            .copyWith(color: AppColors.textMuted),
                      ),
                      onTap: () => onSeleccionar(s),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
