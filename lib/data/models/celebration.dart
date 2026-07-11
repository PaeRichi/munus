import 'liturgical_section.dart';

class Celebration {
  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final String? advertencia;
  final String categoryId;
  final List<LiturgicalSection> sections;
  final List<Celebration> variants;

  const Celebration({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    this.advertencia,
    required this.categoryId,
    required this.sections,
    this.variants = const [],
  });
}