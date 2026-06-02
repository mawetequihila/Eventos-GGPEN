import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Diálogo genérico para textos legais (Termos de Uso / Política de Privacidade).
Future<void> showLegalDialog(
    BuildContext context, String title, String body) {
  return showDialog<void>(
    context: context,
    barrierColor: AppColors.navy.withValues(alpha: 0.55),
    builder: (ctx) => Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 520,
          maxHeight: MediaQuery.of(context).size.height * 0.82,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 8, 10),
              child: Row(
                children: [
                  Expanded(child: Text(title, style: AppTheme.cardTitle())),
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 18),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.line),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Text(
                  body,
                  style: TextStyle(
                      fontSize: 14,
                      height: 1.55,
                      color: AppColors.navy.withValues(alpha: 0.78)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style:
                    FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                child: Text(AppLocalizations.of(ctx).termsDialogClose),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> showTermsDialog(BuildContext context) {
  final l = AppLocalizations.of(context);
  return showLegalDialog(context, l.termsDialogTitle, l.termsBody);
}

Future<void> showPrivacyDialog(BuildContext context) {
  final l = AppLocalizations.of(context);
  return showLegalDialog(context, l.privacyDialogTitle, l.privacyBody);
}
