import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/ggpen_repository.dart';

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
    _authSub = _repo.authChanges.listen((_) => notifyListeners());
  }

  final Set<String> _favorites = {};
  final Set<String> _reminders = {};
  Locale? _locale;
  int _reminderLeadMinutes = 15;
  Map<String, String>? _localProfile;

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

  /// Termina sessão (Google e/ou perfil local) e limpa o perfil persistido.
  Future<void> signOut() async {
    if (_repo.isLoggedIn) {
      await _repo.signOut();
    }
    if (_localProfile != null) {
      _localProfile = null;
      await _prefs?.remove(_kLocalProfile);
    }
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
