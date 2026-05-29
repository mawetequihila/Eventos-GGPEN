import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'brand_logo.dart';

/// Menu lateral com todas as secções. As 4 principais trocam de aba; as
/// restantes abrem como páginas.
class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelectTab;
  final VoidCallback onOpenMinha;
  final VoidCallback onOpenNotif;
  final VoidCallback onOpenMapa;
  final VoidCallback onOpenParticipantes;
  final VoidCallback onOpenPerfil;

  const AppDrawer({
    super.key,
    required this.selectedIndex,
    required this.onSelectTab,
    required this.onOpenMinha,
    required this.onOpenNotif,
    required this.onOpenMapa,
    required this.onOpenParticipantes,
    required this.onOpenPerfil,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).padding.top + 26,
              20,
              20,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: AppColors.line)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandImage(asset: AppAssets.ggpen, height: 46),
                const SizedBox(height: 14),
                Text(
                  'Agenda no Angotic 2026',
                  style: AppTheme.display(size: 15, weight: FontWeight.w700,
                      color: AppColors.navy),
                ),
                const SizedBox(height: 8),
                const _GradientRule(),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _tab(context, LucideIcons.home, 'Início', 0),
                _tab(context, LucideIcons.calendar, 'Agenda', 1),
                _tab(context, LucideIcons.users, 'Oradores', 2),
                _tab(context, LucideIcons.satellite, 'GGPEN', 3),
                const Divider(height: 16, color: AppColors.line),
                _push(context, LucideIcons.bookmark, 'Minha Agenda', onOpenMinha),
                _push(context, LucideIcons.bell, 'Notificações', onOpenNotif),
                _push(context, LucideIcons.map, 'Mapa', onOpenMapa),
                _push(context, LucideIcons.userCheck, 'Participantes',
                    onOpenParticipantes),
                _push(context, LucideIcons.user, 'Perfil', onOpenPerfil),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.line),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'apresentado por GGPEN',
              style: TextStyle(fontSize: 11, letterSpacing: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(BuildContext context, IconData icon, String label, int index) {
    final selected = index == selectedIndex;
    return ListTile(
      leading: Icon(icon, size: 20, color: selected ? AppColors.techBlue : null),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? AppColors.techBlue : null,
        ),
      ),
      selected: selected,
      selectedTileColor: AppColors.techBlue.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        Scaffold.of(context).closeDrawer();
        onSelectTab(index);
      },
    );
  }

  Widget _push(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback action,
  ) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        Scaffold.of(context).closeDrawer();
        action();
      },
    );
  }
}

class _GradientRule extends StatelessWidget {
  const _GradientRule();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      width: 56,
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
