import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// Monta o HTML do mapa 3D totalmente autossuficiente (Three.js embutido, sem
/// rede nem caminhos externos) e injeta o destino vindo da atividade.
Future<String> buildVenueHtml(String? destination) async {
  final html = await rootBundle.loadString('assets/venue/venue_map.html');
  final three = await rootBundle.loadString('assets/venue/three.min.js');
  final dest = destination ?? '';
  final inject = '<script>$three</script>\n'
      '<script>window.__INITDEST__=${jsonEncode(dest)};</script>';
  return html.replaceFirst('<!--THREEJS-->', inject);
}
