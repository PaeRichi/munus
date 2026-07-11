import 'liturgical_element.dart';

class LiturgicalSection {
  final String id;
  final String title;
  final List<LiturgicalElement> elements;

  const LiturgicalSection({
    required this.id,
    required this.title,
    required this.elements,
  });
}