// Seleciona a implementação do mapa 3D conforme a plataforma:
// - mobile/desktop (dart.library.io) -> WebView (webview_flutter)
// - web (dart.library.html) -> <iframe> via HtmlElementView
export 'venue_map_stub.dart'
    if (dart.library.io) 'venue_map_mobile.dart'
    if (dart.library.html) 'venue_map_web.dart';
