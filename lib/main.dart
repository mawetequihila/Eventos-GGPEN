import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'data/ggpen_repository.dart';
import 'services/notification_service.dart';
import 'services/push_service.dart';
import 'state/app_state.dart';
import 'state/event_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kupwtlqzwpprozbnqdff.supabase.co',
    anonKey: 'sb_publishable_CWUmVOhFQKOaVoKT_J-mmg_aDDoUGK8',
  );

  // Notificações locais (telemóvel). NÃO esperar: a init pode mostrar o pedido
  // de permissão e bloquearia o arranque até o utilizador responder.
  unawaited(NotificationService.instance.init());

  // Push (FCM). A init é defensiva — sem Firebase configurado não faz nada
  // (ver doc/FCM_SETUP.md). Regista o handler de background internamente.
  unawaited(PushService.instance.init());

  final repo = GgpenRepository();

  final appState = AppState(repo);
  await appState.load();

  // Carrega evento/atividades/oradores em background; a UI mostra loading.
  final eventState = EventState(repo)..load();

  // Idioma do conteúdo (título/descrição/bio) segue o idioma escolhido na app.
  eventState.setLanguage(appState.locale?.languageCode);
  appState.addListener(
    () => eventState.setLanguage(appState.locale?.languageCode),
  );

  // Quando a agenda muda (incl. em tempo real), reconcilia os lembretes: se o
  // horário de uma sessão marcada mudou, reagenda e avisa o utilizador.
  eventState.addListener(
    () => appState.onActivitiesChanged(eventState.activities),
  );

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
