import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSizeService {
  static const _key = 'font_size';
  static const double defaultSize = 17;
  static const double minSize = 14;

  // Antes era `static const double maxSize = 22;` fijo para todos los
  // dispositivos. En iPad ese techo se quedaba chico -- tiene sentido
  // además pensando que un iPad probablemente se apoya en un atril, más
  // lejos de los ojos que un teléfono en la mano, así que hace falta
  // letra proporcionalmente más grande, no solo "hay más lugar en
  // pantalla".
  //
  // 600 puntos lógicos de lado más corto es el mismo corte que usan
  // Android e iOS para distinguir teléfono de tablet.
  //
  // Es un getter (no un const) porque depende del dispositivo en tiempo
  // de ejecución. Usamos PlatformDispatcher en vez de BuildContext
  // porque este valor también hace falta desde FontSizeNotifier
  // (Riverpod, en repository_providers.dart), que no tiene acceso
  // directo a un context de widget.
  static double get maxSize => _isTablet ? 30 : 22;

  static bool get _isTablet {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final shortestSide =
        view.physicalSize.shortestSide / view.devicePixelRatio;
    return shortestSide >= 600;
  }

  Future<double> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_key) ?? defaultSize;
  }

  Future<void> setFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_key, size.clamp(minSize, maxSize));
  }
}
