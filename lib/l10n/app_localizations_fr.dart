// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get navHome => 'Accueil';

  @override
  String get navAgenda => 'Programme';

  @override
  String get navSpeakers => 'Invités';

  @override
  String get navGgpen => 'GGPEN';

  @override
  String get drawerMyAgenda => 'Mon programme';

  @override
  String get drawerNotifications => 'Notifications';

  @override
  String get drawerMap => 'Carte';

  @override
  String get drawerParticipants => 'Participants';

  @override
  String get drawerProfile => 'Profil';

  @override
  String get drawerHeaderTitle => 'Programme à Angotic 2026';

  @override
  String get drawerPoweredBy => 'présenté par GGPEN';

  @override
  String get splashTagline => 'Programme à Angotic 2026';

  @override
  String get greetingMorning => 'Bonjour';

  @override
  String get greetingAfternoon => 'Bon après-midi';

  @override
  String get greetingEvening => 'Bonsoir';

  @override
  String greetingLine(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get guest => 'visiteur';

  @override
  String get liveNow => 'En cours maintenant';

  @override
  String get noLiveSession => 'Aucune session en cours pour le moment.';

  @override
  String get nextSessionStartsIn => 'LA PROCHAINE SESSION COMMENCE DANS';

  @override
  String get noMoreSessionsToday => 'Plus de sessions aujourd\'hui';

  @override
  String get quickAccess => 'Accès rapide';

  @override
  String get shortcutAgenda => 'Programme';

  @override
  String get shortcutSaved => 'Enregistrées';

  @override
  String get shortcutMap => 'Carte';

  @override
  String get shortcutNotifications => 'Alertes';

  @override
  String get shortcutBadge => 'Badge';

  @override
  String get homeSignInCta => 'Se connecter';

  @override
  String get todaySchedule => 'Programme du jour';

  @override
  String get seeAll => 'Tout voir →';

  @override
  String get agendaTitle => 'Programme';

  @override
  String get searchTooltip => 'Rechercher';

  @override
  String get searchHint => 'Rechercher une activité, un lieu ou un intervenant';

  @override
  String get searchPrompt => 'Tapez pour rechercher…';

  @override
  String get noResults => 'Aucun résultat.';

  @override
  String searchResultSubtitle(int day, String time, String location) {
    return 'Jour $day · $time · $location';
  }

  @override
  String get weekday1 => 'Jeu';

  @override
  String get weekday2 => 'Ven';

  @override
  String get weekday3 => 'Sam';

  @override
  String get linkCopied => 'Lien copié (démo)';

  @override
  String get tabSpeakers => 'Intervenants';

  @override
  String get roleModerators => 'Modérateurs';

  @override
  String get roleSpeakers => 'Orateurs';

  @override
  String get roleGuests => 'Invités';

  @override
  String get tabQa => 'Questions';

  @override
  String get remindBeforeStart => 'Me rappeler avant le début';

  @override
  String get inMyAgenda => 'Dans mon programme';

  @override
  String get addToMyAgenda => 'Ajouter à mon programme';

  @override
  String get noSpeakersForSession =>
      'Aucun intervenant associé à cette session.';

  @override
  String get speakersUpper => 'INTERVENANTS';

  @override
  String get guestSpeaker => 'Intervenant invité';

  @override
  String get qaHint => 'Écrivez votre question...';

  @override
  String get you => 'Vous';

  @override
  String get myAgendaTitle => 'Mon programme';

  @override
  String get emptyAgendaTitle => 'Votre programme est vide';

  @override
  String get emptyAgendaBody =>
      'Marquez des activités d\'une étoile dans le Programme pour les retrouver ici et activer des rappels.';

  @override
  String get seeAgenda => 'Voir le programme';

  @override
  String get favoritesStoredLocally =>
      'Vos favoris sont enregistrés sur ce téléphone.';

  @override
  String get sync => 'Synchroniser';

  @override
  String get overlapWarning =>
      'Vous avez des activités aux horaires qui se chevauchent.';

  @override
  String get noOverlap => 'Aucun conflit d\'horaire.';

  @override
  String dayUpper(int day) {
    return 'JOUR $day';
  }

  @override
  String get spaceProgramTitle => 'Programme Spatial National';

  @override
  String get ggpenDescription =>
      'Le Bureau de Gestion du Programme Spatial National (GGPEN) coordonne le programme spatial de l\'Angola, mettant la technologie satellitaire au service de la connectivité, de l\'observation de la Terre et de la transformation numérique du pays. À Angotic 2026, nous montrons ce que nous construisons.';

  @override
  String get atAngotic => 'À Angotic 2026';

  @override
  String get ourAgenda => 'Notre programme';

  @override
  String get ourAgendaSubtitle => 'Conférences, démos et networking';

  @override
  String get whereWeAre => 'Où nous sommes';

  @override
  String get contacts => 'Contacts';

  @override
  String get contactSite => 'Site web';

  @override
  String get contactEmail => 'E-mail';

  @override
  String get contactSocial => 'Réseaux';

  @override
  String get presentAt => 'présent à';

  @override
  String get standLabel => 'Stand A · Pavillon 2';

  @override
  String get standNearAuditorium => 'À côté de l\'Auditorium 1';

  @override
  String get howToGet => 'Comment s\'y rendre';

  @override
  String get howToGetBody =>
      'Depuis l\'entrée principale, suivez le couloir central et prenez la 2e à droite. Le stand GGPEN est signalé par le logo.';

  @override
  String get usefulPoints => 'Points utiles';

  @override
  String get pointAuditorium => 'Auditorium 1';

  @override
  String get pointLounge => 'Lounge';

  @override
  String get pointCatering => 'Restauration';

  @override
  String get pointParking => 'Parking';

  @override
  String get speakersTitle => 'Invités';

  @override
  String speakersConfirmed(int count) {
    return '$count confirmés';
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
  String get searchParticipantsHint =>
      'Rechercher par nom, entreprise ou fonction';

  @override
  String get noParticipantsFound => 'Aucun participant trouvé.';

  @override
  String get checkInBadge => 'Check-in';

  @override
  String get toConfirm => 'À confirmer';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get noNotifications => 'Aucune notification pour le moment.';

  @override
  String get profileTitle => 'Profil';

  @override
  String get guestCapitalized => 'Visiteur';

  @override
  String get sessionActive => 'Connecté';

  @override
  String get browsingNoSession => 'Navigation sans compte';

  @override
  String get favorites => 'Favoris';

  @override
  String get reminders => 'Rappels';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get loginDemo => 'Se connecter (démo)';

  @override
  String get loginOptionalNote =>
      'La connexion est facultative. Sans compte, les favoris sont enregistrés uniquement sur ce téléphone.';

  @override
  String get yourName => 'Votre nom';

  @override
  String get nameHintEx => 'Ex. : Maria Sousa';

  @override
  String get cancel => 'Annuler';

  @override
  String get enter => 'Entrer';

  @override
  String get language => 'Langue';

  @override
  String get adminTitle => 'Admin';

  @override
  String get adminOverview => 'Vue d\'ensemble · mis à jour en temps réel';

  @override
  String get metricParticipants => 'Participants';

  @override
  String get metricCheckins => 'Check-ins';

  @override
  String get metricActiveSessions => 'Sessions actives';

  @override
  String get metricCompleted => 'Terminées';

  @override
  String get chartParticipationByTime => 'Participation par horaire';

  @override
  String get chartTopSessions => 'Sessions les plus suivies';

  @override
  String get manage => 'Gérer →';

  @override
  String get participantsUpper => 'PARTICIPANTS';

  @override
  String get statusPresent => 'Présent';

  @override
  String get statusPending => 'En attente';

  @override
  String get statusCancelled => 'ANNULÉ';

  @override
  String get statusLive => 'EN DIRECT';

  @override
  String get typeApresentacao => 'Présentation';

  @override
  String get typeLancamento => 'Lancement';

  @override
  String get typeAssinatura => 'Signature';

  @override
  String get typePlenaria => 'Plénière';

  @override
  String get typePainel => 'Panel';

  @override
  String get typeFormacao => 'Formation';

  @override
  String get typeWorkshop => 'Atelier';

  @override
  String get happeningNow => 'En cours maintenant';

  @override
  String get eventInProgress => 'L\'événement est en cours';

  @override
  String get unitDays => 'jours';

  @override
  String get unitHoursLong => 'heures';

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
  String get relativeNow => 'maintenant';

  @override
  String relativeMinutes(int count) {
    return 'il y a $count min';
  }

  @override
  String relativeHours(int count) {
    return 'il y a $count h';
  }

  @override
  String relativeDays(int count) {
    return 'il y a $count j';
  }

  @override
  String get notifKindNotice => 'Avis';

  @override
  String get notifKindScheduleChange => 'Changement d\'horaire';

  @override
  String get notifKindCancellation => 'Annulation';

  @override
  String get notifKindStarting => 'Bientôt';

  @override
  String get profileTooltip => 'Profil';

  @override
  String get eventSubtitle =>
      'Angola ICT Forum · Sur la voie de la transformation numérique';

  @override
  String get retry => 'Réessayer';

  @override
  String get loadError => 'Impossible de charger les données.';

  @override
  String get signInWithGoogleBtn => 'Se connecter avec Google';

  @override
  String get qaSentPending => 'Question envoyée. En attente d\'approbation.';

  @override
  String get qaLoginRequired => 'Connectez-vous avec Google pour participer.';

  @override
  String get noQuestionsYet => 'Aucune question approuvée pour l\'instant.';

  @override
  String get moderator => 'Modérateur';

  @override
  String get aboutSpeaker => 'À propos';

  @override
  String get noBio => 'Aucune biographie disponible.';

  @override
  String get photosTitle => 'Photos';

  @override
  String get locationSection => 'Emplacement';

  @override
  String get descriptionTitle => 'À propos de cette session';

  @override
  String get notifWelcomeTitle => 'Bienvenue à Angotic 2026';

  @override
  String get notifWelcomeBody =>
      'Explorez le programme et enregistrez les sessions à ne pas manquer.';

  @override
  String notifStartingSoonTitle(String title) {
    return '$title commence bientôt';
  }

  @override
  String notifStartingSoonBody(String time, String location) {
    return 'Commence à $time · $location';
  }

  @override
  String notifTimeChangedTitle(String title) {
    return 'Horaire modifié : $title';
  }

  @override
  String notifTimeChangedBody(String time, String location) {
    return 'Désormais à $time · $location';
  }

  @override
  String notifSessionUpdatedTitle(String title) {
    return 'Session mise à jour : $title';
  }

  @override
  String get noPhotos => 'Pas encore de photos.';

  @override
  String get reminderLeadTitle => 'Délai du rappel';

  @override
  String get reminderLeadHint =>
      'Quand vous prévenir avant le début d\'une session';

  @override
  String get leadAtStart => 'Au début';

  @override
  String leadMinutes(int count) {
    return '$count min';
  }

  @override
  String notifLiveTitle(String title) {
    return '$title est en cours';
  }

  @override
  String notifLiveBody(String location) {
    return 'Maintenant · $location';
  }

  @override
  String get qaEdit => 'Modifier';

  @override
  String get qaDelete => 'Supprimer';

  @override
  String get qaDeleteConfirm => 'Supprimer cette question ?';

  @override
  String get qaPending => 'En attente';

  @override
  String get qaEditTitle => 'Modifier la question';

  @override
  String get qaSave => 'Enregistrer';

  @override
  String get qaDeleted => 'Question supprimée.';

  @override
  String get speakerSessions => 'Sessions';

  @override
  String get authWelcomeTitle => 'Bienvenue à GGPEN';

  @override
  String get authWelcomeSubtitle =>
      'Suivez notre participation à Angotic 2026.';

  @override
  String get authContinueWithGoogle => 'Continuer avec Google';

  @override
  String get authCreateAccount => 'Inscription';

  @override
  String get authOr => 'ou';

  @override
  String get signupTitle => 'Inscription';

  @override
  String get signupHelper =>
      'Remplissez vos informations pour recevoir rappels et nouveautés.';

  @override
  String get signupNameLabel => 'Nom complet';

  @override
  String get signupEmailLabel => 'Email';

  @override
  String get signupPhoneLabel => 'Téléphone';

  @override
  String get signupCompanyLabel => 'Entreprise / Institution';

  @override
  String get signupRoleLabel => 'Fonction';

  @override
  String get signupTermsPrefix => 'J\'accepte les ';

  @override
  String get signupTermsLink => 'Conditions d\'utilisation';

  @override
  String get signupTermsAnd => ' et la ';

  @override
  String get signupPrivacyLink => 'Politique de confidentialité';

  @override
  String get signupTermsSuffix => '.';

  @override
  String get signupSubmit => 'Créer le compte';

  @override
  String get signupHaveAccount => 'Vous avez déjà un compte ?';

  @override
  String get signupSignInLink => 'Se connecter';

  @override
  String get signupValidationRequired => 'Champ obligatoire';

  @override
  String get signupValidationEmail => 'Email invalide';

  @override
  String get signupMustAcceptTerms =>
      'Vous devez accepter les conditions pour continuer.';

  @override
  String get termsDialogTitle => 'Conditions d\'utilisation';

  @override
  String get termsBody =>
      'En utilisant l\'application GGPEN · Angotic 2026, vous acceptez ces Conditions d\'utilisation. L\'App est le guide officiel des événements du GGPEN.\n\nVotre compte : fournissez des informations exactes et protégez votre accès. Vous êtes responsable de l\'activité sur votre compte.\n\nParticipation et questions : vous êtes responsable du contenu que vous publiez. Tout contenu offensant, illégal, diffamatoire, trompeur ou de type spam est interdit. Les questions sont modérées et le GGPEN peut les rejeter ou les supprimer. En soumettant, vous autorisez le GGPEN à afficher votre contenu dans le cadre de l\'événement.\n\nMarque et contenus : la marque GGPEN/Angotic, les logos et les supports sont la propriété du GGPEN et ne peuvent être utilisés sans autorisation.\n\nService : fourni en l\'état et susceptible d\'être modifié ou interrompu. Le GGPEN n\'est pas responsable des indisponibilités ni des contenus soumis par les utilisateurs.\n\nDonnées : le traitement de vos données est régi par la Politique de confidentialité.\n\nDroit applicable : la législation de la République d\'Angola.\n\nModifications : nous pouvons mettre à jour ces Conditions ; l\'utilisation continue vaut acceptation.\n\nContact : geral@ggpen.gov.ao';

  @override
  String get privacyDialogTitle => 'Politique de confidentialité';

  @override
  String get privacyBody =>
      'Le Bureau de gestion du Programme spatial national (GGPEN) est le responsable du traitement de vos données dans cette application.\n\nDonnées collectées : lors de la connexion avec Google, votre nom, e-mail et avatar ; les informations que vous fournissez (téléphone, entreprise, fonction) ; et les questions et mentions j\'aime que vous soumettez. Favoris, rappels et langue restent uniquement sur votre appareil. Nous ne collectons pas la localisation.\n\nFinalités : authentifier votre session, afficher le programme et gérer votre participation, envoyer des rappels et des informations sur Angotic 2026, ainsi que des communications du GGPEN et de ses partenaires.\n\nPartage : nous utilisons Supabase pour héberger les données pour le compte du GGPEN, et Google uniquement pour la connexion. Nous ne vendons pas vos données.\n\nSécurité : connexions chiffrées et accès par utilisateur ; les questions ne deviennent publiques qu\'après approbation.\n\nVos droits : vous pouvez accéder à vos données, les corriger et les supprimer, et demander la suppression du compte, via geral@ggpen.gov.ao.\n\nGGPEN — Complexo Administrativo Clássicos de Talatona, Rua do MAT, Edifício n.º 3, 6.º andar, Belas — Luanda, Angola. Tél. : +244 222 777 312.';

  @override
  String get termsDialogClose => 'Fermer';

  @override
  String get profileFieldPhone => 'Téléphone';

  @override
  String get profileFieldCompany => 'Entreprise';

  @override
  String get profileFieldRole => 'Fonction';

  @override
  String get completeProfileTitle => 'Complétez votre profil';

  @override
  String get completeProfileSubtitle =>
      'Quelques infos de plus — téléphone, entreprise et fonction.';

  @override
  String get profileSaveLater => 'Terminer plus tard';

  @override
  String get welcomeBackTitle => 'BIENVENUE';

  @override
  String welcomeBackHello(String name) {
    return 'Bonjour, $name !';
  }

  @override
  String get welcomeBackContinue => 'Continuer';

  @override
  String get welcomeBackSwitch =>
      'Ce n\'est pas vous ? Utiliser un autre compte';

  @override
  String get welcomeBackSwitchTitle => 'Utiliser un autre compte ?';

  @override
  String get welcomeBackSwitchBody =>
      'Cela supprimera les données enregistrées sur ce téléphone. Vous devrez vous inscrire à nouveau.';

  @override
  String get welcomeBackSwitchConfirm => 'Supprimer et continuer';

  @override
  String get profileSectionPersonal => 'Informations personnelles';

  @override
  String get profileSectionPreferences => 'Préférences';

  @override
  String get profileSectionLegal => 'Mentions légales';

  @override
  String get profileFieldEmail => 'Email';

  @override
  String get loginPrivacyFooter => 'Vos données restent sur cet appareil.';
}
