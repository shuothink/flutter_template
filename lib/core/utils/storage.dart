import 'package:ifl/ifl.dart';
import 'package:ifl/ifl_hive.dart';

abstract final class StorageImpl {
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String localeKey = 'locale';
  static const String darkModeKey = 'dark_mode';

  static const List<String> _managedKeys = <String>[
    authTokenKey,
    refreshTokenKey,
    userIdKey,
    localeKey,
    darkModeKey,
  ];

  static KvStorage? _kvStorage;
  static final Map<String, String> _memoryCache = <String, String>{};

  static Future<void> initialize() async {
    if (_kvStorage != null) return;
    _kvStorage = await initHiveKvStorage();
    await warmUp();
  }

  static Future<void> warmUp() async {
    final storage = _requiredStorage;
    for (final key in _managedKeys) {
      final value = await storage.read(key);
      if (value == null) {
        _memoryCache.remove(key);
      } else {
        _memoryCache[key] = value;
      }
    }
  }

  static KvStorage get _requiredStorage {
    final storage = _kvStorage;
    if (storage == null) {
      throw StateError(
        'StorageImpl is not initialized. Call initialize() before use.',
      );
    }
    return storage;
  }

  // --- Auth Token ---

  static String? getToken() => _memoryCache[authTokenKey];

  static Future<void> setToken(String token) async {
    await _requiredStorage.write(authTokenKey, token);
    _memoryCache[authTokenKey] = token;
  }

  static String? getRefreshToken() => _memoryCache[refreshTokenKey];

  static Future<void> setRefreshToken(String token) async {
    await _requiredStorage.write(refreshTokenKey, token);
    _memoryCache[refreshTokenKey] = token;
  }

  // --- User ID ---

  static String? getUserId() => _memoryCache[userIdKey];

  static Future<void> setUserId(String userId) async {
    await _requiredStorage.write(userIdKey, userId);
    _memoryCache[userIdKey] = userId;
  }

  // --- Preferences ---

  static String? getLocale() => _memoryCache[localeKey];

  static Future<void> setLocale(String locale) async {
    await _requiredStorage.write(localeKey, locale);
    _memoryCache[localeKey] = locale;
  }

  static bool? getDarkMode() {
    final value = _memoryCache[darkModeKey];
    if (value == null) return null;
    if (value == '1') return true;
    if (value == '0') return false;
    return bool.tryParse(value);
  }

  static Future<void> setDarkMode(bool darkMode) async {
    final value = darkMode.toString();
    await _requiredStorage.write(darkModeKey, value);
    _memoryCache[darkModeKey] = value;
  }

  // --- Session Management ---

  static Future<void> saveAuthSession({
    required String userId,
    required String accessToken,
    String? refreshToken,
  }) async {
    await setUserId(userId);
    await setToken(accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await setRefreshToken(refreshToken);
    }
  }

  static Future<void> clearAuthSession() async {
    await _requiredStorage.delete(userIdKey);
    _memoryCache.remove(userIdKey);
    await _requiredStorage.delete(authTokenKey);
    _memoryCache.remove(authTokenKey);
    await _requiredStorage.delete(refreshTokenKey);
    _memoryCache.remove(refreshTokenKey);
  }
}
