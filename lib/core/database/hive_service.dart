import 'package:hive_flutter/hive_flutter.dart';
import '../config/env_config.dart';

class HiveService {
  static const String settingsBoxName = 'settings_box';
  static const String favoritesBoxName = 'favorites_box';
  static const String searchHistoryBoxName = 'search_history_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(settingsBoxName);
    await Hive.openBox(favoritesBoxName);
    await Hive.openBox(searchHistoryBoxName);
  }

  // Settings getters & setters
  static Box get _settingsBox => Hive.box(settingsBoxName);
  static Box get _favoritesBox => Hive.box(favoritesBoxName);
  static Box get _searchBox => Hive.box(searchHistoryBoxName);

  static bool get isDarkMode => _settingsBox.get('is_dark_mode', defaultValue: true);
  static Future<void> setDarkMode(bool val) => _settingsBox.put('is_dark_mode', val);

  static String get customTileUrl => _settingsBox.get(
        'custom_tile_url',
        defaultValue: EnvConfig.defaultMapTileUrl,
      );
  static Future<void> setCustomTileUrl(String url) => _settingsBox.put('custom_tile_url', url);

  static String get customApiKey => _settingsBox.get(
        'custom_api_key',
        defaultValue: EnvConfig.mapApiKey,
      );
  static Future<void> setCustomApiKey(String key) => _settingsBox.put('custom_api_key', key);

  // Favorites
  static List<int> get favoriteBusIds =>
      List<int>.from(_favoritesBox.get('bus_ids', defaultValue: <int>[]));

  static Future<void> toggleFavorite(int busId) async {
    final list = favoriteBusIds;
    if (list.contains(busId)) {
      list.remove(busId);
    } else {
      list.add(busId);
    }
    await _favoritesBox.put('bus_ids', list);
  }

  // Search History
  static List<String> get recentSearches =>
      List<String>.from(_searchBox.get('queries', defaultValue: <String>[]));

  static Future<void> addSearchQuery(String query) async {
    final list = recentSearches;
    list.remove(query);
    list.insert(0, query);
    if (list.length > 10) list.removeLast();
    await _searchBox.put('queries', list);
  }
}
