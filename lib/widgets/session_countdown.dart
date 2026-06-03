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

    // A mais de 24h mostra 4 unidades (Dias · Horas · Min · Seg) para haver
    // sempre movimento visível; no próprio dia mostra 3 (Horas · Min · Seg).
    final List<Widget> units;
    final double numberSize;
    final double sepSize;
    final double sepHPad;
    if (diff.inDays >= 1) {
      numberSize = 30;
      sepSize = 24;
      sepHPad = 6;
      units = [
        _unit(two(diff.inDays), l.unitDays, base, labelColor, numberSize),
        _sep(sepColor, sepSize, sepHPad),
        _unit(two(diff.inHours % 24), l.unitHoursLong, base, labelColor,
            numberSize),
        _sep(sepColor, sepSize, sepHPad),
        _unit(two(diff.inMinutes % 60), l.unitMinLong, base, labelColor,
            numberSize),
        _sep(sepColor, sepSize, sepHPad),
        _unit(two(diff.inSeconds % 60), l.unitSecLong, accent, labelColor,
            numberSize),
      ];
    } else {
      numberSize = 38;
      sepSize = 30;
      sepHPad = 8;
      units = [
        _unit(two(diff.inHours), l.unitHoursLong, base, labelColor,
            numberSize),
        _sep(sepColor, sepSize, sepHPad),
        _unit(two(diff.inMinutes % 60), l.unitMinLong, base, labelColor,
            numberSize),
        _sep(sepColor, sepSize, sepHPad),
        _unit(two(diff.inSeconds % 60), l.unitSecLong, accent, labelColor,
            numberSize),
      ];
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: units,
    );
  }

  Widget _unit(
      String v, String label, Color color, Color labelColor, double size) {
    return Column(
      children: [
        Text(v, style: AppTheme.display(size: size, color: color, height: 1)),
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

  Widget _sep(Color color, double size, double hPad) => Padding(
        padding: EdgeInsets.only(bottom: 14, left: hPad, right: hPad),
        child: Text(':',
            style: TextStyle(
                fontSize: size, fontWeight: FontWeight.w300, color: color)),
      );
}
