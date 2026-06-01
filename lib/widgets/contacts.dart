import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_colors.dart';

/// Contactos oficiais do GGPEN.
class GgpenContacts {
  GgpenContacts._();
  static const String site = 'https://ggpen.gov.ao';
  static const String email = 'geral@ggpen.gov.ao';
  static const String facebook = 'https://www.facebook.com/ggpenoficial';
  static const String instagram = 'https://www.instagram.com/ggpen_oficial';
  static const String youtube = 'https://www.youtube.com/@ggpenoficial2354';
  static const String tiktok = 'https://www.tiktok.com/@ggpenoficial';
}

/// Abre um URL externo (browser, app de email, redes). Mostra aviso em caso de erro.
Future<void> openExternalUrl(BuildContext context, String url) async {
  final messenger = ScaffoldMessenger.of(context);
  final uri = Uri.parse(url);
  try {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(url)));
    }
  } catch (_) {
    messenger.showSnackBar(SnackBar(content: Text(url)));
  }
}

Future<void> openEmail(BuildContext context, String address) =>
    openExternalUrl(context, 'mailto:$address');

/// Folha com as redes sociais oficiais do GGPEN.
Future<void> showSocialLinks(BuildContext context) {
  final items = <(IconData, String, String)>[
    (LucideIcons.share2, 'Facebook', GgpenContacts.facebook),
    (LucideIcons.image, 'Instagram', GgpenContacts.instagram),
    (LucideIcons.playCircle, 'YouTube', GgpenContacts.youtube),
    (LucideIcons.music, 'TikTok', GgpenContacts.tiktok),
  ];
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          for (final it in items)
            ListTile(
              leading: Icon(it.$1, color: AppColors.techBlue),
              title: Text(it.$2),
              trailing: const Icon(LucideIcons.externalLink, size: 16),
              onTap: () {
                Navigator.of(ctx).pop();
                openExternalUrl(context, it.$3);
              },
            ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
