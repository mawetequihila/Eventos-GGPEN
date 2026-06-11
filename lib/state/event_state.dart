import 'dart:async';

import 'package:flutter/material.dart';

import '../data/ggpen_models.dart' as sb;
import '../data/ggpen_repository.dart';
import '../models/activity.dart';
import '../models/speaker.dart';
import '../theme/app_colors.dart';

enum LoadStatus { idle, loading, ready, error }

/// Carrega o evento atual, as atividades e os oradores do Supabase e converte-os
/// para os modelos da app (`Activity`, `Speaker`). A UI consome este estado em
/// vez de `MockData`. Trata estados de loading e erro.
class EventState extends ChangeNotifier {
  final GgpenRepository repo;
  EventState(this.repo);

  LoadStatus status = LoadStatus.idle;
  String? error;

  sb.AppEvent? event;
  List<Activity> activities = [];
  List<Speaker> speakers = [];

  /// Dias distintos do evento (datas sem hora), ordenados — mapeiam o índice 1..N.
  List<DateTime> days = [];

  /// Paleta para dar cor aos oradores (a BD não guarda cor).
  static const List<Color> _palette = [
    AppColors.talk,
    AppColors.demo,
    AppColors.ceremony,
    AppColors.workshop,
    AppColors.navy,
    Color(0xFF2A4A8C),
    AppColors.accent2,
    AppColors.gold,
  ];

  bool get isReady => status == LoadStatus.ready;

  // Dados crus (mantidos para re-mapear quando a língua muda, sem refetch).
  List<sb.Activity> _rawActs = [];
  List<sb.Speaker> _rawSpeakers = [];
  Map<String, int> _counts = {};
  List<DateTime> _dayKeys = [];
  /// Idioma do CONTEÚDO (título/descrição/bio). Definido a partir do idioma
  /// escolhido na app. `null`/`pt` → mostra o texto base (português).
  String? _lang;

  /// Define o idioma do conteúdo e re-mapeia os modelos (sem ir ao backend).
  /// Chamado quando o utilizador troca de idioma na app.
  void setLanguage(String? code) {
    final norm = (code == null || code.isEmpty) ? 'pt' : code;
    if (norm == _lang) return;
    _lang = norm;
    if (_rawActs.isNotEmpty || _rawSpeakers.isNotEmpty) {
      _rebuild();
      notifyListeners();
    }
  }

  /// Reconstrói `activities`/`speakers` a partir dos dados crus, no idioma atual.
  void _rebuild() {
    activities = _rawActs.map((a) => _toAppActivity(a, _dayKeys)).toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    speakers = [
      for (var i = 0; i < _rawSpeakers.length; i++)
        _toAppSpeaker(_rawSpeakers[i], _counts[_rawSpeakers[i].id] ?? 0, i),
    ];
  }

  // Subscrição em tempo real às atividades (deteta mudanças de horário feitas
  // no painel enquanto a app está aberta).
  StreamSubscription<List<sb.Activity>>? _activitiesSub;
  bool _realtimeOn = false;

  /// Liga a escuta em tempo real às atividades deste evento. Ao mudar algo no
  /// backend, recarrega a agenda — o que dispara a reconciliação de lembretes.
  void _listenActivities(String eventId) {
    if (_realtimeOn) return;
    _realtimeOn = true;
    _activitiesSub = repo.watchActivities(eventId).skip(1).listen(
      (_) => load(),
      onError: (_) {/* ignora falhas de stream; o pull-to-refresh continua a servir */},
    );
  }

  Future<void> load() async {
    status = LoadStatus.loading;
    error = null;
    notifyListeners();
    try {
      final ev = await repo.getCurrentEvent();
      _listenActivities(ev.id); // tempo real (uma vez)
      final acts = await repo.getActivities(ev.id);
      final counts = await repo.getSpeakerSessionCounts();
      final allSpeakers = await repo.getAllSpeakers();
      // Garantia extra: ordenar também no cliente por `ordem` (menor primeiro;
      // sem ordem vai para o fim) e nome como desempate — independente da query.
      allSpeakers.sort((a, b) {
        final ao = a.ordem ?? 1 << 30;
        final bo = b.ordem ?? 1 << 30;
        if (ao != bo) return ao.compareTo(bo);
        return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
      });

      // Dias distintos (por data de início), ordenados.
      final dayKeys = <DateTime>[];
      for (final a in acts) {
        final d = DateTime(a.inicio.year, a.inicio.month, a.inicio.day);
        if (!dayKeys.contains(d)) dayKeys.add(d);
      }
      dayKeys.sort();

      event = ev;
      days = dayKeys;
      // Guarda os dados crus para re-mapear ao trocar de idioma sem refetch.
      _rawActs = acts;
      _rawSpeakers = allSpeakers;
      _counts = counts;
      _dayKeys = dayKeys;
      _rebuild();
      status = LoadStatus.ready;
    } catch (e) {
      error = e.toString();
      status = LoadStatus.error;
    }
    notifyListeners();
  }

  List<Activity> byDay(int day) {
    final list = activities.where((a) => a.day == day).toList();
    list.sort((a, b) => a.start.compareTo(b.start));
    return list;
  }

  int get dayCount => days.length;

  @override
  void dispose() {
    _activitiesSub?.cancel();
    super.dispose();
  }

  DateTime? dateForDay(int day) =>
      (day >= 1 && day <= days.length) ? days[day - 1] : null;

  // ---- Mapeamento Supabase -> modelos da app ----
  Activity _toAppActivity(sb.Activity a, List<DateTime> dayKeys) {
    final d = DateTime(a.inicio.year, a.inicio.month, a.inicio.day);
    final idx = dayKeys.indexOf(d);
    return Activity(
      id: a.id,
      title: a.tituloFor(_lang),
      type: _mapTipo(a.tipo),
      day: idx < 0 ? 1 : idx + 1,
      start: a.inicio,
      end: a.fim ?? a.inicio,
      location: a.local ?? '',
      description: a.descricaoFor(_lang) ?? '',
    );
  }

  Speaker _toAppSpeaker(sb.Speaker s, int sessions, int index) => Speaker(
        id: s.id,
        name: s.nome,
        role: s.organizacaoFor(_lang) ?? '',
        bio: s.bioFor(_lang),
        avatarUrl: s.avatarUrl,
        country: s.pais,
        region: s.origem,
        sessions: sessions == 0 ? 1 : sessions,
        color: _palette[index % _palette.length],
      );

  ActivityType _mapTipo(String tipo) {
    switch (tipo) {
      case 'apresentacao':
        return ActivityType.apresentacao;
      case 'lancamento':
        return ActivityType.lancamento;
      case 'assinatura':
        return ActivityType.assinatura;
      case 'plenaria':
        return ActivityType.plenaria;
      case 'paralela':
        return ActivityType.paralela;
      case 'painel':
        return ActivityType.painel;
      case 'formacao':
        return ActivityType.formacao;
      case 'workshop':
        return ActivityType.workshop;
      default:
        // 'outro' e quaisquer valores não mapeados.
        return ActivityType.apresentacao;
    }
  }
}
