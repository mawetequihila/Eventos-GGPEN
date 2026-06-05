import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../data/ggpen_models.dart' as sb;
import '../data/ggpen_repository.dart';
import '../models/speaker.dart';
import '../screens/agenda/activity_detail_screen.dart';
import '../state/event_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Abre a ficha do orador num diálogo centrado.
Future<void> showSpeakerDetail(BuildContext context, Speaker speaker) {
  return showDialog<void>(
    context: context,
    barrierColor: AppColors.navy.withValues(alpha: 0.55),
    builder: (ctx) => _SpeakerDetailDialog(speaker: speaker),
  );
}

class _SpeakerDetailDialog extends StatelessWidget {
  final Speaker speaker;
  const _SpeakerDetailDialog({required this.speaker});

  String _hhmm(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  /// Fecha o diálogo e abre o ecrã da actividade correspondente (procura a
  /// versão já mapeada no EventState pelo id; ignora se ainda não carregou).
  void _openSession(BuildContext context, sb.Activity a) {
    final es = context.read<EventState>();
    final match = es.activities.where((x) => x.id == a.id).toList();
    if (match.isEmpty) return;
    Navigator.of(context).pop(); // fecha o diálogo do orador
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ActivityDetailScreen(activity: match.first),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final muted = AppColors.navy.withValues(alpha: 0.6);
    final hasPhoto = (speaker.avatarUrl ?? '').isNotEmpty;
    final bio = speaker.bio?.trim() ?? '';
    final repo = context.read<GgpenRepository>();

    final mq = MediaQuery.of(context);
    final maxH = mq.size.height * 0.86;

    return Dialog(
      backgroundColor: Colors.white,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      clipBehavior: Clip.antiAlias,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 440, maxHeight: maxH),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header com gradiente da cor do orador (visual anchor).
            _Header(speaker: speaker, hasPhoto: hasPhoto),
            // Corpo scrollable.
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: FutureBuilder<List<sb.Activity>>(
                  future: speaker.id == null
                      ? Future.value(const <sb.Activity>[])
                      : repo.getSpeakerSessions(speaker.id!),
                  builder: (context, snap) {
                    final isLoading = snap.connectionState == ConnectionState.waiting;
                    final hasError = snap.hasError;
                    final sessions = snap.data ?? const <sb.Activity>[];
                    final count = sessions.isNotEmpty
                        ? sessions.length
                        : speaker.sessions;
                    
                    // Sempre mostra a seção de sessões se houver pelo menos 1
                    final shouldShowSessions = count > 0;
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: speaker.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              l.sessionsCount(count),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: speaker.color),
                            ),
                          ),
                        ),
                        if (shouldShowSessions) ...[
                          const SizedBox(height: 22),
                          Text(l.speakerSessions.toUpperCase(),
                              style: AppTheme.overline(
                                  AppColors.navy.withValues(alpha: 0.45))),
                          const SizedBox(height: 10),
                          if (isLoading)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.bg,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.line),
                                ),
                                child: const SizedBox(
                                  height: 60,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else if (hasError)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.bg,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.line),
                                ),
                                child: Text(
                                  l.loadError,
                                  style: TextStyle(fontSize: 12, color: muted),
                                ),
                              ),
                            )
                          else
                            ...sessions.map((a) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Material(
                                    color: AppColors.bg,
                                    borderRadius: BorderRadius.circular(12),
                                    clipBehavior: Clip.antiAlias,
                                    child: InkWell(
                                      onTap: () => _openSession(context, a),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: AppColors.line),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(a.titulo,
                                                      style:
                                                          AppTheme.cardTitle()),
                                                  const SizedBox(height: 3),
                                                  Text(
                                                    '${_hhmm(a.inicio)}${(a.local ?? '').isNotEmpty ? ' · ${a.local}' : ''}',
                                                    style: AppTheme.meta(muted),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(LucideIcons.chevronRight,
                                                size: 18,
                                                color: AppColors.navy
                                                    .withValues(alpha: 0.4)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                        ],
                        const SizedBox(height: 22),
                        Text(l.aboutSpeaker.toUpperCase(),
                            style: AppTheme.overline(
                                AppColors.navy.withValues(alpha: 0.45))),
                        const SizedBox(height: 8),
                        Text(
                          bio.isEmpty ? l.noBio : bio,
                          style: TextStyle(
                              fontSize: 14, height: 1.55, color: muted),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Speaker speaker;
  final bool hasPhoto;
  const _Header({required this.speaker, required this.hasPhoto});

  /// Origem apresentada: "região · país" (o que existir), ex.: "Cabinda · Angola".
  String get _origin => [speaker.region, speaker.country]
      .map((s) => (s ?? '').trim())
      .where((s) => s.isNotEmpty)
      .join(' · ');

  @override
  Widget build(BuildContext context) {
    final base = speaker.color;
    final dark = Color.alphaBlend(
        Colors.black.withValues(alpha: 0.22), base);

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [base, dark],
            ),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: Colors.white.withValues(alpha: 0.22),
                foregroundImage: hasPhoto
                    ? CachedNetworkImageProvider(speaker.avatarUrl!,
                        maxWidth: 280)
                    : null,
                child: hasPhoto
                    ? null
                    : Text(
                        speaker.initials,
                        style: AppTheme.display(
                            size: 28,
                            weight: FontWeight.w700,
                            color: Colors.white),
                      ),
              ),
              const SizedBox(height: 14),
              Text(
                speaker.name,
                textAlign: TextAlign.center,
                style: AppTheme.display(size: 19, color: Colors.white),
              ),
              if (speaker.role.trim().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  speaker.role,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: Colors.white.withValues(alpha: 0.88)),
                ),
              ],
              if (_origin.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.mapPin,
                        size: 13,
                        color: Colors.white.withValues(alpha: 0.9)),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        _origin,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.95)),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        // Botão de fechar — afordância clara e ao alcance do polegar.
        Positioned(
          top: 8,
          right: 8,
          child: Material(
            color: Colors.white.withValues(alpha: 0.18),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: IconButton(
              icon: const Icon(LucideIcons.x, color: Colors.white, size: 18),
              visualDensity: VisualDensity.compact,
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ],
    );
  }
}
