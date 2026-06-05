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
  String get navSpeakers => 'Guests';

  @override
  String get navGgpen => 'GGPEN';

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
  String get shortcutNotifications => 'Alerts';

  @override
  String get shortcutBadge => 'Badge';

  @override
  String get homeSignInCta => 'Sign in';

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
  String get tabSpeakers => 'Participants';

  @override
  String get roleModerators => 'Moderators';

  @override
  String get roleSpeakers => 'Speakers';

  @override
  String get roleGuests => 'Guests';

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
      'The National Space Programme Management Office (GGPEN) coordinates Angola\'s space programme, putting satellite technology at the service of connectivity, Earth observation and the country\'s digital transformation. At Angotic 2026 we show what we are building.';

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
  String get speakersTitle => 'Guests';

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
  String notifTimeChangedTitle(String title) {
    return 'Time changed: $title';
  }

  @override
  String notifTimeChangedBody(String time, String location) {
    return 'Now at $time · $location';
  }

  @override
  String notifSessionUpdatedTitle(String title) {
    return 'Session updated: $title';
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

  @override
  String get speakerSessions => 'Sessions';

  @override
  String get authWelcomeTitle => 'Welcome to GGPEN';

  @override
  String get authWelcomeSubtitle => 'Follow our participation at Angotic 2026.';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authCreateAccount => 'Sign up';

  @override
  String get authOr => 'or';

  @override
  String get signupTitle => 'Sign up';

  @override
  String get signupHelper =>
      'Fill in your details to receive reminders and updates.';

  @override
  String get signupNameLabel => 'Full name';

  @override
  String get signupEmailLabel => 'Email';

  @override
  String get signupPhoneLabel => 'Phone';

  @override
  String get signupCompanyLabel => 'Company / Institution';

  @override
  String get signupRoleLabel => 'Role';

  @override
  String get signupTermsPrefix => 'I accept the ';

  @override
  String get signupTermsLink => 'Terms of Use';

  @override
  String get signupTermsAnd => ' and the ';

  @override
  String get signupPrivacyLink => 'Privacy Policy';

  @override
  String get signupTermsSuffix => '.';

  @override
  String get signupSubmit => 'Create account';

  @override
  String get signupHaveAccount => 'Already have an account?';

  @override
  String get signupSignInLink => 'Sign in';

  @override
  String get signupValidationRequired => 'Required field';

  @override
  String get signupValidationEmail => 'Invalid email';

  @override
  String get signupMustAcceptTerms => 'You must accept the terms to continue.';

  @override
  String get termsDialogTitle => 'Terms of Use';

  @override
  String get termsBody =>
      'By using the GGPEN · Angotic 2026 app you accept these Terms of Use. The App is the official guide to GGPEN events.\n\nYour account: provide accurate information and keep your access secure. You are responsible for activity on your account.\n\nParticipation and questions: you are responsible for the content you post. Offensive, illegal, defamatory, misleading or spam content is prohibited. Questions are moderated and GGPEN may reject or remove them. By submitting, you authorise GGPEN to display your content in the context of the event.\n\nBrand and content: the GGPEN/Angotic brand, logos and materials are property of GGPEN and may not be used without authorisation.\n\nService: provided as is and may be changed or interrupted. GGPEN is not liable for unavailability or for content submitted by users.\n\nData: the processing of your data is governed by the Privacy Policy.\n\nGoverning law: the laws of the Republic of Angola.\n\nChanges: we may update these Terms; continued use implies acceptance.\n\nContact: geral@ggpen.gov.ao';

  @override
  String get privacyDialogTitle => 'Privacy Policy';

  @override
  String get privacyBody =>
      'The National Space Programme Management Office (GGPEN) is the controller of your data in this app.\n\nData collected: when you sign in with Google, your name, email and avatar; the details you provide (phone, company, role); and the questions and likes you submit. Favourites, reminders and language stay only on your device. We do not collect location.\n\nPurposes: to authenticate your session, show the agenda and manage your participation, send reminders and Angotic 2026 information, and communications from GGPEN and partners.\n\nSharing: we use Supabase to host the data on behalf of GGPEN, and Google only for sign-in. We do not sell your data.\n\nSecurity: encrypted connections and per-user access; questions only become public after approval.\n\nYour rights: you can access, correct and delete your data, and request account deletion, via geral@ggpen.gov.ao.\n\nGGPEN — Complexo Administrativo Clássicos de Talatona, Rua do MAT, Edifício n.º 3, 6.º andar, Belas — Luanda, Angola. Tel.: +244 222 777 312.';

  @override
  String get termsDialogClose => 'Close';

  @override
  String get profileFieldPhone => 'Phone';

  @override
  String get profileFieldCompany => 'Company';

  @override
  String get profileFieldRole => 'Role';

  @override
  String get completeProfileTitle => 'Complete your profile';

  @override
  String get completeProfileSubtitle =>
      'Just a few more details — phone, company and role.';

  @override
  String get profileSaveLater => 'Finish later';

  @override
  String get welcomeBackTitle => 'WELCOME BACK';

  @override
  String welcomeBackHello(String name) {
    return 'Hello, $name!';
  }

  @override
  String get welcomeBackContinue => 'Continue';

  @override
  String get welcomeBackSwitch => 'Not you? Use another account';

  @override
  String get welcomeBackSwitchTitle => 'Use another account?';

  @override
  String get welcomeBackSwitchBody =>
      'This will delete the data saved on this phone. You\'ll need to sign up again.';

  @override
  String get welcomeBackSwitchConfirm => 'Delete and continue';

  @override
  String get profileSectionPersonal => 'Personal info';

  @override
  String get profileSectionPreferences => 'Preferences';

  @override
  String get profileSectionLegal => 'Legal';

  @override
  String get profileFieldEmail => 'Email';

  @override
  String get loginPrivacyFooter => 'Your data stays on this device.';
}
