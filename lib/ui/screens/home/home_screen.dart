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
import '../../../domain/onboarding/scroll_into_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _ritualsListKey = GlobalKey();
  final _regionalToggleKey = GlobalKey();
  final _scrollController = ScrollController();
  bool _listKeyAssigned = false;
  bool _tourLaunched = false;
  late final Future<bool> _hasSeenTourFuture;

  @override
  void initState() {
    super.initState();
    _hasSeenTourFuture = ref.read(homeTourServiceProvider).hasSeenTour();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _maybeShowHomeTour(bool hasSeenTour) {
    if (hasSeenTour || _tourLaunched) return;
    _tourLaunched = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final ritualsListKey = _listKeyAssigned ? _ritualsListKey : null;
      // Si por algún motivo el primer paso no tiene target (lista vacía),
      // el tour arranca directo en el toggle -- hay que llevarlo a la
      // vista antes del primer show(), ya que en ese caso no hay un
      // "Siguiente" previo que dispare el scroll.
      if (ritualsListKey == null) {
        await scrollKeyIntoView(_regionalToggleKey, _scrollController);
        if (!mounted) return;
      }
      TutorialCoachMark(
        targets: buildHomeTourTargets(
          ritualsListKey: ritualsListKey,
          regionalToggleKey: _regionalToggleKey,
          scrollController: _scrollController,
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

            // Primer ítem de tipo "celebration" -- ahí (y solo ahí) va el
            // GlobalKey del tour, nunca en el ListView entero (ver nota en
            // home_tour.dart sobre el bug de las franjas grises).
            final firstCelebrationIndex =
                items.indexWhere((i) => i['type'] == 'celebration');
            _listKeyAssigned = firstCelebrationIndex != -1;

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 28),
              itemCount: items.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
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
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                            color: MunusColors.textDiscrete,
                          ),
                        ),
                        const SizedBox(height: 6),
                        KeyedSubtree(
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

                final itemIndex = index - 1;
                final item = items[itemIndex];

                if (item['type'] == 'header') {
                  return Padding(
                    key: ValueKey(item['title']),
                    padding: const EdgeInsets.only(top: 28, bottom: 8),
                    child: Text(
                      item['title']!,
                      style: MunusTextStyles.sectionTitle(
                          FontSizeService.defaultSize),
                    ),
                  );
                }

                final isFavorite = favorites.contains(item['id']);
                final tile = ListTile(
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

                if (itemIndex == firstCelebrationIndex) {
                  return KeyedSubtree(key: _ritualsListKey, child: tile);
                }
                return tile;
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
