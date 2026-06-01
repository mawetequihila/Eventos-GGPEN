import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';

enum NotificationKind { aviso, mudanca, cancelamento, inicio }

extension NotificationKindX on NotificationKind {
  String label(AppLocalizations l) {
    switch (this) {
      case NotificationKind.aviso:
        return l.notifKindNotice;
      case NotificationKind.mudanca:
        return l.notifKindScheduleChange;
      case NotificationKind.cancelamento:
        return l.notifKindCancellation;
      case NotificationKind.inicio:
        return l.notifKindStarting;
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationKind.aviso:
        return LucideIcons.megaphone;
      case NotificationKind.mudanca:
        return LucideIcons.calendarClock;
      case NotificationKind.cancelamento:
        return LucideIcons.xCircle;
      case NotificationKind.inicio:
        return LucideIcons.playCircle;
    }
  }

  Color get color {
    switch (this) {
      case NotificationKind.aviso:
        return AppColors.techBlue;
      case NotificationKind.mudanca:
        return AppColors.warning;
      case NotificationKind.cancelamento:
        return const Color(0xFFE5484D);
      case NotificationKind.inicio:
        return AppColors.live;
    }
  }
}

class NotificationItem {
  final String title;
  final String body;
  final DateTime time;
  final NotificationKind kind;
  final bool unread;

  const NotificationItem({
    required this.title,
    required this.body,
    required this.time,
    required this.kind,
    this.unread = false,
  });

  /// Tempo relativo localizado (ex.: "há 5 min", "5 min ago").
  String relativeTime(AppLocalizations l) {
    final diff = DateTime.now().difference(time);
    if (diff.isNegative) return l.relativeNow;
    if (diff.inMinutes < 1) return l.relativeNow;
    if (diff.inMinutes < 60) return l.relativeMinutes(diff.inMinutes);
    if (diff.inHours < 24) return l.relativeHours(diff.inHours);
    return l.relativeDays(diff.inDays);
  }
}
