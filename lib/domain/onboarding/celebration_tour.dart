import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'tour_step_content.dart';
import 'scroll_into_view.dart';

/// Arma los targets del tour de celebración (primera entrada a CUALQUIER
/// ritual).
///
/// [optionsKey] es nullable: no todo ritual tiene necesariamente un
/// bloque con `opciones` como primer elemento visible. Si es null, ese
/// paso se omite -- si NO es null, igual puede estar fuera de la vista
/// inicial (rituales con monición larga antes de la lectura), por eso
/// [scrollController] se usa para llevarlo a la vista antes de mostrar
/// ese paso, en el "Siguiente" del paso anterior (favorito).
List<TargetFocus> buildCelebrationTourTargets({
  required GlobalKey favoritoKey,
  required GlobalKey qrKey,
  required ScrollController scrollController,
  GlobalKey? optionsKey,
}) {
  final targets = <TargetFocus>[
    TargetFocus(
      identify: 'celebration_tour_favorito',
      keyTarget: favoritoKey,
      shape: ShapeLightFocus.Circle,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) => TourStepContent(
            title: 'Guardá este ritual entre tus favoritos',
            body: 'Tocá la tirita para marcarlo como favorito y encontrarlo '
                'rápidamente desde la pantalla principal.',
            onNext: () {
              if (optionsKey != null) {
                scrollKeyIntoView(optionsKey, scrollController)
                    .then((_) => controller.next());
              } else {
                controller.next();
              }
            },
          ),
        ),
      ],
    ),
  ];

  if (optionsKey != null) {
    targets.add(
      TargetFocus(
        identify: 'celebration_tour_options',
        keyTarget: optionsKey,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => TourStepContent(
              title: 'Elegí tus opciones',
              body: 'Cuando el ritual ofrece distintas lecturas, oraciones, '
                  'saludos o fórmulas, elegí la que prefieras. Munus '
                  'recordará tu elección para las próximas veces.',
              onNext: controller.next,
            ),
          ),
        ],
      ),
    );
  }

  targets.add(
    TargetFocus(
      identify: 'celebration_tour_qr',
      keyTarget: qrKey,
      shape: ShapeLightFocus.Circle,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) => TourStepContent(
            title: 'Compartí las respuestas con la asamblea',
            body: 'Generá un código QR para que los presentes puedan '
                'acceder a las respuestas y participar de la celebración '
                'desde sus teléfonos.',
            onNext: controller.next,
          ),
        ),
      ],
    ),
  );

  return targets;
}
