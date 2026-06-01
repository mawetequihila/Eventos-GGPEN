// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navAgenda => 'Agenda';

  @override
  String get navSpeakers => 'Speakers';

  @override
  String get drawerMyAgenda => 'My Agenda';

  @override
  String get drawerNotifications => 'Notifications';

  @override
  String get drawerMap => 'Map';

  @override
  String get drawerParticipants => 'Participants';

  @override
  String get drawerProfile => 'Profile';

  @override
  String get drawerHeaderTitle => 'Agenda at Angotic 2026';

  @override
  String get drawerPoweredBy => 'presented by GGPEN';

  @override
  String get splashTagline => 'Agenda at Angotic 2026';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String greetingLine(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get guest => 'visitor';

  @override
  String get liveNow => 'Happening now';

  @override
  String get noLiveSession => 'No session is running right now.';

  @override
  String get nextSessionStartsIn => 'NEXT SESSION STARTS IN';

  @override
  String get noMoreSessionsToday => 'No more sessions today';

  @override
  String get quickAccess => 'Quick access';

  @override
  String get shortcutAgenda => 'Agenda';

  @override
  String get shortcutSaved => 'Saved';

  @override
  String get shortcutMap => 'Map';

  @override
  String get todaySchedule => 'Today\'s schedule';

  @override
  String get seeAll => 'See all →';

  @override
  String get agendaTitle => 'Agenda';

  @override
  String get searchTooltip => 'Search';

  @override
  String get searchHint => 'Search activity, location or speaker';

  @override
  String get searchPrompt => 'Type to search…';

  @override
  String get noResults => 'No results.';

  @override
  String searchResultSubtitle(int day, String time, String location) {
    return 'Day $day · $time · $location';
  }

  @override
  String get weekday1 => 'Thu';

  @override
  String get weekday2 => 'Fri';

  @override
  String get weekday3 => 'Sat';

  @override
  String get linkCopied => 'Link copied (demo)';

  @override
  String get tabSpeakers => 'Speakers';

  @override
  String get tabQa => 'Questions';

  @override
  String get remindBeforeStart => 'Remind me before it starts';

  @override
  String get inMyAgenda => 'In my agenda';

  @override
  String get addToMyAgenda => 'Add to my agenda';

  @override
  String get noSpeakersForSession => 'No speakers assigned to this session.';

  @override
  String get speakersUpper => 'SPEAKERS';

  @override
  String get guestSpeaker => 'Guest speaker';

  @override
  String get qaHint => 'Type your question...';

  @override
  String get you => 'You';

  @override
  String get myAgendaTitle => 'My Agenda';

  @override
  String get emptyAgendaTitle => 'Your agenda is empty';

  @override
  String get emptyAgendaBody =>
      'Star activities in the Agenda to see them here and turn on reminders.';

  @override
  String get seeAgenda => 'See agenda';

  @override
  String get favoritesStoredLocally =>
      'Your favourites are stored on this phone.';

  @override
  String get sync => 'Sync';

  @override
  String get overlapWarning => 'You have activities with overlapping times.';

  @override
  String get noOverlap => 'No schedule conflicts.';

  @override
  String dayUpper(int day) {
    return 'DAY $day';
  }

  @override
  String get spaceProgramTitle => 'National Space Programme';

  @override
  String get ggpenDescription =>
      'GGPEN coordinates Angola\'s National Space Programme, putting satellite technology at the service of connectivity, Earth observation and the country\'s digital transformation. At Angotic 2026 we show what we are building.';

  @override
  String get atAngotic => 'At Angotic 2026';

  @override
  String get ourAgenda => 'Our agenda';

  @override
  String get ourAgendaSubtitle => 'Talks, demos and networking';

  @override
  String get whereWeAre => 'Where we are';

  @override
  String get contacts => 'Contacts';

  @override
  String get contactSite => 'Website';

  @override
  String get contactEmail => 'Email';

  @override
  String get contactSocial => 'Social';

  @override
  String get presentAt => 'present at';

  @override
  String get standLabel => 'Stand A · Pavilion 2';

  @override
  String get standNearAuditorium => 'Next to Auditorium 1';

  @override
  String get howToGet => 'How to get there';

  @override
  String get howToGetBody =>
      'From the main entrance, follow the central corridor and take the 2nd right. The GGPEN stand is marked with the logo.';

  @override
  String get usefulPoints => 'Useful points';

  @override
  String get pointAuditorium => 'Auditorium 1';

  @override
  String get pointLounge => 'Lounge';

  @override
  String get pointCatering => 'Catering';

  @override
  String get pointParking => 'Parking';

  @override
  String get speakersTitle => 'Speakers';

  @override
  String speakersConfirmed(int count) {
    return '$count confirmed';
  }

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions',
      one: '1 session',
    );
    return '$_temp0';
  }

  @override
  String get participantsTitle => 'Participants';

  @override
  String participantsCount(int count) {
    return '$count participants';
  }

  @override
  String checkinsCount(int count) {
    return '$count check-ins';
  }

  @override
  String get searchParticipantsHint => 'Search by name, company or role';

  @override
  String get noParticipantsFound => 'No participant found.';

  @override
  String get checkInBadge => 'Check-in';

  @override
  String get toConfirm => 'To confirm';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get noNotifications => 'No notifications right now.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get guestCapitalized => 'Visitor';

  @override
  String get sessionActive => 'Signed in';

  @override
  String get browsingNoSession => 'Browsing without an account';

  @override
  String get favorites => 'Favourites';

  @override
  String get reminders => 'Reminders';

  @override
  String get logout => 'Sign out';

  @override
  String get loginDemo => 'Sign in (demo)';

  @override
  String get loginOptionalNote =>
      'Signing in is optional. Without an account, favourites are stored only on this phone.';

  @override
  String get yourName => 'Your name';

  @override
  String get nameHintEx => 'e.g. Maria Sousa';

  @override
  String get cancel => 'Cancel';

  @override
  String get enter => 'Enter';

  @override
  String get language => 'Language';

  @override
  String get adminTitle => 'Admin';

  @override
  String get adminOverview => 'Overview · updated in real time';

  @override
  String get metricParticipants => 'Participants';

  @override
  String get metricCheckins => 'Check-ins';

  @override
  String get metricActiveSessions => 'Active sessions';

  @override
  String get metricCompleted => 'Completed';

  @override
  String get chartParticipationByTime => 'Participation by time';

  @override
  String get chartTopSessions => 'Most subscribed sessions';

  @override
  String get manage => 'Manage →';

  @override
  String get participantsUpper => 'PARTICIPANTS';

  @override
  String get statusPresent => 'Present';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusCancelled => 'CANCELLED';

  @override
  String get statusLive => 'LIVE';

  @override
  String get typeApresentacao => 'Presentation';

  @override
  String get typeLancamento => 'Launch';

  @override
  String get typeAssinatura => 'Signing';

  @override
  String get typePlenaria => 'Plenary';

  @override
  String get typePainel => 'Panel';

  @override
  String get typeFormacao => 'Training';

  @override
  String get typeWorkshop => 'Workshop';

  @override
  String get happeningNow => 'Happening now';

  @override
  String get eventInProgress => 'The event is in progress';

  @override
  String get unitDays => 'days';

  @override
  String get unitHoursLong => 'hours';

  @override
  String get unitMinLong => 'min';

  @override
  String get unitSecLong => 'sec';

  @override
  String get unitHoursShort => 'h';

  @override
  String get unitMinShort => 'm';

  @override
  String get unitSecShort => 's';

  @override
  String get relativeNow => 'now';

  @override
  String relativeMinutes(int count) {
    return '$count min ago';
  }

  @override
  String relativeHours(int count) {
    return '$count h ago';
  }

  @override
  String relativeDays(int count) {
    return '$count d ago';
  }

  @override
  String get notifKindNotice => 'Notice';

  @override
  String get notifKindScheduleChange => 'Schedule change';

  @override
  String get notifKindCancellation => 'Cancellation';

  @override
  String get notifKindStarting => 'Starting';

  @override
  String get profileTooltip => 'Profile';

  @override
  String get eventSubtitle =>
      'Angola ICT Forum · On the road to digital transformation';

  @override
  String get retry => 'Retry';

  @override
  String get loadError => 'Couldn\'t load data.';

  @override
  String get signInWithGoogleBtn => 'Sign in with Google';

  @override
  String get qaSentPending => 'Question sent. Awaiting approval.';

  @override
  String get qaLoginRequired => 'Sign in with Google to take part.';

  @override
  String get noQuestionsYet => 'No approved questions yet.';

  @override
  String get moderator => 'Moderator';

  @override
  String get aboutSpeaker => 'About';

  @override
  String get noBio => 'No biography available.';

  @override
  String get photosTitle => 'Photos';

  @override
  String get locationSection => 'Location';

  @override
  String get descriptionTitle => 'About this session';

  @override
  String get notifWelcomeTitle => 'Welcome to Angotic 2026';

  @override
  String get notifWelcomeBody =>
      'Explore the agenda and save the sessions you don\'t want to miss.';

  @override
  String notifStartingSoonTitle(String title) {
    return '$title starts soon';
  }

  @override
  String notifStartingSoonBody(String time, String location) {
    return 'Starts at $time · $location';
  }

  @override
  String get noPhotos => 'No photos yet.';

  @override
  String get reminderLeadTitle => 'Reminder lead time';

  @override
  String get reminderLeadHint => 'When to alert you before a session starts';

  @override
  String get leadAtStart => 'At start';

  @override
  String leadMinutes(int count) {
    return '$count min';
  }

  @override
  String notifLiveTitle(String title) {
    return '$title is live';
  }

  @override
  String notifLiveBody(String location) {
    return 'Now · $location';
  }

  @override
  String get qaEdit => 'Edit';

  @override
  String get qaDelete => 'Delete';

  @override
  String get qaDeleteConfirm => 'Delete this question?';

  @override
  String get qaPending => 'Pending';

  @override
  String get qaEditTitle => 'Edit question';

  @override
  String get qaSave => 'Save';

  @override
  String get qaDeleted => 'Question deleted.';
}
