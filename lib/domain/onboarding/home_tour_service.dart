import 'package:shared_preferences/shared_preferences.dart';

/// Persistencia de si el usuario ya vio el tour general (pantalla principal).
///
/// Mismo patrón que font_size_service.dart / regional_variant_service.dart:
/// una clase de servicio con lectura/escritura directa a shared_preferences,
/// consumida por un Notifier expuesto vía provider.
class HomeTourService {
  static const _key = 'hasSeenHomeTour';

  Future<bool> hasSeenTour() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  Future<void> markAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }

  /// Solo para debugging/pruebas manuales — no se expone en la UI de
  /// producción. Permite volver a disparar el tour sin desinstalar la app.
  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
