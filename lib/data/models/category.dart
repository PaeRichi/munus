class Category {
  final String id;
  final String title;
  final String? description;
  final String? icon;
  final int order;
  final bool isVisible;

  const Category({
    required this.id,
    required this.title,
    this.description,
    this.icon,
    required this.order,
    this.isVisible = true,
  });
}