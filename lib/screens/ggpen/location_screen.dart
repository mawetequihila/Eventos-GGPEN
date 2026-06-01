import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';

import '../../theme/app_colors.dart';
import '../../widgets/venue_map/venue_map_3d.dart';

/// Mapa 3D da feira ANGOTIC 2026. Se [destination] for indicado (o local de uma
/// atividade), o mapa abre já com a rota pronta — o utilizador só marca onde está.
class LocationScreen extends StatelessWidget {
  final String? destination;
  const LocationScreen({super.key, this.destination});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(title: Text(l.whereWeAre)),
      body: VenueMap3D(destination: destination),
    );
  }
}
