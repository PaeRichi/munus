import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../data/models/celebration.dart';
import '../../../data/models/liturgical_element.dart';
import '../../widgets/celebration/liturgical_element_widget.dart';
import '../../../core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';


class CelebrationScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final Map<String, String> celebrationMeta;

  const CelebrationScreen({
    super.key,
    required this.categoryId,
    required this.celebrationMeta,
  });

  @override
  ConsumerState<CelebrationScreen> createState() => _CelebrationScreenState();
}

class _CelebrationScreenState extends ConsumerState<CelebrationScreen> {
  bool showOptional = false;
  late final Future<Celebration> _celebrationFuture;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _celebrationFuture = ref.read(celebrationRepositoryProvider).getCelebration(
          assetPath: widget.celebrationMeta['assetPath']!,
          categoryId: widget.categoryId,
        );
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  /// Arma la lista de bloques a mostrar. Cuando un título de sección está
  /// seguido, sin nada en el medio, por un bloque que tiene opciones, los
  /// combina en una sola línea: título a la izquierda, botón "Elegir
  /// fórmula" a la derecha. En cualquier otro caso, cada bloque se muestra
  /// como siempre, con su propio botón (si tiene opciones) arriba del texto.
  List<Widget> _buildElementWidgets(
    List<LiturgicalElement> elements,
    Map<String, String> preferences,
    double fontSize,
    String celebrationId,
  ) {
    final widgets = <Widget>[];

    void addSpacer() {
      if (widgets.isNotEmpty) widgets.add(const SizedBox(height: 20));
    }

    Future<void> handleSelected(String elementId, String optionId) async {
      final service = ref.read(celebrationPreferencesServiceProvider);
      await service.setOptionChoice(celebrationId, elementId, optionId);
      ref.invalidate(celebrationPreferencesProvider(celebrationId));
    }

    var i = 0;
    while (i < elements.length) {
      final el = elements[i];
      final next = (i + 1 < elements.length) ? elements[i + 1] : null;
      final nextHasOptions = next != null && next.options.isNotEmpty;

      if (el.type == LiturgicalElementType.title && nextHasOptions) {
        addSpacer();
        widgets.add(_TitleWithOptionsButton(
          titleElement: el,
          optionsElement: next,
          preferences: preferences,
          fontSize: fontSize,
          onOptionSelected: handleSelected,
        ));
        addSpacer();
        widgets.add(LiturgicalElementWidget(
          element: next,
          fontSize: fontSize,
          preferences: preferences,
          showOptionalRubrics: showOptional,
          hideOptionsButton: true,
          onOptionSelected: handleSelected,
        ));
        i += 2;
      } else {
        addSpacer();
        widgets.add(LiturgicalElementWidget(
          element: el,
          fontSize: fontSize,
          preferences: preferences,
          showOptionalRubrics: showOptional,
          onOptionSelected: handleSelected,
        ));
        i += 1;
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final celebrationId = widget.celebrationMeta['id'] ?? '';
    final preferencesAsync =
        ref.watch(celebrationPreferencesProvider(celebrationId));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.celebrationMeta['title']!,
    style: const TextStyle(
      fontFamily: 'CormorantGaramond',
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: MunusColors.textMain,
    ),
  ),
  actions: [
  Consumer(
    builder: (context, ref, _) {
      final favoritesAsync = ref.watch(favoritesProvider);
      final isFavorite = favoritesAsync.maybeWhen(
        data: (favorites) => favorites.contains(celebrationId),
        orElse: () => false,
      );
      return IconButton(
        icon: Opacity(
          opacity: isFavorite ? 1.0 : 0.35,
          child: Image.asset(
            'assets/images/tirita_sola.png',
            height: 30,
          ),
        ),
        tooltip: isFavorite
            ? 'Quitar de frecuentes'
            : 'Agregar a frecuentes',
        onPressed: () async {
          final service = ref.read(favoritesServiceProvider);
          await service.toggleFavorite(celebrationId);
          ref.invalidate(favoritesProvider);
        },
      );
    },
  ),
  IconButton(
  icon: const Icon(Icons.qr_code),
  color: MunusColors.textDiscrete,
  tooltip: 'Mostrar QR para la asamblea',
  onPressed: () async {
    final service = ref.read(assemblyUrlServiceProvider);
    final prefsService = ref.read(celebrationPreferencesServiceProvider);
    final celebrationId = widget.celebrationMeta['id'] ?? '';
    final preferences = await prefsService.getPreferences(celebrationId);
    final celebration = await ref
        .read(celebrationRepositoryProvider)
        .getCelebration(
          assetPath: widget.celebrationMeta['assetPath']!,
          categoryId: widget.categoryId,
        );
    final url = service.generateUrl(celebration, preferences);
    if (context.mounted) {
      context.push('/qr', extra: {
        'url': url,
        'title': widget.celebrationMeta['title'] ?? '',
      });
    }
  },
),
  IconButton(
    icon: const Text('A-',
        style: TextStyle(
            fontWeight: FontWeight.w500,
            color: MunusColors.textDiscrete)),
    onPressed: () =>
        ref.read(fontSizeProvider.notifier).decrease(),
  ),
  IconButton(
    icon: const Text('A+',
        style: TextStyle(
            fontWeight: FontWeight.w500,
            color: MunusColors.textDiscrete)),
    onPressed: () =>
        ref.read(fontSizeProvider.notifier).increase(),
  ),
  IconButton(
    icon: Icon(
  showOptional ? Icons.visibility : Icons.visibility_off,
  color: MunusColors.textRubric,
),
    tooltip: showOptional
        ? 'Ocultar rúbricas opcionales'
        : 'Mostrar rúbricas opcionales',
    onPressed: () => setState(() => showOptional = !showOptional),
  ),
],
      ),
      body: FutureBuilder<Celebration>(
        future: _celebrationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final celebration = snapshot.data!;
          final elements = celebration.sections.first.elements.where((e) {
            if (!showOptional &&
                e.type == LiturgicalElementType.rubric &&
                !e.isRequired) {
              return false;
            }
            return true;
          }).toList();

          return preferencesAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (_, _) => const Center(
                child: Text('Error al cargar preferencias')),
            data: (preferences) {
              final fontSize = ref.watch(fontSizeProvider);
              return ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 32),
                children: _buildElementWidgets(
                    elements, preferences, fontSize, celebrationId),
              );
            },
          );
        },
      ),
    );
  }
}

/// Fila combinada: título de sección a la izquierda, botón "Elegir
/// fórmula" a la derecha, para cuando el bloque con opciones está
/// pegado justo debajo de un título.
class _TitleWithOptionsButton extends StatelessWidget {
  final LiturgicalElement titleElement;
  final LiturgicalElement optionsElement;
  final Map<String, String> preferences;
  final double fontSize;
  final Future<void> Function(String elementId, String optionId)?
      onOptionSelected;

  const _TitleWithOptionsButton({
    required this.titleElement,
    required this.optionsElement,
    required this.preferences,
    required this.fontSize,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              titleElement.text ?? '',
              style: MunusTextStyles.sectionTitle(fontSize),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => LiturgicalElementWidget.showOptionsSheet(
              context,
              element: optionsElement,
              preferences: preferences,
              fontSize: fontSize,
              onOptionSelected: onOptionSelected,
            ),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: MunusColors.textRubric, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Elegir fórmula',
                style: MunusTextStyles.reference(fontSize - 4).copyWith(
                  color: MunusColors.textRubric,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}