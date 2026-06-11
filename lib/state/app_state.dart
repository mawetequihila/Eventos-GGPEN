import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/ggpen_repository.dart';
import '../models/activity.dart';
import '../models/notification_item.dart';
import '../services/notification_service.dart';
import '../services/reminder_scheduler.dart';

/// Estado da sessão para decidir o ecrã raiz.
/// - loggedOut: sem sessão e sem perfil local guardado
/// - welcomeBack: há perfil local guardado mas sessão inactiva → "Bem-vindo de volta"
/// - ready: pronto para a app
enum AuthStatus { loggedOut, welcomeBack, ready }

/// Resultado do registo por email.
enum SignUpResult { signedIn, needsEmailConfirmation }

/// Estado global: favoritos e lembretes (locais), idioma (local) e sessão
/// (autenticação Google via Supabase). Favoritos NUNCA vão para o backend.
class AppState extends ChangeNotifier {
  static const _kFavorites = 'favorites';
  static const _kReminders = 'reminders';
  static const _kWatchedSig = 'watchedSig';
  static const _kInbox = 'noticeInbox';
  static const _kLocale = 'locale';
  static const _kLeadMinutes = 'reminderLeadMinutes';
  static const _kLocalProfile = 'localProfile';
  static const _kLocalProfileActive = 'localProfileActive';

  /// Opções de antecedência do lembrete (minutos antes de começar).
  static const List<int> leadOptions = [0, 5, 10, 15, 30];

  /// Idiomas suportados pela app (PT, EN, FR, AR).
  static const List<Locale> supportedLocales = [
    Locale('pt'),
    Locale('en'),
    Locale('fr'),
    Locale('ar'),
  ];

  final GgpenRepository _repo;
  AppState(this._repo) {
    _authSub = _repo.authChanges.listen((_) {
      notifyListeners();
      // Ao iniciar sessão, traz favoritos/lembretes/idioma da conta.
      if (_repo.isLoggedIn) _loadCloudPrefs();
    });
  }

  final Set<String> _favorites = {};
  final Set<String> _reminders = {};
  /// Assinatura ("inicioMs|local") de cada sessão na biblioteca (favoritos).
  /// Permite detectar quando o organizador muda o horário/local e avisar — para
  /// QUALQUER sessão guardada, não só as que têm lembrete (sino).
  final Map<String, String> _watchedSig = {};
  /// Histórico persistente de notificações (mais recente primeiro). Acumula
  /// todos os avisos — incluindo "horário alterado" — com estado lida/não-lida.
  final List<StoredNotice> _inbox = [];
  Locale? _locale;
  int _reminderLeadMinutes = 15;
  Map<String, String>? _localProfile;
  bool _localProfileActive = false;
  bool _signingOut = false;


  SharedPreferences? _prefs;
  StreamSubscription<AuthState>? _authSub;

  Set<String> get favorites => Set.unmodifiable(_favorites);

  /// Sessão iniciada — Google (Supabase) OU perfil local activo.
  /// O perfil local pode estar guardado mas inactivo (após signOut) — nesse
  /// caso `isLoggedIn` é false e o AuthGate mostra `welcomeBack`.
  bool get isLoggedIn => _repo.isLoggedIn || _localProfileActive;

  /// Há perfil local guardado (para mostrar "Bem-vindo de volta" após logout).
  bool get hasSavedLocalProfile => _localProfile != null;

  /// Perfil local (quando o utilizador se inscreveu pelo formulário). Apenas
  /// guardado em SharedPreferences. Sem backend.
  Map<String, String>? get localProfile =>
      _localProfile == null ? null : Map.unmodifiable(_localProfile!);

  /// Nome a mostrar do utilizador autenticado (Google ou perfil local).
  String? get userName {
    final user = _repo.currentUser;
    if (user != null) {
      final meta = user.userMetadata;
      // 'nome' = cadastro por email; 'full_name'/'name' = Google.
      final fullName = meta?['nome'] ?? meta?['full_name'] ?? meta?['name'];
      if (fullName is String && fullName.trim().isNotEmpty) {
        return fullName.trim();
      }
      final email = user.email;
      if (email != null && email.isNotEmpty) return email.split('@').first;
    }
    final localName = _localProfile?['name']?.trim();
    if (localName != null && localName.isNotEmpty) return localName;
    return null;
  }

  /// Email da sessão (Google ou perfil local).
  String? get userEmail {
    final googleEmail = _repo.currentUser?.email;
    if (googleEmail != null && googleEmail.isNotEmpty) return googleEmail;
    return _localProfile?['email'];
  }

  /// Estado da sessão para o AuthGate decidir o ecrã raiz.
  AuthStatus get authStatus {
    // Durante o logout (Google em background) tratamos como sem sessão,
    // para a UI redirecionar imediatamente e não ficar pendurada.
    if (_signingOut) {
      if (_localProfile != null) return AuthStatus.welcomeBack;
      return AuthStatus.loggedOut;
    }
    // Com sessão, entra sempre direto na app.
    if (_repo.isLoggedIn) return AuthStatus.ready;
    if (_localProfileActive) return AuthStatus.ready;
    if (_localProfile != null) return AuthStatus.welcomeBack;
    return AuthStatus.loggedOut;
  }

  /// Idioma escolhido. `null` = seguir o idioma do sistema.
  Locale? get locale => _locale;

  /// Minutos antes do início em que a app avisa (0 = no momento).
  int get reminderLeadMinutes => _reminderLeadMinutes;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    _favorites.addAll(prefs.getStringList(_kFavorites) ?? const []);
    _reminders.addAll(prefs.getStringList(_kReminders) ?? const []);
    final sigStr = prefs.getString(_kWatchedSig);
    if (sigStr != null && sigStr.isNotEmpty) {
      try {
        final decoded = jsonDecode(sigStr);
        if (decoded is Map) {
          decoded.forEach((k, v) => _watchedSig[k.toString()] = '$v');
        }
      } catch (_) {
        // ignora mapa corrompido
      }
    }
    final inboxStr = prefs.getString(_kInbox);
    if (inboxStr != null && inboxStr.isNotEmpty) {
      try {
        final decoded = jsonDecode(inboxStr);
        if (decoded is List) {
          for (final e in decoded) {
            if (e is Map) {
              _inbox.add(StoredNotice.fromJson(Map<String, dynamic>.from(e)));
            }
          }
        }
      } catch (_) {
        // ignora histórico corrompido
      }
    }
    final code = prefs.getString(_kLocale);
    if (code != null && code.isNotEmpty) {
      _locale = Locale(code);
    }
    _reminderLeadMinutes = prefs.getInt(_kLeadMinutes) ?? 15;
    _localProfileActive = prefs.getBool(_kLocalProfileActive) ?? false;
    final profileStr = prefs.getString(_kLocalProfile);
    if (profileStr != null && profileStr.isNotEmpty) {
      try {
        final decoded = jsonDecode(profileStr);
        if (decoded is Map) {
          _localProfile = {
            for (final e in decoded.entries) e.key.toString(): e.value.toString(),
          };
        }
      } catch (_) {
        // ignora perfil corrompido
      }
    }
    notifyListeners();
    // Se já há sessão ativa (app reaberta), sincroniza as preferências da conta.
    if (_repo.isLoggedIn) _loadCloudPrefs();
  }

  // ---- Sincronização de preferências com a conta (web/multi-dispositivo) ----
  /// Ao iniciar sessão, traz da conta os favoritos/lembretes/idioma. Se a conta
  /// ainda não tiver nada (1.ª vez), envia o que está no dispositivo (migração).
  Future<void> _loadCloudPrefs() async {
    if (!_repo.isLoggedIn) return;
    try {
      final remote = await _repo.getMyPrefs();
      if (remote == null) {
        await _pushCloudPrefs(); // 1.ª vez: migra o local para a conta
        return;
      }
      List<String> asList(dynamic v) =>
          v is List ? v.map((e) => '$e').toList() : const <String>[];
      _favorites
        ..clear()
        ..addAll(asList(remote['favorites']));
      _reminders
        ..clear()
        ..addAll(asList(remote['reminders']));
      final lead = remote['leadMinutes'];
      if (lead is int) _reminderLeadMinutes = lead;
      final loc = remote['locale'];
      if (loc is String && loc.isNotEmpty) _locale = Locale(loc);
      // Persiste localmente o que veio da conta.
      _persistLists();
      _prefs?.setInt(_kLeadMinutes, _reminderLeadMinutes);
      if (_locale != null) _prefs?.setString(_kLocale, _locale!.languageCode);
      notifyListeners();
    } catch (_) {
      // Sem rede / tabela ainda não criada — fica com o estado local.
    }
  }

  /// Envia o estado atual para a conta (se houver sessão). Chamado após mudanças.
  Future<void> _pushCloudPrefs() async {
    if (!_repo.isLoggedIn) return;
    try {
      await _repo.saveMyPrefs({
        'favorites': _favorites.toList(),
        'reminders': _reminders.toList(),
        'leadMinutes': _reminderLeadMinutes,
        'locale': _locale?.languageCode,
      });
    } catch (_) {}
  }

  /// Define a antecedência do lembrete (minutos antes de começar) e persiste.
  void setReminderLeadMinutes(int minutes) {
    _reminderLeadMinutes = minutes;
    _prefs?.setInt(_kLeadMinutes, minutes);
    _pushCloudPrefs();
    notifyListeners();
  }

  /// Define o idioma da app (`null` volta a seguir o sistema) e persiste.
  void setLocale(Locale? locale) {
    _locale = locale;
    if (locale == null) {
      _prefs?.remove(_kLocale);
    } else {
      _prefs?.setString(_kLocale, locale.languageCode);
    }
    _pushCloudPrefs();
    notifyListeners();
  }

  bool isFavorite(String id) => _favorites.contains(id);
  bool isReminder(String id) => _reminders.contains(id);

  /// Assinatura observada de uma sessão: hora de início + local. Se qualquer um
  /// mudar no backend, avisamos o utilizador.
  String _sigOf(Activity a) =>
      '${a.start.millisecondsSinceEpoch}|${a.location}';

  void toggleFavorite(Activity activity) {
    final id = activity.id;
    if (_favorites.remove(id)) {
      // Sai da biblioteca: deixa de ser observado e cancela o lembrete.
      _watchedSig.remove(id);
      if (_reminders.remove(id)) {
        NotificationService.instance.cancelReminder(id);
      }
    } else {
      _favorites.add(id);
      _watchedSig[id] = _sigOf(activity); // baseline para detectar mudanças
    }
    _persistLists();
    _pushCloudPrefs();
    notifyListeners();
  }

  /// Liga/desliga o lembrete de uma sessão e agenda/cancela a notificação local
  /// no telemóvel. Centralizado aqui para ser consistente em todos os ecrãs.
  void toggleReminder(Activity activity, AppLocalizations l) {
    final id = activity.id;
    if (_reminders.remove(id)) {
      // Tira só o sino; a sessão continua na biblioteca (continua observada).
      NotificationService.instance.cancelReminder(id);
    } else {
      _reminders.add(id);
      _favorites.add(id);
      _watchedSig[id] = _sigOf(activity);
      scheduleReminderFor(l, activity, _reminderLeadMinutes);
    }
    _persistLists();
    _pushCloudPrefs();
    notifyListeners();
  }

  // ---- Histórico de notificações (inbox) ----
  static const int _inboxCap = 200;

  /// Histórico, mais recente primeiro.
  List<StoredNotice> get notifications => List.unmodifiable(_inbox);

  /// Quantas ainda não foram lidas (alimenta o badge do sino).
  int get unreadCount => _inbox.where((n) => !n.read).length;

  /// Adiciona um aviso ao histórico se ainda não existir (dedup por [id]).
  /// Devolve true se foi mesmo adicionado. NÃO notifica — o chamador decide.
  bool _addNotice(String id, String title, String body, NotificationKind kind,
      {int? timeMs}) {
    if (_inbox.any((n) => n.id == id)) return false;
    _inbox.insert(
      0,
      StoredNotice(
        id: id,
        title: title,
        body: body,
        timeMs: timeMs ?? DateTime.now().millisecondsSinceEpoch,
        kind: kind,
        read: false,
      ),
    );
    if (_inbox.length > _inboxCap) _inbox.removeRange(_inboxCap, _inbox.length);
    return true;
  }

  /// Marca todas como lidas (chamado ao abrir a aba de Avisos). Limpa o badge.
  void markNotificationsRead() {
    var changed = false;
    for (final n in _inbox) {
      if (!n.read) {
        n.read = true;
        changed = true;
      }
    }
    if (changed) {
      _persistInbox();
      notifyListeners();
    }
  }

  /// Mantém o histórico em dia com o estado das sessões GUARDADAS: boas-vindas
  /// (uma vez), "começa em breve" e "a decorrer". Deduplicado — cada evento
  /// entra uma só vez e fica lá. Chamado periodicamente pelo ecrã inicial.
  void syncSessionAlerts(AppLocalizations l, List<Activity> activities) {
    var changed = _addNotice(
        'welcome', l.notifWelcomeTitle, l.notifWelcomeBody, NotificationKind.aviso);
    final now = DateTime.now();
    final lead = Duration(minutes: _reminderLeadMinutes);
    for (final a in activities) {
      if (!_favorites.contains(a.id)) continue;
      final status = a.statusAt(now);
      if (status == ActivityStatus.live) {
        if (_addNotice(
            'live-${a.id}-${a.start.millisecondsSinceEpoch}',
            l.notifLiveTitle(a.title),
            l.notifLiveBody(a.location),
            NotificationKind.inicio,
            timeMs: a.start.millisecondsSinceEpoch)) {
          changed = true;
        }
      } else {
        final fire = a.start.subtract(lead);
        if (!now.isBefore(fire) && now.isBefore(a.start)) {
          if (_addNotice(
              'soon-${a.id}-${fire.millisecondsSinceEpoch}',
              l.notifStartingSoonTitle(a.title),
              l.notifStartingSoonBody(a.timeRange, a.location),
              NotificationKind.inicio,
              timeMs: fire.millisecondsSinceEpoch)) {
            changed = true;
          }
        }
      }
    }
    if (changed) {
      _persistInbox();
      notifyListeners();
    }
  }

  void _persistInbox() {
    _prefs?.setString(
        _kInbox, jsonEncode(_inbox.map((n) => n.toJson()).toList()));
  }

  // Assinatura da última agenda reconciliada (ids + horas). Evita repetir.
  int _lastReconcileSig = 0;

  /// Chamado sempre que a agenda muda (arranque, pull-to-refresh ou tempo real).
  /// Constrói a sua própria localização a partir do idioma guardado — assim
  /// funciona em qualquer ecrã, sem depender de um `BuildContext`.
  Future<void> onActivitiesChanged(List<Activity> activities) async {
    var sig = 0;
    for (final a in activities) {
      sig ^= Object.hash(
          a.id, a.start.millisecondsSinceEpoch, a.location);
    }
    if (sig == _lastReconcileSig) return;
    _lastReconcileSig = sig;
    if (_favorites.isEmpty) return; // ninguém para avisar
    final l = await AppLocalizations.delegate.load(_locale ?? const Locale('pt'));
    await reconcileReminders(l, activities);
  }

  /// Verifica, sempre que a agenda recarrega, se alguma sessão GUARDADA na
  /// biblioteca mudou (horário ou local). Se mudou, avisa o utilizador de
  /// imediato; se tiver lembrete (sino), também reagenda a notificação. Sessões
  /// vistas pela 1.ª vez só guardam a baseline (sem aviso).
  Future<void> reconcileReminders(
      AppLocalizations l, List<Activity> activities) async {
    var changed = false;
    final byId = {for (final a in activities) a.id: a};
    for (final id in _favorites) {
      final a = byId[id];
      if (a == null) continue; // sessão não está nesta agenda
      final cur = _sigOf(a);
      final prev = _watchedSig[id];
      if (prev == null) {
        _watchedSig[id] = cur; // primeira vez — só regista a baseline
        changed = true;
        continue;
      }
      if (prev == cur) continue; // nada mudou

      final curStart = a.start.millisecondsSinceEpoch;
      final prevStart = int.tryParse(prev.split('|').first);
      final timeChanged = prevStart != curStart;
      if (timeChanged) {
        // Horário mudou: se tiver sino, reagenda o lembrete pré-início.
        if (_reminders.contains(id)) {
          await NotificationService.instance.cancelReminder(id);
          await scheduleReminderFor(l, a, _reminderLeadMinutes);
        }
        final title = l.notifTimeChangedTitle(a.title);
        final body = l.notifTimeChangedBody(a.timeRange, a.location);
        await NotificationService.instance.showNow(
            key: 'changed-$id', title: title, body: body);
        // Cada mudança distinta fica no histórico (id único por nova hora).
        _addNotice('changed-$id-$curStart', title, body, NotificationKind.mudanca);
      } else {
        // Outra mudança (ex.: local da sessão).
        final title = l.notifSessionUpdatedTitle(a.title);
        final body = l.notifTimeChangedBody(a.timeRange, a.location);
        await NotificationService.instance.showNow(
            key: 'updated-$id-${cur.hashCode}', title: title, body: body);
        _addNotice(
            'updated-$id-${cur.hashCode}', title, body, NotificationKind.mudanca);
      }
      _watchedSig[id] = cur;
      changed = true;
    }
    if (changed) {
      _persistLists();
      _persistInbox();
      notifyListeners(); // atualiza o badge
    }
  }

  // ---- Autenticação ----
  /// Sessão Google (Supabase).
  Future<void> signInWithGoogle() => _repo.signInWithGoogle();

  /// Regista uma conta real (email + palavra-passe) no Supabase. O nome vai nos
  /// metadados (o trigger preenche `profiles`). Devolve
  /// [SignUpResult.needsEmailConfirmation] se o Supabase exigir confirmação de
  /// email (sem sessão imediata).
  Future<SignUpResult> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final AuthResponse res;
    try {
      res = await _repo.signUpWithEmail(
          email: email, password: password, nome: name);
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
    return res.session == null
        ? SignUpResult.needsEmailConfirmation
        : SignUpResult.signedIn;
  }

  /// Inicia sessão com email + palavra-passe. O resto (ir para a app, trazer as
  /// preferências da conta) é tratado pelo listener de [authChanges].
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _repo.signInWithEmail(email: email, password: password);
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Pede a reposição de palavra-passe por email.
  Future<void> sendPasswordReset(String email) =>
      _repo.sendPasswordReset(email);

  /// Reenvia o email de confirmação de conta.
  Future<void> resendConfirmation(String email) =>
      _repo.resendConfirmation(email);

  /// Cria/actualiza um perfil local (apenas em SharedPreferences — sem backend).
  /// Usado pelo formulário manual de inscrição.
  Future<void> signUpLocal({
    required String name,
    required String email,
  }) async {
    _localProfile = {
      'name': name.trim(),
      'email': email.trim(),
    };
    _localProfileActive = true;
    await _prefs?.setString(_kLocalProfile, jsonEncode(_localProfile));
    await _prefs?.setBool(_kLocalProfileActive, true);
    notifyListeners();
  }

  /// Reactiva a sessão local guardada (usado no "Bem-vindo de volta").
  Future<void> resumeLocalSession() async {
    if (_localProfile == null) return;
    _localProfileActive = true;
    await _prefs?.setBool(_kLocalProfileActive, true);
    notifyListeners();
  }

  /// Esquece o perfil local guardado (usado em "Não és tu? Usar outra conta")
  /// — limpa dados e desactiva a sessão. Não toca na sessão Google.
  Future<void> forgetLocalProfile() async {
    _localProfile = null;
    _localProfileActive = false;
    await _prefs?.remove(_kLocalProfile);
    await _prefs?.remove(_kLocalProfileActive);
    notifyListeners();
  }

  /// Termina sessão (Google e/ou perfil local). O perfil local **NÃO** é
  /// apagado — fica disponível para "Bem-vindo de volta". Para apagar mesmo,
  /// usar [forgetLocalProfile].
  ///
  /// Atualiza o estado local **imediatamente** e desliga o Supabase em
  /// background com timeout, para a UI não bloquear se a rede estiver lenta.
  Future<void> signOut() async {
    final wasGoogle = _repo.isLoggedIn;
    _signingOut = true;
    _localProfileActive = false;
    notifyListeners(); // AuthGate redireciona imediatamente
    // Persistência local rápida (SharedPreferences).
    await _prefs?.remove(_kLocalProfileActive);
    // Sessão Google em background com timeout — se falhar, ignora (já saímos
    // localmente).
    if (wasGoogle) {
      try {
        await _repo.signOut().timeout(const Duration(seconds: 5));
      } catch (_) {
        // Ignora falhas/timeout; o estado local já está limpo.
      }
    }
    _signingOut = false;
    notifyListeners();
  }

  void _persistLists() {
    _prefs?.setStringList(_kFavorites, _favorites.toList());
    _prefs?.setStringList(_kReminders, _reminders.toList());
    _prefs?.setString(_kWatchedSig, jsonEncode(_watchedSig));
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
