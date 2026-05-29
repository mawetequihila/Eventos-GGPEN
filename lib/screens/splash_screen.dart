import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'home_shell.dart';

/// Abertura clara com anel orbital animado (eco do Angotic).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    Timer(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeShell()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) => CustomPaint(
                  painter: _OrbitPainter(_controller.value),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Agenda no Angotic 2026',
              style: TextStyle(
                color: AppColors.navy.withValues(alpha: 0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const LinearProgressIndicator(
                  minHeight: 3,
                  backgroundColor: AppColors.line,
                  color: AppColors.techBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  final double t;
  _OrbitPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final fullRect = Rect.fromCircle(center: center, radius: size.width / 2);

    for (int i = 0; i < 4; i++) {
      final radius = size.width / 2 - i * 15 - 8;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6
        ..strokeCap = StrokeCap.round
        ..shader = AppColors.brandGradient.createShader(fullRect);
      final startAngle = t * 2 * math.pi + i * 0.8;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        3.7,
        false,
        paint,
      );
    }

    final orbitRadius = size.width / 2 - 8;
    final angle = t * 2 * math.pi;
    final satellite = Offset(
      center.dx + orbitRadius * math.cos(angle),
      center.dy + orbitRadius * math.sin(angle),
    );
    canvas.drawCircle(satellite, 6, Paint()..color = AppColors.cyan);
    canvas.drawCircle(
      satellite,
      11,
      Paint()..color = AppColors.cyan.withValues(alpha: 0.25),
    );
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) =>
      oldDelegate.t != t;
}
