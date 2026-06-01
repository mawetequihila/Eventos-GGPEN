import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';

/// Estado de carregamento: skeletons pulsantes com a forma dos cartões.
class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ac,
      builder: (_, __) {
        final t = _ac.value;
        final base = AppColors.line.withValues(alpha: 0.55 + 0.35 * t);
        final inner = AppColors.line.withValues(alpha: 0.85 + 0.10 * t);
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            for (var i = 0; i < 5; i++) ...[
              _SkeletonCard(base: base, inner: inner),
              const SizedBox(height: 12),
            ],
          ],
        );
      },
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final Color base;
  final Color inner;
  const _SkeletonCard({required this.base, required this.inner});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bar(width: 70, height: 10, color: inner),
          const SizedBox(height: 10),
          _bar(width: double.infinity, height: 14, color: base),
          const SizedBox(height: 6),
          _bar(width: 220, height: 14, color: base),
          const SizedBox(height: 12),
          Row(
            children: [
              _bar(width: 90, height: 10, color: inner),
              const SizedBox(width: 14),
              _bar(width: 120, height: 10, color: inner),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bar(
      {required double width, required double height, required Color color}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

/// Estado de erro com botão para tentar de novo.
class ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  final String? message;
  const ErrorView({super.key, required this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final muted = AppColors.navy.withValues(alpha: 0.6);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.wifiOff, size: 48, color: muted),
            const SizedBox(height: 16),
            Text(
              message ?? l.loadError,
              textAlign: TextAlign.center,
              style: TextStyle(color: muted),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(LucideIcons.refreshCw, size: 18),
              label: Text(l.retry),
            ),
          ],
        ),
      ),
    );
  }
}
