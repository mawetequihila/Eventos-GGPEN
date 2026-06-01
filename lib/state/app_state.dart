import 'dart:async';

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

  SharedPreferences? _prefs;
  StreamSubscription<AuthState>? _authSub;

  Set<String> get favorites => Set.unmodifiable(_favorites);

  /// Sessão Google iniciada?
  bool get isLoggedIn => _repo.isLoggedIn;

  /// Nome a mostrar do utilizador autenticado (ou `null` sem sessão).
  String? get userName {
    final user = _repo.currentUser;
    if (user == null) return null;
    final meta = user.userMetadata;
    final fullName = meta?['full_name'] ?? meta?['name'];
    if (fullName is String && fullName.trim().isNotEmpty) return fullName.trim();
    final email = user.email;
    if (email != null && email.isNotEmpty) return email.split('@').first;
    return null;
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

  // ---- Autenticação (Google via Supabase) ----
  Future<void> signInWithGoogle() => _repo.signInWithGoogle();

  Future<void> signOut() => _repo.signOut();

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
