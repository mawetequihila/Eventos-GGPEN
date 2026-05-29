import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../models/engagement.dart';
import '../models/notification_item.dart';
import '../models/participant.dart';
import '../models/speaker.dart';
import '../theme/app_colors.dart';

/// Informação do evento. A data de início é ancorada a hoje às 09:00 para que
/// a demonstração mostre logo estados "a decorrer" / "a seguir".
class EventInfo {
  EventInfo._();

  static const String name = 'Angotic 2026';
  static const String subtitle =
      'Angola ICT Forum · Na rota da transformação digital';
  static const String standLabel = 'Stand A · Pavilhão 2';

  static DateTime get startDate {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 9, 0);
  }
}

class MockData {
  MockData._();

  /// Cria um DateTime para o dia [day] (1..3) a partir de hoje.
  static DateTime _t(int day, int h, int m) {
    final now = DateTime.now();
    final base = DateTime(now.year, now.month, now.day)
        .add(Duration(days: day - 1));
    return DateTime(base.year, base.month, base.day, h, m);
  }

  /// Rótulo de cada dia (1..3) conforme a agenda oficial.
  static const Map<int, ({String date, String weekday})> dayInfo = {
    1: (date: '11', weekday: 'Qui'),
    2: (date: '12', weekday: 'Sex'),
    3: (date: '13', weekday: 'Sáb'),
  };

  static final List<Activity> activities = [
    // ================= DIA 11 · QUINTA-FEIRA =================
    Activity(
      id: 'd1-market-intelligence',
      title: 'African Space Market Intelligence',
      type: ActivityType.apresentacao,
      day: 1,
      start: _t(1, 13, 45),
      end: _t(1, 14, 0),
      location: 'Stand GGPEN',
      speaker: 'Dr. Temidayo Oniosun',
    ),
    Activity(
      id: 'd1-observa',
      title: 'OBSERVA+',
      type: ActivityType.lancamento,
      day: 1,
      start: _t(1, 14, 0),
      end: _t(1, 14, 30),
      location: 'Contentor',
      speaker: 'Eng. Luciano',
    ),
    Activity(
      id: 'd1-setic-estradas',
      title: 'SETIC/Estradas',
      type: ActivityType.lancamento,
      day: 1,
      start: _t(1, 14, 30),
      end: _t(1, 14, 50),
      location: 'Stand GGPEN',
      speaker: 'Eng. Luciano',
    ),
    Activity(
      id: 'd1-mou-unitel',
      title:
          'Memorando de Entendimento entre o GGPEN e a UNITEL',
      description:
          'Assinatura do Memorando de Entendimento entre o Gabinete de Gestão '
          'do Programa Espacial Nacional (GGPEN) e a UNITEL.',
      type: ActivityType.assinatura,
      day: 1,
      start: _t(1, 14, 50),
      end: _t(1, 15, 0),
      location: 'Stand GGPEN',
      speaker: 'PCE Unitel · DG GGPEN',
    ),
    Activity(
      id: 'd1-plenaria',
      title: 'O espaço como motor da transformação digital',
      description:
          'Sessão plenária. Inclui a assinatura de acordos com as Agências '
          'Espaciais da Nigéria, Azerbaijão, Emirados Árabes Unidos e Gabão.',
      type: ActivityType.plenaria,
      day: 1,
      start: _t(1, 15, 0),
      end: _t(1, 17, 0),
      location: 'Main Hall',
      speaker: 'Mod. Temidayo Oniosun',
    ),
    Activity(
      id: 'd1-painel-geoespacial',
      title:
          'Soluções geoespaciais inteligentes para a transformação digital em '
          'países emergentes',
      type: ActivityType.painel,
      day: 1,
      start: _t(1, 17, 0),
      end: _t(1, 18, 30),
      location: 'Salas T2 e T3',
      speaker: 'Luciano Lupédia',
    ),

    // ================= DIA 12 · SEXTA-FEIRA =================
    Activity(
      id: 'd2-conecta-premium',
      title: 'Conecta Premium',
      type: ActivityType.lancamento,
      day: 2,
      start: _t(2, 9, 0),
      end: _t(2, 9, 30),
      location: 'A anunciar',
      speaker: 'MSTELCOM e GGPEN',
    ),
    Activity(
      id: 'd2-tvws',
      title: 'Conectividade de Próxima Geração (TVWS)',
      type: ActivityType.lancamento,
      day: 2,
      start: _t(2, 9, 30),
      end: _t(2, 10, 0),
      location: 'A anunciar',
      speaker: 'Dr. Amaro · Prof. Luzango Mfupe',
    ),
    Activity(
      id: 'd2-startups-negocios',
      title: 'Startups e Negócios no Sector Espacial',
      type: ActivityType.formacao,
      day: 2,
      start: _t(2, 10, 0),
      end: _t(2, 11, 0),
      location: 'Sala Cabinda 2',
      speaker: 'James Barrington-Brown',
    ),
    Activity(
      id: 'd2-contrato-namibia',
      title:
          'Contrato de Prestação de serviços entre Telecom Namíbia e o GGPEN',
      type: ActivityType.assinatura,
      day: 2,
      start: _t(2, 10, 0),
      end: _t(2, 10, 15),
      location: 'Stand GGPEN',
      speaker: 'DG Telecom Namíbia · DG GGPEN',
    ),
    Activity(
      id: 'd2-acordo-gpl',
      title:
          'Acordo de Parceria entre o GGPEN e o Governo Provincial de Luanda',
      description:
          'Acordo de Parceria entre o Gabinete de Gestão do Programa Espacial '
          'Nacional e o Governo Provincial de Luanda.',
      type: ActivityType.assinatura,
      day: 2,
      start: _t(2, 10, 15),
      end: _t(2, 10, 30),
      location: 'Stand GGPEN',
      speaker: 'GPL · DG GGPEN',
    ),
    Activity(
      id: 'd2-economia-lunar',
      title: 'Economia Lunar e Cooperação Internacional',
      type: ActivityType.painel,
      day: 2,
      start: _t(2, 11, 0),
      end: _t(2, 12, 30),
      location: 'Sala C1',
      speaker: 'NASA Representative',
    ),
    Activity(
      id: 'd2-centros-dados',
      title: 'Centros de Dados Orbitais',
      type: ActivityType.apresentacao,
      day: 2,
      start: _t(2, 13, 0),
      end: _t(2, 13, 30),
      location: 'Stand GGPEN',
      speaker: 'Rama Afullo',
    ),
    Activity(
      id: 'd2-workshop-clima',
      title: 'Tecnologia Espacial e Alterações Climáticas',
      type: ActivityType.workshop,
      day: 2,
      start: _t(2, 13, 30),
      end: _t(2, 18, 0),
      location: 'Sala Cabinda 2',
      speaker: 'GGPEN / MIT / SASSCAL',
    ),
    Activity(
      id: 'd2-nigcomsat',
      title: 'Expansão NigComSat-1R',
      type: ActivityType.apresentacao,
      day: 2,
      start: _t(2, 14, 30),
      end: _t(2, 15, 0),
      location: 'Stand GGPEN',
      speaker: 'Jane Egerton-Idehen',
    ),
    Activity(
      id: 'd2-cubesats',
      title: 'Cubesats: Benefits and Payloads',
      type: ActivityType.apresentacao,
      day: 2,
      start: _t(2, 15, 15),
      end: _t(2, 15, 25),
      location: 'Stand GGPEN',
      speaker: 'Merry Walker',
    ),
    Activity(
      id: 'd2-orbital-data',
      title: 'Orbital Data Centers (AI Edge Computing)',
      type: ActivityType.apresentacao,
      day: 2,
      start: _t(2, 15, 30),
      end: _t(2, 15, 40),
      location: 'Stand GGPEN',
      speaker: 'Rama Afullo',
    ),
    Activity(
      id: 'd2-painel-satelite',
      title:
          'O papel das comunicações via satélite na transformação digital',
      type: ActivityType.painel,
      day: 2,
      start: _t(2, 16, 30),
      end: _t(2, 18, 0),
      location: 'Sala C1',
      speaker: 'Dr. Amaro João',
    ),

    // ================= DIA 13 · SÁBADO =================
    Activity(
      id: 'd3-unitel-anpg-bai-agt',
      title: 'UNITEL, ANPG, BAI, AGT',
      type: ActivityType.lancamento,
      day: 3,
      start: _t(3, 9, 0),
      end: _t(3, 10, 0),
      location: 'Stand GGPEN',
      speaker: 'GGPEN',
    ),
    Activity(
      id: 'd3-protocolo-zap',
      title: 'Protocolo de Cooperação entre GGPEN e ZAP',
      type: ActivityType.assinatura,
      day: 3,
      start: _t(3, 10, 30),
      end: _t(3, 10, 45),
      location: 'Stand GGPEN',
      speaker: 'DG ZAP · DG GGPEN',
    ),
    Activity(
      id: 'd3-contrato-anpg',
      title: 'Contrato de Prestação de serviços entre ANPG e o GGPEN',
      type: ActivityType.assinatura,
      day: 3,
      start: _t(3, 10, 45),
      end: _t(3, 11, 0),
      location: 'Stand GGPEN',
      speaker: 'ANPG · DG GGPEN',
    ),
    Activity(
      id: 'd3-observacao-terra',
      title: 'Estratégias de Observação da Terra',
      type: ActivityType.apresentacao,
      day: 3,
      start: _t(3, 11, 0),
      end: _t(3, 11, 30),
      location: 'Stand GGPEN',
      speaker: 'Alex Fortescue',
    ),
    Activity(
      id: 'd3-angeo-1',
      title: 'ANGEO-1: Key Differentiators',
      type: ActivityType.apresentacao,
      day: 3,
      start: _t(3, 11, 30),
      end: _t(3, 12, 0),
      location: 'Stand GGPEN',
      speaker: 'Airbus Representative',
    ),
    Activity(
      id: 'd3-nigcomsat-1',
      title: 'NigComSat-1R Expansion',
      type: ActivityType.apresentacao,
      day: 3,
      start: _t(3, 12, 0),
      end: _t(3, 12, 30),
      location: 'Stand GGPEN',
      speaker: 'Jane Egerton-Idehen',
    ),
    Activity(
      id: 'd3-cubesats',
      title: 'Cubesats: Benefits and Payloads',
      type: ActivityType.apresentacao,
      day: 3,
      start: _t(3, 13, 30),
      end: _t(3, 13, 45),
      location: 'Stand GGPEN',
      speaker: 'Merry Walker',
    ),
    Activity(
      id: 'd3-nigcomsat-2',
      title: 'NigComSat-1R Expansion',
      type: ActivityType.apresentacao,
      day: 3,
      start: _t(3, 13, 45),
      end: _t(3, 14, 0),
      location: 'Stand GGPEN',
      speaker: 'Jane Egerton-Idehen',
    ),
    Activity(
      id: 'd3-aniversario-gedae',
      title: 'Aniversário GEDAE',
      type: ActivityType.lancamento,
      day: 3,
      start: _t(3, 15, 20),
      end: _t(3, 15, 40),
      location: 'Stand GGPEN',
      speaker: 'Eng. Luciano',
    ),
  ];

  /// Avisos da organização (banner na Home).
  static final List<String> notices = [
    'A plenária "O espaço como motor da transformação digital" começa às 15:00 '
        'no Main Hall — chega cedo.',
  ];

  static List<Activity> byDay(int day) {
    final list = activities.where((a) => a.day == day).toList();
    list.sort((a, b) => a.start.compareTo(b.start));
    return list;
  }

  static Activity byId(String id) =>
      activities.firstWhere((a) => a.id == id);

  // ---- Notificações ----
  static List<NotificationItem> notifications() {
    final now = DateTime.now();
    return [
      NotificationItem(
        title: 'Plenária começa em breve',
        body: 'A plenária "O espaço como motor da transformação digital" '
            'começa às 15:00 no Main Hall.',
        time: now.subtract(const Duration(minutes: 3)),
        kind: NotificationKind.inicio,
        unread: true,
      ),
      NotificationItem(
        title: 'Mudança de sala',
        body: 'O painel "Economia Lunar e Cooperação Internacional" decorre '
            'na Sala C1.',
        time: now.subtract(const Duration(minutes: 35)),
        kind: NotificationKind.mudanca,
        unread: true,
      ),
      NotificationItem(
        title: 'Bem-vindo ao Angotic 2026',
        body: 'Explora a agenda da GGPEN e favorita as actividades que não '
            'queres perder.',
        time: now.subtract(const Duration(hours: 2)),
        kind: NotificationKind.aviso,
      ),
      NotificationItem(
        title: 'Lembrete: Workshop sobre clima',
        body: 'O workshop "Tecnologia Espacial e Alterações Climáticas" '
            'decorre na Sala Cabinda 2, das 13:30 às 18:00.',
        time: now.subtract(const Duration(hours: 5)),
        kind: NotificationKind.aviso,
      ),
    ];
  }

  // ---- Oradores ----
  static const List<Speaker> speakers = [
    Speaker(name: 'Dr. Temidayo Oniosun', role: 'Space Market Intelligence · Moderador', sessions: 2, color: AppColors.talk),
    Speaker(name: 'Jane Egerton-Idehen', role: 'NigComSat-1R', sessions: 3, color: AppColors.demo),
    Speaker(name: 'Rama Afullo', role: 'Centros de Dados Orbitais', sessions: 2, color: AppColors.ceremony),
    Speaker(name: 'Eng. Luciano', role: 'GGPEN', sessions: 3, color: AppColors.workshop),
    Speaker(name: 'Merry Walker', role: 'Cubesats', sessions: 2, color: AppColors.navy),
    Speaker(name: 'Dr. Amaro João', role: 'Comunicações via satélite', sessions: 2, color: Color(0xFF2A4A8C)),
    Speaker(name: 'James Barrington-Brown', role: 'Startups no Sector Espacial', sessions: 1, color: AppColors.talk),
    Speaker(name: 'Alex Fortescue', role: 'Observação da Terra', sessions: 1, color: AppColors.demo),
  ];

  // ---- Q&A (sessão a decorrer) ----
  static const List<QaItem> qa = [
    QaItem(author: 'Marcos Paulo', initials: 'MP', text: 'Como o AngoSat-2 impacta a economia digital angolana?', votes: 14, voted: true, time: 'há 5 min'),
    QaItem(author: 'Anónimo', initials: '', text: 'Quais os planos para expansão nas zonas rurais?', votes: 7, voted: false, time: 'há 12 min'),
    QaItem(author: 'Sofia Mendes', initials: 'SM', text: 'Existe parceria com startups locais angolanas?', votes: 3, voted: false, time: 'há 20 min'),
  ];

  // ---- Sondagem ao vivo ----
  static const Poll poll = Poll(
    question: 'Como avalias o impacto do programa espacial em Angola?',
    totalVotes: 127,
    closesIn: 'Encerra em 8 min',
    options: [
      PollOption('Muito positivo', 52),
      PollOption('Positivo', 31),
      PollOption('Neutro', 12),
      PollOption('Ainda não sinto impacto', 5),
    ],
  );

  // ---- Participantes ----
  static const List<Participant> participants = [
    Participant(
      name: 'Ana Sebastião',
      role: 'Engenheira de Software',
      company: 'GGPEN',
      checkedIn: true,
    ),
    Participant(
      name: 'Bruno Mendes',
      role: 'Investigador',
      company: 'Universidade Agostinho Neto',
      checkedIn: true,
    ),
    Participant(
      name: 'Carla Domingos',
      role: 'Gestora de Produto',
      company: 'Unitel',
    ),
    Participant(
      name: 'Délcio Fernandes',
      role: 'Cientista de Dados',
      company: 'GGPEN',
      checkedIn: true,
    ),
    Participant(
      name: 'Eunice Cardoso',
      role: 'Estudante',
      company: 'ISPTEC',
    ),
    Participant(
      name: 'Fábio Quissanga',
      role: 'CTO',
      company: 'Startup OrbitAO',
      checkedIn: true,
    ),
    Participant(
      name: 'Graça Lopes',
      role: 'Jornalista',
      company: 'TPA',
    ),
    Participant(
      name: 'Hélder Bumba',
      role: 'Engenheiro de Telecomunicações',
      company: 'Angola Telecom',
      checkedIn: true,
    ),
  ];
}
