// lib/data/favorites_local.dart
// Favoritos guardados SO no telemovel (sem backend), via shared_preferences.

import 'package:shared_preferences/shared_preferences.dart';

class FavoritesLocal {
  static const _key = 'favorites_activity_ids';

  Future<Set<String>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? const <String>[]).toSet();
  }

  Future<bool> isFavorite(String activityId) async {
    return (await getAll()).contains(activityId);
  }

  /// Adiciona se nao existir, remove se existir. Devolve o novo estado.
  Future<bool> toggle(String activityId) async {
    final prefs = await SharedPreferences.getInstance();
    final all = (prefs.getStringList(_key) ?? const <String>[]).toSet();
    final added = all.add(activityId);
    if (!added) all.remove(activityId);
    await prefs.setStringList(_key, all.toList());
    return added; // true = ficou favorito; false = deixou de ser
  }
}