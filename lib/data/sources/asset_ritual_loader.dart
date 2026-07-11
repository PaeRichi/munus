import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

class AssetRitualLoader {
  Future<YamlMap> loadRitual(String assetPath) async {
    final content = await rootBundle.loadString(assetPath);
    return loadYaml(content) as YamlMap;
  }
}