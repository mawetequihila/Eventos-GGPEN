import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';

/// Anúncios/novidades do GGPEN, rodados de tempo em tempo em qualquer aba.
class PromoAnnouncements {
  PromoAnnouncements._();

  /// Imagens dos anúncios (colocadas em assets/).
  static const List<String> posts = [
    'assets/promo1.png',
    'assets/promo2.png',
  ];
}

/// Mostra um anúncio (imagem) numa folha inferior. Fecha sozinho após
/// [autoClose] (por defeito 1 min) ou quando o utilizador o dispensa.
Future<void> showPromoSheet(
  BuildContext context,
  String asset, {
  Duration autoClose = const Duration(minutes: 1),
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => _PromoSheet(asset: asset, autoClose: autoClose),
  );
}

class _PromoSheet extends StatefulWidget {
  final String asset;
  final Duration autoClose;
  const _PromoSheet({required this.asset, required this.autoClose});

  @override
  State<_PromoSheet> createState() => _PromoSheetState();
}

class _PromoSheetState extends State<_PromoSheet> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.autoClose, () {
      if (mounted) Navigator.of(context).maybePop();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.82;
    return Container(
      margin: const EdgeInsets.all(12),
      constraints: BoxConstraints(maxHeight: maxH),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
            child: Row(
              children: [
                const Icon(LucideIcons.megaphone,
                    size: 18, color: AppColors.techBlue),
                const SizedBox(width: 8),
                const Text('GGPEN · Novidades',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const Spacer(),
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 20),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
          ),
          Flexible(
            child: InteractiveViewer(
              maxScale: 4,
              child: Image.asset(
                widget.asset,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Padding(
                  padding: EdgeInsets.all(40),
                  child: Icon(LucideIcons.imageOff,
                      size: 40, color: AppColors.line),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
