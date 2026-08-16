import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'tour_step_content.dart';

/// Arma los targets del tour de celebración (primera entrada a CUALQUIER
/// ritual).
///
/// [optionsKey] es nullable a propósito: no todo ritual tiene necesariamente
/// un bloque con `opciones` como primer elemento visible (aunque en la
/// práctica casi todos los de la Biblioteca sí). Si es null, ese paso se
/// omite y el tour queda de 2 pasos (favorito + QR) en vez de 3, para no
/// romper con NotFoundTargetException al apuntar a un target inexistente.
List<TargetFocus> buildCelebrationTourTargets({
  required GlobalKey favoritoKey,
  required GlobalKey qrKey,
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
            onNext: controller.next,
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
