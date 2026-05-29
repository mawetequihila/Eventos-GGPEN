import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';

/// Barra de navegação flutuante (ilha) com FAB central, inspirada no protótipo.
/// Índices: 0 Início · 1 Agenda · 2 Oradores · 3 GGPEN. FAB central = Mapa.
class FloatingNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onFab;

  const FloatingNav({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    required this.onFab,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withValues(alpha: 0.35),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            _item(LucideIcons.home, 0),
            _item(LucideIcons.calendar, 1),
            _fab(),
            _item(LucideIcons.users, 2),
            _item(LucideIcons.satellite, 3),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, int index) {
    final active = index == selectedIndex;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onSelect(index),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? Colors.white.withValues(alpha: 0.10) : null,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 21,
            color: active ? AppColors.accent2 : Colors.white54,
          ),
        ),
      ),
    );
  }

  Widget _fab() {
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: onFab,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.techBlue, Color(0xFF2B5CE8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.techBlue.withValues(alpha: 0.5),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(LucideIcons.map, size: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
