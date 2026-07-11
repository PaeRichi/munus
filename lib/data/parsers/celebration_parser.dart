import 'package:yaml/yaml.dart';
import '../models/celebration.dart';
import '../models/liturgical_section.dart';
import 'liturgical_element_parser.dart';

Celebration parseCelebration(YamlMap yaml, {required String categoryId}) {
  final metadata = yaml['metadata'] as YamlMap;
  final contenido = yaml['contenido'] as YamlList;

  final elements = contenido
      .map((block) => parseLiturgicalElement(block as YamlMap))
      .toList();

  final section = LiturgicalSection(
    id: 'rito',
    title: 'Rito',
    elements: elements,
  );

  return Celebration(
    id: yaml['id'] as String,
    title: metadata['titulo'] as String,
    advertencia: metadata['advertencia'] as String?,
    categoryId: categoryId,
    sections: [section],
  );
}