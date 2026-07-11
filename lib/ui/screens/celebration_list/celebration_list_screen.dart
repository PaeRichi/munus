import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/repository_providers.dart';

class CelebrationListScreen extends ConsumerWidget {
  final String categoryId;

  const CelebrationListScreen({super.key, required this.categoryId});
String _capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(celebrationRepositoryProvider);
    final celebrations = repository.getCelebrationsByCategory(categoryId);

    return Scaffold(
      appBar: AppBar(title: Text(_capitalize (categoryId))),
      body: celebrations.isEmpty
          ? const Center(child: Text('Sin celebraciones todavía.'))
          : ListView.builder(
              itemCount: celebrations.length,
              itemBuilder: (context, index) {
                final celebration = celebrations[index];
                return ListTile(
                  title: Text(celebration['title']!),
                  onTap: () => context.push(
                    '/category/$categoryId/celebration',
                    extra: celebration,
                  ),
                );
              },
            ),
    );
  }
}