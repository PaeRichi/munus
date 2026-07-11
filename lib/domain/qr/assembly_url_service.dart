import 'dart:convert';
import 'dart:io';

class AssemblyUrlService {
  static const _baseUrl =
      'https://paerichi.github.io/munus-asamblea/';

  String generateUrl(
    String assetPath,
    Map<String, String> preferences,
  ) {
    final data = jsonEncode({
      'ritual': assetPath,
      'elecciones': preferences,
    });

    final bytes = utf8.encode(data);
    final compressed = gzip.encode(bytes);
    final encoded = base64Url.encode(compressed);
    return '$_baseUrl?data=$encoded&enc=gz';
  }
}