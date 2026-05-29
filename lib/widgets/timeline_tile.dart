import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/activity.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'type_chip.dart';

/// Linha da agenda: hora + fio vertical com nó colorido + cartão da actividade.
class TimelineTile extends StatelessWidget {
  final Activity activity;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const TimelineTile({
    super.key,
    required this.activity,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.55);
    final status = activity.statusAt(DateTime.now());
    final nodeColor = status == ActivityStatus.live
        ? AppColors.live
        : (status == ActivityStatus.past ? activity.type.color : AppColors.line);
    final filled = status == ActivityStatus.live || status == ActivityStatus.past;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 46,
            child: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(
                activity.startLabel,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: status == ActivityStatus.upcoming ? muted : scheme.onSurface,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 22,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 14,
                  color: isFirst ? Colors.transparent : AppColors.line,
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: filled ? nodeColor : Colors.white,
                    border: Border.all(color: nodeColor, width: 2),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : AppColors.line,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onTap,
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TypeLabel(activity.type),
                              const Spacer(),
                              if (status == ActivityStatus.live) const LiveBadge(),
                            ],
                          ),
                          const SizedBox(height: AppTheme.gap),
                          Text(
                            activity.title,
                            style: AppTheme.cardTitle(
                              color: status == ActivityStatus.cancelled
                                  ? muted
                                  : scheme.onSurface,
                              decoration: status == ActivityStatus.cancelled
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(LucideIcons.mapPin,
                                  size: AppTheme.iconMeta, color: muted),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  activity.location,
                                  style: AppTheme.meta(muted),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
