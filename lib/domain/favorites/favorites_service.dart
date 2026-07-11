import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _key = 'favorites';

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> toggleFavorite(String celebrationId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];
    if (favorites.contains(celebrationId)) {
      favorites.remove(celebrationId);
    } else {
      favorites.add(celebrationId);
    }
    await prefs.setStringList(_key, favorites);
  }

  Future<bool> isFavorite(String celebrationId) async {
    final favorites = await getFavorites();
    return favorites.contains(celebrationId);
  }
}