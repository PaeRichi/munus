import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'tour_step_content.dart';

/// Arma los targets del tour general (primera apertura de la app).
///
/// [ritualsListKey] es nullable: si por algún motivo no se pudo asignar a
/// ningún ítem real de la lista (ej. no hay rituales cargados todavía),
/// ese paso se omite en vez de apuntar a un target inexistente -- mismo
/// criterio ya usado en celebration_tour.dart para el paso de opciones.
///
/// IMPORTANTE: este target NUNCA debe ser el ListView completo. Un target
/// del tamaño de toda la pantalla hace que la animación de pulso del
/// paquete se vea como franjas grises rebotando en los bordes (bug real
/// encontrado en pruebas) -- tiene que ser un elemento chico y acotado,
/// acá el primer ritual visible de la lista.
List<TargetFocus> buildHomeTourTargets({
  required GlobalKey? ritualsListKey,
  required GlobalKey regionalToggleKey,
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
              onNext: controller.next,
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
