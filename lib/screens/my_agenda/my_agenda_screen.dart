import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../data/mock_data.dart';
import '../../models/activity.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/activity_card.dart';
import '../../widgets/app_bar_actions.dart';
import '../agenda/activity_detail_screen.dart';
import '../profile/profile_screen.dart';

class MyAgendaScreen extends StatelessWidget { 
  final VoidCallback onOpenAgenda;

  const MyAgendaScreen({super.key, required this.onOpenAgenda});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final favs = MockData.activities
        .where((a) => state.isFavorite(a.id))
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Agenda'),
        actions: const [AppBarActions()],
      ),
      body: favs.isEmpty
          ? _EmptyState(onOpenAgenda: onOpenAgenda)
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                if (!state.isLoggedIn) const _LoginHint(),
                _ConflictBanner(favs: favs),
                const SizedBox(height: 16),
                ..._buildByDay(context, favs),
              ],
            ),
    );
  }

  List<Widget> _buildByDay(BuildContext context, List<Activity> favs) {
    final widgets = <Widget>[];
    for (var day = 1; day <= 3; day++) {
      final dayItems = favs.where((a) => a.day == day).toList();
      if (dayItems.isEmpty) continue;
      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 4),
        child: Text(
          'DIA $day',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            color: AppColors.navy.withValues(alpha: 0.55),
          ),
        ),
      ));
      for (final a in dayItems) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ActivityCard(
            activity: a,
            showReminderToggle: true,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ActivityDetailScreen(activity: a),
              ),
            ),
          ),
        ));
      }
    }
    return widgets;
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onOpenAgenda;
  const _EmptyState({required this.onOpenAgenda});

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.navy.withValues(alpha: 0.55);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.star, size: 52, color: muted),
            const SizedBox(height: 16),
            const Text(
              'A tua agenda está vazia',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Marca actividades com a estrela na Agenda para as veres aqui e activares lembretes.',
              textAlign: TextAlign.center,
              style: TextStyle(color: muted),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onOpenAgenda,
              icon: const Icon(LucideIcons.calendarDays, size: 18),
              label: const Text('Ver agenda'),
              style: FilledButton.styleFrom(minimumSize: const Size(200, 50)),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginHint extends StatelessWidget {
  const _LoginHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.cloudOff, color: AppColors.navy, size: 20),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Os teus favoritos estão guardados neste telemóvel.',
              style: TextStyle(fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            child: const Text('Sincronizar'),
          ),
        ],
      ),
    );
  }
}

class _ConflictBanner extends StatelessWidget {
  final List<Activity> favs;
  const _ConflictBanner({required this.favs});

  bool get _hasConflict {
    for (var i = 0; i < favs.length; i++) {
      for (var j = i + 1; j < favs.length; j++) {
        if (favs[i].day == favs[j].day && favs[i].overlaps(favs[j])) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final conflict = _hasConflict;
    final color = conflict ? AppColors.warning : AppColors.live;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(conflict ? LucideIcons.alertTriangle : LucideIcons.checkCircle,
              size: 17, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              conflict
                  ? 'Tens actividades com horários sobrepostos.'
                  : 'Sem conflitos de horário.',
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
