import 'package:ggpen_angotic/l10n/app_localizations.dart';

import '../models/activity.dart';
import 'notification_service.dart';

/// Agenda (ou reagenda) a notificação local de uma sessão, [lead] minutos antes
/// de começar. [lead] = 0 avisa no momento do início.
Future<void> scheduleReminderFor(
    AppLocalizations l, Activity a, int lead) async {
  await NotificationService.instance.scheduleReminder(
    activityId: a.id,
    title: l.notifStartingSoonTitle(a.title),
    body: l.notifStartingSoonBody(a.timeRange, a.location),
    when: a.start.subtract(Duration(minutes: lead)),
  );
}

/// Recancela tudo e volta a agendar todas as sessões marcadas, com a nova
/// antecedência. Usado quando o utilizador muda a antecedência nas definições.
Future<void> rescheduleAll(
  AppLocalizations l,
  Iterable<Activity> reminded,
  int lead,
) async {
  await NotificationService.instance.cancelAll();
  for (final a in reminded) {
    await scheduleReminderFor(l, a, lead);
  }
}
