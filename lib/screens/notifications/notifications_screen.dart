import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/notification_item.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_bar_actions.dart';

/// Histórico de notificações (persistido em [AppState]). Acumula todos os
/// avisos — incl. "horário alterado" — e marca tudo como lido ao abrir, para o
/// badge do sino limpar.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Abriu a aba → tudo passa a lido (badge desaparece).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AppState>().markNotificationsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final items = context.watch<AppState>().notifications;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.notificationsTitle),
        actions: const [AppBarActions()],
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                l.noNotifications,
                style: TextStyle(color: AppColors.navy.withValues(alpha: 0.55)),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _NotificationCard(item: items[i]),
            ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final StoredNotice item;
  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final muted = AppColors.navy.withValues(alpha: 0.6);
    final unread = !item.read;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: unread
              ? item.kind.color.withValues(alpha: 0.45)
              : AppColors.line,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: item.kind.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.kind.icon, color: item.kind.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (unread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: item.kind.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.body,
                  style: TextStyle(fontSize: 13, height: 1.45, color: muted),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      item.kind.label(l).toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: item.kind.color,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item.relativeTime(l),
                      style: TextStyle(fontSize: 11, color: muted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
