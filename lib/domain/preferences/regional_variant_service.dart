import 'package:shared_preferences/shared_preferences.dart';

enum RegionalVariant { espana, argentina }

class RegionalVariantService {
  static const _key = 'regional_variant';
  static const defaultVariant = RegionalVariant.espana;

  Future<RegionalVariant> getVariant() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    return stored == RegionalVariant.argentina.name
        ? RegionalVariant.argentina
        : RegionalVariant.espana;
  }

  Future<void> setVariant(RegionalVariant variant) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, variant.name);
  }
}
