import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../data/mock_data.dart';
import '../../models/speaker.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class SpeakersScreen extends StatelessWidget {
  final VoidCallback onMenu;
  const SpeakersScreen({super.key, required this.onMenu});

  @override
  Widget build(BuildContext context) {
    final speakers = MockData.speakers;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.menu, size: 20),
          onPressed: onMenu,
        ),
        title: const Text('Oradores'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
        children: [
          Text('${speakers.length} confirmados',
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
              childAspectRatio: 0.82,
            ),
            itemCount: speakers.length,
            itemBuilder: (_, i) => _SpeakerCard(speaker: speakers[i]),
          ),
        ],
      ),
    );
  }
}

class _SpeakerCard extends StatelessWidget {
  final Speaker speaker;
  const _SpeakerCard({required this.speaker});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: speaker.color,
              shape: BoxShape.circle,
              border: Border.all(color: speaker.color.withValues(alpha: 0.3), width: 3),
            ),
            alignment: Alignment.center,
            child: Text(
              speaker.initials,
              style: AppTheme.display(
                  size: 18, weight: FontWeight.w700, color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            speaker.name,
            textAlign: TextAlign.center,
            style: AppTheme.display(
                size: 13.5, weight: FontWeight.w700, color: AppColors.navy,
                height: 1.25),
          ),
          const SizedBox(height: 3),
          Text(
            speaker.role,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 11, color: AppColors.navy.withValues(alpha: 0.55)),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: speaker.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              speaker.sessions == 1 ? '1 sessão' : '${speaker.sessions} sessões',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: speaker.color),
            ),
          ),
        ],
      ),
    );
  }
}
