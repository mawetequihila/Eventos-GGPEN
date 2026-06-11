import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/brand_logo.dart';
import 'login_email_screen.dart';
import 'signup_screen.dart';

/// Tela inicial de autenticação — leva ao formulário de cadastro.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final mq = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagem de fundo + véu escuro para legibilidade.
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
                  const Spacer(flex: 1),
                  // Logo num "badge" branco com aro acentuado.
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                          color: AppColors.accent2.withValues(alpha: 0.35),
                          width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.navyDeep.withValues(alpha: 0.45),
                          blurRadius: 40,
                          spreadRadius: 2,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: const BrandImage(
                        asset: AppAssets.ggpen, height: 96),
                  ),
                  const SizedBox(height: 24),
                  // Kicker de marca.
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25)),
                    ),
                    child: const Text(
                      'ANGOTIC 2026',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.8,
                        color: AppColors.accent2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l.authWelcomeTitle,
                    textAlign: TextAlign.center,
                    style: AppTheme.display(size: 26, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.authWelcomeSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                  const Spacer(flex: 1),
                  // Value props — chama a atenção para o que o utilizador
                  // ganha ao criar conta. Preenche bem o espaço sem ruído.
                  Row(
                    children: [
                      _ValueProp(
                          icon: LucideIcons.calendarDays,
                          label: l.agendaTitle),
                      const SizedBox(width: 10),
                      _ValueProp(
                          icon: LucideIcons.bellRing, label: l.reminders),
                      const SizedBox(width: 10),
                      _ValueProp(
                          icon: LucideIcons.bookmark, label: l.favorites),
                    ],
                  ),
                  const Spacer(flex: 2),
                  // CTA único primário — leva ao formulário de cadastro.
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const SignupScreen()),
                    ),
                    icon: const Icon(LucideIcons.arrowRight, size: 19),
                    label: Text(l.authCreateAccount),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.navy,
                      iconColor: AppColors.techBlue,
                      minimumSize: const Size.fromHeight(54),
                      textStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Quem já tem conta entra com email + palavra-passe.
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        l.signupHaveAccount,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.85)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const LoginEmailScreen()),
                        ),
                        child: Text(
                          l.signupSignInLink,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Rodapé subtil — assegura que o cadastro é leve e privado.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.shieldCheck,
                          size: 13,
                          color: Colors.white.withValues(alpha: 0.55)),
                      const SizedBox(width: 6),
                      Text(
                        l.loginPrivacyFooter,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.white.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueProp extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ValueProp({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.accent2, size: 22),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.92),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
