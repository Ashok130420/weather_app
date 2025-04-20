import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static Future<void> clearCache() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }

  static void deleteCache({required String key}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.remove(key);
  }

  static Future<bool> getBool({
    required String key,
  }) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    return sharedPreferences.getBool(key) ?? false;
  }

  static Future<Set<String>> getKeys() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getKeys();
  }

  static Future<bool> hasCache({required String key}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.containsKey(key);
  }

  static Future<bool> isExists(String key) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.containsKey(key);
  }

  static Future<String> readCache({required String key}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString(key) ?? "";
  }

  static Future<bool> writeBool(
      {required String key, required bool value}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.setBool(key, value);
  }

  static Future<void> writeCache(
      {required String key, required String value}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString(key, value);
  }

  static Future<void> writeListCache(
      {required String key, required List<String> value}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setStringList(key, value);
  }

  static Future<List<String>?> readListCache({required String key}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getStringList(key);
  }
}
