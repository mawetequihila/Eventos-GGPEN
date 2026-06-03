import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

/// Mostrado quando há um perfil local guardado mas a sessão está inactiva
/// (após logout). Permite reentrar com um clique ou trocar de conta.
class WelcomeBackScreen extends StatelessWidget {
  const WelcomeBackScreen({super.key});

  String _initials(String name) {
    final p = name.trim().split(RegExp(r'\s+'));
    if (p.isEmpty || p.first.isEmpty) return '?';
    if (p.length == 1) {
      return p.first.substring(0, p.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return (p.first[0] + p.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final profile = state.localProfile ?? const {};
    final name = (profile['name'] ?? '').trim();
    final email = (profile['email'] ?? '').trim();
    final mq = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/banners/perfil.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const DecoratedBox(
              decoration: BoxDecoration(gradient: AppColors.bannerFallback),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.navy.withValues(alpha: 0.55),
                  AppColors.navyDeep.withValues(alpha: 0.92),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 32, 24, 24 + mq.padding.bottom),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  // Avatar grande com iniciais sobre um círculo branco translúcido.
                  Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _initials(name.isEmpty ? '?' : name),
                      style: AppTheme.display(
                          size: 38,
                          weight: FontWeight.w800,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    l.welcomeBackTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.welcomeBackHello(name.isEmpty ? '👋' : name),
                    textAlign: TextAlign.center,
                    style: AppTheme.display(size: 24, color: Colors.white),
                  ),
                  if (email.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                  const Spacer(flex: 3),
                  FilledButton.icon(
                    onPressed: () =>
                        context.read<AppState>().resumeLocalSession(),
                    icon: const Icon(LucideIcons.arrowRight, size: 18),
                    label: Text(l.welcomeBackContinue),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.navy,
                      minimumSize: const Size.fromHeight(52),
                      textStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: () => _confirmSwitch(context, l),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white.withValues(alpha: 0.85),
                      minimumSize: const Size.fromHeight(44),
                    ),
                    child: Text(
                      l.welcomeBackSwitch,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmSwitch(BuildContext context, AppLocalizations l) async {
    final ok = await showDialog<bool>(
      context: context,
      barrierColor: AppColors.navy.withValues(alpha: 0.55),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        elevation: 0,
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 26, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Selo de aviso (visual anchor — acção destrutiva).
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.live.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(LucideIcons.triangleAlert,
                      size: 22, color: AppColors.live),
                ),
                const SizedBox(height: 16),
                Text(
                  l.welcomeBackSwitchTitle,
                  style: AppTheme.display(size: 19, color: AppColors.navy),
                ),
                const SizedBox(height: 8),
                Text(
                  l.welcomeBackSwitchBody,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.navy.withValues(alpha: 0.65),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          side: BorderSide(
                              color: AppColors.navy.withValues(alpha: 0.25)),
                          foregroundColor: AppColors.navy,
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        child: Text(l.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        child: Text(
                          l.welcomeBackSwitchConfirm,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (ok == true && context.mounted) {
      await context.read<AppState>().forgetLocalProfile();
    }
  }
}
