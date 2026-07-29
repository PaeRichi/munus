import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/preferences/font_size_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(celebrationRepositoryProvider);
    final favoritesAsync = ref.watch(favoritesProvider);
    final categories = repository.getCategories();

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
              padding: const EdgeInsets.symmetric(horizontal: 28),
              itemCount: items.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 56, bottom: 40),
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
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: GestureDetector(
                        onTap: () => context.push('/about'),
                        child: Icon(
                          Icons.info_outline,
                          color: MunusColors.textDiscrete,
                          size: 18,
                        ),
                      ),
                    ),
                  );
                }

                final item = items[index - 1];
                if (item['type'] == 'header') {
                  return Padding(
                    padding: const EdgeInsets.only(top: 32, bottom: 8),
                    child: Text(
                      item['title']!,
                      style: MunusTextStyles.sectionTitle(
                          FontSizeService.defaultSize),
                    ),
                  );
                }

                final isFavorite = favorites.contains(item['id']);
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item['title']!,
                    style: MunusTextStyles.bodyText(FontSizeService.defaultSize),
                  ),
                  trailing: isFavorite
                      ? Image.asset(
                          'assets/images/tirita_sola.png',
                          height: 32,
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