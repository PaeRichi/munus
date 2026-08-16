import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/celebration_repository.dart';
import '../../domain/favorites/favorites_service.dart';
import '../../domain/preferences/celebration_preferences_service.dart';
import '../../domain/preferences/font_size_service.dart';
import '../../domain/preferences/regional_variant_service.dart';
import '../../domain/qr/assembly_url_service.dart';
import '../../domain/onboarding/home_tour_service.dart';
import '../../domain/onboarding/celebration_tour_service.dart';

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

final regionalVariantServiceProvider = Provider<RegionalVariantService>((ref) {
  return RegionalVariantService();
});

final regionalVariantProvider =
    NotifierProvider<RegionalVariantNotifier, RegionalVariant>(
        RegionalVariantNotifier.new);

class RegionalVariantNotifier extends Notifier<RegionalVariant> {
  late final Future<void> _loaded;

  @override
  RegionalVariant build() {
    _loaded = _load();
    return RegionalVariantService.defaultVariant;
  }

  Future<void> _load() async {
    final service = ref.read(regionalVariantServiceProvider);
    final variant = await service.getVariant();
    state = variant;
  }

  /// Espera a que la variante persistida en shared_preferences termine de
  /// cargarse. build() devuelve el default de forma síncrona antes de que
  /// _load() complete; cualquier lector que necesite el valor real ya en su
  /// primer uso (ej. resolver el asset path de un ritual en initState) debe
  /// esperar esto antes de leer el estado, para no quedarse con el default
  /// por una carrera entre la lectura async de disco y una lectura síncrona.
  Future<void> ensureLoaded() => _loaded;

  Future<void> setVariant(RegionalVariant variant) async {
    final service = ref.read(regionalVariantServiceProvider);
    state = variant;
    await service.setVariant(variant);
  }
}

// --- Onboarding: flags de "ya vio el tour" ---
//
// A diferencia de fontSizeProvider/regionalVariantProvider, acá no se usa
// un NotifierProvider con estado observado por otros widgets: nada más en
// la app necesita reaccionar en tiempo real a "¿ya vio el tour?". Cada
// pantalla (Home / Celebración) lo consulta una sola vez al entrar, vía
// estos providers de servicio simples.
final homeTourServiceProvider = Provider<HomeTourService>((ref) {
  return HomeTourService();
});

final celebrationTourServiceProvider = Provider<CelebrationTourService>((ref) {
  return CelebrationTourService();
});