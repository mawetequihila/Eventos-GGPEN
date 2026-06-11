import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../home_shell.dart';
import 'login_screen.dart';
import 'welcome_back_screen.dart';

/// Decide o ecrã raiz com base no estado da sessão:
/// - loggedOut → Login (primeira vez ou perfil esquecido)
/// - welcomeBack → "Bem-vindo de volta" (perfil local guardado, sessão inactiva)
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
      case AuthStatus.ready:
        return const HomeShell();
    }
  }
}
