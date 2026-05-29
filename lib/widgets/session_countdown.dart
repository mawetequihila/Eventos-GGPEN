import 'dart:async';

import 'package:flutter/material.dart';

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

    final diff = widget.target.difference(DateTime.now());
    if (diff.isNegative) {
      return Center(
        child: Text('A decorrer agora',
            style: AppTheme.display(size: 22, color: AppColors.live)),
      );
    }
    final h = (diff.inHours).toString().padLeft(2, '0');
    final m = (diff.inMinutes % 60).toString().padLeft(2, '0');
    final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _unit(h, 'horas', base, labelColor),
        _sep(sepColor),
        _unit(m, 'min', base, labelColor),
        _sep(sepColor),
        _unit(s, 'seg', accent, labelColor),
      ],
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
