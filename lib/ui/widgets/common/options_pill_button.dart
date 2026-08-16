import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Botón "Elegir fórmula" (pill roja discreta), compartido entre
/// liturgical_element_widget.dart y el _TitleWithOptionsButton de
/// celebration_screen.dart -- antes estaba duplicado en los dos lugares
/// con el mismo Container/GestureDetector, ahora es un solo widget.
///
/// Ajustes pedidos por Producto respecto de la versión anterior:
/// - sans-serif (ya lo era, MunusFonts.ui / Inter -- sin cambio ahí)
/// - texto 2px más chico (antes fontSize-4, ahora fontSize-6)
/// - menos padding horizontal y vertical
/// - borde más fino (1 -> 0.75)
/// - se mantiene la forma de píldora
/// - sigue sin ser dorado/serif a propósito: es una acción de interfaz,
///   no texto litúrgico, y debe diferenciarse visualmente de ese registro.
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
    );
  }
}
