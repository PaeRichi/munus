import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/preferences/font_size_service.dart';
import '../../widgets/common/regional_variant_toggle.dart';
import '../../../domain/onboarding/home_tour.dart';
import '../../../domain/onboarding/tour_finish_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _ritualsListKey = GlobalKey();
  final _regionalToggleKey = GlobalKey();
  bool _tourLaunched = false;
  // Ver nota equivalente en celebration_screen.dart: consulta directa al
  // servicio, no vía NotifierProvider -- evita la ventana donde el valor
  // default se muestra antes de que cargue el real.
  late final Future<bool> _hasSeenTourFuture;

  @override
  void initState() {
    super.initState();
    _hasSeenTourFuture = ref.read(homeTourServiceProvider).hasSeenTour();
  }

  void _maybeShowHomeTour(bool hasSeenTour) {
    if (hasSeenTour || _tourLaunched) return;
    _tourLaunched = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      TutorialCoachMark(
        targets: buildHomeTourTargets(
          ritualsListKey: _ritualsListKey,
          regionalToggleKey: _regionalToggleKey,
        ),
        colorShadow: Colors.black,
        opacityShadow: 0.8,
        paddingFocus: 8,
        hideSkip: true,
        onFinish: () {
          ref.read(homeTourServiceProvider).markAsSeen();
          showTourFinishDialog(
            context,
            message: 'Ya estás listo para usar Munus.',
          );
        },
      ).show(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(celebrationRepositoryProvider);
    final favoritesAsync = ref.watch(favoritesProvider);
    final categories = repository.getCategories();

    if (!_tourLaunched) {
      _hasSeenTourFuture.then(_maybeShowHomeTour);
    }

    return Scaffold(
      body: SafeArea(
        child: favoritesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) =>
              const Center(child: Text('Error al cargar favoritos')),
          data: (favorites) {
            final items = <Map<String, String?>>[];

            // Sección favoritos
            if (favorites.isNotEmpty) {
              items.add({'type': 'header', 'title': 'FRECUENTES'});
              for (final category in categories) {
                final celebrations =
                    repository.getCelebrationsByCategory(category.id);
                for (final celebration in celebrations) {
                  if (favorites.contains(celebration['id'])) {
                    items.add({
                      'type': 'celebration',
                      'title': celebration['title'],
                      'categoryId': category.id,
                      'id': celebration['id'],
                      'assetPath': celebration['assetPath'],
                    });
                  }
                }
              }
            }

            // Secciones por categoría
             for (final category in categories) {
              final celebrations =
                  repository.getCelebrationsByCategory(category.id);
              final nonFavoriteCelebrations = celebrations
                  .where((c) => !favorites.contains(c['id']))
                  .toList();

              if (nonFavoriteCelebrations.isEmpty) continue;

              items.add({
                'type': 'header',
                'title': category.title.toUpperCase(),
              });
              for (final celebration in nonFavoriteCelebrations) {
                items.add({
                  'type': 'celebration',
                  'title': celebration['title'],
                  'categoryId': category.id,
                  'id': celebration['id'],
                  'assetPath': celebration['assetPath'],
                });
              }
            }

            return ListView.builder(
              key: _ritualsListKey,
              padding: const EdgeInsets.symmetric(horizontal: 28),
              itemCount: items.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    // Antes: top 56 / bottom 40. Se achica el espacio
                    // hasta "FRECUENTES" ~14% a pedido de Producto (logo
                    // demasiado separado del contenido). Si hace falta
                    // afinar más, tocar bottom acá y/o el top del header
                    // más abajo -- son los dos únicos números en juego.
                    padding: const EdgeInsets.only(top: 52, bottom: 34),
                    child: Text(
                      'MUNUS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: MunusFonts.display,
                        fontSize: 52,
                        fontWeight: FontWeight.w200,
                        color: MunusColors.textMain,
                        letterSpacing: 12,
                      ),
                    ),
                  );
                }

                if (index == items.length + 1) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 24),
                    child: Column(
                      children: [
                        Text(
                          'Traducción:',
                          style: TextStyle(
                            fontFamily: MunusFonts.ui,
                            // Antes 9px -- Producto pidió más presencia
                            // porque es una función importante (y parte
                            // del tour inicial). Subido a 11 + peso medio,
                            // sigue discreto pero más legible.
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                            color: MunusColors.textDiscrete,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          key: _regionalToggleKey,
                          child: const RegionalVariantToggle(dense: true),
                        ),
                        const SizedBox(height: 28),
                        GestureDetector(
                          onTap: () => context.push('/about'),
                          child: Icon(
                            Icons.info_outline,
                            color: MunusColors.textDiscrete,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final item = items[index - 1];
                if (item['type'] == 'header') {
                  return Padding(
                    key: ValueKey(item['title']),
                    // Antes top 32 / bottom 8. Baja levemente junto con
                    // el ajuste del logo de arriba, mismo pedido de
                    // Producto (achicar el vacío MUNUS -> FRECUENTES).
                    padding: const EdgeInsets.only(top: 28, bottom: 8),
                    child: Text(
                      item['title']!,
                      style: MunusTextStyles.sectionTitle(
                          FontSizeService.defaultSize),
                    ),
                  );
                }

                final isFavorite = favorites.contains(item['id']);
                return ListTile(
                  key: ValueKey(item['id']),
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item['title']!,
                    style: MunusTextStyles.bodyText(FontSizeService.defaultSize),
                  ),
                  trailing: isFavorite
                      ? _FavoriteRibbon(
                          onRemove: () async {
                            final service = ref.read(favoritesServiceProvider);
                            await service.toggleFavorite(item['id']!);
                            ref.invalidate(favoritesProvider);
                          },
                        )
                      : Icon(
                          Icons.chevron_right,
                          color: MunusColors.textDiscrete,
                          size: 22,
                        ),
                  onTap: () => context.push(
                    '/category/${item['categoryId']}/celebration',
                    extra: {
                      'title': item['title'],
                      'assetPath': item['assetPath'],
                      'id': item['id'],
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
class _FavoriteRibbon extends StatefulWidget {
  final VoidCallback onRemove;

  const _FavoriteRibbon({required this.onRemove});

  @override
  State<_FavoriteRibbon> createState() => _FavoriteRibbonState();
}

class _FavoriteRibbonState extends State<_FavoriteRibbon> {
  bool _removing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _removing
          ? null
          : () {
              setState(() => _removing = true);
              Future.delayed(const Duration(milliseconds: 220), () {
                widget.onRemove();
              });
            },
      child: AnimatedScale(
        scale: _removing ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeIn,
        child: Image.asset(
          'assets/images/tirita_sola.png',
          height: 42,
        ),
      ),
    );
  }
}
