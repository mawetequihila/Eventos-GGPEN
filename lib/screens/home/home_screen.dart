import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../data/mock_data.dart';
import '../../models/activity.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/activity_card.dart';
import '../../widgets/home_banner.dart';
import '../../widgets/session_countdown.dart';
import '../agenda/activity_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onMenu;
  final VoidCallback onOpenAgenda;
  final VoidCallback onOpenSaved;
  final VoidCallback onOpenMap;
  final VoidCallback onOpenNotifications;

  const HomeScreen({
    super.key,
    required this.onMenu,
    required this.onOpenAgenda,
    required this.onOpenSaved,
    required this.onOpenMap,
    required this.onOpenNotifications,
  });

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Bom dia';
    if (h < 19) return 'Boa tarde';
    return 'Boa noite';
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final now = DateTime.now();
    final activities = MockData.activities;

    final live = activities
        .where((a) => a.statusAt(now) == ActivityStatus.live)
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    final upcoming = activities
        .where((a) => a.statusAt(now) == ActivityStatus.upcoming)
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    final next = upcoming.isNotEmpty ? upcoming.first : null;
    final today = MockData.byDay(1);

    void openDetail(Activity a) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ActivityDetailScreen(activity: a)));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
          children: [
            // Top bar
            Row(
              children: [
                _RoundBtn(icon: LucideIcons.menu, onTap: onMenu),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${_greeting()}, ${state.userName ?? 'visitante'}',
                    style: AppTheme.display(size: 20, color: AppColors.navy),
                  ),
                ),
                Stack(
                  children: [
                    _RoundBtn(icon: LucideIcons.bell, onTap: onOpenNotifications),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF4D4D),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.bg, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppTheme.sectionGap),

            // Banner principal: carrossel de imagens do evento.
            const HomeBanner(
              images: [
                'assets/banners/home.jpg',
                'assets/banners/ggpen.jpg',
                'assets/banners/perfil.jpg',
              ],
              title: EventInfo.name,
              subtitle: EventInfo.subtitle,
            ),
            const SizedBox(height: AppTheme.sectionGap),

            // A decorrer agora — primeiro card, para o utilizador saber já o
            // que está a acontecer no momento.
            const _SLabel('A decorrer agora'),
            const SizedBox(height: AppTheme.labelGap),
            if (live.isNotEmpty)
              ...live.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.cardGap),
                  child: ActivityCard(activity: a, onTap: () => openDetail(a))))
            else
              const _Hint(text: 'Nenhuma sessão a decorrer neste momento.'),
            const SizedBox(height: AppTheme.sectionGap),

            // Próxima sessão (contagem decrescente para o evento seguinte)
            _CountdownCard(next: next),
            const SizedBox(height: AppTheme.sectionGap),

            const _SLabel('Acesso rápido'),
            const SizedBox(height: AppTheme.labelGap),
            Row(
              children: [
                _Shortcut(icon: LucideIcons.calendar, label: 'Agenda', onTap: onOpenAgenda),
                const SizedBox(width: 10),
                _Shortcut(icon: LucideIcons.bookmark, label: 'Guardadas', onTap: onOpenSaved),
                const SizedBox(width: 10),
                _Shortcut(icon: LucideIcons.map, label: 'Mapa', onTap: onOpenMap),
              ],
            ),

            const SizedBox(height: AppTheme.sectionGap),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _SLabel('Programação de hoje'),
                GestureDetector(
                  onTap: onOpenAgenda,
                  child: const Text('Ver tudo →',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.techBlue)),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.labelGap),
            ...today.take(4).map((a) => Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.cardGap),
                child: ActivityCard(activity: a, onTap: () => openDetail(a)))),
          ],
        ),
      ),
    );
  }
}

class _CountdownCard extends StatelessWidget {
  final Activity? next;
  const _CountdownCard({required this.next});

  @override
  Widget build(BuildContext context) {
    final n = next;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        gradient: AppColors.bannerFallback,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
              color: AppColors.navy.withValues(alpha: 0.22),
              blurRadius: 22,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Text('PRÓXIMA SESSÃO COMEÇA EM',
              style: AppTheme.overline(Colors.white.withValues(alpha: 0.6))),
          const SizedBox(height: 18),
          if (n != null) ...[
            SessionCountdown(target: n.start, onDark: true),
            const SizedBox(height: 20),
            Container(
                width: double.infinity,
                height: 1,
                color: Colors.white.withValues(alpha: 0.12)),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: n.type.color, shape: BoxShape.circle)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.cardTitle(color: Colors.white)),
                      const SizedBox(height: 3),
                      Text('${n.timeRange} · ${n.location}',
                          style: AppTheme.meta(
                              Colors.white.withValues(alpha: 0.6))),
                    ],
                  ),
                ),
              ],
            ),
          ] else
            Text('Sem mais sessões por hoje',
                style: AppTheme.display(size: 20, color: Colors.white)),
        ],
      ),
    );
  }
}

class _RoundBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: Icon(icon, size: AppTheme.iconAction, color: AppColors.navy),
      ),
    );
  }
}

class _SLabel extends StatelessWidget {
  final String text;
  const _SLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(),
        style: AppTheme.overline(AppColors.navy.withValues(alpha: 0.45)));
  }
}

class _Shortcut extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _Shortcut({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            children: [
              Icon(icon, size: AppTheme.iconAction, color: AppColors.techBlue),
              const SizedBox(height: 8),
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.navy.withValues(alpha: 0.7))),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  final String text;
  const _Hint({required this.text});

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.navy.withValues(alpha: 0.55);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Text(text, style: TextStyle(color: muted, fontSize: 13)),
    );
  }
}
