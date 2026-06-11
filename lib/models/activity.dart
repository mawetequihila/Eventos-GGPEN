import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum ActivityType {
  apresentacao,
  lancamento,
  assinatura,
  plenaria,
  paralela,
  painel,
  formacao,
  workshop,
}

extension ActivityTypeX on ActivityType {
  String label(AppLocalizations l) {
    switch (this) {
      case ActivityType.apresentacao:
        return l.typeApresentacao;
      case ActivityType.lancamento:
        return l.typeLancamento;
      case ActivityType.assinatura:
        return l.typeAssinatura;
      case ActivityType.plenaria:
        return l.typePlenaria;
      case ActivityType.paralela:
        return l.formatParalela;
      case ActivityType.painel:
        return l.typePainel;
      case ActivityType.formacao:
        return l.typeFormacao;
      case ActivityType.workshop:
        return l.typeWorkshop;
    }
  }

  Color get color {
    switch (this) {
      case ActivityType.apresentacao:
        return const Color(0xFF4D7EFF);
      case ActivityType.lancamento:
        return const Color(0xFFFF8C42);
      case ActivityType.assinatura:
        return const Color(0xFF1FB6A8);
      case ActivityType.plenaria:
        return const Color(0xFFA87BFF);
      case ActivityType.paralela:
        return const Color(0xFF1FB6A8);
      case ActivityType.painel:
        return const Color(0xFF5C6BC0);
      case ActivityType.formacao:
        return const Color(0xFF2EA86A);
      case ActivityType.workshop:
        return const Color(0xFFE0518A);
    }
  }

  IconData get icon {
    switch (this) {
      case ActivityType.apresentacao:
        return LucideIcons.presentation;
      case ActivityType.lancamento:
        return LucideIcons.rocket;
      case ActivityType.assinatura:
        return LucideIcons.handshake;
      case ActivityType.plenaria:
        return LucideIcons.usersRound;
      case ActivityType.paralela:
        return LucideIcons.splitSquareHorizontal;
      case ActivityType.painel:
        return LucideIcons.messageSquare;
      case ActivityType.formacao:
        return LucideIcons.graduationCap;
      case ActivityType.workshop:
        return LucideIcons.wrench;
    }
  }
}

enum ActivityStatus { upcoming, live, past, cancelled }

class ActivityMaterial {
  final String label;
  final String url;
  const ActivityMaterial(this.label, this.url);
}

class Activity {
  final String id;
  final String title;
  final String description;
  final ActivityType type;
  final int day; // 1..3
  final DateTime start;
  final DateTime end;
  final String location;
  final String? speaker;
  final List<ActivityMaterial> materials;
  final bool cancelled;

  const Activity({
    required this.id,
    required this.title,
    required this.type,
    required this.day,
    required this.start,
    required this.end,
    required this.location,
    this.description = '',
    this.speaker,
    this.materials = const [],
    this.cancelled = false,
  });

  ActivityStatus statusAt(DateTime now) {
    if (cancelled) return ActivityStatus.cancelled;
    if (now.isAfter(end)) return ActivityStatus.past;
    if (!now.isBefore(start)) return ActivityStatus.live; // now in [start, end]
    return ActivityStatus.upcoming;
  }

  static String _two(int n) => n.toString().padLeft(2, '0');

  String get startLabel => '${_two(start.hour)}:${_two(start.minute)}';

  String get timeRange => '$startLabel – ${_two(end.hour)}:${_two(end.minute)}';

  bool overlaps(Activity other) =>
      start.isBefore(other.end) && other.start.isBefore(end);
}
