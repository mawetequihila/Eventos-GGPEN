import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
    Locale('pt')
  ];

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navAgenda.
  ///
  /// In en, this message translates to:
  /// **'Agenda'**
  String get navAgenda;

  /// No description provided for @navSpeakers.
  ///
  /// In en, this message translates to:
  /// **'Speakers'**
  String get navSpeakers;

  /// No description provided for @drawerMyAgenda.
  ///
  /// In en, this message translates to:
  /// **'My Agenda'**
  String get drawerMyAgenda;

  /// No description provided for @drawerNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get drawerNotifications;

  /// No description provided for @drawerMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get drawerMap;

  /// No description provided for @drawerParticipants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get drawerParticipants;

  /// No description provided for @drawerProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get drawerProfile;

  /// No description provided for @drawerHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Agenda at Angotic 2026'**
  String get drawerHeaderTitle;

  /// No description provided for @drawerPoweredBy.
  ///
  /// In en, this message translates to:
  /// **'presented by GGPEN'**
  String get drawerPoweredBy;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Agenda at Angotic 2026'**
  String get splashTagline;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @greetingLine.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {name}'**
  String greetingLine(String greeting, String name);

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'visitor'**
  String get guest;

  /// No description provided for @liveNow.
  ///
  /// In en, this message translates to:
  /// **'Happening now'**
  String get liveNow;

  /// No description provided for @noLiveSession.
  ///
  /// In en, this message translates to:
  /// **'No session is running right now.'**
  String get noLiveSession;

  /// No description provided for @nextSessionStartsIn.
  ///
  /// In en, this message translates to:
  /// **'NEXT SESSION STARTS IN'**
  String get nextSessionStartsIn;

  /// No description provided for @noMoreSessionsToday.
  ///
  /// In en, this message translates to:
  /// **'No more sessions today'**
  String get noMoreSessionsToday;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick access'**
  String get quickAccess;

  /// No description provided for @shortcutAgenda.
  ///
  /// In en, this message translates to:
  /// **'Agenda'**
  String get shortcutAgenda;

  /// No description provided for @shortcutSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get shortcutSaved;

  /// No description provided for @shortcutMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get shortcutMap;

  /// No description provided for @todaySchedule.
  ///
  /// In en, this message translates to:
  /// **'Today\'s schedule'**
  String get todaySchedule;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all →'**
  String get seeAll;

  /// No description provided for @agendaTitle.
  ///
  /// In en, this message translates to:
  /// **'Agenda'**
  String get agendaTitle;

  /// No description provided for @searchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTooltip;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search activity, location or speaker'**
  String get searchHint;

  /// No description provided for @searchPrompt.
  ///
  /// In en, this message translates to:
  /// **'Type to search…'**
  String get searchPrompt;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results.'**
  String get noResults;

  /// No description provided for @searchResultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Day {day} · {time} · {location}'**
  String searchResultSubtitle(int day, String time, String location);

  /// No description provided for @weekday1.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekday1;

  /// No description provided for @weekday2.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekday2;

  /// No description provided for @weekday3.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekday3;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied (demo)'**
  String get linkCopied;

  /// No description provided for @tabSpeakers.
  ///
  /// In en, this message translates to:
  /// **'Speakers'**
  String get tabSpeakers;

  /// No description provided for @tabQa.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get tabQa;

  /// No description provided for @remindBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'Remind me before it starts'**
  String get remindBeforeStart;

  /// No description provided for @inMyAgenda.
  ///
  /// In en, this message translates to:
  /// **'In my agenda'**
  String get inMyAgenda;

  /// No description provided for @addToMyAgenda.
  ///
  /// In en, this message translates to:
  /// **'Add to my agenda'**
  String get addToMyAgenda;

  /// No description provided for @noSpeakersForSession.
  ///
  /// In en, this message translates to:
  /// **'No speakers assigned to this session.'**
  String get noSpeakersForSession;

  /// No description provided for @speakersUpper.
  ///
  /// In en, this message translates to:
  /// **'SPEAKERS'**
  String get speakersUpper;

  /// No description provided for @guestSpeaker.
  ///
  /// In en, this message translates to:
  /// **'Guest speaker'**
  String get guestSpeaker;

  /// No description provided for @qaHint.
  ///
  /// In en, this message translates to:
  /// **'Type your question...'**
  String get qaHint;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @myAgendaTitle.
  ///
  /// In en, this message translates to:
  /// **'My Agenda'**
  String get myAgendaTitle;

  /// No description provided for @emptyAgendaTitle.
  ///
  /// In en, this message translates to:
  /// **'Your agenda is empty'**
  String get emptyAgendaTitle;

  /// No description provided for @emptyAgendaBody.
  ///
  /// In en, this message translates to:
  /// **'Star activities in the Agenda to see them here and turn on reminders.'**
  String get emptyAgendaBody;

  /// No description provided for @seeAgenda.
  ///
  /// In en, this message translates to:
  /// **'See agenda'**
  String get seeAgenda;

  /// No description provided for @favoritesStoredLocally.
  ///
  /// In en, this message translates to:
  /// **'Your favourites are stored on this phone.'**
  String get favoritesStoredLocally;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// No description provided for @overlapWarning.
  ///
  /// In en, this message translates to:
  /// **'You have activities with overlapping times.'**
  String get overlapWarning;

  /// No description provided for @noOverlap.
  ///
  /// In en, this message translates to:
  /// **'No schedule conflicts.'**
  String get noOverlap;

  /// No description provided for @dayUpper.
  ///
  /// In en, this message translates to:
  /// **'DAY {day}'**
  String dayUpper(int day);

  /// No description provided for @spaceProgramTitle.
  ///
  /// In en, this message translates to:
  /// **'National Space Programme'**
  String get spaceProgramTitle;

  /// No description provided for @ggpenDescription.
  ///
  /// In en, this message translates to:
  /// **'GGPEN coordinates Angola\'s National Space Programme, putting satellite technology at the service of connectivity, Earth observation and the country\'s digital transformation. At Angotic 2026 we show what we are building.'**
  String get ggpenDescription;

  /// No description provided for @atAngotic.
  ///
  /// In en, this message translates to:
  /// **'At Angotic 2026'**
  String get atAngotic;

  /// No description provided for @ourAgenda.
  ///
  /// In en, this message translates to:
  /// **'Our agenda'**
  String get ourAgenda;

  /// No description provided for @ourAgendaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Talks, demos and networking'**
  String get ourAgendaSubtitle;

  /// No description provided for @whereWeAre.
  ///
  /// In en, this message translates to:
  /// **'Where we are'**
  String get whereWeAre;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @contactSite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get contactSite;

  /// No description provided for @contactEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactEmail;

  /// No description provided for @contactSocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get contactSocial;

  /// No description provided for @presentAt.
  ///
  /// In en, this message translates to:
  /// **'present at'**
  String get presentAt;

  /// No description provided for @standLabel.
  ///
  /// In en, this message translates to:
  /// **'Stand A · Pavilion 2'**
  String get standLabel;

  /// No description provided for @standNearAuditorium.
  ///
  /// In en, this message translates to:
  /// **'Next to Auditorium 1'**
  String get standNearAuditorium;

  /// No description provided for @howToGet.
  ///
  /// In en, this message translates to:
  /// **'How to get there'**
  String get howToGet;

  /// No description provided for @howToGetBody.
  ///
  /// In en, this message translates to:
  /// **'From the main entrance, follow the central corridor and take the 2nd right. The GGPEN stand is marked with the logo.'**
  String get howToGetBody;

  /// No description provided for @usefulPoints.
  ///
  /// In en, this message translates to:
  /// **'Useful points'**
  String get usefulPoints;

  /// No description provided for @pointAuditorium.
  ///
  /// In en, this message translates to:
  /// **'Auditorium 1'**
  String get pointAuditorium;

  /// No description provided for @pointLounge.
  ///
  /// In en, this message translates to:
  /// **'Lounge'**
  String get pointLounge;

  /// No description provided for @pointCatering.
  ///
  /// In en, this message translates to:
  /// **'Catering'**
  String get pointCatering;

  /// No description provided for @pointParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get pointParking;

  /// No description provided for @speakersTitle.
  ///
  /// In en, this message translates to:
  /// **'Speakers'**
  String get speakersTitle;

  /// No description provided for @speakersConfirmed.
  ///
  /// In en, this message translates to:
  /// **'{count} confirmed'**
  String speakersConfirmed(int count);

  /// No description provided for @sessionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 session} other{{count} sessions}}'**
  String sessionsCount(int count);

  /// No description provided for @participantsTitle.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participantsTitle;

  /// No description provided for @participantsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} participants'**
  String participantsCount(int count);

  /// No description provided for @checkinsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} check-ins'**
  String checkinsCount(int count);

  /// No description provided for @searchParticipantsHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, company or role'**
  String get searchParticipantsHint;

  /// No description provided for @noParticipantsFound.
  ///
  /// In en, this message translates to:
  /// **'No participant found.'**
  String get noParticipantsFound;

  /// No description provided for @checkInBadge.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkInBadge;

  /// No description provided for @toConfirm.
  ///
  /// In en, this message translates to:
  /// **'To confirm'**
  String get toConfirm;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications right now.'**
  String get noNotifications;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @guestCapitalized.
  ///
  /// In en, this message translates to:
  /// **'Visitor'**
  String get guestCapitalized;

  /// No description provided for @sessionActive.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get sessionActive;

  /// No description provided for @browsingNoSession.
  ///
  /// In en, this message translates to:
  /// **'Browsing without an account'**
  String get browsingNoSession;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favorites;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logout;

  /// No description provided for @loginDemo.
  ///
  /// In en, this message translates to:
  /// **'Sign in (demo)'**
  String get loginDemo;

  /// No description provided for @loginOptionalNote.
  ///
  /// In en, this message translates to:
  /// **'Signing in is optional. Without an account, favourites are stored only on this phone.'**
  String get loginOptionalNote;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @nameHintEx.
  ///
  /// In en, this message translates to:
  /// **'e.g. Maria Sousa'**
  String get nameHintEx;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @adminTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminTitle;

  /// No description provided for @adminOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview · updated in real time'**
  String get adminOverview;

  /// No description provided for @metricParticipants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get metricParticipants;

  /// No description provided for @metricCheckins.
  ///
  /// In en, this message translates to:
  /// **'Check-ins'**
  String get metricCheckins;

  /// No description provided for @metricActiveSessions.
  ///
  /// In en, this message translates to:
  /// **'Active sessions'**
  String get metricActiveSessions;

  /// No description provided for @metricCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get metricCompleted;

  /// No description provided for @chartParticipationByTime.
  ///
  /// In en, this message translates to:
  /// **'Participation by time'**
  String get chartParticipationByTime;

  /// No description provided for @chartTopSessions.
  ///
  /// In en, this message translates to:
  /// **'Most subscribed sessions'**
  String get chartTopSessions;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage →'**
  String get manage;

  /// No description provided for @participantsUpper.
  ///
  /// In en, this message translates to:
  /// **'PARTICIPANTS'**
  String get participantsUpper;

  /// No description provided for @statusPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get statusPresent;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'CANCELLED'**
  String get statusCancelled;

  /// No description provided for @statusLive.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get statusLive;

  /// No description provided for @typeApresentacao.
  ///
  /// In en, this message translates to:
  /// **'Presentation'**
  String get typeApresentacao;

  /// No description provided for @typeLancamento.
  ///
  /// In en, this message translates to:
  /// **'Launch'**
  String get typeLancamento;

  /// No description provided for @typeAssinatura.
  ///
  /// In en, this message translates to:
  /// **'Signing'**
  String get typeAssinatura;

  /// No description provided for @typePlenaria.
  ///
  /// In en, this message translates to:
  /// **'Plenary'**
  String get typePlenaria;

  /// No description provided for @typePainel.
  ///
  /// In en, this message translates to:
  /// **'Panel'**
  String get typePainel;

  /// No description provided for @typeFormacao.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get typeFormacao;

  /// No description provided for @typeWorkshop.
  ///
  /// In en, this message translates to:
  /// **'Workshop'**
  String get typeWorkshop;

  /// No description provided for @happeningNow.
  ///
  /// In en, this message translates to:
  /// **'Happening now'**
  String get happeningNow;

  /// No description provided for @eventInProgress.
  ///
  /// In en, this message translates to:
  /// **'The event is in progress'**
  String get eventInProgress;

  /// No description provided for @unitDays.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get unitDays;

  /// No description provided for @unitHoursLong.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get unitHoursLong;

  /// No description provided for @unitMinLong.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get unitMinLong;

  /// No description provided for @unitSecLong.
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get unitSecLong;

  /// No description provided for @unitHoursShort.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get unitHoursShort;

  /// No description provided for @unitMinShort.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get unitMinShort;

  /// No description provided for @unitSecShort.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get unitSecShort;

  /// No description provided for @relativeNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get relativeNow;

  /// No description provided for @relativeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String relativeMinutes(int count);

  /// No description provided for @relativeHours.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String relativeHours(int count);

  /// No description provided for @relativeDays.
  ///
  /// In en, this message translates to:
  /// **'{count} d ago'**
  String relativeDays(int count);

  /// No description provided for @notifKindNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get notifKindNotice;

  /// No description provided for @notifKindScheduleChange.
  ///
  /// In en, this message translates to:
  /// **'Schedule change'**
  String get notifKindScheduleChange;

  /// No description provided for @notifKindCancellation.
  ///
  /// In en, this message translates to:
  /// **'Cancellation'**
  String get notifKindCancellation;

  /// No description provided for @notifKindStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting'**
  String get notifKindStarting;

  /// No description provided for @profileTooltip.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTooltip;

  /// No description provided for @eventSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Angola ICT Forum · On the road to digital transformation'**
  String get eventSubtitle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load data.'**
  String get loadError;

  /// No description provided for @signInWithGoogleBtn.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogleBtn;

  /// No description provided for @qaSentPending.
  ///
  /// In en, this message translates to:
  /// **'Question sent. Awaiting approval.'**
  String get qaSentPending;

  /// No description provided for @qaLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google to take part.'**
  String get qaLoginRequired;

  /// No description provided for @noQuestionsYet.
  ///
  /// In en, this message translates to:
  /// **'No approved questions yet.'**
  String get noQuestionsYet;

  /// No description provided for @moderator.
  ///
  /// In en, this message translates to:
  /// **'Moderator'**
  String get moderator;

  /// No description provided for @aboutSpeaker.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSpeaker;

  /// No description provided for @noBio.
  ///
  /// In en, this message translates to:
  /// **'No biography available.'**
  String get noBio;

  /// No description provided for @photosTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photosTitle;

  /// No description provided for @locationSection.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationSection;

  /// No description provided for @descriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'About this session'**
  String get descriptionTitle;

  /// No description provided for @notifWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Angotic 2026'**
  String get notifWelcomeTitle;

  /// No description provided for @notifWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Explore the agenda and save the sessions you don\'t want to miss.'**
  String get notifWelcomeBody;

  /// No description provided for @notifStartingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'{title} starts soon'**
  String notifStartingSoonTitle(String title);

  /// No description provided for @notifStartingSoonBody.
  ///
  /// In en, this message translates to:
  /// **'Starts at {time} · {location}'**
  String notifStartingSoonBody(String time, String location);

  /// No description provided for @noPhotos.
  ///
  /// In en, this message translates to:
  /// **'No photos yet.'**
  String get noPhotos;

  /// No description provided for @reminderLeadTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder lead time'**
  String get reminderLeadTitle;

  /// No description provided for @reminderLeadHint.
  ///
  /// In en, this message translates to:
  /// **'When to alert you before a session starts'**
  String get reminderLeadHint;

  /// No description provided for @leadAtStart.
  ///
  /// In en, this message translates to:
  /// **'At start'**
  String get leadAtStart;

  /// No description provided for @leadMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String leadMinutes(int count);

  /// No description provided for @notifLiveTitle.
  ///
  /// In en, this message translates to:
  /// **'{title} is live'**
  String notifLiveTitle(String title);

  /// No description provided for @notifLiveBody.
  ///
  /// In en, this message translates to:
  /// **'Now · {location}'**
  String notifLiveBody(String location);

  /// No description provided for @qaEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get qaEdit;

  /// No description provided for @qaDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get qaDelete;

  /// No description provided for @qaDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this question?'**
  String get qaDeleteConfirm;

  /// No description provided for @qaPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get qaPending;

  /// No description provided for @qaEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit question'**
  String get qaEditTitle;

  /// No description provided for @qaSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get qaSave;

  /// No description provided for @qaDeleted.
  ///
  /// In en, this message translates to:
  /// **'Question deleted.'**
  String get qaDeleted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
