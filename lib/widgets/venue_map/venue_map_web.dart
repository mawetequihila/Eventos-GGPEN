import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

import 'venue_map_loader.dart';

/// Mapa 3D na web: HTML autossuficiente injetado no <iframe> via srcdoc
/// (sem caminhos de asset nem CDN).
class VenueMap3D extends StatefulWidget {
  final String? destination;
  const VenueMap3D({super.key, this.destination});

  @override
  State<VenueMap3D> createState() => _VenueMap3DWebState();
}

class _VenueMap3DWebState extends State<VenueMap3D> {
  static int _seq = 0;
  String? _viewType;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final content = await buildVenueHtml(widget.destination);
    // Blob URL lida melhor com HTML grande (Three.js embutido) que srcdoc.
    final blob = html.Blob(<Object>[content], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final viewType = 'venue-map-${_seq++}';
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int _) {
      return html.IFrameElement()
        ..src = url
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allow = 'fullscreen; accelerometer; gyroscope';
    });
    if (mounted) setState(() => _viewType = viewType);
  }

  @override
  Widget build(BuildContext context) {
    final vt = _viewType;
    if (vt == null) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFF7EB4FF)));
    }
    return HtmlElementView(viewType: vt);
  }
}
