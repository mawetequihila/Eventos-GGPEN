import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../home_shell.dart';
import 'complete_profile_screen.dart';
import 'login_screen.dart';

/// Decide o ecrã raiz com base no estado da sessão:
/// sem sessão → Login; Google a verificar perfil → loading; Google sem
/// telefone/empresa/cargo → completar perfil; caso contrário → HomeShell.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    switch (context.watch<AppState>().authStatus) {
      case AuthStatus.loggedOut:
        return const LoginScreen();
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
