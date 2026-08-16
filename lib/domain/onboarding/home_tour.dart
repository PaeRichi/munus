import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'tour_step_content.dart';
import 'scroll_into_view.dart';

/// Arma los targets del tour general (primera apertura de la app).
///
/// [ritualsListKey] es nullable: si no se pudo asignar a ningún ítem real
/// de la lista, ese paso se omite -- ver nota en celebration_tour.dart
/// para el mismo criterio.
///
/// El target NUNCA debe ser el ListView completo -- un target del tamaño
/// de toda la pantalla hace que el pulso del paquete se vea como franjas
/// grises rebotando en los bordes (bug real encontrado en pruebas). Va
/// apuntado al primer ritual visible de la lista, un elemento chico y
/// acotado.
///
/// [scrollController] se usa para llevar el selector CEA/CEE a la vista
/// antes de mostrar ese paso, ya que vive al final de una lista con
/// scroll -- si el usuario no scrolleó hasta ahí, el widget ni siquiera
/// está montado todavía.
List<TargetFocus> buildHomeTourTargets({
  required GlobalKey? ritualsListKey,
  required GlobalKey regionalToggleKey,
  required ScrollController scrollController,
}) {
  final targets = <TargetFocus>[];

  if (ritualsListKey != null) {
    targets.add(
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
              onNext: () {
                scrollKeyIntoView(regionalToggleKey, scrollController)
                    .then((_) => controller.next());
              },
            ),
          ),
        ],
      ),
    );
  }

  targets.add(
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
  );

  return targets;
}
