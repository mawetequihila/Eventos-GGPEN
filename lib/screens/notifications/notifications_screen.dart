import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import '../../models/notification_item.dart';
import '../../state/app_state.dart';
import '../../state/event_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_bar_actions.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  /// Notificações da app. Cada entrada usa a hora REAL em que o aviso "disparou"
  /// — o lembrete dispara em (início − antecedência); o "a decorrer" no início —
  /// para o tempo relativo ("há X min") ficar correto.
  List<NotificationItem> _buildItems(
      AppLocalizations l, EventState es, int leadMinutes) {
    final now = DateTime.now();
    final lead = Duration(minutes: leadMinutes);
    final items = <NotificationItem>[];

    if (es.isReady) {
      for (final a in es.activities) {
        final status = a.statusAt(now);
        if (status == ActivityStatus.live) {
          // Disparou no início da sessão.
          items.add(NotificationItem(
            title: l.notifLiveTitle(a.title),
            body: l.notifLiveBody(a.location),
            time: a.start,
            kind: NotificationKind.inicio,
            unread: true,
          ));
        } else {
          final fire = a.start.subtract(lead);
          // Só aparece depois de o lembrete ter disparado e antes de começar.
          if (!now.isBefore(fire) && now.isBefore(a.start)) {
            items.add(NotificationItem(
              title: l.notifStartingSoonTitle(a.title),
              body: l.notifStartingSoonBody(a.timeRange, a.location),
              time: fire,
              kind: NotificationKind.inicio,
              unread: true,
            ));
          }
        }
      }
      // Mais recentes primeiro.
      items.sort((x, y) => y.time.compareTo(x.time));
    }

    // Boas-vindas — sempre presente, no fundo da lista.
    items.add(NotificationItem(
      title: l.notifWelcomeTitle,
      body: l.notifWelcomeBody,
      time: now,
      kind: NotificationKind.aviso,
      unread: true,
    ));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final es = context.watch<EventState>();
    final lead = context.watch<AppState>().reminderLeadMinutes;
    final items = _buildItems(l, es, lead);

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
  final NotificationItem item;
  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final muted = AppColors.navy.withValues(alpha: 0.6);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.unread
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
                    if (item.unread)
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
