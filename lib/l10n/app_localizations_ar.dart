// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navAgenda => 'الأجندة';

  @override
  String get navSpeakers => 'المتحدثون';

  @override
  String get drawerMyAgenda => 'أجندتي';

  @override
  String get drawerNotifications => 'الإشعارات';

  @override
  String get drawerMap => 'الخريطة';

  @override
  String get drawerParticipants => 'المشاركون';

  @override
  String get drawerProfile => 'الملف الشخصي';

  @override
  String get drawerHeaderTitle => 'الأجندة في أنغوتيك 2026';

  @override
  String get drawerPoweredBy => 'مقدَّم من GGPEN';

  @override
  String get splashTagline => 'الأجندة في أنغوتيك 2026';

  @override
  String get greetingMorning => 'صباح الخير';

  @override
  String get greetingAfternoon => 'مساء الخير';

  @override
  String get greetingEvening => 'مساء الخير';

  @override
  String greetingLine(String greeting, String name) {
    return '$greeting، $name';
  }

  @override
  String get guest => 'زائر';

  @override
  String get liveNow => 'يجري الآن';

  @override
  String get noLiveSession => 'لا توجد جلسة جارية في الوقت الحالي.';

  @override
  String get nextSessionStartsIn => 'تبدأ الجلسة التالية خلال';

  @override
  String get noMoreSessionsToday => 'لا مزيد من الجلسات اليوم';

  @override
  String get quickAccess => 'وصول سريع';

  @override
  String get shortcutAgenda => 'الأجندة';

  @override
  String get shortcutSaved => 'المحفوظة';

  @override
  String get shortcutMap => 'الخريطة';

  @override
  String get todaySchedule => 'جدول اليوم';

  @override
  String get seeAll => 'عرض الكل ←';

  @override
  String get agendaTitle => 'الأجندة';

  @override
  String get searchTooltip => 'بحث';

  @override
  String get searchHint => 'ابحث عن نشاط أو مكان أو متحدث';

  @override
  String get searchPrompt => 'اكتب للبحث…';

  @override
  String get noResults => 'لا توجد نتائج.';

  @override
  String searchResultSubtitle(int day, String time, String location) {
    return 'اليوم $day · $time · $location';
  }

  @override
  String get weekday1 => 'خميس';

  @override
  String get weekday2 => 'جمعة';

  @override
  String get weekday3 => 'سبت';

  @override
  String get linkCopied => 'تم نسخ الرابط (تجريبي)';

  @override
  String get tabSpeakers => 'المتحدثون';

  @override
  String get tabQa => 'الأسئلة';

  @override
  String get remindBeforeStart => 'ذكّرني قبل البدء';

  @override
  String get inMyAgenda => 'في أجندتي';

  @override
  String get addToMyAgenda => 'أضف إلى أجندتي';

  @override
  String get noSpeakersForSession => 'لا يوجد متحدثون مرتبطون بهذه الجلسة.';

  @override
  String get speakersUpper => 'المتحدثون';

  @override
  String get guestSpeaker => 'متحدث ضيف';

  @override
  String get qaHint => 'اكتب سؤالك...';

  @override
  String get you => 'أنت';

  @override
  String get myAgendaTitle => 'أجندتي';

  @override
  String get emptyAgendaTitle => 'أجندتك فارغة';

  @override
  String get emptyAgendaBody =>
      'ضع نجمة على الأنشطة في الأجندة لتراها هنا وتُفعّل التذكيرات.';

  @override
  String get seeAgenda => 'عرض الأجندة';

  @override
  String get favoritesStoredLocally => 'مفضّلاتك محفوظة على هذا الهاتف.';

  @override
  String get sync => 'مزامنة';

  @override
  String get overlapWarning => 'لديك أنشطة بأوقات متداخلة.';

  @override
  String get noOverlap => 'لا توجد تعارضات في المواعيد.';

  @override
  String dayUpper(int day) {
    return 'اليوم $day';
  }

  @override
  String get spaceProgramTitle => 'البرنامج الفضائي الوطني';

  @override
  String get ggpenDescription =>
      'تنسّق GGPEN البرنامج الفضائي الوطني لأنغولا، واضعةً تقنية الأقمار الصناعية في خدمة الاتصال ورصد الأرض والتحول الرقمي للبلاد. في أنغوتيك 2026 نعرض ما نبنيه.';

  @override
  String get atAngotic => 'في أنغوتيك 2026';

  @override
  String get ourAgenda => 'أجندتنا';

  @override
  String get ourAgendaSubtitle => 'محاضرات وعروض وتواصل';

  @override
  String get whereWeAre => 'أين نحن';

  @override
  String get contacts => 'جهات الاتصال';

  @override
  String get contactSite => 'الموقع';

  @override
  String get contactEmail => 'البريد';

  @override
  String get contactSocial => 'الشبكات';

  @override
  String get presentAt => 'حاضرون في';

  @override
  String get standLabel => 'الجناح A · القاعة 2';

  @override
  String get standNearAuditorium => 'بجوار القاعة 1';

  @override
  String get howToGet => 'كيفية الوصول';

  @override
  String get howToGetBody =>
      'من المدخل الرئيسي، اتبع الممر المركزي وانعطف في الثاني إلى اليمين. جناح GGPEN مميّز بالشعار.';

  @override
  String get usefulPoints => 'نقاط مفيدة';

  @override
  String get pointAuditorium => 'القاعة 1';

  @override
  String get pointLounge => 'الاستراحة';

  @override
  String get pointCatering => 'المطاعم';

  @override
  String get pointParking => 'موقف السيارات';

  @override
  String get speakersTitle => 'المتحدثون';

  @override
  String speakersConfirmed(int count) {
    return '$count مؤكَّدون';
  }

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count جلسات',
      one: 'جلسة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get participantsTitle => 'المشاركون';

  @override
  String participantsCount(int count) {
    return '$count مشاركون';
  }

  @override
  String checkinsCount(int count) {
    return '$count تسجيلات حضور';
  }

  @override
  String get searchParticipantsHint => 'ابحث بالاسم أو الشركة أو الوظيفة';

  @override
  String get noParticipantsFound => 'لم يُعثر على أي مشارك.';

  @override
  String get checkInBadge => 'تسجيل حضور';

  @override
  String get toConfirm => 'بانتظار التأكيد';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get noNotifications => 'لا توجد إشعارات حالياً.';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get guestCapitalized => 'زائر';

  @override
  String get sessionActive => 'تم تسجيل الدخول';

  @override
  String get browsingNoSession => 'التصفح بدون حساب';

  @override
  String get favorites => 'المفضّلة';

  @override
  String get reminders => 'التذكيرات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get loginDemo => 'تسجيل الدخول (تجريبي)';

  @override
  String get loginOptionalNote =>
      'تسجيل الدخول اختياري. بدون حساب، تُحفظ المفضّلة على هذا الهاتف فقط.';

  @override
  String get yourName => 'اسمك';

  @override
  String get nameHintEx => 'مثال: ماريا سوزا';

  @override
  String get cancel => 'إلغاء';

  @override
  String get enter => 'دخول';

  @override
  String get language => 'اللغة';

  @override
  String get adminTitle => 'الإدارة';

  @override
  String get adminOverview => 'نظرة عامة · تُحدَّث في الوقت الفعلي';

  @override
  String get metricParticipants => 'المشاركون';

  @override
  String get metricCheckins => 'تسجيلات الحضور';

  @override
  String get metricActiveSessions => 'الجلسات النشطة';

  @override
  String get metricCompleted => 'المكتملة';

  @override
  String get chartParticipationByTime => 'المشاركة حسب التوقيت';

  @override
  String get chartTopSessions => 'الجلسات الأكثر تسجيلاً';

  @override
  String get manage => 'إدارة ←';

  @override
  String get participantsUpper => 'المشاركون';

  @override
  String get statusPresent => 'حاضر';

  @override
  String get statusPending => 'معلّق';

  @override
  String get statusCancelled => 'أُلغيت';

  @override
  String get statusLive => 'مباشر';

  @override
  String get typeApresentacao => 'عرض تقديمي';

  @override
  String get typeLancamento => 'إطلاق';

  @override
  String get typeAssinatura => 'توقيع';

  @override
  String get typePlenaria => 'جلسة عامة';

  @override
  String get typePainel => 'حلقة نقاش';

  @override
  String get typeFormacao => 'تدريب';

  @override
  String get typeWorkshop => 'ورشة عمل';

  @override
  String get happeningNow => 'يجري الآن';

  @override
  String get eventInProgress => 'الفعالية جارية الآن';

  @override
  String get unitDays => 'أيام';

  @override
  String get unitHoursLong => 'ساعات';

  @override
  String get unitMinLong => 'دقيقة';

  @override
  String get unitSecLong => 'ثانية';

  @override
  String get unitHoursShort => 'س';

  @override
  String get unitMinShort => 'د';

  @override
  String get unitSecShort => 'ث';

  @override
  String get relativeNow => 'الآن';

  @override
  String relativeMinutes(int count) {
    return 'قبل $count دقيقة';
  }

  @override
  String relativeHours(int count) {
    return 'قبل $count ساعة';
  }

  @override
  String relativeDays(int count) {
    return 'قبل $count يوم';
  }

  @override
  String get notifKindNotice => 'تنبيه';

  @override
  String get notifKindScheduleChange => 'تغيير الموعد';

  @override
  String get notifKindCancellation => 'إلغاء';

  @override
  String get notifKindStarting => 'على وشك البدء';

  @override
  String get profileTooltip => 'الملف الشخصي';

  @override
  String get eventSubtitle =>
      'منتدى أنغولا لتكنولوجيا المعلومات · على طريق التحول الرقمي';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get loadError => 'تعذّر تحميل البيانات.';

  @override
  String get signInWithGoogleBtn => 'الدخول عبر Google';

  @override
  String get qaSentPending => 'تم إرسال السؤال. في انتظار الموافقة.';

  @override
  String get qaLoginRequired => 'سجّل الدخول عبر Google للمشاركة.';

  @override
  String get noQuestionsYet => 'لا توجد أسئلة معتمدة بعد.';

  @override
  String get moderator => 'مشرف';

  @override
  String get aboutSpeaker => 'نبذة';

  @override
  String get noBio => 'لا تتوفر سيرة ذاتية.';

  @override
  String get photosTitle => 'الصور';

  @override
  String get locationSection => 'الموقع';

  @override
  String get descriptionTitle => 'عن هذه الجلسة';

  @override
  String get notifWelcomeTitle => 'مرحباً بك في أنغوتيك 2026';

  @override
  String get notifWelcomeBody =>
      'استكشف الأجندة واحفظ الجلسات التي لا تريد تفويتها.';

  @override
  String notifStartingSoonTitle(String title) {
    return '$title تبدأ قريباً';
  }

  @override
  String notifStartingSoonBody(String time, String location) {
    return 'تبدأ في $time · $location';
  }

  @override
  String get noPhotos => 'لا توجد صور بعد.';

  @override
  String get reminderLeadTitle => 'مهلة التذكير';

  @override
  String get reminderLeadHint => 'متى ننبّهك قبل بدء الجلسة';

  @override
  String get leadAtStart => 'عند البداية';

  @override
  String leadMinutes(int count) {
    return '$count دقيقة';
  }

  @override
  String notifLiveTitle(String title) {
    return '$title جارية الآن';
  }

  @override
  String notifLiveBody(String location) {
    return 'الآن · $location';
  }

  @override
  String get qaEdit => 'تعديل';

  @override
  String get qaDelete => 'حذف';

  @override
  String get qaDeleteConfirm => 'حذف هذا السؤال؟';

  @override
  String get qaPending => 'قيد المراجعة';

  @override
  String get qaEditTitle => 'تعديل السؤال';

  @override
  String get qaSave => 'حفظ';

  @override
  String get qaDeleted => 'تم حذف السؤال.';
}
