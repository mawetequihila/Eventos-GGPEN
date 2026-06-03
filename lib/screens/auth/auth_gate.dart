import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../home_shell.dart';
import 'complete_profile_screen.dart';
import 'login_screen.dart';
import 'welcome_back_screen.dart';

/// Decide o ecrã raiz com base no estado da sessão:
/// - loggedOut → Login (primeira vez ou perfil esquecido)
/// - welcomeBack → "Bem-vindo de volta" (perfil local guardado, sessão inactiva)
/// - checking → loading (Google a verificar perfil)
/// - needsProfile → completar perfil (Google sem telefone/empresa/cargo)
/// - ready → HomeShell
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    switch (context.watch<AppState>().authStatus) {
      case AuthStatus.loggedOut:
        return const LoginScreen();
      case AuthStatus.welcomeBack:
        return const WelcomeBackScreen();
      case AuthStatus.checking:
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: AppColors.techBlue),
          ),
        );
      case AuthStatus.needsProfile:
        return const CompleteProfileScreen();
      case AuthStatus.ready:
        return const HomeShell();
    }
  }
}
