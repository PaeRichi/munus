import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/celebration_repository.dart';
import '../../domain/favorites/favorites_service.dart';
import '../../domain/preferences/celebration_preferences_service.dart';
import '../../domain/preferences/font_size_service.dart';
import '../../domain/qr/assembly_url_service.dart';

final assemblyUrlServiceProvider = Provider<AssemblyUrlService>((ref) {
  return AssemblyUrlService();
});

final celebrationRepositoryProvider = Provider<CelebrationRepository>((ref) {
  return CelebrationRepository();
});

final favoritesServiceProvider = Provider<FavoritesService>((ref) {
  return FavoritesService();
});

final favoritesProvider = FutureProvider<List<String>>((ref) async {
  final service = ref.watch(favoritesServiceProvider);
  return service.getFavorites();
});

final celebrationPreferencesServiceProvider =
    Provider<CelebrationPreferencesService>((ref) {
  return CelebrationPreferencesService();
});

final celebrationPreferencesProvider =
    FutureProvider.family<Map<String, String>, String>((ref, celebrationId) async {
  final service = ref.watch(celebrationPreferencesServiceProvider);
  return service.getPreferences(celebrationId);
});

final fontSizeServiceProvider = Provider<FontSizeService>((ref) {
  return FontSizeService();
});

final fontSizeProvider =
    NotifierProvider<FontSizeNotifier, double>(FontSizeNotifier.new);

class FontSizeNotifier extends Notifier<double> {
  @override
  double build() {
    _load();
    return FontSizeService.defaultSize;
  }

  Future<void> _load() async {
    final service = ref.read(fontSizeServiceProvider);
    final size = await service.getFontSize();
    state = size;
  }

  Future<void> increase() async {
    final service = ref.read(fontSizeServiceProvider);
    final newSize =
        (state + 1).clamp(FontSizeService.minSize, FontSizeService.maxSize);
    state = newSize;
    await service.setFontSize(newSize);
  }

  Future<void> decrease() async {
    final service = ref.read(fontSizeServiceProvider);
    final newSize =
        (state - 1).clamp(FontSizeService.minSize, FontSizeService.maxSize);
    state = newSize;
    await service.setFontSize(newSize);
  }
}