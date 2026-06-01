import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../models/speaker.dart';
import '../../state/event_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/data_status.dart';
import '../../widgets/speaker_detail.dart';

class SpeakersScreen extends StatelessWidget {
  final VoidCallback onMenu;
  const SpeakersScreen({super.key, required this.onMenu});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final es = context.watch<EventState>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.menu, size: 20),
          onPressed: onMenu,
        ),
        title: Text(l.speakersTitle),
      ),
      body: _body(l, es),
    );
  }

  Widget _body(AppLocalizations l, EventState es) {
    if (es.status == LoadStatus.error) {
      return ErrorView(onRetry: es.load);
    }
    if (!es.isReady) {
      return const LoadingView();
    }
    final speakers = es.speakers;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
      children: [
        Text(l.speakersConfirmed(speakers.length),
            style: TextStyle(
                fontSize: 13, color: AppColors.navy.withValues(alpha: 0.55))),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.74,
          ),
          itemCount: speakers.length,
          itemBuilder: (_, i) => _SpeakerCard(speaker: speakers[i]),
        ),
      ],
    );
  }
}

class _SpeakerCard extends StatelessWidget {
  final Speaker speaker;
  const _SpeakerCard({required this.speaker});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => showSpeakerDetail(context, speaker),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.line),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          child: Column(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: speaker.color,
                backgroundImage: (speaker.avatarUrl ?? '').isNotEmpty
                    ? NetworkImage(speaker.avatarUrl!)
                    : null,
                child: (speaker.avatarUrl ?? '').isNotEmpty
                    ? null
                    : Text(
                        speaker.initials,
                        style: AppTheme.display(
                            size: 18,
                            weight: FontWeight.w700,
                            color: Colors.white),
                      ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      speaker.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.display(
                          size: 13.5,
                          weight: FontWeight.w700,
                          color: AppColors.navy,
                          height: 1.2),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      speaker.role,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 11,
                          height: 1.2,
                          color: AppColors.navy.withValues(alpha: 0.55)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: speaker.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  AppLocalizations.of(context).sessionsCount(speaker.sessions),
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: speaker.color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
