import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Contagem regressiva até [target]. Usada dentro do banner com gradiente,
/// por isso o texto é branco. Quando chega a zero, mostra mensagem de evento
/// a decorrer.
class Countdown extends StatefulWidget {
  final DateTime target;

  const Countdown({super.key, required this.target});

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final diff = widget.target.difference(DateTime.now());
    if (diff.isNegative) {
      return Row(
        children: [
          const Icon(LucideIcons.zap, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            l.eventInProgress,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ],
      );
    }
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;
    return Row(
      children: [
        _unit(days, l.unitDays),
        _sep(),
        _unit(hours, l.unitHoursShort),
        _sep(),
        _unit(minutes, l.unitMinShort),
        _sep(),
        _unit(seconds, l.unitSecShort),
      ],
    );
  }

  Widget _unit(int value, String label) {
    return Column(
      children: [
        Text(
          value.toString().padLeft(2, '0'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _sep() => Padding(
        padding: const EdgeInsets.only(bottom: 14, left: 8, right: 8),
        child: Text(
          ':',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}
