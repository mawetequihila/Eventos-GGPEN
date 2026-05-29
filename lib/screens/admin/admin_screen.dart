import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../data/mock_data.dart';
import '../../models/activity.dart';
import '../../models/participant.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class AdminScreen extends StatelessWidget {
  final VoidCallback onMenu;
  final VoidCallback onOpenParticipantes;

  const AdminScreen({
    super.key,
    required this.onMenu,
    required this.onOpenParticipantes,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final total = MockData.participants.length;
    final checkins = MockData.participants.where((p) => p.checkedIn).length;
    final live = MockData.activities
        .where((a) => a.statusAt(now) == ActivityStatus.live)
        .length;
    final done = MockData.activities
        .where((a) => a.statusAt(now) == ActivityStatus.past)
        .length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.menu, size: 20),
          onPressed: onMenu,
        ),
        title: const Text('Admin'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
        children: [
          Text('Visão geral · actualizado em tempo real',
              style: TextStyle(
                  fontSize: 12, color: AppColors.navy.withValues(alpha: 0.5))),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _Metric(icon: LucideIcons.users, value: '$total', label: 'Participantes')),
            const SizedBox(width: 12),
            Expanded(child: _Metric(icon: LucideIcons.userCheck, value: '$checkins', label: 'Check-ins')),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _Metric(icon: LucideIcons.activity, value: '$live', label: 'Sessões activas')),
            const SizedBox(width: 12),
            Expanded(child: _Metric(icon: LucideIcons.checkCircle, value: '$done', label: 'Concluídas', muted: true)),
          ]),
          const SizedBox(height: 16),
          _Card(
            title: 'Participação por horário',
            child: _BarChart(),
          ),
          const SizedBox(height: 16),
          _Card(
            title: 'Sessões com mais inscrições',
            child: Column(
              children: const [
                _RankRow(label: 'Cerimónia de Abertura', value: 342, pct: 1.0),
                SizedBox(height: 14),
                _RankRow(label: 'Soberania de Dados', value: 287, pct: 0.84),
                SizedBox(height: 14),
                _RankRow(label: 'Demo GEDAE Intelligence', value: 95, pct: 0.28),
                SizedBox(height: 14),
                _RankRow(label: 'Workshop: Estações Terrenas', value: 38, pct: 0.11),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PARTICIPANTES',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: AppColors.navy.withValues(alpha: 0.5))),
              GestureDetector(
                onTap: onOpenParticipantes,
                child: const Text('Gerir →',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.techBlue)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              children: [
                for (var i = 0; i < MockData.participants.length && i < 5; i++)
                  _ParticipantRow(
                    participant: MockData.participants[i],
                    last: i == 4 || i == MockData.participants.length - 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool muted;
  const _Metric({
    required this.icon,
    required this.value,
    required this.label,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = muted ? AppColors.navy.withValues(alpha: 0.5) : AppColors.techBlue;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: c),
          ),
          const SizedBox(height: 12),
          Text(value, style: AppTheme.display(size: 28, color: muted ? c : AppColors.navy)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 12, color: AppColors.navy.withValues(alpha: 0.6))),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;
  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(),
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: AppColors.navy.withValues(alpha: 0.5))),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  static const _bars = [
    ('08h', 0.22, false),
    ('09h', 0.82, true),
    ('10h', 0.70, true),
    ('11h', 1.0, true),
    ('14h', 0.62, true),
    ('16h', 0.46, false),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final b in _bars)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 70 * (b.$2 as double),
                      decoration: BoxDecoration(
                        color: b.$3 as bool
                            ? AppColors.techBlue
                            : AppColors.line,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(5)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(b.$1 as String,
                        style: TextStyle(
                            fontSize: 9,
                            color: AppColors.navy.withValues(alpha: 0.5))),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  final String label;
  final int value;
  final double pct;
  const _RankRow({required this.label, required this.value, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500)),
            ),
            Text('$value',
                style: AppTheme.display(
                    size: 13, weight: FontWeight.w700, color: AppColors.techBlue)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 6,
            backgroundColor: AppColors.line,
            color: AppColors.techBlue,
          ),
        ),
      ],
    );
  }
}

class _ParticipantRow extends StatelessWidget {
  final Participant participant;
  final bool last;
  const _ParticipantRow({required this.participant, required this.last});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.navy.withValues(alpha: 0.10),
            child: Text(participant.initials,
                style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w700,
                    fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(participant.name,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                Text(participant.company,
                    style: TextStyle(
                        fontSize: 11,
                        color: AppColors.navy.withValues(alpha: 0.5))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: participant.checkedIn
                  ? AppColors.talk.withValues(alpha: 0.12)
                  : AppColors.navy.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              participant.checkedIn ? 'Presente' : 'Pendente',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: participant.checkedIn
                      ? AppColors.talk
                      : AppColors.navy.withValues(alpha: 0.5)),
            ),
          ),
        ],
      ),
    );
  }
}
