import 'package:fluttersampleapp/core/storage/i_preference.dart';
import 'package:fluttersampleapp/core/storage/preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceImpl implements IPreference {
  @override
  Future<void> clearPreference() async {
    final SharedPreferences prefs = await Preference.getSharedPreference();
    prefs.clear();
  }

  @override
  Future<dynamic> getPreferenceValue(
      {required String preferenceKey, defaultValue}) async {
    final SharedPreferences prefs = await Preference.getSharedPreference();
    if (defaultValue is String) {
      return prefs.getString(preferenceKey) ?? defaultValue;
    } else if (defaultValue is int) {
      return prefs.getInt(preferenceKey) ?? defaultValue;
    } else if (defaultValue is double) {
      return prefs.getDouble(preferenceKey) ?? defaultValue;
    } else if (defaultValue is bool) {
      return prefs.getBool(preferenceKey) ?? defaultValue;
    } else {
      return prefs.getStringList(preferenceKey) ?? defaultValue;
    }
  }

  @override
  Future<void> setPreferenceValue(
      {required String preferenceKey, value}) async {
    final SharedPreferences prefs = await Preference.getSharedPreference();
    if (value is String) {
      prefs.setString(preferenceKey, value);
    } else if (value is int) {
      prefs.setInt(preferenceKey, value);
    } else if (value is double) {
      prefs.setDouble(preferenceKey, value);
    } else if (value is bool) {
      prefs.setBool(preferenceKey, value);
    } else {
      prefs.setStringList(preferenceKey, value);
    }
  }

  @override
  Future<void> clearPreferenceKey({required String key}) async {
    final SharedPreferences prefs = await Preference.getSharedPreference();
    prefs.remove(key);
  }
}
