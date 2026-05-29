import 'package:flutter/material.dart';

class AppAssets {
  AppAssets._();
  static const String ggpen = 'assets/logo_ggpen.png';
  static const String angotic = 'assets/logo_angotic.png';
}

/// Logo sem qualquer fundo (a imagem já é transparente). Usar sempre sobre
/// superfícies claras para os traços escuros ficarem visíveis.
class BrandImage extends StatelessWidget {
  final String asset;
  final double height;

  const BrandImage({super.key, required this.asset, this.height = 32});

  @override
  Widget build(BuildContext context) {
    return Image.asset(asset, height: height, fit: BoxFit.contain);
  }
}
