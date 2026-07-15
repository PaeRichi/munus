import 'package:flutter/material.dart';
import '../../../data/models/liturgical_element.dart';
import '../../../core/theme/app_theme.dart';

class LiturgicalElementWidget extends StatelessWidget {
  final LiturgicalElement element;
  final Map<String, String> preferences;
  final Function(String elementId, String optionId)? onOptionSelected;
  final double fontSize;
  final bool showOptionalRubrics;
  final bool hideOptionsButton;

  const LiturgicalElementWidget({
    super.key,
    required this.element,
    required this.fontSize,
    this.preferences = const {},
    this.onOptionSelected,
    this.showOptionalRubrics = true,
    this.hideOptionsButton = false,
  });

  /// La opción activa. Devuelve null cuando corresponde mostrar la
  /// fórmula "principal" del propio bloque padre (element.text), en vez
  /// de una alternativa de `opciones`.
  LiturgicalOption? get _activeOption {
    if (element.options.isEmpty) return null;
    final chosenId = preferences[element.id];
    if (chosenId != null) {
      // El sacerdote eligió explícitamente volver a la fórmula principal.
      if (chosenId == element.id) return null;
      final chosen =
          element.options.where((o) => o.id == chosenId).firstOrNull;
      if (chosen != null) return chosen;
    }
    // Sin elección guardada: si el bloque padre tiene su propia fórmula,
    // esa es la que corresponde por defecto (spec: "el bloque padre lleva
    // texto propio solo si existe una fórmula principal"). Si no tiene
    // texto propio (todas las opciones son de igual rango), se usa la
    // primera opción como default, como ya se hacía.
    if (element.text != null) return null;
    return element.options.first;
  }

  String get _activeOptionText {
    if (element.options.isEmpty) return element.text ?? '';
    final option = _activeOption;
    if (option?.text != null) return option!.text!;
    return element.text ?? '';
  }

  String? get _activeOptionReference {
    final option = _activeOption;
    return option?.reference ?? element.reference;
  }

  String? get _activeOptionHeading {
    final option = _activeOption;
    return option?.heading ?? element.heading;
  }

  bool get _hasOptions => element.options.isNotEmpty;

  static String _shortLabel(String text, {int maxLen = 70}) {
    if (text.length <= maxLen) return text;
    return '${text.substring(0, maxLen).trimRight()}…';
  }

  static Widget _optionRow({
    required String label,
    required bool isChosen,
    required double fontSize,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isChosen ? Icons.circle : Icons.circle_outlined,
              size: 14,
              color:
                  isChosen ? MunusColors.textRubric : MunusColors.textDiscrete,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: MunusTextStyles.bodyText(fontSize)),
            ),
          ],
        ),
      ),
    );
  }

  static void showOptionsSheet(
    BuildContext context, {
    required LiturgicalElement element,
    required Map<String, String> preferences,
    required double fontSize,
    Function(String elementId, String optionId)? onOptionSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: MunusColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        final hasOwnFormula = element.text != null;
        final chosenId = preferences[element.id] ??
            (hasOwnFormula
                ? element.id
                : (element.options.isNotEmpty
                    ? element.options.first.id
                    : null));
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            children: [
              Text('Opciones', style: MunusTextStyles.sectionTitle(fontSize)),
              const SizedBox(height: 16),
              if (hasOwnFormula)
                _optionRow(
                  label: element.reference ?? _shortLabel(element.text!),
                  isChosen: chosenId == element.id,
                  fontSize: fontSize,
                  onTap: () {
                    onOptionSelected?.call(element.id, element.id);
                    Navigator.pop(context);
                  },
                ),
              ...element.options.map((option) {
                final isChosen = option.id == chosenId;
                final label = option.displayName ??
                    option.reference ??
                    (option.text != null ? _shortLabel(option.text!) : null) ??
                    option.id;
                return _optionRow(
                  label: label,
                  isChosen: isChosen,
                  fontSize: fontSize,
                  onTap: () {
                    onOptionSelected?.call(element.id, option.id);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showOptions(BuildContext context) {
    showOptionsSheet(
      context,
      element: element,
      preferences: preferences,
      fontSize: fontSize,
      onOptionSelected: onOptionSelected,
    );
  }

  Widget _buildOptionsButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () => _showOptions(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final option = _activeOption;
    if (option != null && option.elements.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_hasOptions && !hideOptionsButton) _buildOptionsButton(context),
          ..._buildElementsList(context, option.elements),
        ],
      );
    }

    switch (element.type) {
      case LiturgicalElementType.rubric:
      case LiturgicalElementType.gesture:
        return _buildRubric();
      case LiturgicalElementType.title:
        return _buildTitle();
      case LiturgicalElementType.response:
        return _buildResponse();
      case LiturgicalElementType.reading:
        return _buildReading(context);
      case LiturgicalElementType.litany:
        return _buildLitany();
      case LiturgicalElementType.intercessions:
        return _buildIntercessions();
      case LiturgicalElementType.psalm:
        return _buildPsalm();
      default:
        return _buildBodyText(context);
    }
  }
 List<Widget> _buildParagraphs(String text, TextStyle style) {
    final paragraphs =
        text.split('\n\n').where((p) => p.trim().isNotEmpty).toList();
    final widgets = <Widget>[];
    for (var i = 0; i < paragraphs.length; i++) {
      if (i > 0) widgets.add(const SizedBox(height: 12));
      widgets.add(Text(paragraphs[i].trim(), style: style));
    }
    return widgets;
  }

  Widget _buildRubric() {
    return Text(element.text ?? '', style: MunusTextStyles.rubric(fontSize));
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Text(element.text ?? '',
          style: MunusTextStyles.sectionTitle(fontSize)),
    );
  }

  List<Widget> _buildElementsList(
      BuildContext context, List<LiturgicalElement> elements) {
    final visible = elements.where((e) {
      if (!showOptionalRubrics &&
          e.type == LiturgicalElementType.rubric &&
          !e.isRequired) {
        return false;
      }
      return true;
    }).toList();

    final widgets = <Widget>[];
    for (var i = 0; i < visible.length; i++) {
      if (i > 0) widgets.add(const SizedBox(height: 20));
      widgets.add(LiturgicalElementWidget(
        element: visible[i],
        fontSize: fontSize,
        preferences: preferences,
        onOptionSelected: onOptionSelected,
        showOptionalRubrics: showOptionalRubrics,
      ));
    }
    return widgets;
  }

  Widget _buildBodyText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_hasOptions && !hideOptionsButton) _buildOptionsButton(context),
        ..._buildParagraphs(
            _activeOptionText, MunusTextStyles.bodyText(fontSize)),
      ],
    );
  }

  Widget _buildResponse() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: 'R. ', style: MunusTextStyles.responseLabel(fontSize)),
          TextSpan(
              text: element.text ?? '',
              style: MunusTextStyles.response(fontSize)),
        ],
      ),
    );
  }

  Widget _buildReading(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_hasOptions && !hideOptionsButton) _buildOptionsButton(context),
        if (_activeOptionReference != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(_activeOptionReference!,
                style: MunusTextStyles.reference(fontSize)),
          ),
        if (_activeOptionHeading != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(_activeOptionHeading!,
                style: MunusTextStyles.rubric(fontSize)),
          ),
        if (_activeOptionText.isNotEmpty)
          ..._buildParagraphs(
              _activeOptionText, MunusTextStyles.bodyText(fontSize)),
      ],
    );
  }

  Widget _buildLitany() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: element.invocations.map((inv) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(inv.invocation, style: MunusTextStyles.bodyText(fontSize)),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'R. ',
                        style: MunusTextStyles.responseLabel(fontSize)),
                    TextSpan(
                        text: inv.response,
                        style: MunusTextStyles.response(fontSize)),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIntercessions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (element.invitation != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(element.invitation!,
                style: MunusTextStyles.bodyText(fontSize)),
          ),
        if (element.invitation != null && element.fixedResponse != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'R. ',
                      style: MunusTextStyles.responseLabel(fontSize)),
                  TextSpan(
                      text: element.fixedResponse!,
                      style: MunusTextStyles.response(fontSize)),
                ],
              ),
            ),
          ),
        ...element.invocations.map((inv) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(inv.invocation,
                    style: MunusTextStyles.bodyText(fontSize)),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'R. ',
                          style: MunusTextStyles.responseLabel(fontSize)),
                      TextSpan(
                          text: inv.response,
                          style: MunusTextStyles.response(fontSize)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPsalm() {
    final children = <Widget>[];

    if (element.reference != null) {
      children.add(Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(element.reference!,
            style: MunusTextStyles.reference(fontSize)),
      ));
    }

    Widget refrainWidget() {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: 'R. ', style: MunusTextStyles.responseLabel(fontSize)),
            TextSpan(
                text: element.refrain!,
                style: MunusTextStyles.response(fontSize)),
          ],
        ),
      );
    }

    if (element.refrain != null) {
      children.add(Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: refrainWidget(),
      ));
    }

    for (final strophe in element.strophes) {
      children.add(Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(strophe, style: MunusTextStyles.bodyText(fontSize)),
      ));
      if (element.refrain != null) {
        children.add(Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: refrainWidget(),
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
