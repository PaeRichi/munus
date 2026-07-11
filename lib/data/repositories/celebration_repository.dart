import '../models/category.dart';
import '../models/celebration.dart';
import '../parsers/celebration_parser.dart';
import '../sources/asset_ritual_loader.dart';
import '../sources/local/celebrations_data.dart';

class CelebrationRepository {
  final AssetRitualLoader _loader;

  CelebrationRepository({AssetRitualLoader? loader})
      : _loader = loader ?? AssetRitualLoader();

  List<Category> getCategories() {
    final visible = initialCategories.where((c) => c.isVisible).toList();
    visible.sort((a, b) => a.order.compareTo(b.order));
    return visible;
  }

  List<Map<String, String>> getCelebrationsByCategory(String categoryId) {
    return celebrationsByCategory[categoryId] ?? [];
  }

  Future<Celebration> getCelebration({
    required String assetPath,
    required String categoryId,
  }) async {
    final yaml = await _loader.loadRitual(assetPath);
    return parseCelebration(yaml, categoryId: categoryId);
  }
}