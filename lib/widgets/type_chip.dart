import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../theme/app_colors.dart';

/// Indicador de tipo discreto: ponto colorido + texto (sem caixa pesada).
class TypeLabel extends StatelessWidget {
  final ActivityType type;
  const TypeLabel(this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    final c = type.color;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          type.label.toUpperCase(),
          style: TextStyle(
            color: c,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }
}

/// Marca "a decorrer agora".
class LiveBadge extends StatelessWidget {
  const LiveBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 8,
          height: 8,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.live,
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(width: 6),
        Text(
          'EM CURSO',
          style: TextStyle(
            color: AppColors.live,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }
}
