import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String _userBox = 'user';
  static const String _settingsBox = 'settings';
  static const String _cacheBox = 'cache';
  
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';
  static const String _languageKey = 'language';
  static const String _themeKey = 'theme';

  static Future<void> init() async {
    await Hive.openBox(_userBox);
    await Hive.openBox(_settingsBox);
    await Hive.openBox(_cacheBox);
  }

  // Token Management
  static Future<void> saveToken(String token) async {
    final box = Hive.box(_userBox);
    await box.put(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final box = Hive.box(_userBox);
    return box.get(_tokenKey);
  }

  static Future<void> clearToken() async {
    final box = Hive.box(_userBox);
    await box.delete(_tokenKey);
  }

  // User Data
  static Future<void> saveUser(Map<String, dynamic> user) async {
    final box = Hive.box(_userBox);
    await box.put(_userKey, user);
  }

  static Map<String, dynamic>? getUser() {
    final box = Hive.box(_userBox);
    return box.get(_userKey);
  }

  static Future<void> clearUser() async {
    final box = Hive.box(_userBox);
    await box.delete(_userKey);
  }

  // Settings
  static Future<void> saveLanguage(String language) async {
    final box = Hive.box(_settingsBox);
    await box.put(_languageKey, language);
  }

  static String getLanguage() {
    final box = Hive.box(_settingsBox);
    return box.get(_languageKey, defaultValue: 'en');
  }

  static Future<void> saveTheme(String theme) async {
    final box = Hive.box(_settingsBox);
    await box.put(_themeKey, theme);
  }

  static String getTheme() {
    final box = Hive.box(_settingsBox);
    return box.get(_themeKey, defaultValue: 'light');
  }

  // Cache Management
  static Future<void> cacheData(String key, dynamic data) async {
    final box = Hive.box(_cacheBox);
    await box.put(key, data);
  }

  static dynamic getCachedData(String key) {
    final box = Hive.box(_cacheBox);
    return box.get(key);
  }

  static Future<void> clearCache() async {
    final box = Hive.box(_cacheBox);
    await box.clear();
  }

  // Offline Data
  static Future<void> saveOfflineData(String key, dynamic data) async {
    final box = Hive.box(_cacheBox);
    await box.put('offline_$key', {
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static Map<String, dynamic>? getOfflineData(String key) {
    final box = Hive.box(_cacheBox);
    return box.get('offline_$key');
  }

  static Future<void> clearAllData() async {
    await clearToken();
    await clearUser();
    await clearCache();
  }

  static bool isLoggedIn() {
    final box = Hive.box(_userBox);
    return box.get(_tokenKey) != null;
  }
}
