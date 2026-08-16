import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'tour_step_content.dart';

/// Arma los targets del tour general (primera apertura de la app).
///
/// Requiere dos GlobalKeys ya asignadas a los widgets reales en
/// home_screen.dart:
/// - [ritualsListKey]: algún elemento representativo de la lista de
///   rituales (ej. el primer ListTile o el primer header de sección).
/// - [regionalToggleKey]: el RegionalVariantToggle al pie de la Home.
///
/// El mensaje de cierre ("Ya estás listo para usar Munus.") NO es un target
/// más acá -- es un diálogo aparte que se dispara desde el callback `finish`
/// de TutorialCoachMark (ver PASO_4_home_screen_wiring.md), porque no está
/// anclado a ningún elemento puntual de la interfaz.
List<TargetFocus> buildHomeTourTargets({
  required GlobalKey ritualsListKey,
  required GlobalKey regionalToggleKey,
}) {
  return [
    TargetFocus(
      identify: 'home_tour_rituals_list',
      keyTarget: ritualsListKey,
      shape: ShapeLightFocus.RRect,
      radius: 12,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) => TourStepContent(
            title: 'Todos tus rituales, a mano',
            body: 'Accedé directamente a los rituales de uso frecuente.',
            onNext: controller.next,
          ),
        ),
      ],
    ),
    TargetFocus(
      identify: 'home_tour_regional_toggle',
      keyTarget: regionalToggleKey,
      shape: ShapeLightFocus.RRect,
      radius: 12,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) => TourStepContent(
            title: 'Elegí tu edición',
            body: 'Podés elegir entre la traducción CEA, utilizada en '
                'Argentina, y la CEE, utilizada en España.',
            onNext: controller.next,
          ),
        ),
      ],
    ),
  ];
}
