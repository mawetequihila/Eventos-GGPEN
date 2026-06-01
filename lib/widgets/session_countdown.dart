import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Contador HH:MM:SS até [target]. Centrado; usar [onDark] sobre fundos navy.
class SessionCountdown extends StatefulWidget {
  final DateTime target;
  final bool onDark;
  const SessionCountdown({super.key, required this.target, this.onDark = false});

  @override
  State<SessionCountdown> createState() => _SessionCountdownState();
}

class _SessionCountdownState extends State<SessionCountdown> {
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
    final dark = widget.onDark;
    final base = dark ? Colors.white : AppColors.navy;
    final accent = dark ? AppColors.accent2 : AppColors.techBlue;
    final labelColor = base.withValues(alpha: dark ? 0.65 : 0.5);
    final sepColor = base.withValues(alpha: 0.35);

    final l = AppLocalizations.of(context);
    final diff = widget.target.difference(DateTime.now());
    if (diff.isNegative) {
      return Center(
        child: Text(l.happeningNow,
            style: AppTheme.display(size: 22, color: AppColors.live)),
      );
    }

    String two(int n) => n.toString().padLeft(2, '0');

    // A mais de 24h mostra Dias · Horas · Min; no próprio dia mostra Horas · Min · Seg.
    final List<Widget> units;
    if (diff.inDays >= 1) {
      units = [
        _unit(two(diff.inDays), l.unitDays, base, labelColor),
        _sep(sepColor),
        _unit(two(diff.inHours % 24), l.unitHoursLong, base, labelColor),
        _sep(sepColor),
        _unit(two(diff.inMinutes % 60), l.unitMinLong, accent, labelColor),
      ];
    } else {
      units = [
        _unit(two(diff.inHours), l.unitHoursLong, base, labelColor),
        _sep(sepColor),
        _unit(two(diff.inMinutes % 60), l.unitMinLong, base, labelColor),
        _sep(sepColor),
        _unit(two(diff.inSeconds % 60), l.unitSecLong, accent, labelColor),
      ];
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: units,
    );
  }

  Widget _unit(String v, String label, Color color, Color labelColor) {
    return Column(
      children: [
        Text(v, style: AppTheme.display(size: 38, color: color, height: 1)),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: labelColor)),
      ],
    );
  }

  Widget _sep(Color color) => Padding(
        padding: const EdgeInsets.only(bottom: 14, left: 8, right: 8),
        child: Text(':',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.w300, color: color)),
      );
}
