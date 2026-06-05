import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

// Cache do HTML base já com o Three.js embutido (a parte pesada, ~650KB). É
// lido do bundle e montado uma única vez por sessão; reabrir o mapa passa a ser
// instantâneo em vez de reler e reconcatenar 603KB de cada vez.
String? _baseHtml;
Future<String>? _baseHtmlFuture;

Future<String> _loadBaseHtml() async {
  final html = await rootBundle.loadString('assets/venue/venue_map.html');
  final three = await rootBundle.loadString('assets/venue/three.min.js');
  final withThree =
      html.replaceFirst('<!--THREEJS-->', '<script>$three</script>');
  _baseHtml = withThree;
  return withThree;
}

/// Monta o HTML do mapa 3D totalmente autossuficiente (Three.js embutido, sem
/// rede nem caminhos externos) e injeta o destino vindo da atividade.
Future<String> buildVenueHtml(String? destination) async {
  final base = _baseHtml ?? await (_baseHtmlFuture ??= _loadBaseHtml());
  final dest = destination ?? '';
  // Injeção leve do destino logo a seguir ao Three.js, sem reconstruir o resto.
  return base.replaceFirst('</script>',
      '</script>\n<script>window.__INITDEST__=${jsonEncode(dest)};</script>');
}
