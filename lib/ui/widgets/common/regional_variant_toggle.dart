import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/repository_providers.dart' show regionalVariantProvider;
import '../../../core/theme/app_theme.dart';
import '../../../domain/preferences/regional_variant_service.dart';

/// Selector de variante regional (España/Argentina).
///
/// [dense] controla el estilo:
/// - false (default): versión completa con caja y borde, usada históricamente
///   en la pantalla "Acerca de".
/// - true: versión mínima, solo texto, sin caja ni borde — pensada para vivir
///   discretamente al pie de la Home.
class RegionalVariantToggle extends ConsumerWidget {
  final bool dense;

  const RegionalVariantToggle({super.key, this.dense = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final variant = ref.watch(regionalVariantProvider);

    if (dense) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DenseOption(
            label: 'España',
            selected: variant == RegionalVariant.espana,
            onTap: () => ref
                .read(regionalVariantProvider.notifier)
                .setVariant(RegionalVariant.espana),
          ),
          Text(
            '  ·  ',
            style: TextStyle(
              fontFamily: MunusFonts.ui,
              fontSize: 11,
              color: MunusColors.textDiscrete,
            ),
          ),
          _DenseOption(
            label: 'Argentina',
            selected: variant == RegionalVariant.argentina,
            onTap: () => ref
                .read(regionalVariantProvider.notifier)
                .setVariant(RegionalVariant.argentina),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: MunusColors.textRubric, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BoxedOption(
            label: 'España',
            selected: variant == RegionalVariant.espana,
            onTap: () => ref
                .read(regionalVariantProvider.notifier)
                .setVariant(RegionalVariant.espana),
          ),
          _BoxedOption(
            label: 'Argentina',
            selected: variant == RegionalVariant.argentina,
            onTap: () => ref
                .read(regionalVariantProvider.notifier)
                .setVariant(RegionalVariant.argentina),
          ),
        ],
      ),
    );
  }
}

class _DenseOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DenseOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Text(
        label,
        style: TextStyle(
          fontFamily: MunusFonts.ui,
          fontSize: 11,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          color: selected ? MunusColors.textRubric : MunusColors.textDiscrete,
        ),
      ),
    );
  }
}

class _BoxedOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BoxedOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? MunusColors.textRubric : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: MunusFonts.ui,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? MunusColors.background : MunusColors.textMain,
          ),
        ),
      ),
    );
  }
}
