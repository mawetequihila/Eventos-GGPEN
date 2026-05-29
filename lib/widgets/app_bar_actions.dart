import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../screens/profile/profile_screen.dart';

/// Acção do AppBar: abrir o Perfil. (AppBar é escuro, ícone branco.)
class AppBarActions extends StatelessWidget {
  const AppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: IconButton(
        tooltip: 'Perfil',
        icon: const Icon(LucideIcons.user, size: 20),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        ),
      ),
    );
  }
}
