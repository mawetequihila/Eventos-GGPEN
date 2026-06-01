// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get navHome => 'Início';

  @override
  String get navAgenda => 'Agenda';

  @override
  String get navSpeakers => 'Oradores';

  @override
  String get navGgpen => 'GGPEN';

  @override
  String get drawerMyAgenda => 'Minha Agenda';

  @override
  String get drawerNotifications => 'Notificações';

  @override
  String get drawerMap => 'Mapa';

  @override
  String get drawerParticipants => 'Participantes';

  @override
  String get drawerProfile => 'Perfil';

  @override
  String get drawerHeaderTitle => 'Agenda no Angotic 2026';

  @override
  String get drawerPoweredBy => 'apresentado por GGPEN';

  @override
  String get splashTagline => 'Agenda no Angotic 2026';

  @override
  String get greetingMorning => 'Bom dia';

  @override
  String get greetingAfternoon => 'Boa tarde';

  @override
  String get greetingEvening => 'Boa noite';

  @override
  String greetingLine(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get guest => 'visitante';

  @override
  String get liveNow => 'A decorrer agora';

  @override
  String get noLiveSession => 'Nenhuma sessão a decorrer neste momento.';

  @override
  String get nextSessionStartsIn => 'PRÓXIMA SESSÃO COMEÇA EM';

  @override
  String get noMoreSessionsToday => 'Sem mais sessões por hoje';

  @override
  String get quickAccess => 'Acesso rápido';

  @override
  String get shortcutAgenda => 'Agenda';

  @override
  String get shortcutSaved => 'Guardadas';

  @override
  String get shortcutMap => 'Mapa';

  @override
  String get shortcutNotifications => 'Avisos';

  @override
  String get shortcutBadge => 'Crachá';

  @override
  String get homeSignInCta => 'Entrar';

  @override
  String get todaySchedule => 'Programação de hoje';

  @override
  String get seeAll => 'Ver tudo →';

  @override
  String get agendaTitle => 'Agenda';

  @override
  String get searchTooltip => 'Procurar';

  @override
  String get searchHint => 'Procurar actividade, local ou orador';

  @override
  String get searchPrompt => 'Escreve para procurar…';

  @override
  String get noResults => 'Nenhum resultado.';

  @override
  String searchResultSubtitle(int day, String time, String location) {
    return 'Dia $day · $time · $location';
  }

  @override
  String get weekday1 => 'Qui';

  @override
  String get weekday2 => 'Sex';

  @override
  String get weekday3 => 'Sáb';

  @override
  String get linkCopied => 'Link copiado (demo)';

  @override
  String get tabSpeakers => 'Oradores';

  @override
  String get tabQa => 'Dúvidas';

  @override
  String get remindBeforeStart => 'Lembrar-me antes de começar';

  @override
  String get inMyAgenda => 'Na minha agenda';

  @override
  String get addToMyAgenda => 'Adicionar à minha agenda';

  @override
  String get noSpeakersForSession => 'Sem oradores associados a esta sessão.';

  @override
  String get speakersUpper => 'ORADORES';

  @override
  String get guestSpeaker => 'Orador convidado';

  @override
  String get qaHint => 'Escreve a tua dúvida...';

  @override
  String get you => 'Você';

  @override
  String get myAgendaTitle => 'Minha Agenda';

  @override
  String get emptyAgendaTitle => 'A tua agenda está vazia';

  @override
  String get emptyAgendaBody =>
      'Marca actividades com a estrela na Agenda para as veres aqui e activares lembretes.';

  @override
  String get seeAgenda => 'Ver agenda';

  @override
  String get favoritesStoredLocally =>
      'Os teus favoritos estão guardados neste telemóvel.';

  @override
  String get sync => 'Sincronizar';

  @override
  String get overlapWarning => 'Tens actividades com horários sobrepostos.';

  @override
  String get noOverlap => 'Sem conflitos de horário.';

  @override
  String dayUpper(int day) {
    return 'DIA $day';
  }

  @override
  String get spaceProgramTitle => 'Programa Espacial Nacional';

  @override
  String get ggpenDescription =>
      'O Gabinete de Gestão do Programa Espacial Nacional (GGPEN) coordena o programa espacial de Angola, colocando tecnologia de satélite ao serviço da conectividade, da observação da Terra e da transformação digital do país. No Angotic 2026 mostramos o que estamos a construir.';

  @override
  String get atAngotic => 'No Angotic 2026';

  @override
  String get ourAgenda => 'A nossa agenda';

  @override
  String get ourAgendaSubtitle => 'Palestras, demos e networking';

  @override
  String get whereWeAre => 'Onde estamos';

  @override
  String get contacts => 'Contactos';

  @override
  String get contactSite => 'Site';

  @override
  String get contactEmail => 'Email';

  @override
  String get contactSocial => 'Redes';

  @override
  String get presentAt => 'presente no';

  @override
  String get standLabel => 'Stand A · Pavilhão 2';

  @override
  String get standNearAuditorium => 'Junto ao Auditório 1';

  @override
  String get howToGet => 'Como chegar';

  @override
  String get howToGetBody =>
      'A partir da entrada principal, segue pelo corredor central e vira na 2.ª à direita. O stand da GGPEN está sinalizado com o logótipo.';

  @override
  String get usefulPoints => 'Pontos úteis';

  @override
  String get pointAuditorium => 'Auditório 1';

  @override
  String get pointLounge => 'Lounge';

  @override
  String get pointCatering => 'Restauração';

  @override
  String get pointParking => 'Estacionamento';

  @override
  String get speakersTitle => 'Oradores';

  @override
  String speakersConfirmed(int count) {
    return '$count confirmados';
  }

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessões',
      one: '1 sessão',
    );
    return '$_temp0';
  }

  @override
  String get participantsTitle => 'Participantes';

  @override
  String participantsCount(int count) {
    return '$count participantes';
  }

  @override
  String checkinsCount(int count) {
    return '$count check-ins';
  }

  @override
  String get searchParticipantsHint => 'Procurar por nome, empresa ou função';

  @override
  String get noParticipantsFound => 'Nenhum participante encontrado.';

  @override
  String get checkInBadge => 'Check-in';

  @override
  String get toConfirm => 'Por confirmar';

  @override
  String get notificationsTitle => 'Notificações';

  @override
  String get noNotifications => 'Sem notificações de momento.';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get guestCapitalized => 'Visitante';

  @override
  String get sessionActive => 'Sessão iniciada';

  @override
  String get browsingNoSession => 'A navegar sem sessão';

  @override
  String get favorites => 'Favoritos';

  @override
  String get reminders => 'Lembretes';

  @override
  String get logout => 'Terminar sessão';

  @override
  String get loginDemo => 'Iniciar sessão (demo)';

  @override
  String get loginOptionalNote =>
      'O login é opcional. Sem sessão, os favoritos ficam guardados apenas neste telemóvel.';

  @override
  String get yourName => 'O teu nome';

  @override
  String get nameHintEx => 'Ex.: Maria Sousa';

  @override
  String get cancel => 'Cancelar';

  @override
  String get enter => 'Entrar';

  @override
  String get language => 'Idioma';

  @override
  String get adminTitle => 'Admin';

  @override
  String get adminOverview => 'Visão geral · actualizado em tempo real';

  @override
  String get metricParticipants => 'Participantes';

  @override
  String get metricCheckins => 'Check-ins';

  @override
  String get metricActiveSessions => 'Sessões activas';

  @override
  String get metricCompleted => 'Concluídas';

  @override
  String get chartParticipationByTime => 'Participação por horário';

  @override
  String get chartTopSessions => 'Sessões com mais inscrições';

  @override
  String get manage => 'Gerir →';

  @override
  String get participantsUpper => 'PARTICIPANTES';

  @override
  String get statusPresent => 'Presente';

  @override
  String get statusPending => 'Pendente';

  @override
  String get statusCancelled => 'CANCELADO';

  @override
  String get statusLive => 'EM CURSO';

  @override
  String get typeApresentacao => 'Apresentação';

  @override
  String get typeLancamento => 'Lançamento';

  @override
  String get typeAssinatura => 'Assinatura';

  @override
  String get typePlenaria => 'Plenária';

  @override
  String get typePainel => 'Painel';

  @override
  String get typeFormacao => 'Formação';

  @override
  String get typeWorkshop => 'Workshop';

  @override
  String get happeningNow => 'A decorrer agora';

  @override
  String get eventInProgress => 'O evento está a decorrer';

  @override
  String get unitDays => 'dias';

  @override
  String get unitHoursLong => 'horas';

  @override
  String get unitMinLong => 'min';

  @override
  String get unitSecLong => 'seg';

  @override
  String get unitHoursShort => 'h';

  @override
  String get unitMinShort => 'm';

  @override
  String get unitSecShort => 's';

  @override
  String get relativeNow => 'agora';

  @override
  String relativeMinutes(int count) {
    return 'há $count min';
  }

  @override
  String relativeHours(int count) {
    return 'há $count h';
  }

  @override
  String relativeDays(int count) {
    return 'há $count d';
  }

  @override
  String get notifKindNotice => 'Aviso';

  @override
  String get notifKindScheduleChange => 'Mudança de horário';

  @override
  String get notifKindCancellation => 'Cancelamento';

  @override
  String get notifKindStarting => 'A começar';

  @override
  String get profileTooltip => 'Perfil';

  @override
  String get eventSubtitle =>
      'Angola ICT Forum · Na rota da transformação digital';

  @override
  String get retry => 'Tentar de novo';

  @override
  String get loadError => 'Não foi possível carregar os dados.';

  @override
  String get signInWithGoogleBtn => 'Entrar com Google';

  @override
  String get qaSentPending => 'Dúvida enviada. Aguarda aprovação.';

  @override
  String get qaLoginRequired => 'Inicia sessão com o Google para participar.';

  @override
  String get noQuestionsYet => 'Ainda não há dúvidas aprovadas.';

  @override
  String get moderator => 'Moderador';

  @override
  String get aboutSpeaker => 'Sobre';

  @override
  String get noBio => 'Sem biografia disponível.';

  @override
  String get photosTitle => 'Fotos';

  @override
  String get locationSection => 'Localização';

  @override
  String get descriptionTitle => 'Sobre esta sessão';

  @override
  String get notifWelcomeTitle => 'Bem-vindo ao Angotic 2026';

  @override
  String get notifWelcomeBody =>
      'Explora a agenda e guarda as sessões que não queres perder.';

  @override
  String notifStartingSoonTitle(String title) {
    return '$title começa em breve';
  }

  @override
  String notifStartingSoonBody(String time, String location) {
    return 'Começa às $time · $location';
  }

  @override
  String get noPhotos => 'Ainda não há fotos.';

  @override
  String get reminderLeadTitle => 'Antecedência do lembrete';

  @override
  String get reminderLeadHint => 'Quando avisar antes de uma sessão começar';

  @override
  String get leadAtStart => 'No momento';

  @override
  String leadMinutes(int count) {
    return '$count min';
  }

  @override
  String notifLiveTitle(String title) {
    return '$title está a decorrer';
  }

  @override
  String notifLiveBody(String location) {
    return 'Agora · $location';
  }

  @override
  String get qaEdit => 'Editar';

  @override
  String get qaDelete => 'Eliminar';

  @override
  String get qaDeleteConfirm => 'Eliminar esta dúvida?';

  @override
  String get qaPending => 'Pendente';

  @override
  String get qaEditTitle => 'Editar dúvida';

  @override
  String get qaSave => 'Guardar';

  @override
  String get qaDeleted => 'Dúvida eliminada.';

  @override
  String get speakerSessions => 'Sessões';

  @override
  String get authWelcomeTitle => 'Bem-vindo ao GGPEN';

  @override
  String get authWelcomeSubtitle =>
      'Acompanha a nossa participação no Angotic 2026.';

  @override
  String get authContinueWithGoogle => 'Continuar com Google';

  @override
  String get authCreateAccount => 'Criar conta com email';

  @override
  String get authOr => 'ou';

  @override
  String get signupTitle => 'Criar a tua conta';

  @override
  String get signupHelper =>
      'Preenche os teus dados para receberes lembretes e novidades.';

  @override
  String get signupNameLabel => 'Nome completo';

  @override
  String get signupEmailLabel => 'Email';

  @override
  String get signupPhoneLabel => 'Telefone';

  @override
  String get signupCompanyLabel => 'Empresa / Instituição';

  @override
  String get signupRoleLabel => 'Cargo';

  @override
  String get signupTermsPrefix => 'Concordo com os ';

  @override
  String get signupTermsLink => 'termos de uso e tratamento de dados';

  @override
  String get signupTermsSuffix => '.';

  @override
  String get signupSubmit => 'Criar conta';

  @override
  String get signupHaveAccount => 'Já tens conta?';

  @override
  String get signupSignInLink => 'Entrar';

  @override
  String get signupValidationRequired => 'Campo obrigatório';

  @override
  String get signupValidationEmail => 'Email inválido';

  @override
  String get signupMustAcceptTerms =>
      'Tens de aceitar os termos para continuar.';

  @override
  String get termsDialogTitle => 'Termos de uso e tratamento de dados';

  @override
  String get termsBody =>
      'Ao criares uma conta na app, autorizas a GGPEN a usar os teus dados (nome, email, telefone, empresa e cargo) para te enviar informações relacionadas com o Angotic 2026, atualizações da agenda, lembretes de sessões e comunicações futuras — incluindo conteúdos publicitários e de marketing relacionados com o Programa Espacial Nacional e os seus parceiros.\n\nNão partilhamos os teus dados com terceiros sem o teu consentimento. Podes solicitar a remoção dos teus dados a qualquer momento através do contacto geral@ggpen.gov.ao.';

  @override
  String get termsDialogClose => 'Fechar';

  @override
  String get profileFieldPhone => 'Telefone';

  @override
  String get profileFieldCompany => 'Empresa';

  @override
  String get profileFieldRole => 'Cargo';
}
