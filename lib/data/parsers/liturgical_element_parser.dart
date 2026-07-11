import 'package:yaml/yaml.dart';
import '../models/liturgical_element.dart';

LiturgicalElementType _parseType(String value) {
  switch (value) {
    case 'saludo':
      return LiturgicalElementType.greeting;
    case 'monicion':
      return LiturgicalElementType.monition;
    case 'rubrica':
      return LiturgicalElementType.rubric;
    case 'titulo':
      return LiturgicalElementType.title;
    case 'lectura':
      return LiturgicalElementType.reading;
    case 'salmo':
      return LiturgicalElementType.psalm;
    case 'preces':
      return LiturgicalElementType.intercessions;
    case 'letania':
      return LiturgicalElementType.litany;
    case 'oracion':
      return LiturgicalElementType.prayer;
    case 'gesto':
      return LiturgicalElementType.gesture;
    case 'respuesta':
      return LiturgicalElementType.response;
    case 'bendicion':
      return LiturgicalElementType.blessing;
    case 'conclusion':
      return LiturgicalElementType.conclusion;
    default:
      throw FormatException('Tipo de elemento desconocido: $value');
  }
}

LiturgicalRole _parseRole(String value) {
  switch (value) {
    case 'celebrante':
      return LiturgicalRole.celebrant;
    case 'lector':
      return LiturgicalRole.lector;
    case 'asamblea':
      return LiturgicalRole.assembly;
    case 'todos':
      return LiturgicalRole.all;
    default:
      throw FormatException('Actor desconocido: $value');
  }
}

LiturgicalElement parseLiturgicalElement(YamlMap map) {
  final optionsYaml = map['opciones'] as YamlList?;
  final options = optionsYaml?.map((o) {
        final om = o as YamlMap;
        final elementsYaml = om['elementos'] as YamlList?;
        final elements = elementsYaml
                ?.map((e) => parseLiturgicalElement(e as YamlMap))
                .toList() ??
            const <LiturgicalElement>[];
        return LiturgicalOption(
          id: om['id'] as String,
          reference: om['referencia'] as String?,
          text: om['texto'] as String?,
          displayName: om['display_name'] as String?,
          heading: om['encabezado'] as String?,
          elements: elements,
        );
      }).toList() ??
      const [];

  final invocationsYaml = map['invocaciones'] as YamlList?;
  final invocations = invocationsYaml?.map((inv) {
        final im = inv as YamlMap;
        return LiturgicalInvocation(
          invocation: im['invocacion'] as String,
          response: im['respuesta'] as String,
        );
      }).toList() ??
      const [];

  final strophesYaml = map['estrofas'] as YamlList?;
  final strophes =
      strophesYaml?.map((s) => s as String).toList() ?? const [];

  return LiturgicalElement(
    id: map['id'] as String,
    type: _parseType(map['tipo'] as String),
    role: _parseRole(map['actor'] as String),
    isRequired: map['obligatorio'] as bool,
    text: map['texto'] as String?,
    reference: map['referencia'] as String?,
    heading: map['encabezado'] as String?,
    response: map['respuesta'] as String?,
    options: options,
    invocations: invocations,
    invitation: map['invitacion'] as String?,
    fixedResponse: map['respuesta_fija'] as String?,
    refrain: map['estribillo'] as String?,
    strophes: strophes,
  );
}