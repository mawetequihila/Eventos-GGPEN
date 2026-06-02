import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../services/reminder_scheduler.dart';
import '../../state/app_state.dart';
import '../../state/event_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/image_banner.dart';
import '../../widgets/language_selector.dart';
import '../../widgets/legal.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final es = context.watch<EventState>();

    final favCount =
        es.activities.where((a) => state.isFavorite(a.id)).length;
    final reminderCount =
        es.activities.where((a) => state.isReminder(a.id)).length;

    return Scaffold(
      appBar: AppBar(title: Text(l.profileTitle)),
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
                        state.userName ?? l.guestCapitalized,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        state.isLoggedIn
                            ? l.sessionActive
                            : l.browsingNoSession,
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
                  label: l.favorites,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: LucideIcons.bellRing,
                  value: '$reminderCount',
                  label: l.reminders,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              children: [
                const LanguageTile(),
                const Divider(height: 1, color: AppColors.line),
                _ReminderLeadTile(state: state),
                const Divider(height: 1, color: AppColors.line),
                ListTile(
                  leading: const Icon(LucideIcons.fileText, size: 20),
                  title: Text(l.termsDialogTitle,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  trailing: Icon(LucideIcons.chevronRight,
                      size: 18, color: AppColors.navy.withValues(alpha: 0.4)),
                  onTap: () => showTermsDialog(context),
                ),
                const Divider(height: 1, color: AppColors.line),
                ListTile(
                  leading: const Icon(LucideIcons.shieldCheck, size: 20),
                  title: Text(l.privacyDialogTitle,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  trailing: Icon(LucideIcons.chevronRight,
                      size: 18, color: AppColors.navy.withValues(alpha: 0.4)),
                  onTap: () => showPrivacyDialog(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => context.read<AppState>().signOut(),
            icon: const Icon(LucideIcons.logOut, size: 18),
            label: Text(l.logout),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
          ),
        ],
      ),
    );
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

String _leadLabel(AppLocalizations l, int minutes) =>
    minutes == 0 ? l.leadAtStart : l.leadMinutes(minutes);

/// Linha de definição: antecedência com que a app avisa antes de cada sessão.
class _ReminderLeadTile extends StatelessWidget {
  final AppState state;
  const _ReminderLeadTile({required this.state});

  Future<void> _pick(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final es = context.read<EventState>();
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(l.reminderLeadTitle,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
            for (final m in AppState.leadOptions)
              ListTile(
                title: Text(_leadLabel(l, m)),
                trailing: m == state.reminderLeadMinutes
                    ? const Icon(LucideIcons.check,
                        color: AppColors.techBlue, size: 20)
                    : null,
                onTap: () {
                  state.setReminderLeadMinutes(m);
                  // Reagenda as sessões já marcadas com a nova antecedência.
                  final reminded = es.activities
                      .where((a) => state.isReminder(a.id))
                      .toList();
                  rescheduleAll(l, reminded, m);
                  Navigator.of(ctx).pop();
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ListTile(
      leading: const Icon(LucideIcons.bellRing, size: 20),
      title: Text(l.reminderLeadTitle,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(l.reminderLeadHint,
          style: TextStyle(
              fontSize: 11, color: AppColors.navy.withValues(alpha: 0.5))),
      trailing: Text(
        _leadLabel(l, state.reminderLeadMinutes),
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.techBlue),
      ),
      onTap: () => _pick(context),
    );
  }
}
