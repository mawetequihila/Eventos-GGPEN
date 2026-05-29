import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Banner escuro com imagem de fundo (quando [image] é fornecida) e um véu
/// escuro para legibilidade do texto. Sem imagem, usa um fundo navy elegante.
///
/// Quando tiveres as fotos, coloca-as em assets/banners/, declara-as no
/// pubspec.yaml e passa o caminho em [image].
class ImageBanner extends StatelessWidget {
  final String? image;
  final Widget child;
  final double? height;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  const ImageBanner({
    super.key,
    this.image,
    required this.child,
    this.height,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = const BorderRadius.all(Radius.circular(22)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        children: [
          Positioned.fill(
            child: image != null
                ? Image.asset(
                    image!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const DecoratedBox(
                      decoration:
                          BoxDecoration(gradient: AppColors.bannerFallback),
                    ),
                  )
                : const DecoratedBox(
                    decoration: BoxDecoration(gradient: AppColors.bannerFallback),
                  ),
          ),
          // Véu escuro para o texto ficar legível sobre qualquer imagem.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    AppColors.navyDeep.withValues(alpha: 0.85),
                    AppColors.navy.withValues(alpha: 0.45),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: height,
            padding: padding,
            child: child,
          ),
        ],
      ),
    );
  }
}
