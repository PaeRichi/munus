import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Botón "Elegir fórmula" (pill roja discreta), compartido entre
/// liturgical_element_widget.dart y el _TitleWithOptionsButton de
/// celebration_screen.dart.
///
/// El tamaño VISUAL se mantiene chico y discreto a pedido de Producto,
/// pero el área TOCABLE es más grande que lo que se ve -- Apple
/// recomienda un mínimo de 44x44pt para cualquier elemento tocable, y la
/// píldora visible sola queda bastante por debajo de eso. La solución es
/// un margen invisible alrededor (Padding) con `HitTestBehavior.opaque`
/// en el GestureDetector, para que esa zona extra también responda al
/// toque aunque no se vea nada ahí.
class OptionsPillButton extends StatelessWidget {
  final double fontSize;
  final VoidCallback onTap;
  final String label;

  const OptionsPillButton({
    super.key,
    required this.fontSize,
    required this.onTap,
    this.label = 'Elegir fórmula',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // Clave para que el margen invisible de abajo también sea tocable,
      // no solo los píxeles visibles de la píldora.
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            border: Border.all(color: MunusColors.textRubric, width: 0.75),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            style: MunusTextStyles.reference(fontSize - 6).copyWith(
              color: MunusColors.textRubric,
            ),
          ),
        ),
      ),
    );
  }
}
