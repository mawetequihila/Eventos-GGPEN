import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../home_shell.dart';
import 'login_screen.dart';

/// Decide o ecrã raiz com base em [AppState.isLoggedIn]: HomeShell quando
/// existe sessão (Google ou perfil local), caso contrário LoginScreen.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedIn = context.watch<AppState>().isLoggedIn;
    return loggedIn ? const HomeShell() : const LoginScreen();
  }
}
