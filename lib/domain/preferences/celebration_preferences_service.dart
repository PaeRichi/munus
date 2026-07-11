import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CelebrationPreferencesService {
  String _key(String celebrationId) => 'prefs_$celebrationId';

  Future<Map<String, String>> getPreferences(String celebrationId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(celebrationId));
    if (raw == null) return {};
    return Map<String, String>.from(jsonDecode(raw));
  }

  Future<void> setOptionChoice(
    String celebrationId,
    String elementId,
    String optionId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getPreferences(celebrationId);
    current[elementId] = optionId;
    await prefs.setString(_key(celebrationId), jsonEncode(current));
  }

  Future<void> clearPreferences(String celebrationId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(celebrationId));
  }
}