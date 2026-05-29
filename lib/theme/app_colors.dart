import 'package:flutter/material.dart';

/// Paleta alinhada ao protótipo (acentos), adaptada ao tema claro (duotone):
/// fundo claro com secções escuras (navy).
class AppColors {
  AppColors._();

  // Secções escuras (duotone) / texto-tinta
  static const Color navy = Color(0xFF0E1B3D);
  static const Color navyDeep = Color(0xFF0A1430);

  // Acento principal (azul do protótipo)
  static const Color techBlue = Color(0xFF4D7EFF); // accent
  static const Color accent2 = Color(0xFF7EB4FF);

  // Cores por categoria (do protótipo)
  static const Color talk = Color(0xFF4D7EFF);
  static const Color workshop = Color(0xFFA87BFF);
  static const Color demo = Color(0xFFFF8C42);
  static const Color ceremony = Color(0xFF1FB6A8); // teal (mais escuro p/ contraste em claro)

  // Aliases usados no gradiente/splash
  static const Color violet = workshop;
  static const Color cyan = ceremony;

  // Superfícies (claro)
  static const Color bg = Color(0xFFF3F5F9);
  static const Color line = Color(0xFFE3E7F0);

  // Estados
  static const Color live = Color(0xFFE8920C); // âmbar legível em claro
  static const Color liveBright = Color(0xFFFFAD40);
  static const Color warning = Color(0xFFF4A62A);
  static const Color gold = Color(0xFFF5B301);

  static const LinearGradient brandGradient = LinearGradient(
    colors: [workshop, techBlue, ceremony],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bannerFallback = LinearGradient(
    colors: [navy, Color(0xFF1B2E63)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
