import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'tour_step_content.dart';

/// Arma los dos targets del tour general (primera apertura de la app),
/// UNO A LA VEZ -- a propósito no se devuelven juntos en una sola lista.
///
/// El paso 1 (lista de rituales) y el paso 2 (toggle CEA/CEE) viven en la
/// MISMA lista con scroll. Si se muestran como targets de un mismo
/// TutorialCoachMark y se scrollea entre uno y otro (para traer el toggle
/// a la vista) mientras el spotlight del paso 1 sigue en pantalla, el
/// scroll arrastra ese target fuera de su lugar y el overlay queda roto
/// (bug real encontrado en pruebas -- el foco gris no volvía a aparecer).
///
/// La solución es mostrar cada paso como un TutorialCoachMark
/// INDEPENDIENTE: el primero se cierra del todo, recién ahí se scrollea
/// (sin ningún overlay visible encima), y recién ahí se abre el segundo.
/// La orquestación de esa secuencia vive en home_screen.dart
/// (_runHomeTourSequence), acá solo se arma cada target individual.
TargetFocus ritualsListTarget(GlobalKey key) {
  return TargetFocus(
    identify: 'home_tour_rituals_list',
    keyTarget: key,
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
  );
}

TargetFocus regionalToggleTarget(GlobalKey key) {
  return TargetFocus(
    identify: 'home_tour_regional_toggle',
    keyTarget: key,
    shape: ShapeLightFocus.RRect,
    radius: 12,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        builder: (context, controller) => TourStepContent(
          title: 'Elegí tu edición',
          body: 'Podés elegir entre la traducción CEA, utilizada en '
              'Argentina y Latinoamérica, y la CEE, utilizada en España.',
          onNext: controller.next,
        ),
      ),
    ],
  );
}
