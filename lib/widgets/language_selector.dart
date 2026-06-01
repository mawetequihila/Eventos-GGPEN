import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';

/// Idiomas disponíveis, com o nome apresentado no próprio idioma.
const Map<String, String> kLanguageNames = {
  'pt': 'Português',
  'en': 'English',
  'fr': 'Français',
  'ar': 'العربية',
};

/// Abre um seletor de idioma e aplica a escolha ao [AppState].
Future<void> showLanguagePicker(BuildContext context) async {
  final state = context.read<AppState>();
  final current = state.locale?.languageCode;
  final l = AppLocalizations.of(context);

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
              child: Row(
                children: [
                  const Icon(LucideIcons.languages,
                      size: 20, color: AppColors.techBlue),
                  const SizedBox(width: 10),
                  Text(
                    l.language,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            for (final entry in kLanguageNames.entries)
              ListTile(
                title: Text(entry.value),
                trailing: entry.key == current
                    ? const Icon(LucideIcons.check,
                        color: AppColors.techBlue, size: 20)
                    : null,
                onTap: () {
                  state.setLocale(Locale(entry.key));
                  Navigator.of(ctx).pop();
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}

/// Linha de menu que mostra o idioma atual e abre o seletor.
class LanguageTile extends StatelessWidget {
  const LanguageTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final code = context.watch<AppState>().locale?.languageCode ??
        Localizations.localeOf(context).languageCode;
    final name = kLanguageNames[code] ?? code;
    return ListTile(
      leading: const Icon(LucideIcons.languages, size: 20),
      title: Text(l.language,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Text(
        name,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.navy.withValues(alpha: 0.6),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => showLanguagePicker(context),
    );
  }
}
