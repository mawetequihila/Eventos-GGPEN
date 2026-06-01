import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/ggpen_repository.dart';

/// Estado da sessão para decidir o ecrã raiz.
/// - loggedOut: sem sessão
/// - checking: sessão Google iniciada, a verificar o perfil
/// - needsProfile: Google sem telefone/empresa/cargo → completar perfil
/// - ready: pronto para a app
enum AuthStatus { loggedOut, checking, needsProfile, ready }

/// Estado global: favoritos e lembretes (locais), idioma (local) e sessão
/// (autenticação Google via Supabase). Favoritos NUNCA vão para o backend.
class AppState extends ChangeNotifier {
  static const _kFavorites = 'favorites';
  static const _kReminders = 'reminders';
  static const _kLocale = 'locale';
  static const _kLeadMinutes = 'reminderLeadMinutes';
  static const _kLocalProfile = 'localProfile';

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
      // Sessão mudou: voltar a verificar o perfil do Supabase.
      _profileChecked = false;
      _profile = null;
      _profileDismissed = false;
      notifyListeners();
      if (_repo.isLoggedIn) _checkProfile();
    });
  }

  final Set<String> _favorites = {};
  final Set<String> _reminders = {};
  Locale? _locale;
  int _reminderLeadMinutes = 15;
  Map<String, String>? _localProfile;

  // Perfil Supabase (Google): linha de `profiles` + estado da verificação.
  Map<String, dynamic>? _profile;
  bool _profileChecked = false;
  bool _profileDismissed = false;

  SharedPreferences? _prefs;
  StreamSubscription<AuthState>? _authSub;

  Set<String> get favorites => Set.unmodifiable(_favorites);

  /// Sessão iniciada — Google (Supabase) OU perfil local.
  bool get isLoggedIn => _repo.isLoggedIn || _localProfile != null;

  /// Perfil local (quando o utilizador se inscreveu pelo formulário). Apenas
  /// guardado em SharedPreferences. Sem backend.
  Map<String, String>? get localProfile =>
      _localProfile == null ? null : Map.unmodifiable(_localProfile!);

  /// Nome a mostrar do utilizador autenticado (Google ou perfil local).
  String? get userName {
    final user = _repo.currentUser;
    if (user != null) {
      final meta = user.userMetadata;
      final fullName = meta?['full_name'] ?? meta?['name'];
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
    if (_repo.isLoggedIn) {
      if (_profileDismissed) return AuthStatus.ready;
      if (!_profileChecked) return AuthStatus.checking;
      return _profileNeedsCompletion
          ? AuthStatus.needsProfile
          : AuthStatus.ready;
    }
    if (_localProfile != null) return AuthStatus.ready;
    return AuthStatus.loggedOut;
  }

  bool get _profileNeedsCompletion {
    final p = _profile;
    bool empty(dynamic v) => v == null || (v is String && v.trim().isEmpty);
    if (p == null) return true;
    return empty(p['telefone']) || empty(p['empresa']) || empty(p['cargo']);
  }

  // Campos do perfil (para pré-preencher o formulário).
  String? get profilePhone => _profile?['telefone'] as String?;
  String? get profileCompany => _profile?['empresa'] as String?;
  String? get profileRole => _profile?['cargo'] as String?;

  /// Idioma escolhido. `null` = seguir o idioma do sistema.
  Locale? get locale => _locale;

  /// Minutos antes do início em que a app avisa (0 = no momento).
  int get reminderLeadMinutes => _reminderLeadMinutes;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    _favorites.addAll(prefs.getStringList(_kFavorites) ?? const []);
    _reminders.addAll(prefs.getStringList(_kReminders) ?? const []);
    final code = prefs.getString(_kLocale);
    if (code != null && code.isNotEmpty) {
      _locale = Locale(code);
    }
    _reminderLeadMinutes = prefs.getInt(_kLeadMinutes) ?? 15;
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
    // Se já há sessão Google ativa (app reaberta), verifica o perfil.
    if (_repo.isLoggedIn) _checkProfile();
  }

  /// Define a antecedência do lembrete (minutos antes de começar) e persiste.
  void setReminderLeadMinutes(int minutes) {
    _reminderLeadMinutes = minutes;
    _prefs?.setInt(_kLeadMinutes, minutes);
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
    notifyListeners();
  }

  bool isFavorite(String id) => _favorites.contains(id);
  bool isReminder(String id) => _reminders.contains(id);

  void toggleFavorite(String id) {
    if (_favorites.remove(id)) {
      _reminders.remove(id);
    } else {
      _favorites.add(id);
    }
    _persistLists();
    notifyListeners();
  }

  void toggleReminder(String id) {
    if (_reminders.remove(id)) {
      // removido
    } else {
      _reminders.add(id);
      _favorites.add(id);
    }
    _persistLists();
    notifyListeners();
  }

  // ---- Autenticação ----
  /// Sessão Google (Supabase).
  Future<void> signInWithGoogle() => _repo.signInWithGoogle();

  /// Cria/actualiza um perfil local (apenas em SharedPreferences — sem backend).
  /// Usado pelo formulário manual de inscrição.
  Future<void> signUpLocal({
    required String name,
    required String email,
    required String phone,
    required String company,
    required String role,
  }) async {
    _localProfile = {
      'name': name.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'company': company.trim(),
      'role': role.trim(),
    };
    await _prefs?.setString(_kLocalProfile, jsonEncode(_localProfile));
    notifyListeners();
  }

  /// Lê o perfil do Supabase (após login Google) para saber se faltam dados.
  Future<void> _checkProfile() async {
    try {
      _profile = await _repo.getMyProfile();
    } catch (_) {
      _profile = null;
    } finally {
      _profileChecked = true;
      notifyListeners();
    }
  }

  /// Grava os campos extra (telefone, empresa, cargo) na tabela `profiles`.
  Future<void> saveProfileExtra({
    required String telefone,
    required String empresa,
    required String cargo,
  }) async {
    await _repo.updateMyProfile(
      telefone: telefone.trim(),
      empresa: empresa.trim(),
      cargo: cargo.trim(),
    );
    await _checkProfile();
  }

  /// Permite avançar sem completar agora (volta a perguntar no próximo arranque).
  void dismissProfilePrompt() {
    _profileDismissed = true;
    notifyListeners();
  }

  /// Termina sessão (Google e/ou perfil local) e limpa o perfil persistido.
  Future<void> signOut() async {
    if (_repo.isLoggedIn) {
      await _repo.signOut();
    }
    if (_localProfile != null) {
      _localProfile = null;
      await _prefs?.remove(_kLocalProfile);
    }
    _profile = null;
    _profileChecked = false;
    _profileDismissed = false;
    notifyListeners();
  }

  void _persistLists() {
    _prefs?.setStringList(_kFavorites, _favorites.toList());
    _prefs?.setStringList(_kReminders, _reminders.toList());
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
