import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'venue_map_loader.dart';

/// Mapa 3D em mobile: HTML autossuficiente (Three.js embutido) carregado no
/// WebView via loadHtmlString — funciona offline, sem ir à web.
class VenueMap3D extends StatefulWidget {
  final String? destination;
  const VenueMap3D({super.key, this.destination});

  @override
  State<VenueMap3D> createState() => _VenueMap3DState();
}

class _VenueMap3DState extends State<VenueMap3D> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final content = await buildVenueHtml(widget.destination);
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0E1B3D))
      ..loadHtmlString(content);
    if (mounted) setState(() => _controller = controller);
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFF7EB4FF)));
    }
    return WebViewWidget(controller: controller);
  }
}
