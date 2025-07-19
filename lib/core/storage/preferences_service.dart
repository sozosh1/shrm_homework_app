import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class PreferencesService {
  late final SharedPreferences _preferences;
  @PostConstruct()
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // === Account settings ===
  Future<void> setDefaultAccountId(int accountId) async =>
      await _preferences.setInt('default_account_id', accountId);

  int? getDefaultAccountId() => _preferences.getInt('default_account_id');

  // === sync and auth ===
  Future<void> setLastSyncTime(DateTime dateTime) async => await _preferences
      .setString('last_sync_time', dateTime.toIso8601String());

  DateTime? getLastSyncTime() {
    final string = _preferences.getString('last_sync_time');
    return string != null ? DateTime.tryParse(string) : null;
  }

  // === Theme settings ===
  Future<void> setPrimaryColor(int colorValue) async =>
      await _preferences.setInt('primary_color', colorValue);

  int getPrimaryColor() => _preferences.getInt('primary_color') ?? 0xFF2AE881;

  Future<void> setUseSystemTheme(bool useSystem) async =>
      await _preferences.setBool('use_system_theme', useSystem);

  bool getUseSystemTheme() => _preferences.getBool('use_system_theme') ?? false;

  Future<void> setUserToken(String token) async =>
      await _preferences.setString('user_token', token);

  String? getUserToken() => _preferences.getString('user_token');

  // === ui prefs ===

  Future<void> setBalanceVisibility(bool isVisibile) async =>
      await _preferences.setBool('balance_visibility', isVisibile);

  bool getBalanceVisibility() =>
      _preferences.getBool('balance_visibility') ?? true;

  // === app state ===
  Future<void> setFirstLaunch(bool isFirst) async =>
      await _preferences.setBool('first_launch', isFirst);

  bool isFirstLaunch() => _preferences.getBool('first_launch') ?? true;

  // === search ===
  Future<void> setRecentSearches(List<String> searches) async =>
      await _preferences.setStringList('recent_searches', searches);

  List<String> getRecentSeacrhes() =>
      _preferences.getStringList('recent_searches') ?? [];

  Future<void> addRecentSearch(String search) async {
    if (search.trim().isEmpty) return;

    final searches = getRecentSeacrhes();
    searches.remove(search);
    searches.insert(0, search);

    if (searches.length > 10) searches.removeRange(10, searches.length);

    await setRecentSearches(searches);
  }

  // === currency ===
  Future<void> setAppCurrency(String currency) async =>
      await _preferences.setString('app_currency', currency);

  String? getAppCurrency() => _preferences.getString('app_currency');

  // === clear data ===
  Future<void> clearUserData() async {
    await _preferences.remove('user_token');
    await _preferences.remove('default_account_id');
    await _preferences.remove('last_sync_time');
  }

  Future<void> clearRecentSearches() async =>
      await _preferences.remove('recent_searches');
}
