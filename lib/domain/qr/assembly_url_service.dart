import 'dart:convert';
import 'dart:io';
import '../../data/models/celebration.dart';
import '../../data/models/liturgical_element.dart';

class AssemblyUrlService {
  static const _baseUrl =
      'https://paerichi.github.io/munus-asamblea/';

  String generateUrl(
    Celebration celebration,
    Map<String, String> preferences,
  ) {
    final bloques = <Map<String, String>>[];

    for (final section in celebration.sections) {
      for (final element in section.elements) {
        if (element.type == LiturgicalElementType.rubric ||
            element.type == LiturgicalElementType.title ||
            element.type == LiturgicalElementType.gesture) {
          continue;
        }

        final texto = _resolveText(element, preferences);
        if (texto == null || texto.isEmpty) continue;

        bloques.add({
          'tipo': element.type == LiturgicalElementType.response
              ? 'respuesta'
              : 'celebrante',
          'texto': texto,
        });
      }
    }

    final data = jsonEncode({
      'titulo': celebration.title,
      'bloques': bloques,
    });

    final bytes = utf8.encode(data);
    final compressed = gzip.encode(bytes);
    final encoded = base64Url.encode(compressed);
    return '$_baseUrl?data=$encoded&enc=gz';
  }

  String? _resolveText(
      LiturgicalElement element, Map<String, String> preferences) {
    if (element.options.isNotEmpty) {
      final chosenId = preferences[element.id];
      if (chosenId != null) {
        final chosen =
            element.options.where((o) => o.id == chosenId).firstOrNull;
        if (chosen?.text != null) return chosen!.text;
      }
      return element.options.first.text;
    }

    if (element.type == LiturgicalElementType.litany ||
        element.type == LiturgicalElementType.intercessions) {
      return null;
    }

    return element.text;
  }
}