import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../services/reminder_scheduler.dart';
import '../../state/app_state.dart';
import '../../state/event_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/language_selector.dart';
import '../../widgets/legal.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _initials(String? name) {
    final n = (name ?? '').trim();
    if (n.isEmpty) return '?';
    final p = n.split(RegExp(r'\s+'));
    if (p.length == 1) {
      return p.first.substring(0, p.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return (p.first[0] + p.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final es = context.watch<EventState>();

    final favCount =
        es.activities.where((a) => state.isFavorite(a.id)).length;
    final reminderCount =
        es.activities.where((a) => state.isReminder(a.id)).length;

    // Campos do perfil — nome/email vêm da sessão (Google/email) ou do local.
    final email = state.userEmail;

    final hasPersonalInfo = _nonEmpty(email);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(l.profileTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // ---- Header com avatar de iniciais ----
          _HeaderCard(
            initials: _initials(state.userName),
            name: state.userName ?? l.guestCapitalized,
            email: email,
          ),
          const SizedBox(height: 16),

          // ---- Estatísticas ----
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: LucideIcons.bookmark,
                  value: '$favCount',
                  label: l.favorites,
                  color: AppColors.techBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: LucideIcons.bellRing,
                  value: '$reminderCount',
                  label: l.reminders,
                  color: AppColors.live,
                ),
              ),
            ],
          ),

          // ---- Secção: Informação pessoal ----
          if (hasPersonalInfo) ...[
            const SizedBox(height: 24),
            _SectionLabel(l.profileSectionPersonal),
            const SizedBox(height: 10),
            _Card(
              children: [
                if (_nonEmpty(email))
                  _InfoRow(
                      icon: LucideIcons.mail,
                      label: l.profileFieldEmail,
                      value: email!),
              ],
            ),
          ],

          // ---- Secção: Preferências ----
          const SizedBox(height: 24),
          _SectionLabel(l.profileSectionPreferences),
          const SizedBox(height: 10),
          _Card(
            children: [
              const LanguageTile(),
              const Divider(height: 1, color: AppColors.line),
              _ReminderLeadTile(state: state),
            ],
          ),

          // ---- Secção: Legal ----
          const SizedBox(height: 24),
          _SectionLabel(l.profileSectionLegal),
          const SizedBox(height: 10),
          _Card(
            children: [
              ListTile(
                leading: const Icon(LucideIcons.fileText,
                    size: 20, color: AppColors.navy),
                title: Text(l.termsDialogTitle,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                trailing: Icon(LucideIcons.chevronRight,
                    size: 18, color: AppColors.navy.withValues(alpha: 0.4)),
                onTap: () => showTermsDialog(context),
              ),
              const Divider(height: 1, color: AppColors.line),
              ListTile(
                leading: const Icon(LucideIcons.shieldCheck,
                    size: 20, color: AppColors.navy),
                title: Text(l.privacyDialogTitle,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                trailing: Icon(LucideIcons.chevronRight,
                    size: 18, color: AppColors.navy.withValues(alpha: 0.4)),
                onTap: () => showPrivacyDialog(context),
              ),
            ],
          ),

          // ---- Terminar sessão (tom subtil de alerta) ----
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () {
              // Sai do ecrã primeiro para o AuthGate poder redirecionar sem
              // ficar bloqueado por uma rota empilhada por cima.
              Navigator.of(context).popUntil((r) => r.isFirst);
              // signOut é fire-and-forget: o estado local é actualizado
              // imediatamente e o Supabase desliga em background.
              context.read<AppState>().signOut();
            },
            icon: const Icon(LucideIcons.logOut, size: 18),
            label: Text(l.logout),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              foregroundColor: AppColors.live,
              side: BorderSide(
                  color: AppColors.live.withValues(alpha: 0.45)),
              textStyle: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  static bool _nonEmpty(String? v) => v != null && v.trim().isNotEmpty;
}

// =================== HEADER ===================

class _HeaderCard extends StatelessWidget {
  final String initials;
  final String name;
  final String? email;
  const _HeaderCard({
    required this.initials,
    required this.name,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              'assets/banners/perfil.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const DecoratedBox(
                decoration:
                    BoxDecoration(gradient: AppColors.bannerFallback),
              ),
            ),
          ),
          // Véu escuro com gradiente para legibilidade
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.navyDeep.withValues(alpha: 0.85),
                    AppColors.navy.withValues(alpha: 0.55),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
            child: Row(
              children: [
                // Avatar com gradiente de marca + iniciais
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.brandGradient,
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.85),
                        width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.navyDeep.withValues(alpha: 0.45),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: AppTheme.display(
                        size: 24,
                        weight: FontWeight.w800,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.display(
                            size: 19, color: Colors.white),
                      ),
                      if (email != null && email!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          email!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =================== STATS ===================

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTheme.display(
                size: 24, color: AppColors.navy, weight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.navy.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}

// =================== SECTION LABEL + CARD WRAPPER + INFO ROW ===================

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text.toUpperCase(),
        style: AppTheme.overline(AppColors.navy.withValues(alpha: 0.5)),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon,
                size: 18, color: AppColors.navy.withValues(alpha: 0.7)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    color: AppColors.navy.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =================== REMINDER LEAD TILE ===================

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
      leading:
          const Icon(LucideIcons.bellRing, size: 20, color: AppColors.navy),
      title: Text(l.reminderLeadTitle,
          style:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(l.reminderLeadHint,
          style: TextStyle(
              fontSize: 11, color: AppColors.navy.withValues(alpha: 0.5))),
      trailing: Text(
        _leadLabel(l, state.reminderLeadMinutes),
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.techBlue),
      ),
      onTap: () => _pick(context),
    );
  }
}
