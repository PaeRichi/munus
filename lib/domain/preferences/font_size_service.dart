import 'package:shared_preferences/shared_preferences.dart';

class FontSizeService {
  static const _key = 'font_size';
  static const double defaultSize = 17;
  static const double minSize = 14;
  static const double maxSize = 22;

  Future<double> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_key) ?? defaultSize;
  }

  Future<void> setFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_key, size.clamp(minSize, maxSize));
  }
}