import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Anúncios/novidades do GGPEN, rodados de tempo em tempo em qualquer aba.
class PromoAnnouncements {
  PromoAnnouncements._();

  /// Imagens dos anúncios (colocadas em assets/).
  static const List<String> posts = [
    'assets/promo1.png',
    'assets/promo2.png',
  ];
}

/// Mostra um anúncio (imagem) num diálogo centrado. Fecha sozinho após
/// [autoClose] (por defeito 1 min) ou quando o utilizador o dispensa.
Future<void> showPromoSheet(
  BuildContext context,
  String asset, {
  Duration autoClose = const Duration(minutes: 1),
}) {
  return showDialog<void>(
    context: context,
    barrierColor: AppColors.navy.withValues(alpha: 0.55),
    builder: (ctx) => _PromoDialog(asset: asset, autoClose: autoClose),
  );
}

class _PromoDialog extends StatefulWidget {
  final String asset;
  final Duration autoClose;
  const _PromoDialog({required this.asset, required this.autoClose});

  @override
  State<_PromoDialog> createState() => _PromoDialogState();
}

class _PromoDialogState extends State<_PromoDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progress;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(
      vsync: this,
      duration: widget.autoClose,
    )..forward();
    _timer = Timer(widget.autoClose, () {
      if (mounted) Navigator.of(context).maybePop();
    });
  }

  @override
  void dispose() {
    _progress.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final maxH = mq.size.height * 0.86;

    return Dialog(
      backgroundColor: Colors.white,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      clipBehavior: Clip.antiAlias,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 480, maxHeight: maxH),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Barra de progresso do auto-close (afordância subtil).
            AnimatedBuilder(
              animation: _progress,
              builder: (_, __) => LinearProgressIndicator(
                value: 1 - _progress.value,
                minHeight: 2,
                backgroundColor: AppColors.line,
                color: AppColors.techBlue,
              ),
            ),
            // Header com selo de identidade e botão de fechar.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.techBlue.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(LucideIcons.megaphone,
                        size: 18, color: AppColors.techBlue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('GGPEN · Novidades',
                            style: AppTheme.cardTitle()),
                        const SizedBox(height: 2),
                        Text('Toque na imagem para ampliar',
                            style: AppTheme.meta(
                                AppColors.navy.withValues(alpha: 0.55))),
                      ],
                    ),
                  ),
                  Material(
                    color: AppColors.bg,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: IconButton(
                      icon: const Icon(LucideIcons.x, size: 18),
                      visualDensity: VisualDensity.compact,
                      tooltip: MaterialLocalizations.of(context)
                          .closeButtonTooltip,
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.line),
            // Imagem do anúncio: frame quadrado fixo, mesma forma para
            // qualquer imagem carregada (cover, sem distorção).
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: AppColors.bg,
                width: double.infinity,
                child: InteractiveViewer(
                  maxScale: 4,
                  child: Image.asset(
                    widget.asset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(48),
                        child: Icon(LucideIcons.imageOff,
                            size: 48, color: AppColors.line),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
