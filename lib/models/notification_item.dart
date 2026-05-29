import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';

enum NotificationKind { aviso, mudanca, cancelamento, inicio }

extension NotificationKindX on NotificationKind {
  String get label {
    switch (this) {
      case NotificationKind.aviso:
        return 'Aviso';
      case NotificationKind.mudanca:
        return 'Mudança de horário';
      case NotificationKind.cancelamento:
        return 'Cancelamento';
      case NotificationKind.inicio:
        return 'A começar';
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

  /// Tempo relativo simples em português (ex.: "há 5 min", "há 2 h").
  String get relativeTime {
    final diff = DateTime.now().difference(time);
    if (diff.isNegative) return 'agora';
    if (diff.inMinutes < 1) return 'agora';
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'há ${diff.inHours} h';
    return 'há ${diff.inDays} d';
  }
}
