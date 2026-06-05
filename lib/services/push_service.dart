import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'notification_service.dart';

/// Handler de mensagens com a app em segundo plano / terminada. Tem de ser uma
/// função top-level com @pragma('vm:entry-point'). O sistema Android já mostra a
/// notificação automaticamente quando a mensagem traz bloco `notification`, por
/// isso normalmente não há nada a fazer aqui.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Sem trabalho extra: a notificação é apresentada pelo sistema.
}

/// Notificações PUSH (Firebase Cloud Messaging). Entregam avisos mesmo com a
/// app fechada e permitem broadcast a todos os participantes.
///
/// IMPORTANTE: só funciona depois de configurar o Firebase (ver doc/FCM_SETUP.md
/// — adicionar google-services.json e o plugin Gradle). Enquanto não estiver
/// configurado, [init] falha silenciosamente e a app funciona na mesma com as
/// notificações locais.
class PushService {
  PushService._();
  static final PushService instance = PushService._();

  bool _ready = false;
  bool get isReady => _ready;

  Future<void> init() async {
    if (kIsWeb) return; // web push exigiria configuração adicional
    try {
      await Firebase.initializeApp();
      final messaging = FirebaseMessaging.instance;

      // Handler de background/terminada (depois do Firebase pronto).
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Pede permissão (iOS sempre; Android 13+ também).
      await messaging.requestPermission();

      // Regista o token deste dispositivo no Supabase para o servidor poder
      // enviar push. Também reage à renovação do token.
      final token = await messaging.getToken();
      if (token != null) await _saveToken(token);
      messaging.onTokenRefresh.listen(_saveToken);

      // App em primeiro plano: o sistema não mostra automaticamente, por isso
      // reaproveitamos a notificação local.
      FirebaseMessaging.onMessage.listen((m) {
        final n = m.notification;
        if (n != null) {
          NotificationService.instance.showNow(
            key: m.messageId ?? '${n.title}${n.body}',
            title: n.title ?? '',
            body: n.body ?? '',
          );
        }
      });

      _ready = true;
    } catch (_) {
      // Firebase ainda não configurado (sem google-services.json/plugin) — a app
      // continua a funcionar com notificações locais.
      _ready = false;
    }
  }

  /// Chama após o login/logout para associar (ou desassociar) o token ao user.
  Future<void> refreshTokenOwner() async {
    if (!_ready) return;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await _saveToken(token);
    } catch (_) {}
  }

  Future<void> _saveToken(String token) async {
    try {
      final db = Supabase.instance.client;
      await db.from('device_tokens').upsert({
        'token': token,
        'user_id': db.auth.currentUser?.id,
        'platform': defaultTargetPlatform.name,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'token');
    } catch (_) {
      // RLS/tabela ainda não criada — ignora.
    }
  }
}
