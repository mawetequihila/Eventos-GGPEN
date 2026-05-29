import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../data/mock_data.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/image_banner.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final muted = AppColors.navy.withValues(alpha: 0.6);

    final favCount =
        MockData.activities.where((a) => state.isFavorite(a.id)).length;
    final reminderCount =
        MockData.activities.where((a) => state.isReminder(a.id)).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          ImageBanner(
            image: 'assets/banners/perfil.jpg',
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withValues(alpha: 0.22),
                  child: Icon(
                    state.isLoggedIn ? LucideIcons.user : LucideIcons.userCheck,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.userName ?? 'Visitante',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        state.isLoggedIn
                            ? 'Sessão iniciada'
                            : 'A navegar sem sessão',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: LucideIcons.star,
                  value: '$favCount',
                  label: 'Favoritos',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: LucideIcons.bellRing,
                  value: '$reminderCount',
                  label: 'Lembretes',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (state.isLoggedIn)
            OutlinedButton.icon(
              onPressed: () => context.read<AppState>().logout(),
              icon: const Icon(LucideIcons.logOut, size: 18),
              label: const Text('Terminar sessão'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            )
          else
            FilledButton.icon(
              onPressed: () => _promptLogin(context),
              icon: const Icon(LucideIcons.logIn, size: 18),
              label: const Text('Iniciar sessão (demo)'),
            ),
          const SizedBox(height: 10),
          Text(
            'O login é opcional. Sem sessão, os favoritos ficam guardados '
            'apenas neste telemóvel.',
            style: TextStyle(fontSize: 12, color: muted),
          ),
        ],
      ),
    );
  }

  Future<void> _promptLogin(BuildContext context) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Iniciar sessão (demo)'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'O teu nome',
            hintText: 'Ex.: Maria Sousa',
          ),
          onSubmitted: (v) => Navigator.of(ctx).pop(v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text),
            child: const Text('Entrar'),
          ),
        ],
      ),
    );
    if (name != null && context.mounted) {
      context.read<AppState>().login(name);
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.techBlue, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.navy.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
