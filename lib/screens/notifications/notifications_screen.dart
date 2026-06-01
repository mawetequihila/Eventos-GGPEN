import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import '../../models/notification_item.dart';
import '../../state/event_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_bar_actions.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  /// Notificações da app: por defeito só as boas-vindas. Depois surgem as
  /// sessões a decorrer agora e as que começam em breve (60 min antes).
  List<NotificationItem> _buildItems(AppLocalizations l, EventState es) {
    final now = DateTime.now();
    final items = <NotificationItem>[];

    if (es.isReady) {
      // A decorrer agora.
      final live = es.activities
          .where((a) => a.statusAt(now) == ActivityStatus.live)
          .toList()
        ..sort((a, b) => a.start.compareTo(b.start));
      for (final a in live) {
        items.add(NotificationItem(
          title: l.notifLiveTitle(a.title),
          body: l.notifLiveBody(a.location),
          time: a.start,
          kind: NotificationKind.inicio,
          unread: true,
        ));
      }

      // A começar em breve (próximos 60 min).
      final soon = es.activities.where((a) {
        final diff = a.start.difference(now);
        return !diff.isNegative && diff.inMinutes <= 60;
      }).toList()
        ..sort((a, b) => a.start.compareTo(b.start));
      for (final a in soon) {
        items.add(NotificationItem(
          title: l.notifStartingSoonTitle(a.title),
          body: l.notifStartingSoonBody(a.timeRange, a.location),
          time: now,
          kind: NotificationKind.inicio,
          unread: true,
        ));
      }
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
    final items = _buildItems(l, es);

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
