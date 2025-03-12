abstract class IPreference {
  Future<void> setPreferenceValue(
      {required String preferenceKey, dynamic value});

  Future<dynamic> getPreferenceValue(
      {required String preferenceKey, dynamic defaultValue});

  Future<void> clearPreference();

  Future<void> clearPreferenceKey({required String key});
}
