import 'package:flutter/widgets.dart';

/// Fallback para plataformas sem suporte de WebView/iframe.
class VenueMap3D extends StatelessWidget {
  final String? destination;
  const VenueMap3D({super.key, this.destination});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Mapa 3D indisponível nesta plataforma.'),
    );
  }
}
