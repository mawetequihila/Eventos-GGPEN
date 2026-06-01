import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../data/ggpen_models.dart' as sb;
import '../data/ggpen_repository.dart';
import '../models/speaker.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Abre a ficha do orador (foto/iniciais, cargo, sessões e biografia).
Future<void> showSpeakerDetail(BuildContext context, Speaker speaker) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _SpeakerDetailSheet(speaker: speaker),
  );
}

class _SpeakerDetailSheet extends StatelessWidget {
  final Speaker speaker;
  const _SpeakerDetailSheet({required this.speaker});

  String _hhmm(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final muted = AppColors.navy.withValues(alpha: 0.6);
    final hasPhoto = (speaker.avatarUrl ?? '').isNotEmpty;
    final bio = speaker.bio?.trim() ?? '';
    final repo = context.read<GgpenRepository>();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 44,
                backgroundColor: speaker.color,
                backgroundImage:
                    hasPhoto ? NetworkImage(speaker.avatarUrl!) : null,
                child: hasPhoto
                    ? null
                    : Text(
                        speaker.initials,
                        style: AppTheme.display(
                            size: 26,
                            weight: FontWeight.w700,
                            color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              speaker.name,
              textAlign: TextAlign.center,
              style: AppTheme.display(size: 20, color: AppColors.navy),
            ),
            if (speaker.role.trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                speaker.role,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: muted, height: 1.35),
              ),
            ],
            // Sessões do orador (vindas do Supabase) + contagem real no badge.
            FutureBuilder<List<sb.Activity>>(
              future: speaker.id == null
                  ? Future.value(const <sb.Activity>[])
                  : repo.getSpeakerSessions(speaker.id!),
              builder: (context, snap) {
                final sessions = snap.data ?? const <sb.Activity>[];
                final count =
                    sessions.isNotEmpty ? sessions.length : speaker.sessions;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: speaker.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          l.sessionsCount(count),
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: speaker.color),
                        ),
                      ),
                    ),
                    if (sessions.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(l.speakerSessions.toUpperCase(),
                          style: AppTheme.overline(
                              AppColors.navy.withValues(alpha: 0.45))),
                      const SizedBox(height: 8),
                      ...sessions.map((a) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.bg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.line),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(a.titulo,
                                      style: AppTheme.cardTitle()),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${_hhmm(a.inicio)}${(a.local ?? '').isNotEmpty ? ' · ${a.local}' : ''}',
                                    style: AppTheme.meta(muted),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Text(l.aboutSpeaker.toUpperCase(),
                style: AppTheme.overline(AppColors.navy.withValues(alpha: 0.45))),
            const SizedBox(height: 8),
            Text(
              bio.isEmpty ? l.noBio : bio,
              style: TextStyle(fontSize: 14, height: 1.55, color: muted),
            ),
          ],
        );
      },
    );
  }
}
