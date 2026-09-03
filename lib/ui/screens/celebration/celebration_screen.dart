import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../data/models/celebration.dart';
import '../../../data/models/liturgical_element.dart';
import '../../widgets/celebration/liturgical_element_widget.dart';
import '../../widgets/common/options_pill_button.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/onboarding/celebration_tour.dart';
import '../../../domain/onboarding/tour_finish_dialog.dart';
import '../../screens/qr/assembly_qr_sheet.dart';


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
  late final Future<String> _resolvedAssetPathFuture;

  // --- Onboarding: keys de los targets del tour de celebración ---
  final _favoritoKey = GlobalKey();
  final _qrKey = GlobalKey();
  final _optionsKey = GlobalKey();
  final _scrollController = ScrollController();
  bool _optionsElementFound = false;
  bool _tourLaunched = false;
  // Consulta directa al servicio (no vía provider/Notifier): nada más en
  // la app necesita reaccionar a este flag en tiempo real, así que evitamos
  // el patrón NotifierProvider (que además tiene una ventana donde el
  // valor default se muestra antes de que cargue el real -- indeseable
  // acá porque dispararía el tour de más).
  late final Future<bool> _hasSeenTourFuture;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    final repository = ref.read(celebrationRepositoryProvider);
    // Se espera ensureLoaded() antes de leer la variante: build() del
    // notifier devuelve el default de forma síncrona antes de que termine
    // de leer shared_preferences, así que leer el estado acá sin esperar
    // podía devolver España aunque el usuario tuviera Argentina persistida
    // (bug: variante no se aplicaba en el primer ritual abierto tras
    // iniciar la app).
    _resolvedAssetPathFuture = ref
        .read(regionalVariantProvider.notifier)
        .ensureLoaded()
        .then((_) => repository.resolveAssetPath(
              widget.celebrationMeta['assetPath']!,
              ref.read(regionalVariantProvider),
            ));
    _celebrationFuture = _resolvedAssetPathFuture.then(
      (assetPath) => repository.getCelebration(
        assetPath: assetPath,
        categoryId: widget.categoryId,
      ),
    );
    _hasSeenTourFuture =
        ref.read(celebrationTourServiceProvider).hasSeenTour();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _scrollController.dispose();
    super.dispose();
  }

  void _maybeShowCelebrationTour(bool hasSeenTour) {
    if (hasSeenTour || _tourLaunched) return;
    _tourLaunched = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Ya no hace falta chequear si _optionsKey está montado: si
      // _optionsElementFound es true, el scroll automático (ver
      // celebration_tour.dart / scroll_into_view.dart) se encarga de
      // llevarlo a la vista cuando corresponda, esté donde esté en la
      // lista.
      TutorialCoachMark(
        targets: buildCelebrationTourTargets(
          favoritoKey: _favoritoKey,
          qrKey: _qrKey,
          scrollController: _scrollController,
          optionsKey: _optionsElementFound ? _optionsKey : null,
        ),
        colorShadow: Colors.black,
        opacityShadow: 0.8,
        paddingFocus: 8,
        hideSkip: true,
        onFinish: () {
          ref.read(celebrationTourServiceProvider).markAsSeen();
          showTourFinishDialog(
            context,
            message: 'Todo listo para celebrar.',
          );
        },
      ).show(context: context);
    });
  }

  List<Widget> _buildElementWidgets(
    List<LiturgicalElement> elements,
    Map<String, String> preferences,
    double fontSize,
    String celebrationId,
  ) {
    final widgets = <Widget>[];
    // Se resetea en cada build; se vuelve a calcular junto con la lista.
    _optionsElementFound = false;

    void addSpacer() {
      if (widgets.isNotEmpty) widgets.add(const SizedBox(height: 20));
    }

    Widget maybeWrapWithOptionsKey(Widget child, bool elementHasOptions) {
      if (elementHasOptions && !_optionsElementFound) {
        _optionsElementFound = true;
        return KeyedSubtree(key: _optionsKey, child: child);
      }
      return child;
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
        widgets.add(maybeWrapWithOptionsKey(
          _TitleWithOptionsButton(
            titleElement: el,
            optionsElement: next,
            preferences: preferences,
            fontSize: fontSize,
            onOptionSelected: handleSelected,
          ),
          true,
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
        widgets.add(maybeWrapWithOptionsKey(
          LiturgicalElementWidget(
            element: el,
            fontSize: fontSize,
            preferences: preferences,
            showOptionalRubrics: showOptional,
            onOptionSelected: handleSelected,
          ),
          el.options.isNotEmpty,
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
        key: _favoritoKey,
        icon: TweenAnimationBuilder<double>(
          key: ValueKey(isFavorite),
          tween: Tween(begin: 1.5, end: 1.0),
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) => Transform.scale(
            scale: scale,
            child: child,
          ),
          child: Opacity(
            opacity: isFavorite ? 1.0 : 0.35,
            child: Image.asset(
              'assets/images/tirita_sola.png',
              height: 30,
            ),
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
  key: _qrKey,
  icon: const Icon(Icons.qr_code),
  color: MunusColors.textDiscrete,
  tooltip: 'Mostrar QR para la asamblea',
  onPressed: () async {
    final service = ref.read(assemblyUrlServiceProvider);
    final prefsService = ref.read(celebrationPreferencesServiceProvider);
    final preferences = await prefsService.getPreferences(celebrationId);
    final assetPath = await _resolvedAssetPathFuture;
    final url = service.generateUrl(assetPath, preferences);
    if (context.mounted) {
  showAssemblyQrSheet(
    context,
    url: url,
    celebrationTitle: widget.celebrationMeta['title'] ?? '',
  );
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
              final elementWidgets = _buildElementWidgets(
                  elements, preferences, fontSize, celebrationId);

              if (!_tourLaunched) {
                _hasSeenTourFuture.then(_maybeShowCelebrationTour);
              }

              return PrimaryScrollController(
  controller: _scrollController,
  child: ListView(
    controller: _scrollController,
    padding: const EdgeInsets.symmetric(
        horizontal: 24, vertical: 32),
    children: elementWidgets,
  ),
);
            },
          );
        },
      ),
    );
  }
}

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
              style: MunusTextStyles.liturgicalTitle(fontSize),
            ),
          ),
          const SizedBox(width: 12),
          OptionsPillButton(
            fontSize: fontSize,
            onTap: () => LiturgicalElementWidget.showOptionsSheet(
              context,
              element: optionsElement,
              preferences: preferences,
              fontSize: fontSize,
              onOptionSelected: onOptionSelected,
            ),
          ),
        ],
      ),
    );
  }
}
