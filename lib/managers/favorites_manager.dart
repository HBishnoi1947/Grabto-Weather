import 'package:shared_preferences/shared_preferences.dart';

// Favorites Manager with SharedPreferences
class FavoritesManager {
  static List<String> _favorites = [];
  static const String _favoritesKey = 'favorite_cities';

  static List<String> get favorites => List.from(_favorites);

  static Future<void> initialize() async {
    await _loadFavorites();
  }

  static Future<void> addFavorite(String city) async {
    if (!_favorites.contains(city)) {
      _favorites.add(city);
      await _saveFavorites();
    }
  }

  static Future<void> removeFavorite(String city) async {
    _favorites.remove(city);
    await _saveFavorites();
  }

  static bool isFavorite(String city) {
    return _favorites.contains(city);
  }

  static Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesList = prefs.getStringList(_favoritesKey);
      if (favoritesList != null) {
        _favorites = favoritesList;
      } else {
        // Set default favorites if none exist
        _favorites = ['Indore', 'Bangalore', 'Lucknow'];
        await _saveFavorites();
      }
    } catch (e) {
      print('Error loading favorites: $e');
      // Fallback to default favorites
      _favorites = ['Indore', 'Bangalore', 'Lucknow'];
    }
  }

  static Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, _favorites);
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }
}
