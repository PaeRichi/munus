import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Contenido de un paso de tour (título + cuerpo + botón de avance),
/// con la tipografía y paleta de Munus. Se usa como `TargetContent.builder`
/// en `tutorial_coach_mark`, tanto para el tour general como el de
/// celebración.
class TourStepContent extends StatelessWidget {
  final String title;
  final String body;
  final String buttonLabel;
  final VoidCallback onNext;
  final Alignment alignment;

  const TourStepContent({
    super.key,
    required this.title,
    required this.body,
    required this.onNext,
    this.buttonLabel = 'Siguiente',
    this.alignment = Alignment.bottomCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: MunusColors.background,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: MunusFonts.display,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: MunusColors.textMain,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              body,
              style: TextStyle(
                fontFamily: MunusFonts.ui,
                fontSize: 14,
                height: 1.4,
                color: MunusColors.textMain,
              ),
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onNext,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: MunusColors.textRubric,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    buttonLabel,
                    style: TextStyle(
                      fontFamily: MunusFonts.ui,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: MunusColors.background,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
