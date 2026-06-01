import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/app_colors.dart';
import '../../widgets/app_bar_actions.dart';
import '../../widgets/contacts.dart';
import '../../widgets/brand_logo.dart';
import '../../widgets/image_banner.dart';
import 'location_screen.dart';

class GgpenScreen extends StatelessWidget {
  final VoidCallback onOpenAgenda;
  final VoidCallback onMenu;

  const GgpenScreen({
    super.key,
    required this.onOpenAgenda,
    required this.onMenu,
  });

  // Substituir por uma foto (satélite/equipa) em assets/banners/ quando enviares.
  static const String? _bannerImage = 'assets/banners/ggpen.jpg';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final muted = AppColors.navy.withValues(alpha: 0.6);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.menu, size: 20),
          onPressed: onMenu,
        ),
        title: const Text('GGPEN'),
        actions: const [AppBarActions()],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          ImageBanner(
            image: _bannerImage,
            height: 150,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                l.spaceProgramTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          // Logo sem fundo, sobre o fundo claro do ecrã.
          const Align(
            alignment: Alignment.centerLeft,
            child: BrandImage(asset: AppAssets.ggpen, height: 64),
          ),
          const SizedBox(height: 16),
          Text(
            l.ggpenDescription,
            style: TextStyle(fontSize: 14, height: 1.55, color: muted),
          ),
          const SizedBox(height: 24),
          _Label(l.atAngotic),
          const SizedBox(height: 10),
          _LinkTile(
            icon: LucideIcons.calendarDays,
            title: l.ourAgenda,
            subtitle: l.ourAgendaSubtitle,
            onTap: onOpenAgenda,
          ),
          const SizedBox(height: 10),
          _LinkTile(
            icon: LucideIcons.mapPin,
            title: l.whereWeAre,
            subtitle: l.standLabel,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LocationScreen()),
            ),
          ),
          const SizedBox(height: 24),
          _Label(l.contacts),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ContactIcon(LucideIcons.globe, l.contactSite,
                  onTap: () => openExternalUrl(context, GgpenContacts.site)),
              _ContactIcon(LucideIcons.mail, l.contactEmail,
                  onTap: () => openEmail(context, GgpenContacts.email)),
              _ContactIcon(LucideIcons.share2, l.contactSocial,
                  onTap: () => showSocialLinks(context)),
            ],
          ),
          const SizedBox(height: 28),
          Center(
            child: Text(
              l.presentAt,
              style: const TextStyle(fontSize: 12, letterSpacing: 1),
            ),
          ),
          const SizedBox(height: 10),
          const Center(child: BrandImage(asset: AppAssets.angotic, height: 30)),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1,
        color: AppColors.navy.withValues(alpha: 0.55),
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.techBlue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.techBlue, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700)),
                      Text(subtitle,
                          style: TextStyle(
                              fontSize: 13,
                              color: AppColors.navy.withValues(alpha: 0.6))),
                    ],
                  ),
                ),
                Icon(LucideIcons.chevronRight,
                    color: AppColors.navy.withValues(alpha: 0.4), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ContactIcon(this.icon, this.label, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.techBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.techBlue, size: 22),
            ),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(color: AppColors.navy.withValues(alpha: 0.6))),
          ],
        ),
      ),
    );
  }
}
