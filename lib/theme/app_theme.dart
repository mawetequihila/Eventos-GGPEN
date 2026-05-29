import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Tema único claro "duotone": fundo claro, AppBar e navegação em navy.
/// Usa a fonte do sistema (sem download online) — funciona offline.
class AppTheme {
  AppTheme._();

  /// Estilo de títulos (display). Mantém a mesma assinatura usada nos ecrãs;
  /// usa a fonte por omissão para não depender de rede.
  static TextStyle display({
    double? size,
    FontWeight weight = FontWeight.w800,
    Color? color,
    double height = 1.15,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // ---- Tokens de espaçamento (ritmo vertical consistente) ----
  static const double gap = 8; // espaçamento mínimo entre elementos próximos
  static const double labelGap = 12; // rótulo de secção → conteúdo
  static const double cardGap = 12; // entre cartões numa lista
  static const double sectionGap = 24; // entre blocos/secções

  // ---- Tokens de tamanho de ícone ----
  static const double iconMeta = 14; // ícones inline (hora, local)
  static const double iconSm = 16; // estados/avisos
  static const double iconAction = 20; // botões, atalhos e ações

  // ---- Estilos de texto reutilizáveis ----
  /// Rótulo/overline em maiúsculas (secções, etiquetas pequenas).
  static TextStyle overline(Color color) => TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.1,
        color: color,
      );

  /// Título de cartão (actividades, listas).
  static TextStyle cardTitle({Color? color, TextDecoration? decoration}) =>
      TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: color,
        decoration: decoration,
      );

  /// Texto corrente.
  static TextStyle body(Color color) =>
      TextStyle(fontSize: 13, height: 1.4, color: color);

  /// Meta-informação secundária (hora · local).
  static TextStyle meta(Color color) => TextStyle(fontSize: 12, color: color);

  static ThemeData theme() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.techBlue,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.navy,
      secondary: AppColors.techBlue,
      surface: Colors.white,
      onSurface: AppColors.navy,
      outlineVariant: AppColors.line,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.bg,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.techBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
