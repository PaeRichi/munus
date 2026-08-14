import '../../domain/preferences/regional_variant_service.dart';
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

  /// Convierte una ruta de la biblioteca española (`assets/rituals/...`) en
  /// su equivalente en la carpeta argentina (`assets/rituals_ar/...`),
  /// manteniendo la misma subcarpeta y nombre de archivo. Si ese archivo
  /// todavía no existe (Biblioteca no lo transcribió aún), devuelve la ruta
  /// española original sin avisar ni fallar — fallback silencioso.
  Future<String> resolveAssetPath(
    String basePath,
    RegionalVariant variant,
  ) async {
    if (variant != RegionalVariant.argentina) return basePath;
    if (!basePath.startsWith('assets/rituals/')) return basePath;

    final arPath = basePath.replaceFirst('assets/rituals/', 'assets/rituals_ar/');
    final exists = await _loader.assetExists(arPath);
    return exists ? arPath : basePath;
  }

  Future<Celebration> getCelebration({
    required String assetPath,
    required String categoryId,
  }) async {
    final yaml = await _loader.loadRitual(assetPath);
    return parseCelebration(yaml, categoryId: categoryId);
  }
}