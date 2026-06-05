import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../models/activity.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'app_card.dart';
import 'type_chip.dart';

/// Cartão de actividade usado na Home e na Minha Agenda.
class ActivityCard extends StatefulWidget {
  final Activity activity;
  final VoidCallback onTap;
  final bool showReminderToggle;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onTap,
    this.showReminderToggle = false,
  });

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activity = widget.activity;
    final state = context.watch<AppState>();
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.55);
    final status = activity.statusAt(DateTime.now());
    final isLive = status == ActivityStatus.live;
    final isFav = state.isFavorite(activity.id);
    final isReminder = state.isReminder(activity.id);

    final card = AppCard(
      onTap: widget.onTap,
      borderColor: isLive ? AppColors.live : null,
      borderWidth: isLive ? 1.5 : 1,
      color: isLive
          ? Color.alphaBlend(
              AppColors.live.withValues(alpha: 0.06), Colors.white)
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TypeLabel(activity.type),
                    const SizedBox(width: AppTheme.labelGap),
                    if (status == ActivityStatus.live) const LiveBadge(),
                    if (status == ActivityStatus.cancelled)
                      Text(
                        AppLocalizations.of(context).statusCancelled,
                        style: AppTheme.overline(scheme.error),
                      ),
                  ],
                ),
                const SizedBox(height: AppTheme.gap),
                Text(
                  activity.title,
                  style: AppTheme.cardTitle(
                    decoration: status == ActivityStatus.cancelled
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: AppTheme.gap),
                Wrap(
                  spacing: AppTheme.labelGap,
                  runSpacing: 2,
                  children: [
                    _meta(muted, LucideIcons.clock, activity.timeRange),
                    _meta(muted, LucideIcons.mapPin, activity.location),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              _IconAction(
                icon: isFav ? Icons.bookmark_rounded : LucideIcons.bookmark,
                active: isFav,
                activeColor: AppColors.techBlue,
                onTap: () =>
                    context.read<AppState>().toggleFavorite(activity),
              ),
              if (widget.showReminderToggle && isFav)
                _IconAction(
                  icon: isReminder ? LucideIcons.bellRing : LucideIcons.bell,
                  active: isReminder,
                  activeColor: scheme.secondary,
                  onTap: () => context
                      .read<AppState>()
                      .toggleReminder(activity, AppLocalizations.of(context)),
                ),
            ],
          ),
        ],
      ),
    );

    if (!isLive) return card;

    // Glow pulsante âmbar quando a sessão está EM CURSO.
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, child) {
        final t = _pulse.value;
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.live.withValues(alpha: 0.10 + 0.18 * t),
                blurRadius: 14 + 10 * t,
                spreadRadius: 0,
              ),
            ],
          ),
          child: child,
        );
      },
      child: card,
    );
  }

  Widget _meta(Color color, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppTheme.iconMeta, color: color),
        const SizedBox(width: 6),
        Text(text, style: AppTheme.meta(color)),
      ],
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  const _IconAction({
    required this.icon,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4);
    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: Icon(icon, size: AppTheme.iconAction, color: active ? activeColor : muted),
      onPressed: onTap,
    );
  }
}
