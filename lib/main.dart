import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'data/ggpen_repository.dart';
import 'services/notification_service.dart';
import 'state/app_state.dart';
import 'state/event_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kupwtlqzwpprozbnqdff.supabase.co',
    anonKey: 'sb_publishable_CWUmVOhFQKOaVoKT_J-mmg_aDDoUGK8',
  );

  // Notificações locais (telemóvel). No-op na web.
  await NotificationService.instance.init();

  final repo = GgpenRepository();

  final appState = AppState(repo);
  await appState.load();

  // Carrega evento/atividades/oradores em background; a UI mostra loading.
  final eventState = EventState(repo)..load();

  runApp(
    MultiProvider(
      providers: [
        Provider<GgpenRepository>.value(value: repo),
        ChangeNotifierProvider<AppState>.value(value: appState),
        ChangeNotifierProvider<EventState>.value(value: eventState),
      ],
      child: const GgpenAngoticApp(),
    ),
  );
}
