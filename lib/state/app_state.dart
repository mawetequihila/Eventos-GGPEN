import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Estado global: favoritos, lembretes e login (demo). Persiste localmente.
class AppState extends ChangeNotifier {
  static const _kFavorites = 'favorites';
  static const _kReminders = 'reminders';
  static const _kUserName = 'userName';

  final Set<String> _favorites = {};
  final Set<String> _reminders = {};
  String? _userName;

  SharedPreferences? _prefs;

  Set<String> get favorites => Set.unmodifiable(_favorites);
  bool get isLoggedIn => _userName != null;
  String? get userName => _userName;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    _favorites.addAll(prefs.getStringList(_kFavorites) ?? const []);
    _reminders.addAll(prefs.getStringList(_kReminders) ?? const []);
    _userName = prefs.getString(_kUserName);
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

  void login(String name) {
    _userName = name.trim().isEmpty ? 'Convidado' : name.trim();
    _prefs?.setString(_kUserName, _userName!);
    notifyListeners();
  }

  void logout() {
    _userName = null;
    _prefs?.remove(_kUserName);
    notifyListeners();
  }

  void _persistLists() {
    _prefs?.setStringList(_kFavorites, _favorites.toList());
    _prefs?.setStringList(_kReminders, _reminders.toList());
  }
}
