import 'package:shared_preferences/shared_preferences.dart';

/// Persistencia de si el usuario ya vio el tour de celebración.
///
/// Se dispara una sola vez, la primera vez que se entra a CUALQUIER ritual
/// (no por ritual individual) — un único flag global, igual que
/// hasSeenHomeTour.
class CelebrationTourService {
  static const _key = 'hasSeenCelebrationTour';

  Future<bool> hasSeenTour() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  Future<void> markAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
