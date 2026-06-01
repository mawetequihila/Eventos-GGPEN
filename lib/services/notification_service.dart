import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Notificações locais no telemóvel (com som), agendadas para tocar antes de uma
/// sessão começar — mesmo com a app fechada. Só Android/iOS; no-op na web.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const String _channelId = 'session_reminders';

  Future<void> init() async {
    if (kIsWeb) return;
    try {
      tzdata.initializeTimeZones();
      // O evento decorre em Angola (Luanda, sem horário de verão).
      tz.setLocalLocation(tz.getLocation('Africa/Luanda'));

      const settings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      );
      await _plugin.initialize(settings: settings);

      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  int _idFor(String activityId) => activityId.hashCode & 0x7fffffff;

  /// Agenda um lembrete local para [when]. Ignora se a hora já passou.
  Future<void> scheduleReminder({
    required String activityId,
    required String title,
    required String body,
    required DateTime when,
  }) async {
    if (kIsWeb || !_ready) return;
    final scheduled = tz.TZDateTime.from(when, tz.local);
    if (!scheduled.isAfter(tz.TZDateTime.now(tz.local))) return;
    try {
      await _plugin.zonedSchedule(
        id: _idFor(activityId),
        title: title,
        body: body,
        scheduledDate: scheduled,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            'Lembretes de sessão',
            channelDescription: 'Avisa antes de uma sessão começar',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            enableLights: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (_) {
      // Falha ao agendar (permissão negada, etc.) — ignora silenciosamente.
    }
  }

  Future<void> cancelReminder(String activityId) async {
    if (kIsWeb || !_ready) return;
    try {
      await _plugin.cancel(id: _idFor(activityId));
    } catch (_) {}
  }

  Future<void> cancelAll() async {
    if (kIsWeb || !_ready) return;
    try {
      await _plugin.cancelAll();
    } catch (_) {}
  }
}
