import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import '../../state/app_state.dart';
import '../../state/event_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/activity_card.dart';
import '../../widgets/brand_logo.dart';
import '../../widgets/data_status.dart';
import '../../widgets/home_banner.dart';
import '../../widgets/session_countdown.dart';
import '../agenda/activity_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onMenu;
  final VoidCallback onOpenAgenda;
  final VoidCallback onOpenSaved;
  final VoidCallback onOpenMap;
  final VoidCallback onOpenNotifications;
  final VoidCallback onOpenPerfil;

  const HomeScreen({
    super.key,
    required this.onMenu,
    required this.onOpenAgenda,
    required this.onOpenSaved,
    required this.onOpenMap,
    required this.onOpenNotifications,
    required this.onOpenPerfil,
  });

  String _greeting(AppLocalizations l) {
    final h = DateTime.now().hour;
    if (h < 12) return l.greetingMorning;
    if (h < 19) return l.greetingAfternoon;
    return l.greetingEvening;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final es = context.watch<EventState>();
    final now = DateTime.now();

    if (es.status == LoadStatus.error) {
      return Scaffold(body: SafeArea(child: ErrorView(onRetry: es.load)));
    }
    if (!es.isReady) {
      return const Scaffold(body: SafeArea(child: LoadingView()));
    }

    final activities = es.activities;

    final live = activities
        .where((a) => a.statusAt(now) == ActivityStatus.live)
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    final upcoming = activities
        .where((a) => a.statusAt(now) == ActivityStatus.upcoming)
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    final next = upcoming.isNotEmpty ? upcoming.first : null;
    final today = es.byDay(1);

    // Contagem de notificações não-lidas (mesma lógica que NotificationsScreen).
    final lead = Duration(minutes: state.reminderLeadMinutes);
    var unread = 1; // boas-vindas sempre presente
    for (final a in activities) {
      final status = a.statusAt(now);
      if (status == ActivityStatus.live) {
        unread++;
      } else {
        final fire = a.start.subtract(lead);
        if (!now.isBefore(fire) && now.isBefore(a.start)) {
          unread++;
        }
      }
    }

    void openDetail(Activity a) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ActivityDetailScreen(activity: a)));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
          children: [
            // Top bar — logo centrada, ladeada pelo menu e pelo sino.
            Row(
              children: [
                _RoundBtn(icon: LucideIcons.menu, onTap: onMenu),
                const Expanded(
                  child: Center(
                    child: BrandImage(
                        asset: AppAssets.ggpen, height: 88),
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _RoundBtn(icon: LucideIcons.bell, onTap: onOpenNotifications),
                    if (unread > 0)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          constraints:
                              const BoxConstraints(minWidth: 18, minHeight: 18),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF4D4D),
                            borderRadius: BorderRadius.circular(9),
                            border:
                                Border.all(color: AppColors.bg, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              unread > 99 ? '99+' : '$unread',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Center(
              child: Container(
                width: 48,
                height: 3,
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                l.greetingLine(_greeting(l), state.userName ?? l.guest),
                style: AppTheme.display(size: 18, color: AppColors.navy),
              ),
            ),
            const SizedBox(height: AppTheme.sectionGap),

            // Banner principal: carrossel de imagens do evento.
            HomeBanner(
              images: const [
                'assets/banners/home.jpg',
                'assets/banners/ggpen.jpg',
                'assets/banners/perfil.jpg',
              ],
              title: es.event?.nome ?? 'Angotic 2026',
              subtitle: l.eventSubtitle,
            ),
            const SizedBox(height: AppTheme.sectionGap),

            // A decorrer agora — primeiro card, para o utilizador saber já o
            // que está a acontecer no momento.
            _SLabel(l.liveNow),
            const SizedBox(height: AppTheme.labelGap),
            if (live.isNotEmpty)
              ...live.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.cardGap),
                  child: ActivityCard(activity: a, onTap: () => openDetail(a))))
            else
              _Hint(text: l.noLiveSession),
            const SizedBox(height: AppTheme.sectionGap),

            // Próxima sessão (contagem decrescente para o evento seguinte)
            _CountdownCard(next: next),
            const SizedBox(height: AppTheme.sectionGap),

            _SLabel(l.quickAccess),
            const SizedBox(height: AppTheme.labelGap),
            Row(
              children: [
                _Shortcut(icon: LucideIcons.bookmark, label: l.shortcutSaved, onTap: onOpenSaved),
                const SizedBox(width: 10),
                _Shortcut(icon: LucideIcons.bell, label: l.shortcutNotifications, onTap: onOpenNotifications),
              ],
            ),

            const SizedBox(height: AppTheme.sectionGap),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SLabel(l.todaySchedule),
                GestureDetector(
                  onTap: onOpenAgenda,
                  child: Text(l.seeAll,
                      style: const TextStyle(
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

class _CountdownCard extends StatefulWidget {
  final Activity? next;
  const _CountdownCard({required this.next});

  @override
  State<_CountdownCard> createState() => _CountdownCardState();
}

class _CountdownCardState extends State<_CountdownCard>
    with SingleTickerProviderStateMixin {
  Timer? _tick;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    // Tick a cada segundo para reavaliar se a sessão está prestes a começar.
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _tick?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final n = widget.next;

    final diff = n?.start.difference(DateTime.now()) ?? Duration.zero;
    final isUrgent =
        n != null && diff.inSeconds > 0 && diff.inMinutes < 5;

    final overlineColor = isUrgent
        ? AppColors.liveBright
        : Colors.white.withValues(alpha: 0.6);

    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, child) {
        final t = _pulse.value;
        final shadow = isUrgent
            ? BoxShadow(
                color: AppColors.live.withValues(alpha: 0.25 + 0.20 * t),
                blurRadius: 22 + 10 * t,
                offset: const Offset(0, 10),
              )
            : BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.22),
                blurRadius: 22,
                offset: const Offset(0, 10),
              );
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: BoxDecoration(
            gradient: AppColors.bannerFallback,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [shadow],
          ),
          child: child,
        );
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isUrgent) ...[
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                      color: AppColors.liveBright, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
              ],
              Text(l.nextSessionStartsIn,
                  style: AppTheme.overline(overlineColor)),
            ],
          ),
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
            Text(l.noMoreSessionsToday,
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
